function [Estat, Ystat, Hstat, txthist] = MyHistResults(SR, SSR)


E = [SR.E_sample]; 

Estat.mean = mean(E);
Estat.median = median(E);
Estat.stdev = std(E);
Estat.min = min(E);
Estat.max = max(E);

YS = [SSR.Yield_Strength];

Ystat.mean = mean(YS);
Ystat.median = median(YS);
Ystat.stdev = std(YS);
Ystat.min = min(YS);
Ystat.max = max(YS);

Hardening = [SSR.Hardening];
H = Hardening(1,:);

Hstat.mean = mean(H);
Hstat.median = median(H);
Hstat.stdev = std(H);
Hstat.min = min(H);
Hstat.max = max(H);

txthist = [Estat.mean; Estat.stdev; 1; Ystat.mean; Ystat.stdev; Hstat.mean; Hstat.stdev]';

end

