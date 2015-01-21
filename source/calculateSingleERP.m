function [ERP1,ERP2] = calculateSingleERP(Model, K_str, CIStep, dt)

ERP1 = NaN;
ERP2 = NaN;

file = dir([Model '/' K_str '/status.mat']);

if(~isempty(file))
    sim_stat = load([Model '/' K_str '/' '/status.mat']);
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

save([Model '/' K_str '/status.mat'],'-struct','sim_stat');

while(sim_stat.maxCI1-sim_stat.minCI1-sim_stat.CIStep>1e-3)
    CI = round((sim_stat.maxCI1+sim_stat.minCI1)/2/sim_stat.CIStep)*sim_stat.CIStep;
    CI_str = ['CI1_' num2str(round(CI/CIStep),'%05d')];
    if(~isempty(dir([Model '/' K_str '/' CI_str])))
        rmdir([Model '/' K_str '/' CI_str],'s')
    end
    copyfile([Model '/' K_str '/base'],[Model '/' K_str '/' CI_str])
    createMainFileERP1(Model, K_str, CI, CI_str, dt);
    createFileERPStim(Model, K_str, sim_stat.IStim, CI, CI_str);
    cd([Model '/' K_str '/' CI_str])
    ! ./runelv 1 data/main_file_ERP1.dat post/ERP1_
    a=load('post/ERP1_00000151.var');
    dt_results = a(2,1)-a(1,1);
    V=zeros(length(a(:,2)),5);
    V(:,1)=a(:,2);
    a=load('post/ERP1_00000176.var');
    V(:,2)=a(:,2);
    a=load('post/ERP1_00000201.var');
    V(:,3)=a(:,2);
    a=load('post/ERP1_00000226.var');
    V(:,4)=a(:,2);
    a=load('post/ERP1_00000251.var');
    V(:,5)=a(:,2);
    cd ../../..
    [conduction, apd90] = testConduction(V,dt_results);

    if(conduction & length(apd90)==2)
       sim_stat.maxCI1=CI;
    else
       sim_stat.minCI1=CI;
    end

    save([Model '/' K_str '/status.mat'],'-struct','sim_stat');

end

if(~isfield(sim_stat,'minCI2'))
    sim_stat.minCI2 = 0;
end

if(~isfield(sim_stat,'maxCI2'))
    sim_stat.maxCI2=1000;
end

save([Model '/' K_str '/status.mat'],'-struct','sim_stat');

while(sim_stat.maxCI2-sim_stat.minCI2-sim_stat.CIStep>1e-3)
    CI = round((sim_stat.maxCI2+sim_stat.minCI2)/2/sim_stat.CIStep)*sim_stat.CIStep;
    CI_str = ['CI2_' num2str(round(CI/CIStep),'%05d')];
    if(~isempty(dir([Model '/' K_str '/' CI_str])))
        rmdir([Model '/' K_str '/' CI_str],'s')
    end
    copyfile([Model '/' K_str '/base'],[Model '/' K_str '/' CI_str])
    createMainFileERP2(Model, K_str, CI, CI_str, dt);
    createFileERPStim(Model, K_str,sim_stat.IStim, CI, CI_str);
    cd([Model '/' K_str '/' CI_str])
    ! ./runelv 1 data/main_file_ERP2.dat post/ERP2_
    a=load('post/ERP2_00000151.var');
    dt_results = a(2,1)-a(1,1);
    V=zeros(length(a(:,2)),5);
    V(:,1)=a(:,2);
    a=load('post/ERP2_00000176.var');
    V(:,2)=a(:,2);
    a=load('post/ERP2_00000201.var');
    V(:,3)=a(:,2);
    a=load('post/ERP2_00000226.var');
    V(:,4)=a(:,2);
    a=load('post/ERP2_00000251.var');
    V(:,5)=a(:,2);
    cd ../../..
    [conduction, apd90] = testConduction(V,dt_results);

    if(conduction & length(apd90)==2)
       sim_stat.maxCI2=CI;
    else
       sim_stat.minCI2=CI;
    end

    save([Model '/' K_str '/status.mat'],'-struct','sim_stat');

end

sim_stat.ERP1 = sim_stat.maxCI1;
sim_stat.ERP2 = sim_stat.maxCI2;
ERP1 = sim_stat.ERP1;
ERP2 = sim_stat.ERP2;
save([Model '/' K_str '/status.mat'],'-struct','sim_stat');
