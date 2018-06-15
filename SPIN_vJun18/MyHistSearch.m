function [histy, mflag] = MyHistSearch(SearchResults, bins, wr, wr2, histplot)

histy.Estar = NaN;
histy.Esample = NaN;
histy.ModLength = NaN;
histy.Fit1R2 = NaN;
histy.Fit1AAR = NaN;
histy.Fit1MAR = NaN;
histy.Fit2R2 = NaN;
histy.Fit2AAR = NaN;
histy.Fit2MAR = NaN;
histy.Fit3R2 = NaN;
histy.hchange = NaN;
histy.Pchange = NaN;
histy.Fit4AAR = NaN;
histy.Fit4MAR = NaN;
histy.P_star = NaN;
histy.h_star = NaN;
histy.dP = NaN;
histy.dH = NaN;


%% the histogram plots
Fit1 = [SearchResults.Fit1];
Fit2 = [SearchResults.Fit2];
Fit3 = [SearchResults.Fit3];
Fit4 = [SearchResults.Fit4];

if histplot
subplot(4,4,1) % E_star & E_sample
end
mflag = 0;
[N, X] = hist([SearchResults.E_star], bins);
histy.Estar = [N; X];
if histplot
plot(X,N,'b.-');
hold on
end
[N, X] = hist([SearchResults.E_sample], bins);
histy.Esample = [N; X];
if histplot
plot(X,N,'g.-');
%   find the peaks in histograms  
    hold on
end
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
        mflag = 0;
        for iii = 1:size(pks,2)-1
            if (locs(iii) + wr * w(iii)) < (locs(iii+1) - wr * w(iii+1))
                mflag = 1;
            end
        end
        if mflag == 1
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
    % plot the peak regions
    ilcut = max(find((X - lb)<=0));
    iucut = min(find((X - ub)>=0));
    if histplot
    plot(X(ilcut:iucut),N(ilcut:iucut),'r.-');
    end
% get lower and upper bounds
bw = abs(X(1)-X(2)); % histogram bin width
tol = 0.05*bw; % tolerance
filt_n = [X(ilcut)- (bw/2 + tol) X(iucut)+ (bw/2 + tol)];
%
if histplot
xlabel('Modulus [GPa]', 'FontWeight', 'Bold');
legend('effective','sample','Location','NorthWest');
hold off
end

if histplot
subplot(4,4,2) % Fit1 & Fit2 & Fit3 R2
end
[N, X] = hist([Fit1.Rsquared], bins);
if histplot
plot(X,N,'b.-');
end
histy.Fit1R2 = [N; X];
% get lower and upper bounds
bw = abs(X(1)-X(2)); % histogram bin width
tol = 0.05*bw; % tolerance
filt_n = [filt_n; min(X)- (bw/2 + tol) max(X) + (bw/2 + tol)];
%
[N, X] = hist([Fit2.Rsquared], bins);
histy.Fit2R2 = [N; X];
if histplot
hold on
plot(X,N,'g.-');
end
[N, X] = hist([Fit3.Rsquared], bins);
histy.Fit3R2 = [N; X];
if histplot
hold on
plot(X,N,'r.-');
xlabel('R^2', 'FontWeight', 'Bold');
legend('Fit1','Fit2', 'Fit3','Location','NorthWest');
hold off

subplot(4,4,3); % Modulus Segment Length
end
[N, X] = hist([SearchResults.modulus_length], bins);
histy.ModLength = [N; X];
if histplot
plot(X,N,'b.-');
end
% get lower and upper bounds
bw = abs(X(1)-X(2)); % histogram bin width
tol = 0.05*bw; % tolerance
filt_n = [filt_n; min(X)- (bw/2 + tol)  max(X) + (bw/2 + tol)];
%
if histplot
xlabel('Modulus Length [#points]', 'FontWeight', 'Bold');

subplot(4,4,4) % Fit2 R2
end
[N, X] = hist([Fit2.Rsquared], bins);
histy.Fit2R2 = [N; X];
if histplot
plot(X,N,'b.-');
end
% get lower and upper bounds
bw = abs(X(1)-X(2)); % histogram bin width
tol = 0.05*bw; % tolerance
filt_n = [filt_n; min(X)- (bw/2 + tol) max(X) + (bw/2 + tol)];
%
if histplot
xlabel('Fit2 R^2', 'FontWeight', 'Bold');

