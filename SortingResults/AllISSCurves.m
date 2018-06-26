%%
filelist=dir(['Ti-Ni_550C_100um_lowNi_02-10-2016_Analysis_*.mat']);
for i = 1:length(filelist)
    load(filelist(i).name,'Stress_Strain_Analysis');
    SSR = Stress_Strain_Analysis.StressStrainResult;
    a = (~logical(imag(SSR.Strain(:,1)))).*(~logical(imag(SSR.Stress(:,1)))).*(SSR.Strain > 0).*(SSR.Stress > 0);
    index = find(a);
    plot(SSR.Strain(index),SSR.Stress(index),'-r')
    hold on
end

%%
filelist=dir(['TiNi_550C_100um_moderateNi_02-11-_Analysis_*.mat']);
for i = 1:length(filelist)
    load(filelist(i).name,'Stress_Strain_Analysis');
    SSR = Stress_Strain_Analysis.StressStrainResult;
    a = (~logical(imag(SSR.Strain(:,1)))).*(~logical(imag(SSR.Stress(:,1)))).*(SSR.Strain > 0).*(SSR.Stress > 0);
    index = find(a);
    plot(SSR.Strain(index),SSR.Stress(index),'-g')
    hold on
end

%%
filelist=dir(['Ti-Ni_550C_highNi_02-11-2016_Analysis_*.mat']);
for i = 1:length(filelist)
    load(filelist(i).name,'Stress_Strain_Analysis');
    SSR = Stress_Strain_Analysis.StressStrainResult;
    a = (~logical(imag(SSR.Strain(:,1)))).*(~logical(imag(SSR.Stress(:,1)))).*(SSR.Strain > 0).*(SSR.Stress > 0);
    index = find(a);
    plot(SSR.Strain(index),SSR.Stress(index),'-b')
    hold on
end

%% Plot median curve(2% strain)
%% pt1
filelist=dir(['Ti-Ni_550C_100um_lowNi_02-10-2016_Analysis_*.mat']);
stress = zeros(length(filelist),1);
for i = 1:length(filelist)
    load(filelist(i).name,'Stress_Strain_Analysis');
    SSR = Stress_Strain_Analysis.StressStrainResult;
    a = (~logical(imag(SSR.Strain(:,1)))).*(~logical(imag(SSR.Stress(:,1)))).*(SSR.Strain > 0).*(SSR.Stress > 0);
    index = find(a);
    [~,sindex] = min(abs(SSR.Strain(index)-0.02));
    stress(i) = SSR.Stress(index(sindex));
end
[~,I] = sort(stress);
% mdnb = I(round(length(stress)/2));
mdnb = 8;
load(filelist(mdnb).name,'Stress_Strain_Analysis');
SSR = Stress_Strain_Analysis.StressStrainResult;
a = (~logical(imag(SSR.Strain(:,1)))).*(~logical(imag(SSR.Stress(:,1)))).*(SSR.Strain > 0).*(SSR.Stress > 0);
index = find(a);
plot(SSR.Strain(index),SSR.Stress(index),'r.')
hold on

%% pt2
filelist=dir(['TiNi_550C_100um_moderateNi_02-11-_Analysis_*.mat']);
stress = zeros(length(filelist),1);
for i = 1:length(filelist)
    load(filelist(i).name,'Stress_Strain_Analysis');
    SSR = Stress_Strain_Analysis.StressStrainResult;
    a = (~logical(imag(SSR.Strain(:,1)))).*(~logical(imag(SSR.Stress(:,1)))).*(SSR.Strain > 0).*(SSR.Stress > 0);
    index = find(a);
    [~,sindex] = min(abs(SSR.Strain(index)-0.02));
    stress(i) = SSR.Stress(index(sindex));
end
[~,I] = sort(stress);
mdnb = I(round(length(stress)/2)-1);
load(filelist(mdnb).name,'Stress_Strain_Analysis');
SSR = Stress_Strain_Analysis.StressStrainResult;
a = (~logical(imag(SSR.Strain(:,1)))).*(~logical(imag(SSR.Stress(:,1)))).*(SSR.Strain > 0).*(SSR.Stress > 0);
index = find(a);
plot(SSR.Strain(index),SSR.Stress(index),'g.')
hold on


%% pt3
filelist=dir(['Ti-Ni_550C_highNi_02-11-2016_Analysis_*.mat']);
stress = zeros(length(filelist),1);
for i = 1:length(filelist)
    load(filelist(i).name,'Stress_Strain_Analysis');
    SSR = Stress_Strain_Analysis.StressStrainResult;
    a = (~logical(imag(SSR.Strain(:,1)))).*(~logical(imag(SSR.Stress(:,1)))).*(SSR.Strain > 0).*(SSR.Stress > 0);
    index = find(a);
    [~,sindex] = min(abs(SSR.Strain(index)-0.02));
    stress(i) = SSR.Stress(index(sindex));
end
[~,I] = sort(stress);
mdnb = I(round(length(stress)/2)+4);
load(filelist(mdnb).name,'Stress_Strain_Analysis');
SSR = Stress_Strain_Analysis.StressStrainResult;
a = (~logical(imag(SSR.Strain(:,1)))).*(~logical(imag(SSR.Stress(:,1)))).*(SSR.Strain > 0).*(SSR.Stress > 0);
index = find(a);
plot(SSR.Strain(index),SSR.Stress(index),'b.')
hold on
