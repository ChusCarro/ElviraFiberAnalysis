function plotS1(pathToSave,CL,K,nodeOut)

close all;
K
for i=1:length(K)
    K_str = ['K_' num2str(K(i))]

    if(~isempty(dir([pathToSave '/' K_str '/status.mat'])))
        sim_stat = load([pathToSave '/' K_str '/status.mat']);

        if(isfield(sim_stat,'S1Conduction'))
            f=figure;
            for j=1:length(nodeOut)
                a=load(sprintf('%s/%s/base-S1/post/S1_prc0_%08d.var',pathToSave,K_str,nodeOut(j)));
                dt = a(2,1)-a(1,1);
                t(:,j)=a(end-round(CL*2/dt):end,1);
                V(:,j)=a(end-round(CL*2/dt):end,2);
            end

            plot(t,V)
            title('S1')
            saveas(f,[pathToSave '/' K_str '-S1.pdf'])
        end
    end
end
