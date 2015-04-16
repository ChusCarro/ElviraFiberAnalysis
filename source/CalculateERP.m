function CalculateERP(cores, pathToSave, mainElvira, project, cellType, K, K_index, dt, step_save, pre_dur,...
                       pre_step, fun_sodium, h_index, j_index, Imax, Istep, CI_step,sigma_L,Cm,...
                       HZ, BZ, IZ, dx, dxOut, nOut, CL, numStimIThreshold)

L = HZ+BZ+IZ;
nodes = 0:dx:L;
nodeOut = [round((HZ+BZ+IZ/2-dxOut/2*(nOut-1))/dx):round(dxOut/dx):round((HZ+BZ+IZ/2+dxOut/2*(nOut-1))/dx)]+1

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

if(isempty(dir([pathToSave '/IStim'])))
    [SUCCES, MESSAGE] = mkdir([pathToSave '/IStim']);
    copyfile([pathToSave '/base'],[pathToSave '/IStim/base']);
end


Threshold = calculateIThreshold([pathToSave '/IStim'], Imax, Istep, numStimIThreshold, CL, dt, nodeOut, project)

if(~Threshold)
   disp('Bad configuration. Unable to find Istim Threshold')
   return
end

%matlabpool(cores)
%parfor i=1:length(K)
%    K_str{i} = ['K_' num2str(K(i))];
%
%    if(isempty(dir([pathToSave '/' K_str{i}])))
%        [SUCCESS,MESSAGE] =  mkdir([pathToSave '/' K_str{i}]);
%        copyfile([pathToSave '/base'],[pathToSave '/' K_str{i} '/base']);
%        createFileParamNode([pathToSave '/' K_str{i} '/base'],K(i),K_index,length(nodes))
%    end
%
%    [preStim_stat(i),new_pre_dur(i)] = calculatePreStim([pathToSave '/' K_str{i}],...
%                                            K(i), h_index, j_index, fun_sodium, pre_dur, pre_step, dt, nodeOut, project);
%    
%    while(~preStim_stat(i))
%        [preStim_stat(i),new_pre_dur(i)] =  calculatePreStim([pathToSave '/' K_str{i}],...
%                                                 K(i), h_index, j_index, fun_sodium, new_pre_dur(i), pre_step, dt, nodeOut, project);
%    end
%
%    
%    S1_stat(i)=runS1([pathToSave '/' K_str{i}],K(i), dt, project);
%
%
%    if(~S1_stat(i))
%        continue;
%    end
%    
%    calculateSingleERP([pathToSave '/' K_str{i}], K(i), CI_step, dt, project);
%end

%matlabpool close