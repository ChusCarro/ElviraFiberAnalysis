addpath([pwd() '/../source'])

pathToSave = '~/FiberResults/';

K=[4:0.1:11];

models = {'TP06','CRLP','This work without [K^+]_i dynamics','This work with [K^+]_i dynamics'};

figures = plotStatus([pathToSave '/TP06_H2_B0.5_I1.5'],K)
figures = plotStatus([pathToSave '/CRLP_H2_B0.5_I1.5'],K,'g',figures)
figures = plotStatus([pathToSave '/CRLP_v2_H2_B0.5_I1.5'],K,'r',figures)
figures = plotStatus([pathToSave '/CRLP_v3_H2_B0.5_I1.5'],K,'k',figures)

for i=1:length(figures)
  figure(figures(i))
  l = legend(models,'Location','Best');
  set(l,'Box','off')
end

saveas(figures(1),[pathToSave '/APD.pdf'])
saveas(figures(2),[pathToSave '/CV.pdf'])
saveas(figures(3),[pathToSave '/ERP.pdf'])
saveas(figures(3),[pathToSave '/ERP.pdf'])
saveas(figures(4),[pathToSave '/IThreshold.pdf'])
