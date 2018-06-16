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
    [ilcut iucut] = FindZeroPointCorrectionBound(N, X, wr, wr2);
    % plot the peak regions
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
    [ilcut iucut] = FindResidualBound(N, X, wr);
    % plot the peak regions
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
    [ilcut iucut] = FindResidualBound(N, X, wr);
    % plot the peak regions
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
    [ilcut iucut] = FindResidualBound(N, X, wr);
    % plot the peak regions
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
    [ilcut iucut] = FindResidualBound(N, X, wr);
    % plot the peak regions
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
    [ilcut, iucut] = FindNearZeroBound(N, X, wr);
    % plot the peak regions
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
    [ilcut iucut] = FindNearZeroBound(N, X, wr);
    % plot the peak regions
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
    [ilcut iucut] = FindResidualBound(N, X, wr);
    % plot the peak regions
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
    [ilcut iucut] = FindResidualBound(N, X, wr);
    % plot the peak regions
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
    [ilcut iucut] = FindZeroPointCorrectionBound(N, X, wr, wr2);
    % plot the peak regions
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
    [ilcut iucut] = FindZeroPointCorrectionBound(N, X, wr, wr2);
    % plot the peak regions
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
    [ilcut iucut] = FindNearZeroBound(N, X, wr);
    % plot the peak regions
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
    [ilcut iucut] = FindNearZeroBound(N, X, wr);
    % plot the peak regions
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
