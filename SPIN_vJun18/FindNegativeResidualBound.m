function [ilcut, iucut] = FindNegativeResidualBound(N, X, wr)

% Gives lower bound index of X as "ilcut" and upper boudn index of X as "iucut"

    yn = [N flip(N(1:end-1))];
    xn = [X X(end)+(X(end)-flip(X(1:end-1)))];
    [~,locs,w] = findpeaks(yn, xn,'MinPeakHeight',1/3*max(yn));
    flag = 0;
    if isempty(locs) % maximum peak at the low x end
        lb = X(1);
        ub = X(end);
    elseif size(locs,2) > 2 % mulitple peaks
        pksn = size(locs,2);
        for iii = 1:(floor(pksn/2)+1)
            if ((locs(iii) - wr * w(iii)) <= X(end)) && ((locs(iii) + wr * w(iii)) >= X(end)) % check if any of the peaks has X(end) value
                flag = 1;
               	zpindex = iii;
             	break
            end
        end
        if flag
            if zpindex == 1
                ub = X(end);
                lb = max(locs(zpindex) - wr * w(zpindex), X(1));
            else
             	lbindex = FindLinkedPeaksLowerBound(locs, w, wr, zpindex-1);
             	lb = max(locs(lbindex) - wr * w(lbindex), X(1));
             	ub = X(end);
            end
        else
            lbindex = FindLinkedPeaksLowerBound(locs, w, wr, (pksn/2));
            lb = max(locs(lbindex) - wr * w(lbindex), X(1));
          	ub = X(end);
        end
    else % single peak or max at X(end)
        lb = max(locs(1) - wr * w(1), X(1));
      	ub = X(end);
    end
    
    
    ilcut = max(find((X - lb)<=0));
    iucut = min(find((X - ub)>=0));
end