subplot(4,4,5); % Fit1 AAR
end
[N, X] = hist([Fit1.AverageAbsoluteResidual], bins);
histy.Fit1AAR = [N; X];
if histplot
plot(X,N,'b.-');
%   find the peaks in histograms  
    hold on
end
    [pks,locs,w] = findpeaks(N,X,'MinPeakHeight',1/3*max(N));
    flag = 0;
    if isempty(pks) % maximum at the ends
        [pks,locn] = max(N);
        if locn == 1
            lb = X(1);
            yn = [flip(N(2:end)) N];
            [pks,locs,w] = findpeaks(yn,'MinPeakHeight',1/3*max(N));
            ub = min((X(1) + wr * w * abs(X(2)-X(1))), X(end));
        else
            lb = X(1);
            ub = X(end);
        end
    elseif size(pks,2) > 1 % mulitple peaks
        for iii = 1:size(pks,2)
            if ((locs(iii) - wr * w(iii)) <= 0) && ((locs(iii) + wr * w(iii)) >= 0) % check if any of the peaks has 0 x value
                flag = 1;
                zpindex = iii;
                break
            end
        end
        if flag == 1 % keep the peak which has 0 x value and keep whichever peak linked to this peak
            if zpindex == 1
                linkflag = 1;
                for iv = 1:(size(pks,2)-1)
                    if locs(iv) + wr * w(iv) < locs(iv+1) - wr * w(iv+1)
                        ub = min((locs(iv) + wr * w(iv)), X(end));
                        lb = max((locs(1) - wr * w(1)), X(1));
                        linkflag = 0;
                        break
                    end
                end
                if linkflag
                    lb = max((locs(1) - wr * w(1)), X(1));
                    ub = min((locs(size(pks,2)) + wr * w(size(pks,2))), X(end));
                end
            else
% % % % %                         
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
        else
            lb = X(1);
            ub = locs - wr2 * w;
        end
    end
    % plot the peak regions
    ilcut = max(find((X - lb)<=0));
    iucut = min(find((X - ub)>=0));
    if histplot
    plot(X(ilcut:iucut),N(ilcut:iucut),'r.-');
    end
% get lower and upper bounds
bw = abs(X(1)-X(2)); % histogram bin width
tol = 0.05*bw; % tolerance
filt_n = [filt_n; X(ilcut)- (bw/2 + tol) X(iucut)+ (bw/2 + tol)];
%
if histplot
xlabel('Fit1 Avg.Abs.Res.', 'FontWeight', 'Bold');

subplot(4,4,6); % Fit1 MAR
end
[N, X] = hist([Fit1.MaxAbsoluteResidual], bins);
histy.Fit1MAR = [N; X];
if histplot
plot(X,N,'b.-');
%   find the peaks in histograms  
    hold on
end
    [pks,locs,w] = findpeaks(N,X,'MinPeakHeight',1/3*max(N));
    flag = 0;
    if isempty(pks) % maximum at the ends
        [pks,locn] = max(N);
        if locn == 1
            lb = X(1);
            yn = [flip(N(2:end)) N];
            [pks,locs,w] = findpeaks(yn,'MinPeakHeight',1/3*max(N));
            ub = min((X(1) + wr * w * abs(X(2)-X(1))), X(end));
        else
            lb = X(1);
            yn = [N flip(N(1:end-1))];
            [pks,locs,w] = findpeaks(yn,'MinPeakHeight',1/3*max(N));
            ub = X(end) - wr2 * w * abs(X(2)-X(1));
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
        else
            lb = X(1);
            ub = locs - wr2 * w;
        end
    end
    % plot the peak regions
    ilcut = max(find((X - lb)<=0));
    iucut = min(find((X - ub)>=0));
    if histplot
    plot(X(ilcut:iucut),N(ilcut:iucut),'r.-');
    end
