function plotIThresholdLimits(pathToSave,K)

close all;

for i=1:length(K)
    K_str = ['K_' num2str(K(i))];

    if(~isempty(dir([pathToSave '/' K_str '/status.mat'])))
        sim_stat = load([pathToSave '/' K_str '/status.mat']);

        f=figure;
        if(isfield(sim_stat,'minIStim'))
            minIStim=sim_stat.minIStim
            if(minIStim==0)
              continue;
            end
            Istim_str = ['Istim_' num2str(minIStim)];
            a=load([pathToSave '/' K_str '/' Istim_str '/post/IThreshold_prc0_00000151.var']);
            b=load([pathToSave '/' K_str '/' Istim_str '/post/IThreshold_prc0_00000176.var']);
            c=load([pathToSave '/' K_str '/' Istim_str '/post/IThreshold_prc0_00000201.var']);
            d=load([pathToSave '/' K_str '/' Istim_str '/post/IThreshold_prc0_00000226.var']);
            e=load([pathToSave '/' K_str '/' Istim_str '/post/IThreshold_prc0_00000251.var']);

            subplot(2,1,1)
            plot(a(:,1),a(:,2),b(:,1),b(:,2),c(:,1),c(:,2),d(:,1),d(:,2),e(:,1),e(:,2))
            title(num2str(minIStim))
         end
         if(isfield(sim_stat,'maxIStim'))
            maxIStim=sim_stat.maxIStim
            Istim_str = ['Istim_' num2str(maxIStim)];
            a=load([pathToSave '/' K_str '/' Istim_str '/post/IThreshold_prc0_00000151.var']);
            b=load([pathToSave '/' K_str '/' Istim_str '/post/IThreshold_prc0_00000176.var']);
            c=load([pathToSave '/' K_str '/' Istim_str '/post/IThreshold_prc0_00000201.var']);
            d=load([pathToSave '/' K_str '/' Istim_str '/post/IThreshold_prc0_00000226.var']);
            e=load([pathToSave '/' K_str '/' Istim_str '/post/IThreshold_prc0_00000251.var']);

            subplot(2,1,2)
            plot(a(:,1),a(:,2),b(:,1),b(:,2),c(:,1),c(:,2),d(:,1),d(:,2),e(:,1),e(:,2))
            title(num2str(maxIStim))
          end
          saveas(f,[pathToSave '/Istim_' K_str '.pdf'])
        end
    end
end
