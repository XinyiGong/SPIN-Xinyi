    function [ ] = plotint(TestData, limx, limzerox, Eestimate) % plots the stress-strain curve for the analysis selcted with the cursor
%     function [ ] = plotint(TestData, seg_start, seg_end, Plastic, limx, limzerox, BEuler) % plots the stress-strain curve for the analysis selcted with the cursor
%         SSR = CalcStressStrainWithYield(TestData, analysis, Plastic);
        
        figure()
        SZ = get(0,'Screensize');
        set(gcf, 'Position', SZ) % make fullscreen
%         subplot(2,4,[1,2,5,6]) % stress-strain curve
%         hold on
%         
%         mstrain = max(real(SSR.Strain));
%         mstress = max(real(SSR.Stress));
%         temp = [0 mstrain]; % for line plotting
%         plot(SSR.Strain, SSR.Stress,'b.', 'markersize', 10); % stress-strain data
%         plot(temp,[SSR.E_ind].*temp,'color',[0.5 0.5 0.5],'LineStyle','-','linewidth',2) % modulus line
%         plot(temp, ([SSR.Hardening(1)].*temp + SSR.Hardening(2)), 'k--', 'linewidth', 2) % hardening slope line
%         plot(temp, [SSR.E_ind].*(temp - Plastic.YS_offset),'color',[0.5 0.5 0.5],'LineStyle','--','linewidth',2); % strain offset line
%         plot(SSR.Strain(analysis.modulus_start:analysis.segment_end), SSR.Stress(analysis.modulus_start:analysis.segment_end), 'g.','markersize', 10); %%% modulus fit data - 09-07-2016
% %         plot(SSR.Strain(analysis.segment_start:analysis.segment_end), SSR.Stress(analysis.segment_start:analysis.segment_end), 'g.','markersize', 10); %%% modulus fit data - 09-07-2016
%         plot(SSR.Strain(SSR.HardeningStartEnd(1):SSR.HardeningStartEnd(2)), SSR.Stress(SSR.HardeningStartEnd(1):SSR.HardeningStartEnd(2)), 'k.','markersize', 10); %hardening slope data
%         plot(SSR.Yield_Strain, SSR.Yield_Strength, 'r.', 'markersize', 35); % yield point
%         
%         xlabel('Ind. Strain ','fontsize',13)
%         ylabel ('Ind. Stress [GPa]','fontsize',13)
%         legend('Stress-Strain','Modulus Line', 'Hardening Fit', 'Strain Offset','Modulus Fit Data', 'Hardening Fit Data', 'Yield Point', 1, 'Location', 'SOUTHEAST');
%         
%         % use for manual scaling
%         mstrain = 0.05;
%         mstress = 4;
%         
%         xlim([0 mstrain + mstrain/20])
%         ylim([0 mstress + mstress/20])
%         
%         Eexp = num2str(analysis.E_sample);
% % %         Euler1 = num2str(BEuler(1,:));
% % %         Euler2 = num2str(BEuler(2,:));
% % %         Euler3 = num2str(BEuler(3,:));
%         YS = num2str(SSR.Yield_Strength);
%         H = num2str(SSR.Hardening(1));
% % %         tl=['Es=',Eexp,'; ','Bunge=',Euler1,', ',Euler2,', ',Euler3,'; ','Strength=',YS,'; ','Hardening=',H];
%         tl=['Es=',Eexp,'; ','Strength=',YS,'; ','Hardening=',H];
%         title(tl, 'fontsize',13)
%         grid on;

        % rename variables for easy reference
        Load = TestData.Data(:,8);
        Displ = TestData.Data(:,7);
        S = TestData.Data(:,9);
        % note these are harmonic corrected, see LoadTest.m
        segment_start = TestData.SegStart;
        segment_end = TestData.SegEnd;
        
        
        subplot(2,2,1) % stiffness vs displ
        hold on
        plot(Displ, S, 'b.');
        plot(Displ(segment_start:segment_end), S(segment_start:segment_end), 'g.');
        xlabel('displacement / nm');
        ylabel('stiffness / N/m');
        title('Stiffness Vs. Displacement');
        hold off
        
        
        subplot(2,2,2) % load vs displ
        hold on
        
        plot(Displ, Load, 'b.');
        plot(Displ(segment_start:segment_end), Load(segment_start:segment_end), 'g.');
        if limx ~= 0;
            xlim([0 limx])
        end
