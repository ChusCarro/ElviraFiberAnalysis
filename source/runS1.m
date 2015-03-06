function conduction = runS1(pathToSave,K,dt,project)

file=dir([pathToSave '/status.mat']);

if(~isempty(file))
    sim_stat = load([pathToSave '/status.mat']);
else
    conduction = false;
    return;
end

if(~isfield(sim_stat,'IStim'))
    conduction = false;
    return;
end

if(isempty(dir([pathToSave '/base-S1'])))

    IStim = sim_stat.IStim;

    createFileStimulus([pathToSave '/base'],[0:1000:10000],1,IStim);
    createMainFile([pathToSave '/base'],'main_file_S1', project, ...
                 ['Calculation of S1 train with K = ' num2str(K) 'mM'] ,...
                 11000,dt,'restartPreStim_prc_','restartS1',1000)


    cd([pathToSave '/base/'])
    ! ./runelv 1 data/main_file_S1.dat post/S1_ 
    cd ../../..

    copyfile([pathToSave '/base'],[pathToSave '/base-S1']);
    delete([pathToSave '/base/*.*']);
    delete([pathToSave '/base/post/*']);
end

if(~isfield(sim_stat,'APD2'))
    cd([pathToSave '/base-S1/'])
    a=load('post/S1_prc0_00000151.var');
    dt_results = a(2,1)-a(1,1);
    CL_pos = round(1000/dt_results);

    V1=zeros(length(a(end-CL_pos:end,2)),5);
    V2=zeros(length(a(end-CL_pos*2:end-CL_pos,2)),5);

    V1(:,1)=a(end-CL_pos:end,2);
    V2(:,1)=a(end-CL_pos*2:end-CL_pos,2);

    a=load('post/S1_prc0_00000176.var');
    V1(:,2)=a(end-CL_pos:end,2);
    V2(:,2)=a(end-CL_pos*2:end-CL_pos,2);

    a=load('post/S1_prc0_00000201.var');
    V1(:,3)=a(end-CL_pos:end,2);
    V2(:,3)=a(end-CL_pos*2:end-CL_pos,2);

    a=load('post/S1_prc0_00000226.var');
    V1(:,4)=a(end-CL_pos:end,2);
    V2(:,4)=a(end-CL_pos*2:end-CL_pos,2);

    a=load('post/S1_prc0_00000251.var');
    V1(:,5)=a(end-CL_pos:end,2);
    V2(:,5)=a(end-CL_pos*2:end-CL_pos,2);

    cd ../../..

    [conduction1, CV1, APD1] = testConduction(V1,dt_results,1);
    [conduction2, CV2, APD2] = testConduction(V2,dt_results,1);
    
    conduction = conduction1 & conduction2;

    sim_stat.S1Conduction = conduction;
    sim_stat.CV1  = CV1;
    sim_stat.APD1 = APD1;
    sim_stat.CV2  = CV2;
    sim_stat.APD2 = APD2;
end

save([pathToSave '/status.mat'],'-struct','sim_stat');
conduction = sim_stat.S1Conduction;

