addpath([pwd() '/../source'])

pathToSave = '~/FiberResults/TP06_H2_B0.5_I2';
mainElvira = '~/Software/Elvira/Elvira20150121/bin/mainelv_infiniband_gcc';
project = 'Hperkalemia in fibre - ten Tusscher & Panfilov 2006 Model';
cellType = 3;
K = [4 5 5.4 6:10 10.1:0.1:11];
cores=1;
K_index = 17;
K_control = 5.4;
h_index = 7;
j_index = 8;
dt = 0.02;
step_save=5;
fun_sodium=@sodiumTenTusscher;
%[s]=rmdir(Model,'s');
pre_dur = 1000;
pre_step = 100;
Imax = 500;
Istep = 1;
CI_step = 1;
sigma_L = 0.0012;
Cm = 1;
HZ = 2;
BZ = 0.5;
IZ = 2;
centerOut = 3.5;
dx = 0.01;
nOut = 5;
dxOut = 0.25;

CL = 1000;
numStimIThreshold = 5;
nS1 = 10;

CVControl = 65;
CVError = 0.2;

nodesOut = CalculateERP(cores, pathToSave, mainElvira, project, cellType, K, K_index, K_control, dt,...
             step_save, pre_dur, pre_step, fun_sodium, h_index,...
             j_index, Imax, Istep, CI_step, sigma_L, Cm, HZ, BZ, IZ, dx, dxOut,...
             nOut, centerOut, CL, numStimIThreshold, nS1, CVControl, CVError);

plotStatus(pathToSave,K)
plotIThresholdLimits(pathToSave,nodesOut)
plotCILimits(pathToSave,K,nodesOut)
plotS1(pathToSave,CL,K,nodesOut)

exit
