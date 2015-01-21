Model = 'GrandiEstable0001';
cellType = 13;
K=[4 5 5.4 6:8 8.1:0.1:10 11];
cores=4;
K_index = 17;
h_index = 13;
j_index = 14;
K_dirFact = 10;
dt = 0.002;
step_save=50;
fun_sodium=@sodiumGrandi;
%[s]=rmdir(Model,'s');
pre_dur = 1000;
pre_step = 100;
Imax = 500;
Istep = 1;
CI_step = 0.1;

calculateERP(cores, Model, cellType, K, K_index, K_dirFact, dt,...
             step_save, pre_dur, pre_step, fun_sodium, h_index,...
             j_index, Imax, Istep, CI_step)

exit
