function conduction = runS1(pathToSave,K_str,dt)

file=dir([pathToSave '/' K_str '/status.mat']);

if(~isempty(file))
    sim_stat = load([pathToSave '/' K_str '/status.mat']);
else
    conduction = false;
    return;
end

if(~isfield(sim_stat,'IStim'))
    conduction = false;
    return;
end

if(isempty(dir([pathToSave '/' K_str '/base-S1'])))

    IStim = sim_stat.IStim;

    createMainFileS1(pathToSave,K_str,dt);
    createFileS1Stim(pathToSave,K_str,IStim);

    cd([pathToSave '/' K_str '/base/'])
    ! ./runelv 1 data/main_file_S1.dat post/S1_ 
    cd ../../..

    copyfile([pathToSave '/' K_str '/base'],[pathToSave '/' K_str '/base-S1']);
    delete([pathToSave '/' K_str '/base/*.*']);
    delete([pathToSave '/' K_str '/base/post/*']);
end

if(~isfield(sim_stat,'APD2'))
    cd([pathToSave '/' K_str '/base-S1/'])
    a=load('post/S1_00000151.var');
    dt_results = a(2,1)-a(1,1);
    CL_pos = round(1000/dt_results);

    V1=zeros(length(a(end-CL_pos:end,2)),5);
    V2=zeros(length(a(end-CL_pos*2:end-CL_pos,2)),5);

    V1(:,1)=a(end-CL_pos:end,2);
    V2(:,1)=a(end-CL_pos*2:end-CL_pos,2);

    a=load('post/S1_00000176.var');
    V1(:,2)=a(end-CL_pos:end,2);
    V2(:,2)=a(end-CL_pos*2:end-CL_pos,2);

    a=load('post/S1_00000201.var');
    V1(:,3)=a(end-CL_pos:end,2);
    V2(:,3)=a(end-CL_pos*2:end-CL_pos,2);

    a=load('post/S1_00000226.var');
    V1(:,4)=a(end-CL_pos:end,2);
    V2(:,4)=a(end-CL_pos*2:end-CL_pos,2);

    a=load('post/S1_00000251.var');
    V1(:,5)=a(end-CL_pos:end,2);
    V2(:,5)=a(end-CL_pos*2:end-CL_pos,2);

    cd ../../..

    [conduction1, CV1, APD1] = testConduction(V1,dt_results);
    [conduction2, CV2, APD2] = testConduction(V2,dt_results);
    
    conduction = conduction1 & conduction2;

    sim_stat.S1Conduction = conduction;
    sim_stat.CV1  = CV1;
    sim_stat.APD1 = APD1;
    sim_stat.CV2  = CV2;
    sim_stat.APD2 = APD2;
end

save([pathToSave '/' K_str '/status.mat'],'-struct','sim_stat');
conduction = sim_stat.S1Conduction;

