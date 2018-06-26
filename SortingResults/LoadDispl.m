%%
filepath = '/Users/Gong/OneDrive - Georgia Institute of Technology/Projects/NITiAlloy/Ti-Ni(Dec. 2014)/Indentation/550C_100um_02-11-2016/Ti-Ni_550C_100um_lowNi_02-10-2016/';
filename='Ti-Ni_550C_100um_lowNi_02-10-2016.xls';
file=[filepath,filename]; 
tnum = '009'; %used for saving
sheet = ['Test ', tnum]; %name of sheet in file
[num txt] = xlsread(file, sheet);

HoldSegmentII = size(num, 1); 
% for ii=1:size(txt,1) 
%     if strcmpi(txt(ii), 'End of Loading Marker') == 1 % 'End Of Loading Marker' the exact text depends on the version of NanoSuite
%         HoldSegmentII=ii-2; 
%         break; 
%     end
% end
T = num(1:HoldSegmentII, 1:6);
h = T(:,2) + T(:,5).*sqrt(2); % displacement(nm)
P = T(:,3) + T(:,6).*sqrt(2).*10^-3; % Load (mN)
plot(h, P, 'r.')
hold on
%%
filepath = '/Users/Gong/OneDrive - Georgia Institute of Technology/Projects/NITiAlloy/Ti-Ni(Dec. 2014)/Indentation/550C_100um_02-11-2016/TiNi_550C_100um_moderateNi_02-11-2016/';
filename='TiNi_550C_100um_moderateNi_02-11-2016.xls';
file=[filepath,filename]; 
tnum = '005'; %used for saving
sheet = ['Test ', tnum]; %name of sheet in file
[num txt] = xlsread(file, sheet);

HoldSegmentII = size(num, 1); 
% for ii=1:size(txt,1) 
%     if strcmpi(txt(ii), 'End of Loading Marker') == 1 % 'End Of Loading Marker' the exact text depends on the version of NanoSuite
%         HoldSegmentII=ii-2; 
%         break; 
%     end
% end
T = num(1:HoldSegmentII, 1:6);
h = T(:,2) + T(:,5).*sqrt(2); % displacement(nm)
P = T(:,3) + T(:,6).*sqrt(2).*10^-3; % Load (mN)
plot(h, P, 'g.')
hold on
%%
filepath = '/Users/Gong/OneDrive - Georgia Institute of Technology/Projects/NITiAlloy/Ti-Ni(Dec. 2014)/Indentation/550C_100um_02-11-2016/TiNi_550C_100um_highNi_02-11-2016/';
filename='Ti-Ni_550C_highNi_02-11-2016.xls';
file=[filepath,filename]; 
tnum = '019'; %used for saving
sheet = ['Test ', tnum]; %name of sheet in file
[num txt] = xlsread(file, sheet);

HoldSegmentII = size(num, 1); 
% for ii=1:size(txt,1) 
%     if strcmpi(txt(ii), 'End of Loading Marker') == 1 % 'End Of Loading Marker' the exact text depends on the version of NanoSuite
%         HoldSegmentII=ii-2; 
%         break; 
%     end
% end
T = num(1:HoldSegmentII, 1:6);
h = T(:,2) + T(:,5).*sqrt(2); % displacement(nm)
P = T(:,3) + T(:,6).*sqrt(2).*10^-3; % Load (mN)
plot(h, P, 'b.')
hold on

%% 
axis([0 900 0 500])
grid on
