function [ilcut, iucut] = FindNearZeroBound(N, X, wr)

% Gives lower bound index of X as "ilcut" and upper boudn index of X as "iucut"

if X(1) >= 0 % all X >= 0
    [ilcut, iucut] = FindResidualBound(N, X, wr);
elseif X(end) <= 0 % all X <= 0
    [ilcut, iucut] = FindNegativeResidualBound(N, X, wr);
else
    [pks,locs,w] = findpeaks(N, X,'MinPeakHeight',1/3*max(N));
    flag = 0;
    if isempty(pks) % maximum peak at the low or high x end
        yn = [flip(N(2:end)) N];
        xn = [X(1)-(flip(X(2:end))-X(1)) X];
        [pks,locs,w] = findpeaks(yn, xn,'MinPeakHeight',1/3*max(yn));
        if (~isempty(pks)) && ((locs - wr * w) <= 0) && ((locs + wr * w) >= 0)
            ub = min(locs + wr * w, X(end));
            lb = X(1);
        else
            yn = [N flip(N(1:end-1))];
            xn = [X X(end)+(X(end)-flip(X(1:end-1)))];
            [pks,locs,w] = findpeaks(yn, xn,'MinPeakHeight',1/3*max(yn));
            if (~isempty(pks)) && ((locs - wr * w) <= 0) && ((locs + wr * w) >= 0)
                lb = max(locs - wr * w, X(1));
                ub = X(end);
            else
                lb = X(1);
                ub = X(end);
            end
        end
    elseif size(pks,2) > 1 % mulitple peaks
        pksn = size(pks,2);
        for iii = 1:pksn
            if ((locs(iii) - wr * w(iii)) <= 0) && ((locs(iii) + wr * w(iii)) >= 0) % check if any of the peaks has 0 x value
                flag = 1;
               	zpindex = iii;
             	break
            end
        end
        if flag % certain peak has 0 in its x range
            if zpindex == 1
                lb = max(locs(zpindex) - wr * w(zpindex), X(1));
                ubindex = FindLinkedPeaksUpperBound(locs, w, wr, zpindex+1);
              	ub = min((locs(ubindex) + wr * w(ubindex)), X(end));              
            elseif zpindex == pksn
                ub= min((locs(zpindex) + wr * w(zpindex)), X(end));
                lbindex = FindLinkedPeaksLowerBound(locs, w, wr, zpindex-1);
             	lb = max(locs(lbindex) - wr * w(lbindex), X(1));
            else
                ubindex = FindLinkedPeaksUpperBound(locs, w, wr, zpindex+1);
              	ub = min((locs(ubindex) + wr * w(ubindex)), X(end));
                lbindex = FindLinkedPeaksLowerBound(locs, w, wr, zpindex-1);
             	lb = max(locs(lbindex) - wr * w(lbindex), X(1));
            end
        else % no peak has 0 in its x range
            ubflag = 0;
            for iv = 1:pksn
                if locs(iv) - wr * w(iv) > 0
                    ubindex = iv;
                    ubflag = 1;
                    break
                end
            end
            if ubflag == 0
                ub = X(end);
                lb = max(locs(pksn) - wr * w(pksn), X(1));
            elseif ubindex ==1
                lb = X(1);
                ub = min((locs(1) + wr * w(1)), X(end));
            else
                lb = max(locs(ubindex-1) - wr * w(ubindex-1), X(1));
                ub = min((locs(ubindex) + wr * w(ubindex)), X(end));
            end
        end
    else % single peak
        if (locs + wr * w) > 0 && (locs - wr * w) > 0
            ub = min((locs + wr * w), X(end));
         	lb = X(1);
        elseif (locs + wr * w) < 0 && (locs - wr * w) < 0
            ub = X(end);
            lb = max((locs - wr * w), X(1));
        else
            if locs < 0
                xn = X(X<0);
                yn = N(X<0);
                [ilcut, iucut] = FindNegativeResidualBound(yn, xn, wr);
                lb = xn(ilcut);
                ub = min(locs + wr * w, X(end));
            else
                xn = X(X>0);
                yn = N(X>0);
                [ilcut, iucut] = FindResidualBound(yn, xn, wr);
                ub = xn(iucut);
                lb = max(locs - wr * w, X(1));
            end
        end
    end
    ilcut = max(find((X - lb)<=0));
    iucut = min(find((X - ub)>=0));
end

