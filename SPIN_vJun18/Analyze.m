function [SearchResults, npoints, HistSearchResults, mflag] = Analyze(TestData, seg_sizes, filt, Plastic, BEuler, bins, wr, wr2, limx,limzerox, MaxAnsNum, TestMode)

FitResults = SingleSearchAllSegments(seg_sizes, TestData);
[SearchResults, npoints, HistSearchResults, mflag] = SearchExplorer(TestData, FitResults, filt, Plastic, BEuler, bins, wr, wr2, limx,limzerox, MaxAnsNum, TestMode);

