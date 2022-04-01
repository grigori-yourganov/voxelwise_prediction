% not really a voxelwise-prediction script. this is just a script that runs NiiStat on a cluster from a batch. 

xlsname = 'C:\Users\gyourga\Documents\data\POLAR_FIRST_SESSION_ONLY_MAT_FILES\behavioral_lj.xlsx';
roiIndices = 1;
modalityIndices = 8;
numPermute = -1;
pThresh = 0.05;
minOverlap = 5;
regressBehav = false;
maskName = [];
GrayMatterConnectivityOnly = true;
deSkew = false;
doTFCE = false;
doSVM = true;
NiiStat(xlsname, roiIndices, modalityIndices,numPermute, pThresh, minOverlap, regressBehav, maskName, GrayMatterConnectivityOnly, deSkew, doTFCE, doSVM);
