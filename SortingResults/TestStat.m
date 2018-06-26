function [testindex, Emedian, Esd, Ymedian, Ysd, Hmedian, Hsd] = TestStat(filepath)

filelist=dir([filepath,'*.mat']);
testindex=zeros(length(filelist),1);
for i=1:length(filelist)
    load([filepath,filelist(i).name],'Estat','Ystat','Hstat');
    testindex(i,1)=str2num(filelist(i).name(end-6:end-4));
    Emedian(i,1) = Estat.median;
    Esd(i,1) = Estat.stdev;
    Ymedian(i,1) = Ystat.median;
    Ysd(i,1) = Ystat.stdev;
    Hmedian(i,1) = Hstat.median;
    Hsd(i,1) = Hstat.stdev;
end