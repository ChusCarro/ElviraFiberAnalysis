function conduction = runS1(pathToSave,K,dt,nodeOut,dxOut,nS1,CL,project)

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

    createFileStimulus([pathToSave '/base'],[0:CL:CL*(nS1)],1,IStim);
    createMainFile([pathToSave '/base'],'main_file_S1', project, ...
                 ['Calculation of S1 train with K = ' num2str(K) 'mM'] ,...
                 CL*(nS1+1),dt,'restartPreStim_prc_','restartS1',CL,true,false);

    cd([pathToSave '/base/'])
    ! ./runelv 1 data/main_file_S1.dat post/S1_ 
    cd ../../..

    copyfile([pathToSave '/base'],[pathToSave '/base-S1']);
    delete([pathToSave '/base/*.*']);
    delete([pathToSave '/base/post/*']);
end

if(~isfield(sim_stat,'APD2'))
    cd([pathToSave '/base-S1/'])
    for i=1:length(nodeOut)
        a=load(sprintf('post/S1_prc0_%08d.var',nodeOut(i)));
        dt_results = a(2,1)-a(1,1);
        CL_pos = round(CL/dt_results);
        V(:,i)=a(end-CL_pos*2:end,2);
    end
    cd ../../..

    [conduction, CV, APD] = testConduction(V,dt_results,2,dxOut);
    
    conduction = conduction(1) & conduction(2);

    sim_stat.S1Conduction = conduction;
    sim_stat.CV1  = CV(1);
    sim_stat.APD1 = APD(1);
    sim_stat.CV2  = CV(2);
    sim_stat.APD2 = APD(2);
end

save([pathToSave '/status.mat'],'-struct','sim_stat');
conduction = sim_stat.S1Conduction;

