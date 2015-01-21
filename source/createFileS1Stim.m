function createFileS1Stim(Model, K_str, Istim)

f=fopen([Model '/' K_str '/base/data/file_stimulus_S1.dat'],'w');
fprintf(f,'1\n');
fprintf(f,'  1 11');
for i=0:1000:10000
	fprintf(f,[' '  num2str(i) ' 1.0 ' num2str(Istim)]);
end
fprintf(f,'\n');
fprintf(f,'1 0\n');
fprintf(f,'  1 1\n');

fclose(f);




