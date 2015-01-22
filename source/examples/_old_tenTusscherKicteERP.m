Model = 'tenTusscherKicte';
cellType = 3;
cores = 4;
K=[4:0.1:15];
K_index = 17;
h_index = 10;
j_index = 11;
K_dirFact = 10;
dt = 0.02;
step_save=5;
fun_sodium=@sodiumTenTusscher;
%[s]=rmdir(Model,'s');
pre_dur = 500;
pre_step = 100;
Imax = 500;
Istep = 1;
CI_step = 0.1;

calculateERP(cores,Model, cellType, K, K_index, K_dirFact, dt, step_save,...
    pre_dur, pre_step, fun_sodium, h_index, j_index, Imax, Istep, CI_step)

plotCILimits(Model,K,K_dirFact);
plotIThresholdLimits(Model,K,K_dirFact);
plotPreStim(Model,K,K_dirFact,fun_sodium,h_index,j_index);

exit
