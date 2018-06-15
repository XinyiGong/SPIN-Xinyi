function [yield_stress, yield_strain, a, b] = FindYield(Stress, strain, segment_end, Plastic_window, E_ind, Plastic)

% calculates the yield point using one of two options:
% Option 1 (when a pop-in is detected): the intersection of a back
% extrapolated linear fit in the post elastic regime with an offset modulus
% line. 
% Option 2 (no pop-in detected): median stress value in an offset
% modulus line window, +/- 30% offset strain.
%
% AND calculates the linear hardening slope which is the same as the back extrapolation fit

plastic_start = Plastic_window.min_point;
plastic_end = Plastic_window.max_point;

% smoothed for hardening/back extrapolation fit
SStrain = smoothstrain(plastic_start, plastic_end, strain, Plastic.smooth_window); 
% Strain should be the same size as strain

% hardening/ back extrapolation linear fit
p = mypolyfit(SStrain, Stress(plastic_start:plastic_end),1);
a = p(1); % hardening slope
b = p(2); % y-intercept

if Plastic_window.popsuccess==0 % pop-in occured, use back extrapolated method
    % intersection of offset line and back extrapolated line
    yield_strain = (E_ind*Plastic.YS_offset + p(2)) / (E_ind - p(1));
    yield_stress = E_ind*(yield_strain - Plastic.YS_offset);
    
else % no pop-in, take the median of a small window at the offset line
    
    % use the modulus slope and YS_window to define two offset lines which
    % make up the small window for calculating the median
    c1 = 1 - Plastic.YS_window;  c2 = 1 + Plastic.YS_window; 
    f1 = E_ind .* (strain(segment_end:end) - c1 * Plastic.YS_offset);
    f2 = E_ind .* (strain(segment_end:end) - c2 * Plastic.YS_offset);
    
    windmin = find ( (f1 - Stress(segment_end:end)) > 0, 1 );
    windmax = find ( (f2 - Stress(segment_end:end)) > 0, 1 );

    in1 = segment_end -1 + windmin;
    in2 = segment_end -1 + windmax;
    
    Yield_Strain = strain (in1 : in2); % all values in the small window
    yield_strain = median (Yield_Strain); % median value
    Yield_Stress = Stress (in1 : in2);
    yield_stress = median (Yield_Stress);
    
end

end