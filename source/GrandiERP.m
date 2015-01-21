pathToSave = '~/FiberResults/GrandiEstable0001';
mainElvira = '~/Software/Elvira/Elvira20150121/bin/mainelv_infiniband_gcc'
cellType = 13;
K=[4:0.1:11];
cores=4;
K_index = 17;
h_index = 13;
j_index = 14;
dt = 0.002;
step_save=50;
fun_sodium=@sodiumGrandi;
%[s]=rmdir(Model,'s');
pre_dur = 1000;
pre_step = 100;
Imax = 500;
Istep = 1;
CI_step = 0.1;

calculateERP(cores, pathToSave, mainElvira, cellType, K, K_index, dt,...
             step_save, pre_dur, pre_step, fun_sodium, h_index,...
             j_index, Imax, Istep, CI_step)

exit
