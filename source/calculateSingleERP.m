function [ERP1,ERP2] = calculateSingleERP(pathToSave, Ki, CIStep, dt, project)
CL = 1000;
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
        warning(0,'Different CIStep from previous simulations. It''s necessary to implement the modification of the names')
     end
end

if(~isfield(sim_stat,'minCI1'))
    sim_stat.minCI1 = 0;
end

if(~isfield(sim_stat,'maxCI1'))
    sim_stat.maxCI1=1000;
end

save([pathToSave '/status.mat'],'-struct','sim_stat');

while(sim_stat.maxCI1-sim_stat.minCI1-sim_stat.CIStep>1e-3)
    CI = round((sim_stat.maxCI1+sim_stat.minCI1)/2/sim_stat.CIStep)*sim_stat.CIStep;
    CI_str = ['CI1_' num2str(CI)];
    if(~isempty(dir([pathToSave '/' CI_str])))
        rmdir([pathToSave '/' CI_str],'s')
    end
    copyfile([pathToSave '/base'],[pathToSave '/' CI_str])
    
    load_instant = round(10*CL/dt);
    createMainFile([pathToSave  '/' CI_str],'main_file_ERP1',project,['ERP calculation for Ki = ' num2str(Ki) ' with CI = ' CI_str],...
       CI+CL,dt,['restartS1_' num2str(load_instant) '_prc_'],[],0);
    createFileStimulus([pathToSave  '/' CI_str],[0 CI],1,sim_stat.IStim);
    cd([pathToSave '/' CI_str])
    ! ./runelv 1 data/main_file_ERP1.dat post/ERP1_
    a=load('post/ERP1_prc0_00000151.var');
    dt_results = a(2,1)-a(1,1);
    V=zeros(length(a(:,2)),5);
    V(:,1)=a(:,2);
    a=load('post/ERP1_prc0_00000176.var');
    V(:,2)=a(:,2);
    a=load('post/ERP1_prc0_00000201.var');
    V(:,3)=a(:,2);
    a=load('post/ERP1_prc0_00000226.var');
    V(:,4)=a(:,2);
    a=load('post/ERP1_prc0_00000251.var');
    V(:,5)=a(:,2);
    cd ../../..
    conduction = testConduction(V,dt_results,2);

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
    sim_stat.maxCI2=1000;
end

save([pathToSave '/status.mat'],'-struct','sim_stat');

while(sim_stat.maxCI2-sim_stat.minCI2-sim_stat.CIStep>1e-3)
    CI = round((sim_stat.maxCI2+sim_stat.minCI2)/2/sim_stat.CIStep)*sim_stat.CIStep;
    CI_str = ['CI2_' num2str(CI)];
    if(~isempty(dir([pathToSave '/' CI_str])))
        rmdir([pathToSave '/' CI_str],'s')
    end
    copyfile([pathToSave '/base'],[pathToSave '/' CI_str])

    load_instant = round(11*CL/dt);
    createMainFile([pathToSave  '/' CI_str],'main_file_ERP2',project,['ERP calculation for Ki = ' num2str(Ki) ' with CI = ' CI_str],...
       CI+CL,dt,['restartS1_' num2str(load_instant) '_prc_'],[],0);
    createFileStimulus([pathToSave  '/' CI_str],[0 CI],1,sim_stat.IStim);
    cd([pathToSave '/' CI_str])
    ! ./runelv 1 data/main_file_ERP2.dat post/ERP2_
    a=load('post/ERP2_prc0_00000151.var');
    dt_results = a(2,1)-a(1,1);
    V=zeros(length(a(:,2)),5);
    V(:,1)=a(:,2);
    a=load('post/ERP2_prc0_00000176.var');
    V(:,2)=a(:,2);
    a=load('post/ERP2_prc0_00000201.var');
    V(:,3)=a(:,2);
    a=load('post/ERP2_prc0_00000226.var');
    V(:,4)=a(:,2);
    a=load('post/ERP2_prc0_00000251.var');
    V(:,5)=a(:,2);
    cd ../../..
    conduction = testConduction(V,dt_results,2);

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
