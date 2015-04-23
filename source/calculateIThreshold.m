function conduction = calculateIThreshold(pathToSave, Imax, IStep, numStim, CL, dt, nodeOut, dxOut, project)

initialPath = pwd();

conduction =false;
file = dir([pathToSave '/status.mat']);

if(~isempty(file))
    sim_stat = load([pathToSave '/status.mat']);
else
    sim_stat = struct();
end

if(~isfield(sim_stat,'conduction'))
    sim_stat.conduction = false;
else
    conduction=sim_stat.conduction;
end

if(~isfield(sim_stat,'IStep'))
    sim_stat.IStep = IStep;
else if(sim_stat.IStep ~= IStep)
        warning(0,'Different IStep from previous simulations. It''s necessary to implement the modification of the names')
     end
end


if(~isfield(sim_stat,'minIStim'))
    sim_stat.minIStim = 0;
end

if(~isfield(sim_stat,'maxIStim'))
    if(sim_stat.minIStim>=Imax)
        save([pathToSave '/status.mat'],'-struct','sim_stat');
        return;
    end

    Istim_str = ['Istim_' num2str(Imax)];
    if(~isempty(dir([pathToSave '/' Istim_str])))
        rmdir([pathToSave '/' Istim_str],'s')
    end
    copyfile([pathToSave '/base'],[pathToSave '/' Istim_str])
    createFileStimulus([pathToSave '/' Istim_str],[0:CL:CL*(numStim-1)],1,Imax);
    createMainFile([pathToSave '/' Istim_str],'main_file_IThreshold', project, ...
                 ['Calculation of umbral threshold with Istim = ' num2str(Imax) 'pA/pF'] ,...
                 numStim*CL,dt,[],[],0,false,false)

    cd([pathToSave '/' Istim_str]);
    ! ./runelv 1 data/main_file_IThreshold.dat post/IThreshold_
    for i=1:length(nodeOut)
        a=load(sprintf('post/IThreshold_prc0_%08d.var',nodeOut(i)));
        dt_results = a(2,1)-a(1,1);
        V(:,i)=a(:,2);
    end
    cond = testConduction(V,dt_results,numStim,dxOut);
    
    if(cond)
       sim_stat.maxIStim=Imax;
       sim_stat.conduction=true;
       conduction = true;
    else
       sim_stat.conduction=false;
       sim_stat.minIStim=Imax;
    end
else
    sim_stat.conduction=true;
    conduction = true;
end

save([pathToSave '/status.mat'],'-struct','sim_stat');

if(~sim_stat.conduction)
    return;
end

while(sim_stat.maxIStim-sim_stat.minIStim-sim_stat.IStep>1e-3)
    Istim = round((sim_stat.maxIStim+sim_stat.minIStim)/2/sim_stat.IStep)*sim_stat.IStep;
    Istim_str = ['Istim_' num2str(Istim)];
    if(~isempty(dir([pathToSave '/' Istim_str])))
        rmdir([pathToSave '/' Istim_str],'s')
    end
    copyfile([pathToSave '/base'],[pathToSave '/' Istim_str])
    createFileStimulus([pathToSave '/' Istim_str],[0:CL:CL*(numStim-1)],1,Istim);
    createMainFile([pathToSave '/' Istim_str],'main_file_IThreshold', project, ...
                 ['Calculation of umbral threshold with Istim = ' num2str(Istim) 'pA/pF'] ,...
                 numStim*CL,dt,[],[],0,false,false)

    cd([pathToSave '/' Istim_str])
    ! ./runelv 1 data/main_file_IThreshold.dat post/IThreshold_
    for i=1:length(nodeOut)
      a=load(sprintf('post/IThreshold_prc0_%08d.var',nodeOut(i)));
      dt_results = a(2,1)-a(1,1);
      V(:,i)=a(:,2);
    end
    cond = testConduction(V,dt_results,numStim,dxOut);

    if(cond)
       sim_stat.maxIStim=Istim;
    else
       sim_stat.minIStim=Istim;
    end

    save([pathToSave '/status.mat'],'-struct','sim_stat');

end

cd(initialPath)
sim_stat.IThreshold = sim_stat.maxIStim;
sim_stat.IStim = sim_stat.IThreshold * 2;

save([pathToSave '/status.mat'],'-struct','sim_stat');
