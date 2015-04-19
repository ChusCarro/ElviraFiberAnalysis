function plotCILimits(pathToSave,K,nodeOut)

close all;

for i=1:length(K)
    K_str = ['K_' num2str(K(i))]

    if(~isempty(dir([pathToSave '/' K_str '/status.mat'])))
        sim_stat = load([pathToSave '/' K_str '/status.mat']);

        if(isfield(sim_stat,'maxCI1'))
            minCI1=sim_stat.minCI1;
            maxCI1=sim_stat.maxCI1;
            f=figure;
            if(minCI1>0)
              CI_str = ['CI1_' num2str(minCI1)];
              for j=1:length(nodeOut)
                a=load(sprintf('%s/%s/%s/post/ERP1_prc0_%08d.var',pathToSave,K_str,CI_str,nodeOut(j)));
                %if(K(i)==8)
                %    keyboard;
                %end     
                t(:,j)=a(:,1);
                V(:,j)=a(:,2);
              end

              subplot(2,1,1)
              plot(t,V)
              title(['CI1 = ' num2str(minCI1)])
              clear t V;
            end
        
            if(maxCI1<1000)
              CI_str = ['CI1_' num2str(maxCI1)];
              for j=1:length(nodeOut)
                a=load(sprintf('%s/%s/%s/post/ERP1_prc0_%08d.var',pathToSave,K_str,CI_str,nodeOut(j)));
                t(:,j)=a(:,1);
                V(:,j)=a(:,2);
              end
              subplot(2,1,2)
              plot(t,V)

              title(['CI1 = ' num2str(maxCI1)])
              clear t V;
            end
            saveas(f,[pathToSave '/' K_str '-CI1.pdf'])
        end
            
        if(isfield(sim_stat,'maxCI2'))
            minCI2=sim_stat.minCI2;
            maxCI2=sim_stat.maxCI2;
            
            if(minCI2==1000 || maxCI2==1000)
                continue;
            end

            f=figure;
            if(minCI2>0)
              CI_str = ['CI2_' num2str(minCI2)];
            
              for j=1:length(nodeOut)
                a=load(sprintf('%s/%s/%s/post/ERP2_prc0_%08d.var',pathToSave,K_str,CI_str,nodeOut(j)));
                t(:,j)=a(:,1);
                V(:,j)=a(:,2);
              end

              subplot(2,1,1)
              plot(t,V)
              title(['CI2 = ' num2str(minCI2)])
              clear t V;
            end

            if(maxCI2<1000)
              CI_str = ['CI2_' num2str(maxCI2)];
              for j=1:length(nodeOut)
                a=load(sprintf('%s/%s/%s/post/ERP2_prc0_%08d.var',pathToSave,K_str,CI_str,nodeOut(j)));
                t(:,j)=a(:,1);
                V(:,j)=a(:,2);
              end

              subplot(2,1,2)
              plot(t,V)
              title(['CI2 = ' num2str(maxCI2)])
              clear t V;
            end
            saveas(f,[pathToSave '/' K_str '-CI2.pdf'])
        end
    end
end
