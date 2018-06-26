clc
clear
filepath = '/Users/Gong/OneDrive - Georgia Institute of Technology/Projects/NITiAlloy/Ti-Ni(Dec. 2014)/Indentation/550C_100um_02-11-2016/Ti-Ni_550C_100um_lowNi_02-10-2016/';
[testindex Emedian Esd Ymedian Ysd Hmedian Hsd] = TestStat(filepath);

%%
clc
clear
filepath = '/Users/Gong/OneDrive - Georgia Institute of Technology/Projects/NITiAlloy/Ti-Ni(Dec. 2014)/Indentation/550C_100um_02-11-2016/TiNi_550C_100um_moderateNi_02-11-2016/';
[testindex Emedian Esd Ymedian Ysd Hmedian Hsd] = TestStat(filepath);

%%
clc
clear
filepath = '/Users/Gong/OneDrive - Georgia Institute of Technology/Projects/NITiAlloy/Ti-Ni(Dec. 2014)/Indentation/550C_100um_02-11-2016/TiNi_550C_100um_highNi_02-11-2016/';
[testindex Emedian Esd Ymedian Ysd Hmedian Hsd] = TestStat(filepath);

%% Modulus
onv = ones(size(Esd));
errorbar(3*onv,Emedian,Esd,'.k');
hold on

ylabel('Eind','FontSize',20);
axis([0.5 3.5 70 120])

%%
onv = ones(size(Esd));
plot(3*onv,Emedian,'.k');
hold on
ylabel('Eind','FontSize',20);
axis([0.5 3.5 70 120])

%% Yield
onv = ones(size(Ysd));
errorbar(3*onv,Ymedian,Ysd,'.k');
hold on
ylabel('Yind','FontSize',20);
axis([0.5 3.5 0.4 1.8])

%%
onv = ones(size(Ysd));
plot(3*onv,Ymedian,'.k');
hold on
ylabel('Yind','FontSize',20);
axis([0.5 3.5 0.4 1.8])

%% Harding
onv = ones(size(Hsd));
errorbar(3*onv,Hmedian,Hsd,'.k');
hold on
ylabel('Hind','FontSize',20);
axis([0.5 3.5 20 70])

%%
onv = ones(size(Hsd));
plot(3*onv,Hmedian,'.k');
hold on
ylabel('Hind','FontSize',20);
axis([0.5 3.5 20 70])