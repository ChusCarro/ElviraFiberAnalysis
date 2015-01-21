function createFileERPStim(Model, K_str, Istim, CI, CI_str)

f=fopen([Model '/' K_str '/' CI_str '/data/file_stimulus_ERP.dat'],'w');
fprintf(f,'1\n');
fprintf(f,'1 2\n');
fprintf(f,['    0.0 1.0 ' num2str(Istim) ' ' num2str(CI) ' 1.0 ' num2str(Istim) '\n']);
fprintf(f,'    1 0\n');
fprintf(f,' 1 1\n');

fclose(f);




