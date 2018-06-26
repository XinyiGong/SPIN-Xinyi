%% Load data and Analyze
%clear
clc
clear
filepath = '/Users/Gong/OneDrive - Georgia Institute of Technology/Projects/NITiAlloy/Ti-Ni(Dec. 2014)/Indentation/550C_100um_02-11-2016/TiNi_550C_100um_highNi_02-11-2016/';
filename='Ti-Ni_550C_highNi_02-11-2016.xls';
file=[filepath,filename]; 


%%
for tnum = 1:9
    sheet = ['Test 00', num2str(tnum)]; %name of sheet in file
    % Zero Pt and Modulus Fit Analysis single test
    [TestData] = LoadMachineData(file, sheet);
    plot(TestData.Data(:,7),TestData.Data(:,8));
    hold on
end

%%
[testindex Emedian Esd Ymedian Ysd Hmedian Hsd] = TestStat(filepath);

%%
figure
errorbar(Emedian,Esd,'.k');
ylabel('Eind','FontSize',20);
axis([0 25 70 120])

figure
errorbar(Ymedian,Ysd,'.k');
ylabel('Yind','FontSize',20);
axis([0 25 0.4 1.8])

figure
errorbar(Hmedian,Hsd,'.k');
ylabel('Hind','FontSize',20);

%% Save
save(['C:\Users\xgong42\OneDrive for Business\Ti-Ni(Dec. 2014)\550C_100um_02-11-2016\',filename(1:end-4)])