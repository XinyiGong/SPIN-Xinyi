clear
clc
close all
filepath = '/Users/Gong/OneDrive - Georgia Institute of Technology/Projects/AMTiAlloy/Ti-Mn(May 2015)/NI/500C';
symb = '/'; % use / on mac, use \ on windows
filename{1}='TiMn-500C_8mm_100um_06-06-2018';
filename{2}='TiMn-500C_14mm_100um_06-07-2018';
filename{3}='TiMn-500C_20mm_100um_06-07-2018';
filename{4}='TiMn-500C_26mm_100um_06-08-2018';
filename{5}='TiMn-500C_32mm_100um_06-08-2018';


E = [];
Ys =[];
H = [];
Origin = [];
for j = 1:length(filename)
    file{j}=[filepath,symb,filename{j},symb,filename{j},'_Analysis_*.mat'];
    filelist{j}=dir(file{j});
    for i = 1:length(filelist{j})
        load([filepath,symb,filename{j},symb,filelist{j}(i).name],'Stress_Strain_Analysis');
        SSR = Stress_Strain_Analysis.StressStrainResult;
        SSFR = Stress_Strain_Analysis.FitResult;
        E = [E; SSFR.E_sample];
        Ys = [Ys; SSR.Yield_Strength];
        H = [H; SSR.Hardening(1,1)];
        Origin = [Origin; filename{j}(11:14)];
    end
end

%% BoxPlot
figure; boxplot(E,Origin)
title('Modulus vs. Distance')
xlabel('Distance from pure Ti end')
ylabel('Youngs Modulus from Indentation (GPa)')

figure; boxplot(Ys,Origin)
title('Indentation Yield Strength vs. Distance')
xlabel('Distance from pure Ti end')
ylabel('Indentation Yield Strength (GPa)')

figure; boxplot(H,Origin)
title('Initial Hardening Rate vs. Distance')
xlabel('Distance from pure Ti end')
ylabel('Initial Hardening Rate (GPa)')


