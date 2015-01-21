function plotCILimits(pathToSave,K,K_dirFact)

close all;

if(isempty(K_dirFact))
    [N,D]=rat(K);
    K_dirFact = max(D);
end
digits = floor(log10(max(K*K_dirFact))+1);

for i=1:length(K)
    K_str = ['K_' num2str(round(K(i)*K_dirFact),['%0' num2str(digits) 'd'])];

    if(~isempty(dir([pathToSave '/' K_str '/status.mat'])))
        sim_stat = load([pathToSave '/' K_str '/status.mat']);

        if(isfield(sim_stat,'ERP1'))
            minCI1=sim_stat.minCI1;
            maxCI1=sim_stat.maxCI1;
            CIStep = sim_stat.CIStep;
            CI_str = ['CI1_' num2str(round(minCI1/CIStep),'%05d')];
            a=load([pathToSave '/' K_str '/' CI_str '/post/ERP1_00000151.var']);
            b=load([pathToSave '/' K_str '/' CI_str '/post/ERP1_00000176.var']);
            c=load([pathToSave '/' K_str '/' CI_str '/post/ERP1_00000201.var']);
            d=load([pathToSave '/' K_str '/' CI_str '/post/ERP1_00000226.var']);
            e=load([pathToSave '/' K_str '/' CI_str '/post/ERP1_00000251.var']);

            f=figure;
            subplot(2,1,1)
            plot(a(:,1),a(:,2),b(:,1),b(:,2),c(:,1),c(:,2),d(:,1),d(:,2),e(:,1),e(:,2))
            title(['CI1 = ' num2str(minCI1)])

            CI_str = ['CI1_' num2str(round(maxCI1/CIStep),'%05d')];
            a=load([pathToSave '/' K_str '/' CI_str '/post/ERP1_00000151.var']);
            b=load([pathToSave '/' K_str '/' CI_str '/post/ERP1_00000176.var']);
            c=load([pathToSave '/' K_str '/' CI_str '/post/ERP1_00000201.var']);
            d=load([pathToSave '/' K_str '/' CI_str '/post/ERP1_00000226.var']);
            e=load([pathToSave '/' K_str '/' CI_str '/post/ERP1_00000251.var']);

            subplot(2,1,2)
            plot(a(:,1),a(:,2),b(:,1),b(:,2),c(:,1),c(:,2),d(:,1),d(:,2),e(:,1),e(:,2))

            title(['CI1 = ' num2str(maxCI1)])
            saveas(f,[pathToSave '/' K_str '-CI1.pdf'])
        end
            
        if(isfield(sim_stat,'ERP2'))
            minCI2=sim_stat.minCI2;
            maxCI2=sim_stat.maxCI2;
            
            if(minCI2==1000 || maxCI2==1000)
                continue;
            end

            CIStep = sim_stat.CIStep;
            CI_str = ['CI2_' num2str(round(minCI2/CIStep),'%05d')];
            a=load([pathToSave '/' K_str '/' CI_str '/post/ERP2_00000151.var']);
            b=load([pathToSave '/' K_str '/' CI_str '/post/ERP2_00000176.var']);
            c=load([pathToSave '/' K_str '/' CI_str '/post/ERP2_00000201.var']);
            d=load([pathToSave '/' K_str '/' CI_str '/post/ERP2_00000226.var']);
            e=load([pathToSave '/' K_str '/' CI_str '/post/ERP2_00000251.var']);

            f=figure;
            subplot(2,1,1)
            plot(a(:,1),a(:,2),b(:,1),b(:,2),c(:,1),c(:,2),d(:,1),d(:,2),e(:,1),e(:,2))
            title(['CI2 = ' num2str(minCI2)])

            CI_str = ['CI2_' num2str(round(maxCI2/CIStep),'%05d')];
            a=load([pathToSave '/' K_str '/' CI_str '/post/ERP2_00000151.var']);
            b=load([pathToSave '/' K_str '/' CI_str '/post/ERP2_00000176.var']);
            c=load([pathToSave '/' K_str '/' CI_str '/post/ERP2_00000201.var']);
            d=load([pathToSave '/' K_str '/' CI_str '/post/ERP2_00000226.var']);
            e=load([pathToSave '/' K_str '/' CI_str '/post/ERP2_00000251.var']);

            subplot(2,1,2)
            plot(a(:,1),a(:,2),b(:,1),b(:,2),c(:,1),c(:,2),d(:,1),d(:,2),e(:,1),e(:,2))

            title(['CI2 = ' num2str(maxCI2)])
            saveas(f,[pathToSave '/' K_str '-CI2.pdf'])
        end
    end
end
