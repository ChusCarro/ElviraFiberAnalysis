function plotStatus(Model,K,K_dirFact)

close all;

if(isempty(K_dirFact))
    [N,D]=rat(K);
    K_dirFact = max(D);
end
digits = floor(log10(max(K*K_dirFact))+1);

K_plot=[];
APD1_plot=[];
APD2_plot=[];
CV1_plot=[];
CV2_plot=[];
ERP1_plot=[];
ERP2_plot=[];
IThreshold_plot=[];
S1Conduction_plot=[];
Conduction_plot=[];

for i=1:length(K)
    K_str = ['K_' num2str(round(K(i)*K_dirFact),['%0' num2str(digits) 'd'])];

    if(~isempty(dir([Model '/' K_str '/status.mat'])))
        K_plot=[K_plot K(i)];
        sim_stat = load([Model '/' K_str '/status.mat']);

        if(isfield(sim_stat,'APD1') & ~isempty(sim_stat.APD1) & ~isempty(sim_stat.APD2))
            APD1_plot = [APD1_plot min([sim_stat.APD1 sim_stat.APD2])];
            APD2_plot = [APD2_plot max([sim_stat.APD1 sim_stat.APD2])];
        else
            APD1_plot = [APD1_plot NaN];
            APD2_plot = [APD2_plot NaN];
        end

        if(isfield(sim_stat,'CV1') & ~isempty(sim_stat.CV1) & ~isempty(sim_stat.CV2))
            CV1_plot = [CV1_plot min([sim_stat.CV1 sim_stat.CV2])];
            CV2_plot = [CV2_plot max([sim_stat.CV1 sim_stat.CV2])];
        else
            CV1_plot = [CV1_plot NaN];
            CV2_plot = [CV2_plot NaN];
        end

        if(isfield(sim_stat,'ERP1') & ~isempty(sim_stat.ERP1) & ~isempty(sim_stat.ERP2))
            ERP1_plot = [ERP1_plot min([sim_stat.ERP1 sim_stat.ERP2])];
            ERP2_plot = [ERP2_plot max([sim_stat.ERP1 sim_stat.ERP2])];
        else
            ERP1_plot = [ERP1_plot NaN];
            ERP2_plot = [ERP2_plot NaN];
        end

        if(isfield(sim_stat,'IThreshold') & ~isempty(sim_stat.IThreshold))
            IThreshold_plot = [IThreshold_plot sim_stat.IThreshold];
        else
            IThreshold_plot = [IThreshold_plot NaN];
        end
          
        if(isfield(sim_stat,'S1Conduction'))
            S1Conduction_plot = [S1Conduction_plot sim_stat.S1Conduction];
        else
            S1Conduction_plot = [S1Conduction_plot NaN];
        end

        if(isfield(sim_stat,'conduction'))
            Conduction_plot = [Conduction_plot sim_stat.conduction];
        else
            Conduction_plot = [Conduction_plot NaN];
        end

    end
end

K_plot
f=figure;
plot(K_plot,APD1_plot,'-b.',K_plot,APD2_plot,'-b.','linewidth',1,'MarkerSize',8)
title('Action Potential Duration')
xlabel('[K^+]_o (mM)')
ylabel('APD_{90} (ms)')
xlim([min(K_plot) max(K_plot)])
ylim([0 max([1 APD1_plot APD2_plot])*1.05])
saveas(f,[Model '/APD_90.fig'])
saveas(f,[Model '/APD_90.pdf'])

f=figure;
plot(K_plot,CV1_plot,'-b.',K_plot,CV2_plot,'-b.','linewidth',1,'MarkerSize',8)
title('Conduction Velocity')
xlabel('[K^+]_o (mM)')
ylabel('CV (cm/s)')
xlim([min(K_plot) max(K_plot)])
ylim([0 max([1 CV1_plot CV2_plot])*1.05])
saveas(f,[Model '/CV.fig'])
saveas(f,[Model '/CV.pdf'])

f=figure;
plot(K_plot,ERP1_plot,'-b.',K_plot,ERP2_plot,'-b.','linewidth',1,'MarkerSize',8)
title('Effective Refractory Period')
xlabel('[K^+]_o (mM)')
ylabel('ERP (ms)')
xlim([min(K_plot) max(K_plot)])
ylim([0 max([1 ERP1_plot ERP2_plot])*1.05])
saveas(f,[Model '/ERP.fig'])
saveas(f,[Model '/ERP.pdf'])

f=figure;
plot(K_plot,IThreshold_plot,'-b.','linewidth',1,'MarkerSize',8)
title('I_{Threshold}')
xlabel('[K^+]_o (mM)')
ylabel('I_{Threshold} (pA/pF)')
xlim([min(K_plot) max(K_plot)])
ylim([0 max([1 IThreshold_plot])*1.05])
saveas(f,[Model '/IThreshold.fig'])
saveas(f,[Model '/IThreshold.pdf'])

f=figure;
plot(K_plot(1:end-1),diff(IThreshold_plot)./diff(K_plot),'-b.','linewidth',1,'MarkerSize',8)
title('I_{Threshold} slope')
xlabel('[K^+]_o (mM)')
ylabel('dI/dK')
xlim([K_plot(1) K_plot(end-1)])
ylim([min(diff(IThreshold_plot)./diff(K_plot)) max(diff(IThreshold_plot)./diff(K_plot))])
saveas(f,[Model '/dIThreshold.fig'])
saveas(f,[Model '/dIThreshold.pdf'])

f=figure;
stem(K_plot,Conduction_plot.*S1Conduction_plot)
title('Conduction')
xlabel('[K^+]_o (mM)')
xlim([K_plot(1) K_plot(end)])
ylim([0 1])
saveas(f,[Model '/Conduction.fig'])
saveas(f,[Model '/Conduction.pdf'])

