close all;
clear all;
clc;

addpath([pwd() '/../source'])
pathToSave = '~/FiberResults';%/CriterioV0';


disp(['Plotting results from: ' pathToSave])

K=[4:0.1:10];

models = {'TP06','GPB','CRLP','This work without [K^+]_i dynamics','This work with [K^+]_i dynamics'};
directories = {'TP06_H2_B0.5_I2','GPB_H2_B0.5_I2','CRLP_H2_B0.5_I2','CRLP_v2_H2_B0.5_I2','CRLP_v3_H2_B0.5_I2'};
colors = 'bygrk';

disp(' - Models:')
for i=1:length(models)
  disp(['   * ' models{i} ' (' directories{i} ')'])
end

disp(' ')

figures=[];
for i=1:length(directories)
  disp(['Plotting model ' models{i} '...'])
  figures = plotStatus([pathToSave '/' directories{i}],K,colors(i),figures,i,length(models));
  plotStatus([pathToSave '/' directories{i}],K);
end

disp(' ')
disp('Adding legends...')
for i=1:length(figures)-1
  figure(figures(i))
  l = legend(models,'Location','BestOutside');
  set(l,'Box','off')
  xlim([min(K) max(K)])
end

figure(figures(5))
for i=1:length(models)
  s=subplot(length(models),1,i);
  title(models{i})
  xlim([min(K) max(K)])
  ylim([0 1])
  if(i<length(models))
    xlabel('')
    set(s,'XTickLabel',[])
  end
  set(s,'YTick',[0 1])
  set(s,'YTickLabel',[' NO';'YES'])
end

disp(' ')
disp('Saving pdf files...')
savegraphics(figures(1),[pathToSave '/APD'])
savegraphics(figures(2),[pathToSave '/CV'])
savegraphics(figures(3),[pathToSave '/ERP'])
savegraphics(figures(4),[pathToSave '/IThreshold'])
savegraphics(figures(5),[pathToSave '/Conduction'])

disp(['Files saved at ' pathToSave])
