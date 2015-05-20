function figures=plotStatus(pathToSave,K,color,figures)

if(nargin<3)
  color = 'b';
end
if(nargin<4 || length(figures)<5)
  for i=1:5
    figures(i)=figure;
  end
end


%close all;

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
    K_str = ['K_' num2str(K(i))];

    if(~isempty(dir([pathToSave '/' K_str '/status.mat'])))
        K_plot=[K_plot K(i)];
        sim_stat = load([pathToSave '/' K_str '/status.mat']);

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

        if(isfield(sim_stat,'ERP1') & ~isempty(sim_stat.ERP1))
            ERP1_plot = [ERP1_plot sim_stat.ERP1];
        else
            ERP1_plot = [ERP1_plot NaN];
        end
        if(isfield(sim_stat,'ERP2') & ~isempty(sim_stat.ERP2))
            ERP2_plot = [ERP2_plot sim_stat.ERP2];
        else
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
f=figure(figures(1));
hold on
plot([K_plot NaN K_plot],[APD1_plot NaN APD2_plot],['-' color '.'])%,'linewidth',1,'MarkerSize',8)
title('Action Potential Duration')
xlabel('[K^+]_o (mM)')
ylabel('APD_{90} (ms)')
%xlim([min(K_plot) max(K_plot)])
%ylim([0 max([1 APD1_plot APD2_plot])*1.05])
if(nargout==0)
  saveas(f,[pathToSave '/APD_90.pdf'])
end

f=figure(figures(2));
hold on
plot([K_plot NaN K_plot],[CV1_plot NaN CV2_plot],['-' color '.'])%,'linewidth',1,'MarkerSize',8)
title('Conduction Velocity')
xlabel('[K^+]_o (mM)')
ylabel('CV (cm/s)')
%xlim([min(K_plot) max(K_plot)])
%ylim([0 max([1 CV1_plot CV2_plot])*1.05])
if(nargout==0)
  saveas(f,[pathToSave '/CV.pdf'])
end

f=figure(figures(3));
hold on
plot([K_plot NaN K_plot],[ERP1_plot NaN ERP2_plot],['-' color '.'])%,'linewidth',1,'MarkerSize',8)
title('Effective Refractory Period')
xlabel('[K^+]_o (mM)')
ylabel('ERP (ms)')
%xlim([min(K_plot) max(K_plot)])
%ylim([0 max([1 ERP1_plot ERP2_plot])*1.05])
if(nargout==0)
  saveas(f,[pathToSave '/ERP.pdf'])
end

f=figure(figures(4));
hold on
plot(K_plot,IThreshold_plot,['-' color '.'])%,'linewidth',1,'MarkerSize',8)
title('I_{Threshold}')
xlabel('[K^+]_o (mM)')
ylabel('I_{Threshold} (pA/pF)')
%xlim([min(K_plot) max(K_plot)])
%ylim([0 max([1 IThreshold_plot])*1.05])
if(nargout==0)
  saveas(f,[pathToSave '/IThreshold.pdf'])
end

f=figure(figures(5));
hold
stem(K_plot,Conduction_plot.*S1Conduction_plot,color)
title('Conduction')
xlabel('[K^+]_o (mM)')
%xlim([K_plot(1) K_plot(end)])
%ylim([0 1])
if(nargout==0)
  saveas(f,[pathToSave '/Conduction.pdf'])
end
