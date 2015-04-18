function [ERP1,ERP2] = calculateSingleERP(pathToSave, Ki, CIStep, dt, nodeOut, dxOut, nS1, CL, project)
ERP1 = NaN;
ERP2 = NaN;

initialPath = pwd();
file = dir([pathToSave '/status.mat']);

if(~isempty(file))
    sim_stat = load([pathToSave '/status.mat']);
else
    return;
end

if(~isfield(sim_stat,'S1Conduction'))
    return;
else
    conduction=sim_stat.S1Conduction;
    if(~conduction)
        return;
    end
end

if(~isfield(sim_stat,'CIStep'))
    sim_stat.CIStep = CIStep;
else if(sim_stat.CIStep ~= CIStep)
        warning(0,'Different CIStep from previous simulations. It could cause problems')
     end
end

if(~isfield(sim_stat,'minCI1'))
    sim_stat.minCI1 = 0;
end

if(~isfield(sim_stat,'maxCI1'))
    sim_stat.maxCI1=CL;
end

save([pathToSave '/status.mat'],'-struct','sim_stat');

while(sim_stat.maxCI1-sim_stat.minCI1-sim_stat.CIStep>1e-3)
    CI = round((sim_stat.maxCI1+sim_stat.minCI1)/2/sim_stat.CIStep)*sim_stat.CIStep;
    CI_str = ['CI1_' num2str(CI)];
    if(~isempty(dir([pathToSave '/' CI_str])))
        rmdir([pathToSave '/' CI_str],'s')
    end
    copyfile([pathToSave '/base'],[pathToSave '/' CI_str])
    
    load_instant = round(nS1*CL/dt);
    createMainFile([pathToSave  '/' CI_str],'main_file_ERP1',project,['ERP calculation for Ki = ' num2str(Ki) ' with CI = ' CI_str],...
       CI+CL,dt,['restartS1_' num2str(load_instant) '_prc_'],[],0,true,false);
    createFileStimulus([pathToSave  '/' CI_str],[0 CI],1,sim_stat.IStim);
    cd([pathToSave '/' CI_str])
    ! ./runelv 1 data/main_file_ERP1.dat post/ERP1_

    for i=1:length(nodeOut)
        a=load(sprintf('post/ERP1_prc0_%08d.var',nodeOut(i)));
        dt_results = a(2,1)-a(1,1);
        V(:,i)=a(:,2);
    end
    cd ../../..
    conduction = testConduction(V,dt_results,2,dxOut);
    clear V

    if(conduction)
       sim_stat.maxCI1=CI;
    else
       sim_stat.minCI1=CI;
    end

    save([pathToSave '/status.mat'],'-struct','sim_stat');

end

sim_stat.ERP1 = sim_stat.maxCI1;
ERP1 = sim_stat.ERP1;

if(~isfield(sim_stat,'minCI2'))
    sim_stat.minCI2 = 0;
end

if(~isfield(sim_stat,'maxCI2'))
    sim_stat.maxCI2=CL;
end

save([pathToSave '/status.mat'],'-struct','sim_stat');

while(sim_stat.maxCI2-sim_stat.minCI2-sim_stat.CIStep>1e-3)
    CI = round((sim_stat.maxCI2+sim_stat.minCI2)/2/sim_stat.CIStep)*sim_stat.CIStep;
    CI_str = ['CI2_' num2str(CI)];
    if(~isempty(dir([pathToSave '/' CI_str])))
        rmdir([pathToSave '/' CI_str],'s')
    end
    copyfile([pathToSave '/base'],[pathToSave '/' CI_str])

    load_instant = round((nS1+1)*CL/dt);
    createMainFile([pathToSave  '/' CI_str],'main_file_ERP2',project,['ERP calculation for Ki = ' num2str(Ki) ' with CI = ' CI_str],...
       CI+CL,dt,['restartS1_' num2str(load_instant) '_prc_'],[],0,true,false);
    createFileStimulus([pathToSave  '/' CI_str],[0 CI],1,sim_stat.IStim);
    cd([pathToSave '/' CI_str])
    ! ./runelv 1 data/main_file_ERP2.dat post/ERP2_
    
    for i=1:length(nodeOut)
        a=load(sprintf('post/ERP2_prc0_%08d.var',nodeOut(i)));
        dt_results = a(2,1)-a(1,1);
        V(:,i)=a(:,2);
    end
    cd ../../..
    conduction = testConduction(V,dt_results,2,dxOut);
    clear V

    if(conduction)
       sim_stat.maxCI2=CI;
    else
       sim_stat.minCI2=CI;
    end

    save([pathToSave '/status.mat'],'-struct','sim_stat');

end

sim_stat.ERP2 = sim_stat.maxCI2;
ERP2 = sim_stat.ERP2;

save([pathToSave '/status.mat'],'-struct','sim_stat');


cd(initialPath)
