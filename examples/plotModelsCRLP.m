addpath([pwd() '/../source'])

pathToSave = '~/FiberResults/';

K=[4:0.1:11];

a=dir('~/FiberResults/CRLP_H*');
for i=1:length(a)
  models{i}=a(i).name
end

colors = 'bgrky';

figures = [];
for i=1:length(models)
  figures = plotStatus([pathToSave '/' models{i}],K,colors(i),figures);
end

for i=1:length(figures)
  figure(figures(i))
  legend(models,'Location','BestOutside')
end

saveas(figures(1),[pathToSave '/CRLP_APD.pdf'])
saveas(figures(2),[pathToSave '/CRLP_CV.pdf'])
saveas(figures(3),[pathToSave '/CRLP_ERP.pdf'])
saveas(figures(4),[pathToSave '/CRLP_IThreshold.pdf'])
