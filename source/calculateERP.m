function calculateERP(cores, pathToSave, cellType, K, K_index, K_dirFact, dt, step_save, pre_dur,...
                       pre_step, fun_sodium, h_index, j_index, Imax, Istep, CI_step)

[SUCCESS,MESSAGE] = mkdir(pathToSave);

if(SUCCESS==0)
    error([Model ' directory can''t be created: ' MESSAGE])
end

if(isempty(dir([pathToSave '/base'])))
    copyfile('base',[pathToSave '/base']);
    createRunElv(Model)
    createFilePropNod(Model, cellType);
    createFileNodeOutput(Model, step_save);
end

if(isempty(K_dirFact))
    [N,D]=rat(K);
    K_dirFact = max(D);
end
digits = floor(log10(max(K*K_dirFact))+1);

K_str = cell(length(K));
preStim_stat = zeros(size(K));
new_pre_dur = zeros(size(K));
Threshold_stat = zeros(size(K));
S1_stat = zeros(size(K));

matlabpool(cores)
parfor i=1:length(K)
    K_str{i} = ['K_' num2str(round(K(i)*K_dirFact),['%0' num2str(digits) 'd'])];

    if(isempty(dir([Model '/' K_str{i}])))
        [SUCCESS,MESSAGE] =  mkdir([Model '/' K_str{i}]);
        copyfile([Model '/base'],[Model '/' K_str{i} '/base']);
        createFileParamNode(Model,K(i),K_index,K_str{i})
    end

    [preStim_stat(i),new_pre_dur(i)] = calculatePreStim(Model, K_str{i}, h_index, j_index, fun_sodium, pre_dur, pre_step, dt);
    
    while(~preStim_stat(i))
        [preStim_stat(i),new_pre_dur(i)] =  calculatePreStim(Model, K_str{i}, h_index, j_index, fun_sodium, new_pre_dur(i), pre_step, dt);
    end

    Threshold_stat(i) = calculateIThreshold(Model, K_str{i},Imax, Istep, dt);

    if(~Threshold_stat(i))
        continue;
    end
    
    S1_stat(i)=runS1(Model, K_str{i}, dt);

    if(~S1_stat(i))
        continue;
    end
    
    calculateSingleERP(Model, K_str{i}, CI_step, dt);
end

matlabpool close
