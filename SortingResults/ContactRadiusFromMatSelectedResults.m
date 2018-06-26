filelist=dir(['Ti-Ni_550C_100um_lowNi_02-10-2016_Analysis_*.mat']);
for i = 1:length(filelist)
    load(filelist(i).name,'Stress_Strain_Analysis');
    rst = Stress_Strain_Analysis.StressStrainResult;
    [I I]=min(abs(rst.Strain-rst.Yield_Strain));
    a(1,i) = rst.contact_radius(I);
    % Contact Radius at yield
    a(2,i) = rst.contact_radius(rst.HardeningStartEnd(1));
    % Contact Radius at Hardening Start
    a(3,i) = rst.contact_radius(rst.HardeningStartEnd(2));
    % Contact Radius at Hardening End
end


%%
filelist=dir(['TiNi_550C_100um_moderateNi_02-11-_Analysis_*.mat']);
for i = 1:length(filelist)
    load(filelist(i).name,'Stress_Strain_Analysis');
    rst = Stress_Strain_Analysis.StressStrainResult;
    [I I]=min(abs(rst.Strain-rst.Yield_Strain));
    a(1,i) = rst.contact_radius(I);
    % Contact Radius at yield
    a(2,i) = rst.contact_radius(rst.HardeningStartEnd(1));
    % Contact Radius at Hardening Start
    a(3,i) = rst.contact_radius(rst.HardeningStartEnd(2));
    % Contact Radius at Hardening End
end

%%
filelist=dir(['Ti-Ni_550C_highNi_02-11-2016_Analysis_*.mat']);
for i = 1:length(filelist)
    load(filelist(i).name,'Stress_Strain_Analysis');
    rst = Stress_Strain_Analysis.StressStrainResult;
    [I I]=min(abs(rst.Strain-rst.Yield_Strain));
    a(1,i) = rst.contact_radius(I);
    % Contact Radius at yield
    a(2,i) = rst.contact_radius(rst.HardeningStartEnd(1));
    % Contact Radius at Hardening Start
    a(3,i) = rst.contact_radius(rst.HardeningStartEnd(2));
    % Contact Radius at Hardening End
end