% get lower and upper bounds
bw = abs(X(1)-X(2)); % histogram bin width
tol = 0.05*bw; % tolerance
filt_n = [filt_n; X(ilcut)- (bw/2 + tol) X(iucut)+ (bw/2 + tol)];
%
if histplot
xlabel('Fit1 Max.Abs.Res.', 'FontWeight', 'Bold');

subplot(4,4,7); % Fit2 AAR
end
[N, X] = hist([Fit2.AverageAbsoluteResidual], bins);
histy.Fit2AAR = [N; X];
if histplot
plot(X,N,'b.-');
%   find the peaks in histograms  
    hold on
end
    [pks,locs,w] = findpeaks(N,X,'MinPeakHeight',1/3*max(N));
    flag = 0;
    if isempty(pks) % maximum at the ends
        [pks,locn] = max(N);
        if locn == 1
            lb = X(1);
            yn = [flip(N(2:end)) N];
            [pks,locs,w] = findpeaks(yn,'MinPeakHeight',1/3*max(N));
            ub = min((X(1) + wr * w * abs(X(2)-X(1))), X(end));
        else
            lb = X(1);
            yn = [N flip(N(1:end-1))];
            [pks,locs,w] = findpeaks(yn,'MinPeakHeight',1/3*max(N));
            ub = X(end) - wr2 * w * abs(X(2)-X(1));
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
        else
            lb = X(1);
            ub = locs - wr2 * w;
        end
    end
    % plot the peak regions
    ilcut = max(find((X - lb)<=0));
    iucut = min(find((X - ub)>=0));
    if histplot
    plot(X(ilcut:iucut),N(ilcut:iucut),'r.-');
    end
% get lower and upper bounds
bw = abs(X(1)-X(2)); % histogram bin width
tol = 0.05*bw; % tolerance
filt_n = [filt_n; X(ilcut)- (bw/2 + tol) X(iucut)+ (bw/2 + tol)];
%
if histplot
xlabel('Fit2 Avg.Abs.Res.', 'FontWeight', 'Bold');

subplot(4,4,8); % Fit2 MAR
end
[N, X] = hist([Fit2.MaxAbsoluteResidual], bins);
histy.Fit2MAR = [N; X];
if histplot
plot(X,N,'b.-');
%   find the peaks in histograms  
    hold on
end
    [pks,locs,w] = findpeaks(N,X,'MinPeakHeight',1/3*max(N));
    flag = 0;
    if isempty(pks) % maximum at the ends
        [pks,locn] = max(N);
        if locn == 1
            lb = X(1);
            yn = [flip(N(2:end)) N];
            [pks,locs,w] = findpeaks(yn,'MinPeakHeight',1/3*max(N));
            ub = min((X(1) + wr * w * abs(X(2)-X(1))), X(end));
        else
            lb = X(1);
            yn = [N flip(N(1:end-1))];
            [pks,locs,w] = findpeaks(yn,'MinPeakHeight',1/3*max(N));
            ub = X(end) - wr2 * w * abs(X(2)-X(1));
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
        else
            lb = X(1);
            ub = locs - wr2 * w;
        end
    end
    % plot the peak regions
    ilcut = max(find((X - lb)<=0));
    iucut = min(find((X - ub)>=0));
    if histplot
    plot(X(ilcut:iucut),N(ilcut:iucut),'r.-');
    end
% get lower and upper bounds
bw = abs(X(1)-X(2)); % histogram bin width
tol = 0.05*bw; % tolerance
filt_n = [filt_n; X(ilcut)- (bw/2 + tol) X(iucut)+ (bw/2 + tol)];
%
if histplot
xlabel('Fit2 Max.Abs.Res.', 'FontWeight', 'Bold');

subplot(4,4,9); % h_change
end
[N, X] = hist([SearchResults.h_change], bins);
histy.hchange = [N; X];
if histplot
plot(X,N,'b.-');
%   find the peaks in histograms  
    hold on
end
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
    % plot the peak regions
    ilcut = max(find((X - lb)<=0));
    iucut = min(find((X - ub)>=0));
    if histplot
    plot(X(ilcut:iucut),N(ilcut:iucut),'r.-');
    end
