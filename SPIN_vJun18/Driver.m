% function[TestData, FitResults] =  Driver(file, sheet, radius, vs, seg_sizes, skip)
function[TestData] =  Driver(file, sheet, radius, vs, skip, seg_Displstart, seg_Displend, limzerox, limx, Eestimate)

TestData = LoadTest(file, sheet, radius, vs, skip, seg_Displstart, seg_Displend);
plotint(TestData, limx, limzerox, Eestimate);
% FitResults = SingleSearchAllSegments(seg_sizes, TestData);
end