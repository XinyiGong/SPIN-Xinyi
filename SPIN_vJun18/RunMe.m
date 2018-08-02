%% Some ideas for next modifications:allow users to change region selection with slider at the last step

%% Load data and Analyze
clear
clc
clear
close all
filepath = '/Users/Gong/OneDrive - Georgia Institute of Technology/Projects/AMTiAlloy/Ti-Mn(May 2015)/NI/600C/TiMn-600C_8mm_100um_07-12-2018';
filename='TiMn-600C_8mm_100um_07-12-2018.xls';
symb = '/'; % use / on mac, use \ on windows
file=[filepath,symb,filename];
tnum = '008'; %used for saving
sheet = ['Test ', tnum]; %name of sheet in file 

Rind = 100000; %nm ie. 100000 (100um), 16500 (16.5um)
vs = 0.334; % sample Poisson ratio
skip = [0.2 0.2]; % skips analysis with Fit1 R2 < 0.5 AND length(Fit2)/length(Fit1) < 0.1
% modulus also has to be real
limx = 90; %% set to 0 as default
limzerox = 0; %% set to 0 as default (250000 is typical for 100um on Ti)
seg_Displstart = 8; %nm in displacement
seg_Displend = 25;
Eestimate = 0; % set to 0 if no need to check contact area (unit as GPa)

% Zero Pt and Modulus Fit Analysis single test
[TestData] = Driver(file, sheet, Rind, vs, skip, seg_Displstart, seg_Displend, limzerox, limx, Eestimate);
%% Filter Results

wr = 2; % width ratio which is used to choose filter range according to peak width
bins = 20; % number of bins for the historgram plots
MaxAnsNum = 50;
TestMode = 0; % will automatically turn to 1 when 'No result left after NewFilt, need manual filter'
shortest = 120;
segnumspace = 10;


close all
longest = TestData.SegEnd - TestData.SegStart;
if longest <= shortest
 	warning('shortest segment too long');
    return
end
seg_sizes = [shortest:segnumspace:longest]; % don't go crazy with the number of segments [20:5:200]

% Sorting/Cut off Parameters
% Filt: choose from 'R21', 'AAR1', 'MAR1', 'R22', 'AAR1', 'MAR1',
% 'Modulus', 'R23', 'Hr', 'ModLength', 'h_change', 'p_change', 'AAR4',
% 'MAR4', 'h*', 'P*', 'dP', 'dH'
Filt ={ 'E_sample', [0 200];...
%     'R21', [0 1];...
%     'R22', [0.8 1];...
%     'R23', [0.8 1];...
%     'ModLength', [50 500];...
%     'Hr', [5 -5];...  %%missing
%     'AAR1', [0 3];...
%     'MAR1', [0 5];...
%     'AAR2', [0 10];...
%     'MAR2', [0 50];...
%     'h_change', [1 -1];...X
%     'p_change', [1 -1];...  %%missing
%     'AAR4', [0 1];...
%     'MAR4', [0 1];...
% 
%     'P*', [0 20];...
%     'h*', [0 100];...
%     'dP', [0 1];...
%     'dH', [10 -10];...
    };

% Plastic is all the parameters for determing Yield Strength
Plastic.YS_offset = 0.002; % offset strain for YS, min strain for hardening calc
Plastic.H_offset = 0.02; % max offset strain for back extrapolation and hardneing calc
Plastic.H_start = 0.005; % max offset strain for back extrapolation and hardneing calc
Plastic.pop_in = 0.006; % min pop_in strain burst
Plastic.pop_window = 3; % number of data points for calculating change in strain (i.e. n+3 - n)
Plastic.C_dstrain = 1; % factor for eliminating bad extrapolations due to short, high sloped region after pop-in
Plastic.YS_window = 0.20; % +/- faction of YS_offset in which to calc median stress and strain
Plastic.smooth_window = 10; % +/- number of points for movering average on strain, used for back extrapolation

BEuler=[0	0	0]'; %phi1 Phi phi2 for plotting purposes

% Initial filtering
[SearchResults, npoints, HistSearchResults, mflag] = Analyze(TestData, seg_sizes, Filt, Plastic, BEuler, bins, wr, limx,limzerox, MaxAnsNum, TestMode);
if TestMode || mflag || size(SearchResults,2) <= MaxAnsNum % stop at every step in test mode OR stop when automated filter is not filtering OR stop when the number of answers is small enough
 	return
end
% Automatic Filter after initial filtering
% close all
while 1
    [SearchResults, npoints, HistSearchResults, mflag] = SearchExplorer(TestData, SearchResults, NewFilt, Plastic, BEuler, bins, wr, limx,limzerox, MaxAnsNum, TestMode);
    if TestMode || mflag || size(SearchResults,2) <= MaxAnsNum % stop at every step in test mode OR stop when automated filter is not filtering OR stop when the number of answers is small enough
        break
    end
end

%% Stats of E, YS, and H after Save All ISS has been done

[Estat, Ystat, Hstat, histtxt] = MyHistResults(SearchResults, Stress_Strain_Search_Results);

clear Stress_Strain_Search_Results;


% save workspace and the ISS plot in your current directory usin  g tnum 
save([filepath,symb,filename(1:end-4),'_Analysis_' tnum])
set(gcf,'PaperPositionMode','auto')
saveas(gcf,[filepath,symb,filename(1:end-4),'_ISS_' tnum,'.fig'])
saveas(gcf,[filepath,symb,filename(1:end-4),'_ISS_' tnum,'.tif'])


