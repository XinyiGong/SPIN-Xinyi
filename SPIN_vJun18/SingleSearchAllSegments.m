function [FitResults] = SingleSearchAllSegments(seg_sizes, TestData)
AnalysisCell = cell(10,1);
count = 1;
for i=1:length(seg_sizes) % iterate of all segment sizes
    for j=TestData.SegStart:TestData.SegEnd-seg_sizes(i) % iterate through the data
        start = j;
        stop = start + seg_sizes(i);
        [analysis, success]= NIAnalyzeSearch(TestData, start, stop);
        if success==1
            AnalysisCell{count,1}=analysis;
            count = count + 1;
        end    
    end 
end

FitResults = AnalysisCell{1,1}; % sets FitResults to have the same structure as Analysis;

for k = 1:size(AnalysisCell)
        FitResults(k)=AnalysisCell{k};
end
    
end

