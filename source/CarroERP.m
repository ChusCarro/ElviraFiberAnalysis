Model = 'Carro1007';
cellType = 15;
cores = 4;
K=[4 4.5 5:0.1:6 6.5:0.5:9.5 9.6:0.1:10.5 11];
K_index = 12;
h_index = 12;
j_index = 13;
K_dirFact = 10;
dt = 0.002;
step_save=50;
fun_sodium=@sodiumCarro;
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