% get lower and upper bounds
bw = abs(X(1)-X(2)); % histogram bin width
tol = 0.05*bw; % tolerance
filt_n = [filt_n; X(ilcut)- (bw/2 + tol) X(iucut)+ (bw/2 + tol)];
%
if histplot
xlabel('h change [nm/nm]', 'FontWeight', 'Bold');

subplot(4,4,10); % P_change
end
[N, X] = hist([SearchResults.p_change], bins);
histy.Pchange = [N; X];
if histplot
plot(X,N,'b.-');
%   find the peaks in histograms  
    hold on
end
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
    % plot the peak regions
    ilcut = max(find((X - lb)<=0));
    iucut = min(find((X - ub)>=0));
    if histplot
    plot(X(ilcut:iucut),N(ilcut:iucut),'r.-');
    end
% get lower and upper bounds
bw = abs(X(1)-X(2)); % histogram bin width
tol = 0.05*bw; % tolerance
filt_n = [filt_n; X(ilcut)- (bw/2 + tol) X(iucut)+ (bw/2 + tol)];
%
if histplot
xlabel('P change [mN/mN]', 'FontWeight', 'Bold');

subplot(4,4,11); % Fit4 Avg. Abs. Residual
end
[N, X] = hist([Fit4.AverageAbsoluteResidual], bins);
histy.Fit4AAR = [N; X];
if histplot
plot(X, N, 'b.-');
%   find the peaks in histograms  
    hold on
end
    [pks,locs,w] = findpeaks(N,X,'MinPeakHeight',1/3*max(N));
    flag = 0;
    if isempty(pks) % maximum at the ends
        [pks,locn] = max(N);
        if locn == 1
            lb = X(1);
            yn = [flip(N(2:end)) N];
            [pks,locs,w] = findpeaks(yn,'MinPeakHeight',1/3*max(N));
            ub = min((X(1) + wr * w * abs(X(2)-X(1))), X(end));
        else
            lb = X(1);
            yn = [N flip(N(1:end-1))];
            [pks,locs,w] = findpeaks(yn,'MinPeakHeight',1/3*max(N));
            ub = X(end) - wr2 * w * abs(X(2)-X(1));
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
        else
            lb = X(1);
            ub = locs - wr2 * w;
        end
    end
    % plot the peak regions
    ilcut = max(find((X - lb)<=0));
    iucut = min(find((X - ub)>=0));
    if histplot
    plot(X(ilcut:iucut),N(ilcut:iucut),'r.-');
    end
% get lower and upper bounds
bw = abs(X(1)-X(2)); % histogram bin width
tol = 0.05*bw; % tolerance
filt_n = [filt_n; X(ilcut)- (bw/2 + tol) X(iucut)+ (bw/2 + tol)];
%
if histplot
xlabel('Fit4 Avg.Abs.Res.', 'FontWeight', 'Bold');

subplot(4,4,12); % Fit4 MaxAbsResidual
end
[N, X] = hist([Fit4.MaxAbsoluteResidual], bins);
histy.Fit4MAR = [N; X];
if histplot
plot(X,N,'b.-');
%   find the peaks in histograms  
    hold on
end
    [pks,locs,w] = findpeaks(N,X,'MinPeakHeight',1/3*max(N));
    flag = 0;
    if isempty(pks) % maximum at the ends
        [pks,locn] = max(N);
        if locn == 1
            lb = X(1);
            yn = [flip(N(2:end)) N];
            [pks,locs,w] = findpeaks(yn,'MinPeakHeight',1/3*max(N));
            ub = min((X(1) + wr * w * abs(X(2)-X(1))), X(end));
        else
            lb = X(1);
            yn = [N flip(N(1:end-1))];
            [pks,locs,w] = findpeaks(yn,'MinPeakHeight',1/3*max(N));
            ub = X(end) - wr2 * w * abs(X(2)-X(1));
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
        else
            lb = X(1);
            ub = locs - wr2 * w;
        end
    end
    % plot the peak regions
    ilcut = max(find((X - lb)<=0));
    iucut = min(find((X - ub)>=0));
    if histplot
    plot(X(ilcut:iucut),N(ilcut:iucut),'r.-');
    end
