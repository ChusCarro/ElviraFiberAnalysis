function plotIThresholdLimits(Model,K,K_dirFact)

close all;

if(isempty(K_dirFact))
    [N,D]=rat(K);
    K_dirFact = max(D);
end
digits = floor(log10(max(K*K_dirFact))+1);

for i=1:length(K)
    K_str = ['K_' num2str(round(K(i)*K_dirFact),['%0' num2str(digits) 'd'])];

    if(~isempty(dir([Model '/' K_str '/status.mat'])))
        sim_stat = load([Model '/' K_str '/status.mat']);

        if(isfield(sim_stat,'IThreshold'))
            minIStim=sim_stat.minIStim;
            maxIStim=sim_stat.maxIStim;
            IStep = sim_stat.IStep;
            Istim_str = ['Istim_' num2str(round(minIStim/IStep),'%04d')];
            a=load([Model '/' K_str '/' Istim_str '/post/IThreshold_00000151.var']);
            b=load([Model '/' K_str '/' Istim_str '/post/IThreshold_00000176.var']);
            c=load([Model '/' K_str '/' Istim_str '/post/IThreshold_00000201.var']);
            d=load([Model '/' K_str '/' Istim_str '/post/IThreshold_00000226.var']);
            e=load([Model '/' K_str '/' Istim_str '/post/IThreshold_00000251.var']);

            f=figure;
            subplot(2,1,1)
            plot(a(:,1),a(:,2),b(:,1),b(:,2),c(:,1),c(:,2),d(:,1),d(:,2),e(:,1),e(:,2))
            title(num2str(minIStim))

            Istim_str = ['Istim_' num2str(round(maxIStim/IStep),'%04d')];
            a=load([Model '/' K_str '/' Istim_str '/post/IThreshold_00000151.var']);
            b=load([Model '/' K_str '/' Istim_str '/post/IThreshold_00000176.var']);
            c=load([Model '/' K_str '/' Istim_str '/post/IThreshold_00000201.var']);
            d=load([Model '/' K_str '/' Istim_str '/post/IThreshold_00000226.var']);
            e=load([Model '/' K_str '/' Istim_str '/post/IThreshold_00000251.var']);

            subplot(2,1,2)
            plot(a(:,1),a(:,2),b(:,1),b(:,2),c(:,1),c(:,2),d(:,1),d(:,2),e(:,1),e(:,2))
            title(num2str(maxIStim))

            saveas(f,[Model '/Istim_' K_str '.pdf'])
        end
    end
end
