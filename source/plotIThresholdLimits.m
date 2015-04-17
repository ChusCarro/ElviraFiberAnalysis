function plotIThresholdLimits(pathToSave,nodesOut)

close all;


if(~isempty(dir([pathToSave '/IStim/status.mat'])))
    sim_stat = load([pathToSave '/IStim/status.mat']);

    f=figure;
    if(isfield(sim_stat,'minIStim'))
        minIStim=sim_stat.minIStim
        if(minIStim==0)
            return;
        end
        for i=1:length(nodesOut)
            a=load(sprintf('%s/IStim/Istim_%d/post/IThreshold_prc0_%08d.var',pathToSave,minIStim,nodesOut(i)));
            V(:,i) = a(:,2);
            t(:,i) = a(:,1);
        end

        subplot(2,1,1)
        plot(t,V)
        title(num2str(minIStim))
    end


    if(isfield(sim_stat,'maxIStim'))
        maxIStim=sim_stat.maxIStim

        for i=1:length(nodesOut)
            a=load(sprintf('%s/IStim/Istim_%d/post/IThreshold_prc0_%08d.var',pathToSave,maxIStim,nodesOut(i)));
            V(:,i) = a(:,2);
            t(:,i) = a(:,1);
        end

        subplot(2,1,2)
        plot(t,V)
        title(num2str(maxIStim))
    end
saveas(f,[pathToSave '/Istim.pdf'])
end
