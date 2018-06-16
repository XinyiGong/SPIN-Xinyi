function [SearchResults, npoints, HistSearchResults, mflag] = SearchExplorer(TestData, FR, filt, Plastic, BEuler, bins, wr, wr2, limx,limzerox, MaxAnsNum, TestMode)

[SearchResults, npoints] = filterResults(FR, filt); % filter results
    FR = SearchResults;
    SZ = get(0,'Screensize');
    SZ(2) = SZ(2) + 50;
    SZ(4) = SZ(4) - 130;   
    
    if size(SearchResults,2) <= MaxAnsNum % Number of answers is small enough
        nextnewfilt = 0;
        histplot = 0;
        ScatterSliderSwitch = 1;
    else
        if TestMode
            histplot = 1;
            nextnewfilt = 1;
            ScatterSliderSwitch = 1;
        else
            histplot = 0;
            nextnewfilt = 1;
            ScatterSliderSwitch = 0;
        end
    end
    
    
    
    if histplot 
     	figure(2) % histograms
   	end
    % bins is number of bins for histograms
    [HistSearchResults, mflag] = MyHistSearch(SearchResults, bins, wr, wr2, histplot, nextnewfilt);
   	if histplot
     	set(figure(2), 'Position', SZ);
    end
    
       
    if mflag || ScatterSliderSwitch
    figure(3) % histograms with sliders
    subslider(HistSearchResults)
    
    set(figure(3), 'Position', SZ);
    end

    
    
    index = 1;
if mflag || ScatterSliderSwitch
    figure(1) % scatter plot
    [h] = MyPlotSearch(SearchResults); % scatter plot
end
    
    
    Fit4 = [FR.Fit4];
%% grab the index of the datapoint and print these variables on the plot
    function txt = hitme(gcbo,eventdata) % prints results for mouse cliced data point
        p = get(eventdata, 'Position');
        % index must match the x,y,z variables of the scatter plot in MyPlotSearch.m
        index = find(p(1) == [Fit4.AverageAbsoluteResidual] & p(2) == [FR.E_star] & p(3) == [FR.h_change], 1, 'first');
        
        % txt box with data when you use the cursor to select an analysis
        labels = ['Start: %d\n',...
            'End: %d\n'...
            'Length: %d\n',...
            'Modulus Start: %d\n',...
            'Modulus Length: %d\n',...
            'h*: %0.4g\n',...
            'P*: %0.4g\n',...
            'h_ch: %0.4g\n',...
            'p_ch: %0.4g\n',...
            'dH: %0.4g\n',...
            'dP: %0.4g\n',...
            'Fit1.R2: %0.3g\n',...
            'Fit2.R2: %0.3g\n',...
            'Fit3.R2: %0.3g\n',...
            'E_eff: %0.3g\n',...
            'E_s: %0.3g'];
        txt = sprintf(labels, ...
            FR(index).segment_start, ...
            FR(index).segment_end, ...
            FR(index).segment_length, ...
            FR(index).modulus_start, ...
            FR(index).modulus_length, ...
            FR(index).h_star, ...
            FR(index).P_star, ...
            FR(index).h_change,...
            FR(index).p_change,...
            FR(index).dH,...
            FR(index).dP,...
            FR(index).Fit1.Rsquared, ...
            FR(index).Fit2.Rsquared, ...
            FR(index).Fit3.Rsquared,...
            FR(index).E_star, ...
            FR(index).E_sample);
    end
%% plot the stress-strain curve and 4 other plots
    function plotss(a,b) % plots the stress-strain curve for the analysis selcted with the cursor
        SSR = CalcStressStrainWithYield(TestData, FR(index), Plastic);
        
        figure()
        set(gcf, 'Position', SZ) % make fullscreen
        subplot(2,4,[1,2,5,6]) % stress-strain curve
        hold on
        
        mstrain = max(real(SSR.Strain));
        mstress = max(real(SSR.Stress));
        temp = [0 mstrain]; % for line plotting
        plot(SSR.Strain, SSR.Stress,'b.', 'markersize', 10); % stress-strain data
        plot(temp,[SSR.E_ind].*temp,'color',[0.5 0.5 0.5],'LineStyle','-','linewidth',2) % modulus line
        plot(temp, ([SSR.Hardening(1)].*temp + SSR.Hardening(2)), 'k--', 'linewidth', 2) % hardening slope line
        plot(temp, [SSR.E_ind].*(temp - Plastic.YS_offset),'color',[0.5 0.5 0.5],'LineStyle','--','linewidth',2); % strain offset line
        plot(SSR.Strain(FR(index).segment_start:FR(index).segment_end), SSR.Stress(FR(index).segment_start:FR(index).segment_end), 'g.','markersize', 10); %modulus fit data
        plot(SSR.Strain(SSR.HardeningStartEnd(1):SSR.HardeningStartEnd(2)), SSR.Stress(SSR.HardeningStartEnd(1):SSR.HardeningStartEnd(2)), 'k.','markersize', 10); %hardening slope data
        plot(SSR.Yield_Strain, SSR.Yield_Strength, 'r.', 'markersize', 35); % yield point
        
        xlabel('Ind. Strain ','fontsize',13)
        ylabel ('Ind. Stress [GPa]','fontsize',13)
        legend('Stress-Strain','Modulus Line', 'Hardening Fit', 'Strain Offset','Modulus Fit Data', 'Hardening Fit Data', 'Yield Point', 'Location', 'SOUTHEAST');
        
        % use for manual scaling
        mstrain = 0.05;
        mstress = 4;
        
        xlim([0 mstrain + mstrain/20])
        ylim([0 mstress + mstress/20])
        
        Eexp = num2str(FR(index).E_sample);
