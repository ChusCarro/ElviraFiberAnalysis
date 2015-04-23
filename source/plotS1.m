function plotS1(pathToSave,K,nodeOut)

close all;

for i=1:length(K)
    K_str = ['K_' num2str(K(i))]

    if(~isempty(dir([pathToSave '/' K_str '/status.mat'])))
        sim_stat = load([pathToSave '/' K_str '/status.mat']);

        if(isfield(sim_stat,'S1Conduction'))
            f=figure;
            for j=1:length(nodeOut)
                a=load(sprintf('%s/%s/base-S1/post/S1_prc0_%08d.var',pathToSave,K_str,nodeOut(j)));
                t(:,j)=a(:,1);
                V(:,j)=a(:,2);
            end

            plot(t,V)
            title('S1')
            saveas(f,[pathToSave '/' K_str '-S1.pdf'])
        end
    end
end
