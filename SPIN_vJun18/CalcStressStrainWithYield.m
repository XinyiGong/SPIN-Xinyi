function [StressStrainResults] = CalcStressStrainWithYield(TestData, SR, Plastic)

    StressStrainResults.contact_radius = NaN;
    StressStrainResults.Stress = NaN;
    StressStrainResults.Strain = NaN;
    StressStrainResults.Yield_Strength = NaN;
    StressStrainResults.Yield_Strain = NaN;
    StressStrainResults.Hardening = NaN;
    StressStrainResults.HardeningStartEnd = NaN;
    StressStrainResults.h_new = NaN;
    StressStrainResults.P_new = NaN;
    StressStrainResults.popin_YN = NaN;
    StressStrainResults.fullH_YN = NaN;
    StressStrainResults.PopinStressStrain = NaN;
    StressStrainResults.h_sample = NaN;
    StressStrainResults.E_ind = NaN;
    
    h = TestData.Data(:,7); % displacement(nm)
    P = TestData.Data(:,8); % Load (mN)
    S = TestData.Data(:,9); % Harmonic Stiffness (mN/nm)
    % note these are harmonic corrected, see LoadTest.m

    h_star = SR.h_star;
    P_star = SR.P_star;
    
    h_new = h-h_star;  % Total Displacement (nm)
    P_new = P-P_star;  % Load (mN)
    StressStrainResults.h_new = h_new;
    StressStrainResults.P_new = P_new;
    
    E_star = SR.E_star;
            
    a = S./(2*E_star)*1e6;  % (nm) area of contact
    StressStrainResults.contact_radius = a;
    % he = 3/2*P_new./S;      % (nm)
    % R_star = a.^2/he;       % (nm)
    
    vi = TestData.nui;
    Ei = TestData.Ei;
    
    hi = 3/4*(1-vi^2)/Ei*P_new./a.*10^6; % displacement of the indenter tip (nm)
    
    h_sample = h_new - hi;
    StressStrainResults.h_sample = h_sample;
    
    E_ind = (1/E_star - (1-vi^2)/Ei)^-1; % indentation modulus of the sample (GPa)
    StressStrainResults.E_ind = E_ind;
    Stress = P_new./(pi*a.^2)*1e6;  % GPa
    Strain = 4/(3*pi)*h_sample./a; % this is strain corrected for the indenter tip displacement
    StressStrainResults.Stress = Stress;
    StressStrainResults.Strain = Strain;
    
    %Yeild calculation
    SegmentEnd = SR.segment_end;
    [Plastic_window, Pop] = FindYieldStart(Stress, Strain, SegmentEnd, E_ind, Plastic);
    [yield_stress, yield_strain, p1, p2] = FindYield(Stress, Strain, SegmentEnd, Plastic_window, E_ind, Plastic);

    StressStrainResults.Yield_Strength = yield_stress;
    StressStrainResults.Yield_Strain = yield_strain;
    StressStrainResults.Hardening = [p1; p2];
    StressStrainResults.HardeningStartEnd = [Plastic_window.min_point; Plastic_window.max_point];
    StressStrainResults.popin_YN = Plastic_window.popsuccess; % 0=yes, 1=no
    StressStrainResults.fullH_YN = Plastic_window.Hsuccess; %0=yes, 1=no
    StressStrainResults.PopinStressStrain = Pop; % Pop-in stress strain values
end