%         legend('Raw Data','0 Pt. Data','Location','NorthWest');
        xlabel('displacement / nm');
        ylabel('load / mN');
        title('Load Vs. Displacement');
        hold off
        
        
        
        subplot(2,2,3) % stiffness vs load
        hold on
        
        plot(Load, S, 'b.');
        plot(Load(segment_start:segment_end), S(segment_start:segment_end), 'g.');
        xlabel('load / mN');
        ylabel('stiffness / N/m');
        title('Stiffness Vs. Load');
        hold off
 
 
        subplot(2,2,4) % Zero Point Fit
        Y = Load - 2/3.*S.*Displ;
%         plot(S(1:segment_end+150), Y(1:segment_end+150),'b.');
        plot(S, Y,'b.');
        hold on
        plot(S(segment_start:segment_end), Y(segment_start:segment_end),'g*');
        if limzerox ~= 0;
            xlim([0 limzerox])
        end
        ylim([-(max(abs(Y(segment_start:segment_end))))-(max(abs(Y(segment_start:segment_end))))/2 0.1])
%         legend('Raw Data','0 Pt. Data');
        xlabel('S');
        ylabel('P2/3-Sh');
        title('Zero Point Fit')
        hold off
        
        
        
        
        if Eestimate
            figure()
            a = S/(2*Eestimate);
            plot(Displ, a, 'b.');
            hold on
            plot(Displ(segment_start:segment_end), a(segment_start:segment_end), 'g.');
            xlabel('Displacement / nm');
            ylabel('Estimated Contact Radius / nm');
            title('Estimated Contact Radius Vs. Displacement');
            hold off
        
%         subplot(2,4,7) % Modulus Fit
%         modulus_start = analysis.modulus_start;  %%% need to be controlled in manual selection
%         P23 = (SSR.P_new).^(2/3);
% %         plot(P23(segment_start:segment_end+50), SSR.h_new(segment_start:segment_end+50), 'b.')
%         plot(P23(1:segment_end+50), SSR.h_new(1:segment_end+50), 'b.')
%         hold on
%         plot(P23(modulus_start:segment_end), SSR.h_new(modulus_start:segment_end), 'g.')
%         xlim([0 max(P23(segment_start:segment_end+50))+max(P23(modulus_start:segment_end+50))/10])
%         ylim([0 max(SSR.h_new(modulus_start:segment_end+50))+max(SSR.h_new(modulus_start:segment_end+50))/10])
%         xlabel('P 2/3')
%         ylabel('h')
%         legend('Data','Elastic','Location','NorthWest')
%         title('Modulus Fit')
%         hold off
%         
%         subplot(2,4,8) % contact radius vs. strain
%         plot(SSR.Strain, SSR.contact_radius, 'b.')
%         hold on
%         plot(SSR.Strain(modulus_start:segment_end), SSR.contact_radius(modulus_start:segment_end), 'g.')
%         hold on
%         plot(SSR.Strain(SSR.Yield_index), SSR.contact_radius(SSR.Yield_index), 'r.', 'markersize', 35); % contact radius at yield point - added on 09-11-2016
%         xlim([0, mstrain + mstrain/20]);
%         YL = ylim;
%         ylim([0 YL(2)]);
%         xlabel('Strain');
%         ylabel('Contact Radius / nm');
%         legend('Data','Elastic','Location','SouthEast');
%         title('Strain Vs. Contact Radius')
%         grid on
%         hold off
        
    end