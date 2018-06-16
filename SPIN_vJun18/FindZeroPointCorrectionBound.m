function [ilcut iucut] = FindZeroPointCorrectionBound(N, X, wr)

% Gives lower bound index of X as "ilcut" and upper boudn index of X as "iucut"
[~,locs,w] = findpeaks(N,X,'MinPeakHeight',1/3*max(N));
    if isempty(locs) % maximum at the ends
        [~,locn] = max(N);
        if locn == 1
            lb = X(1);
            yn = [flip(N(2:end)) N];
            [~,~,w] = findpeaks(yn,'MinPeakHeight',1/3*max(N));
            ub = min((X(1) + wr * w * abs(X(2)-X(1))), X(end));
        else
            ub = X(end);
            yn = [N flip(N(1:end-1))];
            [~,~,w] = findpeaks(yn,'MinPeakHeight',1/3*max(N));
            lb = max((X(end) - wr * w * abs(X(2)-X(1))), X(1));
        end
    else % some peak/peaks not at the ends
        if N(1) >= (1/3*max(N)) % if first N value as large as a peak, set lower bound as X(1). otherwise, as lower bound of the first peak
        	lb = X(1);
        else
          	lb = max(locs(1) - wr * w(1), X(1));
        end
     	if N(end) >= (1/3*max(N)) % if last N value as large as a peak, set upper bound as X(end). otherwise, as upper bound of the last peak
        	ub = X(end);
    	else
          	ub = min(locs(end) + wr * w(end), X(end));
        end
    end
    
    ilcut = max(find((X - lb)<=0));
    iucut = min(find((X - ub)>=0));
    
end
