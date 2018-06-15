function subslider(histy)
clf
% x and y are the histogram data: x is variable, y is the count/frequency

% order and variables in x and y should match
% order and variable labels in lbd should also match
% labels must be exact text for filter called variables
% any 16 variables or more I guess could go in this plot

x = [...
histy.Esample(2,:)',...   %row 1 of plots
histy.Fit1R2(2,:)',...
histy.ModLength(2,:)',...
histy.Fit2R2(2,:)',...
histy.Fit1AAR(2,:)',... % row 2 of plots
histy.Fit1MAR(2,:)',...
histy.Fit2AAR(2,:)',...
histy.Fit2MAR(2,:)',...
histy.hchange(2,:)',... % row 3 of plots
histy.Pchange(2,:)',...
histy.Fit4AAR(2,:)',...
histy.Fit4MAR(2,:)',...
histy.P_star(2,:)',...  % row 4 of plots
histy.h_star(2,:)',...
histy.dP(2,:)',...
histy.dH(2,:)',...
];
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

y = [...
histy.Esample(1,:)',...   %row 1 of plots
histy.Fit1R2(1,:)',...
histy.ModLength(1,:)',...
histy.Fit2R2(1,:)',...
histy.Fit1AAR(1,:)',... % row 2 of plots
histy.Fit1MAR(1,:)',...
histy.Fit2AAR(1,:)',...
histy.Fit2MAR(1,:)',...
histy.hchange(1,:)',... % row 3 of plots
histy.Pchange(1,:)',...
histy.Fit4AAR(1,:)',...
histy.Fit4MAR(1,:)',...
histy.P_star(1,:)',...  % row 4 of plots
histy.h_star(1,:)',...
histy.dP(1,:)',...
histy.dH(1,:)',...
];
for ii = 1:16 % number of plots
    
    h(ii) = subplot(4,4,ii);
    plot(x(:,ii),y(:,ii),'b.-');
    axis([min(x(:,ii)), max(x(:,ii)), min(y(:,ii)), max(y(:,ii))])
    
%   find the peaks in histograms  
%     hold on
%     [pks,locs,w] = findpeaks(y(:,ii),x(:,ii),'MinPeakHeight',1/3*max(y(:,ii)));
%     if isempty(pks) % maximum at the ends
%         [pks,locn] = max(y(:,ii));
%         if locn == 1
%             lb = x(1,ii);
%             yn = [y(1,ii)-1;y(:,ii)];
%             [pks,locs,w] = findpeaks(yn);
%             ub = x(1,ii) + w * abs(x(1,ii)-x(2,ii));
%         else
%             ub = x(end,ii);
%             yn = [y(:,ii);y(end,ii)-1];
%             [pks,locs,w] = findpeaks(yn);
%             lb = x(end,ii) - w * abs(x(1,ii)-x(2,ii));
%         end
%     elseif size(pks,1) > 1 % mulitple peaks
%         flag = 0;
%         for iii = 1:size(pks,1)-1
%             if (locs(iii) + w(iii)) < (locs(iii+1) - w(iii+1))
%                 flag = 1;
%             end
%         end
%         if flag
%             warning('multiple regions for possible answers - please reselect mother answer');
%         else % combine multiple peaks into one region
%             ub = min ((locs(end) + w(end)), x(end,ii));
%             lb = max ((locs(1) + w(1)), x(1,ii));
%         end
%     else % single peak
%         ub = min ((locs + w), x(end,ii));
%         lb = max ((locs - w), x(1,ii));
%     end
%     % plot the peak regions
%     [clcut, ilcut] = min(abs(x(:,ii) - lb));
%     [cucut, iucut] = min(abs(x(:,ii) - ub));
%     plot(x(ilcut:iucut,ii),y(ilcut:iucut,ii),'g.-');
%     
    xlabel(xlb{ii});
    offset = -0.01;
    wd = 0.01;
    
    % left slider, low
    hslide(ii) = uicontrol('style','slider');
    set(hslide(ii),'units',get(h(ii),'units'))
    subpos = get(h(ii),'position');
    % position left, bot, width, height
    slidepos = [subpos(1)+2.8*offset subpos(2)+offset wd subpos(4)-2*offset];
    set(hslide(ii),'position',slidepos);
    set(hslide(ii),'Callback',@SliderCallback);
    set(hslide(ii),'Min',min(x(:,ii)),'Max',max(x(:,ii)),'Value',min(x(:,ii)));
    
    % right slider, high
    hslide(ii+16) = uicontrol('style','slider');
    set(hslide(ii+16),'units',get(h(ii),'units'))
    subpos = get(h(ii),'position');
    % position left, bot, width, height
    slidepos = [subpos(1)+subpos(3)-offset-wd subpos(2)+offset wd subpos(4)-2*offset];
    set(hslide(ii+16),'position',slidepos);
    set(hslide(ii+16),'Callback',@SliderCallback);
    set(hslide(ii+16),'Min',min(x(:,ii)),'Max',max(x(:,ii)),'Value',max(x(:,ii))); 
end

    function SliderCallback(~,~)
        for ii = 1:16
            % update plots
            SliderValue_L = get(hslide(ii),'Value');
            SliderValue_R = get(hslide(ii+16),'Value');
            new_data = ( x(:,ii) >= SliderValue_L & x(:,ii) <= SliderValue_R );
            newy_data = y(new_data,ii);
            newx_data = x(new_data,ii);
            subplot(4,4,ii)
            plot(newx_data, newy_data,'b.-');
            axis([min(x(:,ii)), max(x(:,ii)), min(y(:,ii)), max(y(:,ii))])
            xlabel(xlb{ii});
        end
    end

uicontrol('style','pushbutton','String',...
           'Save New Filter',...
           'Position', [20 40 160 30],...
           'Callback',@UpdateFilter);

    function UpdateFilter(~,~)
        for ii = 1:16
            bw = abs(x(1,ii)-x(2,ii)); % histogram bin width
            tol = 0.05*bw; % tolerance
            newslider(ii) = get(hslide(ii),'Value') - (bw/2 + tol);
            newslider(ii+16) = get(hslide(ii+16),'Value') + (bw/2 + tol);
        end
        filt_n = [newslider(1:16); newslider(17:32)];
        filt = [xlb, num2cell(filt_n,1)'];
        assignin('base', 'NewFilt', filt);
    end


end