% get lower and upper bounds
bw = abs(X(1)-X(2)); % histogram bin width
tol = 0.05*bw; % tolerance
filt_n = [filt_n; X(ilcut)- (bw/2 + tol) X(iucut)+ (bw/2 + tol)];
% 
if histplot
xlabel('Fit4 Max.Abs.Res.', 'FontWeight', 'Bold');

subplot(4,4,13); % P_star
end
[N, X] = hist([SearchResults.P_star], bins);
histy.P_star = [N; X];
if histplot
plot(X,N,'b.-');
%   find the peaks in histograms  
    hold on
end
    [pks,locs,w] = findpeaks(N,X,'MinPeakHeight',1/3*max(N));
    if isempty(pks) % maximum at the ends
        [pks,locn] = max(N);
        if locn == 1
            lb = X(1);
            yn = [flip(N(2:end)) N];
            [pks,locs,w] = findpeaks(yn,'MinPeakHeight',1/3*max(N));
            ub = X(1) + wr * w * abs(X(2)-X(1));
        else
            ub = X(end);
            yn = [N flip(N(1:end-1))];
            [pks,locs,w] = findpeaks(yn,'MinPeakHeight',1/3*max(N));
            lb = X(end) - wr * w * abs(X(2)-X(1));
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
    % plot the peak regions
    ilcut = max(find((X - lb)<=0));
    iucut = min(find((X - ub)>=0));
    if histplot
    plot(X(ilcut:iucut),N(ilcut:iucut),'r.-');
    end
% get lower and upper bounds
bw = abs(X(1)-X(2)); % histogram bin width
tol = 0.05*bw; % tolerance
filt_n = [filt_n; X(ilcut)- (bw/2 + tol) X(iucut)+ (bw/2 + tol)];
%
if histplot
xlabel('P^* [mN]', 'FontWeight', 'Bold');

subplot(4,4,14); % h_star
end
[N, X] = hist([SearchResults.h_star], bins);
histy.h_star = [N; X];
if histplot
plot(X,N,'b.-');
%   find the peaks in histograms  
    hold on
end
    [pks,locs,w] = findpeaks(N,X,'MinPeakHeight',1/3*max(N));
    if isempty(pks) % maximum at the ends
        [pks,locn] = max(N);
        if locn == 1
            lb = X(1);
            yn = [flip(N(2:end)) N];
            [pks,locs,w] = findpeaks(yn,'MinPeakHeight',1/3*max(N));
            ub = X(1) + wr * w * abs(X(2)-X(1));
        else
            ub = X(end);
            yn = [N flip(N(1:end-1))];
            [pks,locs,w] = findpeaks(yn,'MinPeakHeight',1/3*max(N));
            lb = X(end) - wr * w * abs(X(2)-X(1));
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
    % plot the peak regions
    ilcut = max(find((X - lb)<=0));
    iucut = min(find((X - ub)>=0));
    if histplot
    plot(X(ilcut:iucut),N(ilcut:iucut),'r.-');
    end
% get lower and upper bounds
bw = abs(X(1)-X(2)); % histogram bin width
tol = 0.05*bw; % tolerance
filt_n = [filt_n; X(ilcut)- (bw/2 + tol) X(iucut)+ (bw/2 + tol)];
% 
if histplot
xlabel('h^* [nm]', 'FontWeight', 'Bold');

subplot(4,4,15); % dP
end
[N, X] = hist([SearchResults.dP], bins);
histy.dP = [N; X];
if histplot
plot(X,N,'b.-');
%   find the peaks in histograms  
    hold on
end
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
    % plot the peak regions
    ilcut = max(find((X - lb)<=0));
    iucut = min(find((X - ub)>=0));
    if histplot
    plot(X(ilcut:iucut),N(ilcut:iucut),'r.-');
    end
% get lower and upper bounds
bw = abs(X(1)-X(2)); % histogram bin width
tol = 0.05*bw; % tolerance
filt_n = [filt_n; X(ilcut)- (bw/2 + tol) X(iucut)+ (bw/2 + tol)];
%
if histplot
xlabel('dP [mN]', 'FontWeight', 'Bold');

