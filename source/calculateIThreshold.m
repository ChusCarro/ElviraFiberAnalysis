function conduction = calculateIThreshold(pathToSave, K_str, Imax, IStep, dt)

conduction =false;
file = dir([pathToSave '/' K_str '/status.mat']);

if(~isempty(file))
    sim_stat = load([pathToSave '/' K_str '/' '/status.mat']);
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
        save([pathToSave '/' K_str '/status.mat'],'-struct','sim_stat');
        return;
    end

    Istim_str = ['Istim_' num2str(round(Imax/IStep),'%04d')];
    if(~isempty(dir([pathToSave '/' K_str '/' Istim_str])))
        rmdir([pathToSave '/' K_str '/' Istim_str],'s')
    end
    copyfile([pathToSave '/' K_str '/base'],[pathToSave '/' K_str '/' Istim_str])
    createMainFileIThreshold(pathToSave, K_str, Istim_str, dt);
    createFileIThresholdStim(pathToSave, K_str, Imax, Istim_str);
    initialPath = cd([pathToSave '/' K_str '/' Istim_str]);
    ! ./runelv 1 data/main_file_IThreshold.dat post/IThreshold_
    a=load('post/IThreshold_00000151.var');
    dt_results = a(2,1)-a(1,1);
    V=zeros(length(a(:,2)),5);
    V(:,1)=a(:,2);
    a=load('post/IThreshold_00000176.var');
    V(:,2)=a(:,2);
    a=load('post/IThreshold_00000201.var');
    V(:,3)=a(:,2);
    a=load('post/IThreshold_00000226.var');
    V(:,4)=a(:,2);
    a=load('post/IThreshold_00000251.var');
    V(:,5)=a(:,2);
    cond = testConduction(V,dt_results);
    
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

save([pathToSave '/' K_str '/status.mat'],'-struct','sim_stat');

if(~sim_stat.conduction)
    return;
end

while(sim_stat.maxIStim-sim_stat.minIStim-sim_stat.IStep>1e-3)
    Istim = round((sim_stat.maxIStim+sim_stat.minIStim)/2/sim_stat.IStep)*sim_stat.IStep;
    Istim_str = ['Istim_' num2str(round(Istim/IStep),'%04d')];
    if(~isempty(dir([pathToSave '/' K_str '/' Istim_str])))
        rmdir([pathToSave '/' K_str '/' Istim_str],'s')
    end
    copyfile([pathToSave '/' K_str '/base'],[pathToSave '/' K_str '/' Istim_str])
    createMainFileIThreshold(pathToSave, K_str, Istim_str, dt);
    createFileIThresholdStim(pathToSave, K_str, Istim, Istim_str);
    cd([pathToSave '/' K_str '/' Istim_str])
    ! ./runelv 1 data/main_file_IThreshold.dat post/IThreshold_
    a=load('post/IThreshold_00000151.var');
    dt_results = a(2,1)-a(1,1);
    V=zeros(length(a(:,2)),5);
    V(:,1)=a(:,2);
    a=load('post/IThreshold_00000176.var');
    V(:,2)=a(:,2);
    a=load('post/IThreshold_00000201.var');
    V(:,3)=a(:,2);
    a=load('post/IThreshold_00000226.var');
    V(:,4)=a(:,2);
    a=load('post/IThreshold_00000251.var');
    V(:,5)=a(:,2);
    cond = testConduction(V,dt_results);

    if(cond)
       sim_stat.maxIStim=Istim;
    else
       sim_stat.minIStim=Istim;
    end

    save([pathToSave '/' K_str '/status.mat'],'-struct','sim_stat');

end

cd(initialPath)
sim_stat.IThreshold = sim_stat.maxIStim;
sim_stat.IStim = sim_stat.IThreshold * 2;

save([pathToSave '/' K_str '/status.mat'],'-struct','sim_stat');
