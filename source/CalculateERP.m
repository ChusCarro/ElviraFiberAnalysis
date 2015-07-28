function nodeOut = CalculateERP(cores, pathToSave, mainElvira, project, cellType, K, K_index, K_control, dt, step_save, pre_dur,...
                       pre_step, fun_sodium, h_index, j_index, Imax, Istep, CI_step,sigma_L,Cm,...
                       HZ, BZ, IZ, dx, dxOut, nOut,centerOut, CL, numStimIThreshold,nS1,CVControl,CVerror)

L = HZ+BZ+IZ;
nodes = 0:dx:L;
nodeOut = [round((centerOut-dxOut/2*(nOut-1))/dx):round(dxOut/dx):round((centerOut+dxOut/2*(nOut-1))/dx)]+1

[SUCCESS,MESSAGE] = mkdir(pathToSave);

if(SUCCESS==0)
    error([pathToSave ' directory can''t be created: ' MESSAGE])
end

if(isempty(dir([pathToSave '/base'])))
    mkdir([pathToSave '/base'])
    mkdir([pathToSave '/base/data'])
    mkdir([pathToSave '/base/post'])
    createRunElv([pathToSave '/base'],mainElvira)
    createFileMaterial([pathToSave '/base'],sigma_L,1,Cm);
    createFilePropNod([pathToSave '/base'], cellType);
    createFilePropElement([pathToSave '/base']);
    createFileNodes([pathToSave '/base'],nodes);
    createFileElements([pathToSave '/base'],length(nodes));
    createFileNodeOutput([pathToSave '/base'], step_save, nodeOut, true);
    createFileNodeOutput([pathToSave '/base'], step_save, nodeOut, false);
end

K_str = cell(length(K));
preStim_stat = zeros(size(K));
new_pre_dur = zeros(size(K));
S1_stat = zeros(size(K));

if(isempty(dir([pathToSave '/Sigma'])))
    [SUCCES, MESSAGE] = mkdir([pathToSave '/Sigma']);
    copyfile([pathToSave '/base'],[pathToSave '/Sigma/base']);
end


sigma = calculateSigma([pathToSave '/Sigma'], Imax, sigma_L , Cm, CVControl,CVerror, nS1, CL, dt, nodeOut,dxOut, project);

createFileMaterial([pathToSave '/base'],sigma,1,Cm);


if(isempty(dir([pathToSave '/IStim'])))
    [SUCCES, MESSAGE] = mkdir([pathToSave '/IStim']);
    copyfile([pathToSave '/base'],[pathToSave '/IStim/base']);
end


conduction = calculateIThreshold([pathToSave '/IStim'], Imax, Istep, numStimIThreshold, CL, dt, nodeOut,dxOut, project);

if(~conduction)
   disp('Bad configuration. Unable to find Istim Threshold')
   return
end

matlabpool(cores)
parfor i=1:length(K)
    K_str{i} = ['K_' num2str(K(i))];

    if(isempty(dir([pathToSave '/' K_str{i}])))
        [SUCCESS,MESSAGE] =  mkdir([pathToSave '/' K_str{i}]);
        copyfile([pathToSave '/base'],[pathToSave '/' K_str{i} '/base']);
        copyfile([pathToSave '/IStim/status.mat'],[pathToSave '/' K_str{i} '/status.mat']);
        createFileParamNode([pathToSave '/' K_str{i} '/base'],K(i),K_index,K_control,length(nodes),dx, HZ, BZ, IZ)
    end

    calculatePreStim([pathToSave '/' K_str{i}], K(i), h_index, j_index, fun_sodium, pre_dur, pre_step, dt, nodeOut, project);
    
    S1_stat(i)=runS1([pathToSave '/' K_str{i}],K(i), dt, nodeOut, dxOut, nS1, CL, project);

    if(~S1_stat(i))
        continue;
    end
    
    calculateSingleERP([pathToSave '/' K_str{i}], K(i), CI_step, dt, nodeOut, dxOut, nS1, CL, project);
end

matlabpool close
