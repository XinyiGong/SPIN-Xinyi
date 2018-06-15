function [ilcut iucut] = FindNearZeroBound(N, X, wr, wr2)

% Gives lower bound index of X as "ilcut" and upper boudn index of X as "iucut"

[pks,locs,w] = findpeaks(N,X,'MinPeakHeight',1/3*max(N));
    flag = 0;
    if isempty(pks) % maximum at the ends
        [pks,locn] = max(N);
        if locn == 1
            if X(1) >= 0
                lb = X(1);
                yn = [flip(N(2:end)) N];
                [pks,locs,w] = findpeaks(yn,'MinPeakHeight',1/3*max(N));
                ub = min((X(1) + wr * w * abs(X(2)-X(1))), X(end));
            else
                yn = [flip(N(2:end)) N];
                [pks,locs,w] = findpeaks(yn,'MinPeakHeight',1/3*max(N));
                if (X(1) + wr * w * abs(X(2)-X(1))) >= 0
                    lb = X(1);
                    ub = min((X(1) + wr * w * abs(X(2)-X(1))), X(end));
                else
                    lb = X(1) + wr2 * w * abs(X(2)-X(1));
                    ub = X(end);
                end
            end
        else
            if X(end) <= 0
                ub = X(end);
                yn = [N flip(N(1:end-1))];
                [pks,locs,w] = findpeaks(yn,'MinPeakHeight',1/3*max(N));
                lb = max(X(end) - wr * w * abs(X(2)-X(1)), X(1));
            else
                yn = [N flip(N(1:end-1))];
                [pks,locs,w] = findpeaks(yn,'MinPeakHeight',1/3*max(N));
                if (X(end) - wr * w * abs(X(2)-X(1))) <= 0
                    ub = X(end);
                    lb = max(X(end) - wr * w * abs(X(2)-X(1)), X(1));
                else
                    lb = X(1);
                    ub = X(end) - wr2 * w * abs(X(2)-X(1));
                end
            end
        end
        
    elseif size(pks,2) > 1 % mulitple peaks
        for iii = 1:size(pks,2)
            if ((locs(iii) - wr * w(iii)) <= 0) && ((locs(iii) + wr * w(iii)) >= 0) % check if any of the peaks has 0 x value
                flag = 1;
                zpindex = iii;
                break
            end
        end
        if flag == 1 % keep the peak which has 0 x value
            ub = min((locs(zpindex) + wr * w(zpindex)), X(end));
            lb = max((locs(zpindex) - wr * w(zpindex)), X(1));
        else % eliminate non-zero x value answers using bounds of peaks
            lb = X(1);
            ub = X(end);
            for iii = 1:size(pks,2)
                if ((locs(iii) - wr2 * w(iii)) > 0) && ((locs(iii) - wr2 * w(iii)) < ub)
                    ub = locs(iii) - wr2 * w(iii);
                end
                if ((locs(iii) + wr2 * w(iii)) < 0) && ((locs(iii) + wr2 * w(iii)) > lb)
                    lb = locs(iii) + wr2 * w(iii);
                end
            end
        end
    else % single peak
        if ((locs - wr * w) <= 0) && ((locs + wr * w) >= 0) % check if the peak has 0 x value
            ub = min((locs + wr * w), X(end));
            lb = max((locs - wr * w), X(1));
        elseif locs - wr * w > 0
            lb = X(1);
            ub = locs - wr2 * w;
        else
            ub = X(end);
            lb = locs + wr2 * w;
        end
    end
    ilcut = max(find((X - lb)<=0));
    iucut = min(find((X - ub)>=0));