subplot(4,4,16); % dH
end
[N, X] = hist([SearchResults.dH], bins);
histy.dH = [N; X];
if histplot
plot(X,N,'b.-');
%   find the peaks in histograms  
    hold on
end
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
    % plot the peak regions
    ilcut = max(find((X - lb)<=0));
    iucut = min(find((X - ub)>=0));
    if histplot
    plot(X(ilcut:iucut),N(ilcut:iucut),'r.-');
    end
% get lower and upper bounds
bw = abs(X(1)-X(2)); % histogram bin width
tol = 0.05*bw; % tolerance
filt_n = [filt_n; X(ilcut)- (bw/2 + tol) X(iucut)+ (bw/2 + tol)];
% 
if histplot
xlabel('dH [nm]', 'FontWeight', 'Bold');




% uicontrol('style','pushbutton','String',...
%            'Save New Filter',...
%            'Position', [20 40 160 30],...
%            'Callback',@UpdateFilter2);
end
xlb = {'E_sample';...
    'R21';...    
    'ModLength';...
    'R22';... 
    
    'AAR1';...
    'MAR1';...
    'AAR2';...
    'MAR2';...
    
    'h_change';...    
    'p_change';...
    'AAR4';...
    'MAR4';...
    
    'P*';...
    'h*';...
    'dP';...
    'dH'};



% make mflag to 1 if newfilter is no stricter than the original one
if min(histy.Esample(2,:)) >= filt_n(1,1) && max(histy.Esample(2,:)) <= filt_n(1,2) && ...
        min(histy.Fit1R2(2,:)) >= filt_n(2,1) && max(histy.Fit1R2(2,:)) <= filt_n(2,2) && ...
        min(histy.ModLength(2,:)) >= filt_n(X,1) && max(histy.ModLength(2,:)) <= filt_n(X,2) &&...
        min(histy.Fit2R2(2,:)) >= filt_n(X,1) && max(histy.Fit2R2(2,:)) <= filt_n(X,2) &&...
        min(histy.Fit1AAR(2,:)) >= filt_n(X,1) && max(histy.Fit1AAR(2,:)) <= filt_n(X,2) &&...
        min(histy.Fit1MAR(2,:)) >= filt_n(X,1) && max(histy.Fit1MAR(2,:)) <= filt_n(X,2) &&...
        min(histy.Fit2AAR(2,:)) >= filt_n(X,1) && max(histy.Fit2AAR(2,:)) <= filt_n(X,2) &&...
        min(histy.Fit2MAR(2,:)) >= filt_n(X,1) && max(histy.Fit2MAR(2,:)) <= filt_n(X,2) &&...
        min(histy.hchange(2,:)) >= filt_n(X,1) && max(histy.hchange(2,:)) <= filt_n(X,2) &&...
        min(histy.Pchange(2,:)) >= filt_n(X,1) && max(histy.Pchange(2,:)) <= filt_n(X,2) &&...
        min(histy.Fit4AAR(2,:)) >= filt_n(X,1) && max(histy.Fit4AAR(2,:)) <= filt_n(X,2) &&...
        min(histy.Fit4MAR(2,:)) >= filt_n(X,1) && max(histy.Fit4MAR(2,:)) <= filt_n(X,2) &&...
        min(histy.P_star(2,:)) >= filt_n(X,1) && max(histy.P_star(2,:)) <= filt_n(X,2) &&...
        min(histy.h_star(2,:)) >= filt_n(X,1) && max(histy.h_star(2,:)) <= filt_n(X,2) &&...
        min(histy.dP(2,:)) >= filt_n(X,1) && max(histy.dP(2,:)) <= filt_n(X,2) &&...
        min(histy.dH(2,:)) >= filt_n(X,1) && max(histy.dH(2,:)) <= filt_n(X,2)
    mflag = 1;
end
        
        
        


%     function UpdateFilter2(~,~)
        filt = [xlb, num2cell(filt_n,2)];
% % % if histplot == 0 && mflag == 0
        assignin('base', 'NewFilt', filt);
% % % end
%     end

end
