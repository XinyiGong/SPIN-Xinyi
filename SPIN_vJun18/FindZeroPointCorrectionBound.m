function [ilcut iucut] = FindZeroPointCorrectionBound(N, X, wr, wr2)

% Gives lower bound index of X as "ilcut" and upper boudn index of X as "iucut"
[pks,locs,w] = findpeaks(N,X,'MinPeakHeight',1/3*max(N));
    if isempty(pks) % maximum at the ends
        [pks,locn] = max(N);
        if locn == 1
            lb = X(1);
            yn = [flip(N(2:end)) N];
            [pks,locs,w] = findpeaks(yn,'MinPeakHeight',1/3*max(N));
            ub = min((X(1) + wr * w * abs(X(2)-X(1))), X(end));
        else
            ub = X(end);
            yn = [N flip(N(1:end-1))];
            [pks,locs,w] = findpeaks(yn,'MinPeakHeight',1/3*max(N));
            lb = max((X(end) - wr * w * abs(X(2)-X(1))), X(1));
        end
    elseif size(pks,2) > 1 % mulitple peaks
        flag = 0;
        for iii = 1:size(pks,2)-1
            if (locs(iii) + w(iii)) < (locs(iii+1) - w(iii+1))
                flag = 1;
            end
        end
        if flag == 1
            ub = X(end);
            lb = X(1);
        else % combine multiple peaks into one region
            ub = min ((locs(end) + wr * w(end)), X(end));
            lb = max ((locs(1) - wr * w(1)), X(1));
        end
    else % single peak
        ub = min ((locs + wr * w), X(end));
        lb = max ((locs - wr * w), X(1));
    end
    
    ilcut = max(find((X - lb)<=0));
    iucut = min(find((X - ub)>=0));
    
end
