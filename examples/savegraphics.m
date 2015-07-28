function savegraphics(f,name,varargin)

if(length(varargin)<2)
  x = 7;
  y = 3.8;
else
  x = varargin{1};
  y = varargin{2};
end

figure_margin = 0.1;
figure_print = [0 0 x y]+figure_margin;
paper_size = figure_print(3:4)+figure_margin;

set(f,'PaperPosition',figure_print)
set(f,'PaperSize',paper_size)

saveas(f,[name '.jpeg'])
saveas(f,[name '.pdf'])
