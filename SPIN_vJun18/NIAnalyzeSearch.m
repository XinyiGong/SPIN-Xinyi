function [analysis, success] = NIAnalyzeSearch(TestData, segment_start, segment_end)
    success = 0;
    
    minR21 = TestData.skip(1); % min R2 for zero point fit for success
    seg_overlap = TestData.skip(2); % min segment overlap percent for success
    % this function will also kick out (success = 0) when Fit 2 slope is negative
    
    analysis.segment_start = segment_start;
    analysis.segment_end = segment_end;
    analysis.Fit1 = NaN;
    analysis.Fit2 = NaN;
    analysis.h_star = NaN;
    analysis.P_star = NaN;
    analysis.E_star = NaN;
    analysis.E_sample = NaN;
    analysis.h_change = NaN;
    analysis.p_change = NaN;
    analysis.dH = NaN;
    analysis.dP = NaN;
    analysis.segment_length = segment_end - segment_start + 1; % number of points
    analysis.modulus_start = NaN;
    analysis.modulus_length = NaN; % number of points
    analysis.Fit3 = NaN;
    analysis.Fit4 = NaN;
    
    
    Ri = TestData.IndenterRadius;
    Ei = TestData.Ei;
    nui = TestData.nui;
    nus = TestData.nus;
    
%     % THIS IS PERFORMED IN LoadTest.m since it is a one time calculation
%     % CSM corrections are applied based on S. Vachhani et al. 2013 and G.M. Pharr et al
%     %. 2009
%     sq2 = sqrt(2);
%     h = TestData.Data(:,2) + TestData.Data(:,5).*sq2; % displacement(nm)
%     P = TestData.Data(:,3) + TestData.Data(:,6).*sq2.*10^-3; % Load (mN)
%     S = TestData.Data(:,4); % Harmonic Stiffness (N/m)
%     S = S/1e6;      % To convert S from N/m into mN/nm
%     K = 0.6524;
%     m = 1.5;
%     S = 1/sq2/sqrt(pi).*P./TestData.Data(:,5).*(1/K)^(1/m) .* (1 - (1 - 2*sq2.*TestData.Data(:,5).*S./P).^(1/m));

    h = TestData.Data(:,7);
    P = TestData.Data(:,8);
    S = TestData.Data(:,9);

    A = P-2/3*S.*h;
    
    ws = warning('off','all');   
    
    S_elast=S(segment_start:segment_end); % S in the elastic part
    A_elast=A(segment_start:segment_end); % A in the elastic part

    p = mypolyfit(S_elast,A_elast,1);
    Fit1.slope = p(1) ;
    Fit1.y_intercept = real(p(2));
    Output = polyval(p, S_elast);
    [R21, ~, ~, AAR1, MAR1] =  rsquare(A_elast, Output);
    
    if(R21 < minR21)
        return;
    end
    
    Fit1.Rsquared = real(R21);
    Fit1.AverageAbsoluteResidual = AAR1;
    Fit1.MaxAbsoluteResidual = MAR1;
    analysis.Fit1 = Fit1;
    

    % Calculate h_star and P_star
    h_star = -3/2*Fit1.slope;
    P_star = Fit1.y_intercept;
    analysis.h_star = h_star;
    analysis.P_star = P_star;

    h_new = h-h_star;  % Displacement (nm)
    P_new = P-P_star;  % Load (mN)

    h_new_fit = h_new(segment_start:segment_end);
    P_new_fit = P_new(segment_start:segment_end);

    % Remove the negative values that result from shifting the data.
    first_pos_ii = find(P_new_fit > 0, 1, 'first');

    h_new_fit = h_new_fit(first_pos_ii:end);
    P_new_fit = P_new_fit(first_pos_ii:end);
     
    percent = length(h_new_fit)/length(h_new(segment_start:segment_end));
    modulus_start = first_pos_ii -1 + segment_start;
    
    dH = h_new(modulus_start); % same as looking at h(modulus_start) - h_star
    dP = P_new(modulus_start); % same as looking at P(modulus_start) - P_star
    % these variables are a measure of how close the elastic segment is to
    % the origin
    
    analysis.dH = dH;
    analysis.dP = dP;
    
    % check overlap criteria
    if(percent < seg_overlap)
        return;
    end

    P_new_23 = P_new_fit.^(2/3);

%     p = mypolyfit(P_new_23, h_new_fit, 1);
    p = P_new_23\h_new_fit;
%     if (p(1) <= 0) % if the slope is negative, E_star is imaginary
    if (p <= 0)
        return;
    end
    
%     Fit2.slope = p(1);
    Fit2.slope = p;
%     Fit2.y_intercept = real(p(2));
    % Evaluate Fit assuming y_intercept is zero. Fit2 parameters then emphasize data
    % which is linear and goes through the origin.
%     Output = polyval([p(1) 0], P_new_23);
    Output = p * P_new_23;
    [R22, ~, ~, AAR2, MAR2] = rsquare(h_new_fit, Output);
    
    Fit2.Rsquared = real(R22);
    Fit2.AverageAbsoluteResidual = AAR2;
    Fit2.MaxAbsoluteResidual = MAR2;
    analysis.Fit2 = Fit2;
    
    analysis.h_change = (h(modulus_start) - h(segment_start)) / (h(segment_end) - h(segment_start)); % overlap metric
    analysis.p_change = (P(modulus_start) - P(segment_start)) / (P(segment_end) - P(segment_start)); % overlap metric
    analysis.modulus_start = modulus_start;
    analysis.modulus_length = length(P_new_fit);

    % Find E* from slope2 & y_intercept2
    E_star=(3/4)/(Fit2.slope^(3/2) * Ri^(1/2))*1e6;  % in GPa
    E_sample=(1-nus^2)*(1/E_star-(1-nui^2)/Ei)^-1; % in GPa
    analysis.E_star = real(E_star);
    analysis.E_sample = real(E_sample);
   
    % Get the R square for the linear portion of the stress strain curve
    % he = 3/2*P_new./S;      % (nm)
    a = S./(2*E_star)*1e6;  % (nm) area of contact
    % R_star=a.^2/he;       % (nm)

    Stress=P_new./(pi*a.^2)*1e6;  % GPa
    Strain=4/(3*pi)*h_new./a;

    % Evaluate elastic stress-strain fit
    stress_E = Stress(modulus_start:segment_end); % actual elastic stress data
    strain_E = Strain(modulus_start:segment_end);
    p = mypolyfit(strain_E, stress_E, 1);
    % Evaluate Fit assuming y_intercept is zero. Fit3 parameters then emphasize data
    % which is linear and goes through the origin.
    Output = polyval([p(1) 0], strain_E);
    [R23, ~, ~, AAR3, MAR3] = rsquare(stress_E, Output); % how linear is the segment
    
    Fit3.Rsquared = real(R23);
    Fit3.AverageAbsoluteResidual = AAR3;
    Fit3.MaxAbsoluteResidual = MAR3;
    analysis.Fit3 = Fit3;
    
    stress_Estar = E_star.*Strain(modulus_start:segment_end); % elastic stress data asumming S=Estar*e
    [~, ~, ~, AAR4, MAR4] = rsquare(stress_E, stress_Estar); % how close to the effective modulus line is the data
   
    Fit4.Rsquared = NaN;
    Fit4.AverageAbsoluteResidual = AAR4;
    Fit4.MaxAbsoluteResidual = MAR4;
    analysis.Fit4 = Fit4;

    % No errors, set success to true
    success = 1;
    
end