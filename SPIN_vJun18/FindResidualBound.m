function [ilcut, iucut] = FindResidualBound(N, X, wr)

% Gives lower bound index of X as "ilcut" and upper boudn index of X as "iucut"

    yn = [flip(N(2:end)) N];
    xn = [X(1)-(flip(X(2:end))-X(1)) X];
    [pks,locs,w] = findpeaks(yn, xn,'MinPeakHeight',1/3*max(yn));
    flag = 0;
    if isempty(pks) % maximum peak at the high x end
        lb = X(1);
        ub = X(end);
    elseif size(pks,2) > 2 % mulitple peaks
        pksn = size(pks,2);
        for iii = 1:pksn
            if ((locs(pksn+1-iii) - wr * w(pksn+1-iii)) <= 0) && ((locs(pksn+1-iii) + wr * w(pksn+1-iii)) >= 0) % check if any of the peaks has 0 x value
                flag = 1;
               	zpindex = pksn+1-iii;
             	break
            end
        end
        if flag
            if zpindex == pksn
                ub= min((locs(zpindex) + wr * w(zpindex)), X(end));
                lb = X(1);
            else
                ubindex = FindLinkedPeaksUpperBound(locs, w, wr, zpindex+1);
                ub = min((locs(ubindex) + wr * w(ubindex)), X(end));
               	lb = X(1);
            end
        else
            ubindex = FindLinkedPeaksUpperBound(locs, w, wr, (pksn/2+1));
            ub = min((locs(ubindex) + wr * w(ubindex)), X(end));
            lb = X(1);
        end
    else % single peak or max at X(1)
        pksn = size(pks,2);
        ub = min((locs(pksn) + wr * w(pksn)), X(end));
      	lb = X(1);
    end
    
    
    ilcut = max(find((X - lb)<=0));
    iucut = min(find((X - ub)>=0));