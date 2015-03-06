addpath([pwd() '/../source'])

pathToSave = '~/FiberResults/TP06';
mainElvira = '~/Software/Elvira/Elvira20150121/bin/mainelv_infiniband_gcc';
project = 'Hperkalemia in fibre - ten Tusscher & Panfilov 2006 Model';
cellType = 3;
K=4;%[4:1:11];
cores=4;
K_index = 17;
h_index = 10;
j_index = 11;
dt = 0.02;
step_save=5;
fun_sodium=@sodiumTenTusscher;
%[s]=rmdir(Model,'s');
pre_dur = 1000;
pre_step = 100;
Imax = 500;
Istep = 1;
CI_step = 0.1;
sigma_L = 0.0013;
Cm = 1;
L = 4;
dx = 0.01;
nOut = 5;
dxOut = 0.25;
nodes = [0:dx:L];

nPrev = round((nOut-1)/2);
mid = nodes((end+1)/2);
positions = [-nPrev:-nPrev+nOut-1]*dxOut + mid;
nodeOut = round(positions/dx)+1;

CalculateERP(cores, pathToSave, mainElvira, project, cellType, K, K_index, dt,...
             step_save, pre_dur, pre_step, fun_sodium, h_index,...
             j_index, Imax, Istep, CI_step, sigma_L, Cm, nodes,nodeOut)

exit
