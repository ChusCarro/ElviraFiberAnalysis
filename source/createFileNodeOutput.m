function createFileNodeOutput(Model,step_save)

f=fopen([Model '/base/data/file_node_output.dat'],'w');
fprintf(f,['5  ' num2str(step_save) '\n']);
fprintf(f,'   151 176 201 226 251\n');
fclose(f);  

