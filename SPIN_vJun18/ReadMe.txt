Explanation of Functions and Scripts for analyzing Spherical Nanoindentation Data with CSM.
Jordan Weaver 10/28/2015
The analysis is based on Kalidindi and Pathak. Acta Materialia. 2008 and some of my own ideas and improvements.
Many people have contributed to this code, and many more are required to make it robust so please don't treat this as a finished product.

RunME.m - load, analyze, plot, save data and the analysis with this script. Most of the parameters which require adjusting are set in this script.

LoadTest.m - imports excel data for NI tests. Important to set the indenter properties, the "End of Test" marker, and columns of raw data. CSM corrections are applied here.

smoothstrain.m - applies a moving average to the back-extrapoloation/hardening fit stress-strain data.

filterResults.m - cuts down the results based on different criteria. A new criterion can be added by coping the 'case' logic used for other variables.

CalcStressStrainWithYield.m - here is where the indentation stress-strain curve and properties are calculated

FindYield.m = function for determining the yield point. Also see FindYieldStart.m
FindYieldStart.m - function for determing if a pop-in occurs and some markers needed for FindYield.m

MyPlotSearch.m - plotting function for the 3-D scatter plot of the Results. Change the variables for the plot axis in here and in SearchExplorer.m

NIAnalyzeSearch.m - This code does most the indentation calculations for the elastic segment. Keep this lean and fast since it is used for to analyze all the segments you throw at it.

MyHistSearch.m - plotting function for histograms of relevant variables related to criteria used for selecting good answers.

SearchExplorer.m - interactive plotting function for the 3D scatter plot fo results. Important - the scaling of the ISS curve plot is done in here (mstrain and mstress)

MyHistResults.m - spits out the statistics for E, Y, and H for the saved analyses.

Shouldn't have to touch or understand these...
Driver.m
SingleSearchAllSegments.m
mypolyfit.m
rsquare.m

