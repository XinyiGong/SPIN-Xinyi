function [TestData] = LoadTest(filename, sheet, radius, vs, skip, seg_start, seg_end)

[num txt] = xlsread(filename, sheet);
% num=[NaN(size(num,1),1),num];
num = num(:,2:7);
num = real(num);
TestData.Filename = filename;

TestData.Sheet = sheet;
TestData.StiffnessSegmentStart = NaN;
TestData.LoadSegmentEnd = NaN;
TestData.Data = NaN;
TestData.IndenterRadius = radius;
TestData.nui = 0.07;
TestData.Ei = 1140;
TestData.nus = vs;
TestData.skip = skip;
TestData.SegStart = seg_start;
TestData.SegEnd = seg_end;

if isempty(num)
    warning('%s contains no data', sheet);
    return
end

% Finds where unloading starts
HoldSegmentII = size(num, 1); 
for ii=1:size(txt,1) 
%     if strcmpi(txt(ii), 'End of Loading Marker') == 1 % 'End Of Loading Marker' the exact text depends on the version of NanoSuite
    if strcmpi(txt(ii), 'End of Loading Marker') == 1 % 'End Of Loading Marker' the exact text depends on the version of NanoSuite
        HoldSegmentII=ii-2; 
        break; 
    end
end

T = num(1:HoldSegmentII, 1:6); % num columns 1:6 are loaded
% T(isnan(sum(T,2)), :) = [];

TestData.LoadSegmentEnd = HoldSegmentII;

% CSM corrections are applied based on S. Vachhani et al. 2013 and G.M. Pharr et al
%. 2009
% h = T(:,2) + T(:,5).*sqrt(2); % displacement(nm)
h = T(:,2);
% P = T(:,3) + T(:,6).*sqrt(2).*10^-3; % Load (mN)
P = T(:,3);
S0 = T(:,4); % Harmonic Stiffness (N/m)
S1 = S0./1e6;  % To convert S from N/m into mN/nm
% K = 0.6524;
% m = 1.5;
% S2 = 1/sqrt(2*pi).*P./T(:,5).*(1/K)^(1/m) .* (1 - (1 - 2*sqrt(2).*T(:,5).*S1./P).^(1/m));

% find the last imaginary data point for S2.
% im = imag(S2);
im = imag(S1);
imd = find(im~=0,1,'last');
if isempty(imd) == 1
    imd = 0;
end
TestData.StiffnessSegmentStart = imd +1;

% T(1:end, 7:9) = [h, P, S2];
T(1:end, 7:9) = [h, P, S1];

TestData.Data = T;

if TestData.StiffnessSegmentStart > seg_start || TestData.LoadSegmentEnd <= seg_end
     warning('segment portion selection wrong');
    return
end

end



    
    