% %         Euler1 = num2str(BEuler(1,:));
% %         Euler2 = num2str(BEuler(2,:));
% %         Euler3 = num2str(BEuler(3,:));
        YS = num2str(SSR.Yield_Strength);
        H = num2str(SSR.Hardening(1));
% %         tl=['Es=',Eexp,'; ','Bunge=',Euler1,', ',Euler2,', ',Euler3,'; ','Strength=',YS,'; ','Hardening=',H];
        tl=['Es=',Eexp,'; ','Strength=',YS,'; ','Hardening=',H];
        title(tl, 'fontsize',13)
        grid on;

        % rename variables for easy reference
        Load = TestData.Data(:,8);
        Displ = TestData.Data(:,7);
        S = TestData.Data(:,9);
        % note these are harmonic corrected, see LoadTest.m
        segment_start = FR(index).segment_start;
        segment_end = FR(index).segment_end;
        
        subplot(2,4,3) % load vs displ
        hold on
        
        plot(Displ, Load, 'b.');
        plot(Displ(segment_start:segment_end), Load(segment_start:segment_end), 'g.');
        if limx ~= 0;
            xlim([0 limx])
        end
        legend('Raw Data','0 Pt. Data','Location','NorthWest');
        xlabel('displacement / nm');
        ylabel('load / mN');
        title('Load Vs. Displacement');
        hold off
 
        subplot(2,4,4) % Zero Point Fit
        Y = Load - 2/3.*S.*Displ;
        plot(S(1:segment_end+50), Y(1:segment_end+50),'b.');
        hold on
        plot(S(segment_start:segment_end), Y(segment_start:segment_end),'g*');
        if limzerox ~= 0;
            xlim([0 limzerox])
        end
        ylim([-(max(abs(Y(segment_start:segment_end+60)))) 0.1])
        legend('Raw Data','0 Pt. Data');
        xlabel('S');
        ylabel('P2/3-Sh');
        title('Zero Point Fit')
        
        subplot(2,4,7) % Modulus Fit
        modulus_start = FR(index).modulus_start;
        P23 = (SSR.P_new).^(2/3);
        plot(P23(modulus_start:segment_end+50), SSR.h_new(modulus_start:segment_end+50), 'b.')
        hold on
        plot(P23(modulus_start:segment_end), SSR.h_new(modulus_start:segment_end), 'g.')
        xlabel('P 2/3')
        ylabel('h')
        legend('Data','Elastic','Location','NorthWest')
        title('Modulus Fit')
        hold off
        
        subplot(2,4,8) % contact radius vs. strain
        plot(SSR.Strain, SSR.contact_radius, 'b.')
        hold on
        plot(SSR.Strain(modulus_start:segment_end), SSR.contact_radius(modulus_start:segment_end), 'g.')
        xlim([0, mstrain + mstrain/20]);
        YL = ylim;
        ylim([0 YL(2)]);
        xlabel('Strain');
        ylabel('Contact Radius / nm');
        legend('Data','Elastic','Location','SouthEast');
        title('Strain Vs. Contact Radius')
        grid on
        hold off
        
    end
%% save the FitResult and stress-strain analysis
    function savess(a,b) % save the data for the analysis selcted with the cursor
        StressStrain = CalcStressStrainWithYield(TestData, FR(index), Plastic);
        sht.StressStrainResult = StressStrain;
        sht.FitResult = FR(index);
        assignin('base', 'Stress_Strain_Analysis', sht);
    end
%% save all the stress-strain curves of SearchResults
% 1 to 1 correpondence with SearchResults
    function savessall(a,b)
        for ii = 1:npoints(end);
            [StressStrainSearchResults(ii)] = CalcStressStrainWithYield(TestData, SearchResults(ii), Plastic);
        end
        sht = StressStrainSearchResults;
        assignin('base', 'Stress_Strain_Search_Results', sht);
    end
%%   
if mflag || ScatterSliderSwitch
    dcm_obj = datacursormode(gcf);
    set(dcm_obj, 'enable', 'on');
    set(dcm_obj,'UpdateFcn',@hitme);
%     set(dcm_obj,'DisplayStyle', 'window');
    set(gcf, 'Position', SZ/1.3);
    
    w = findobj('Tag','figpanel');
    pos = get(gcf,'Position');
    set(w,'Position',[20 pos(4)-230 200 60]);
    
    uicontrol('Style', 'pushbutton',...
           'String', 'Plot ISS Analysis',...
           'Position', [20 240 160 30],...
           'Callback', @plotss);
       
    uicontrol('Style', 'pushbutton',...
           'String', 'Save FR & ISS',...
           'Position', [20 140 160 30],...
           'Callback', @savess);   
    
    uicontrol('Style', 'pushbutton',...
           'String', 'Save All ISS',...
           'Position', [20 40 160 30],...
           'Callback', @savessall);
       
       
       
    set(figure(1), 'Position', SZ);
end


end
