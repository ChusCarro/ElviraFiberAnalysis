function createFilePropNod(Model, cellType)

f=fopen([Model '/base/data/file_prop_nod.dat'],'w');

fprintf(f,'1\n');
fprintf(f,['1 1 1 0 ' num2str(cellType) '\n']);

fclose(f);

