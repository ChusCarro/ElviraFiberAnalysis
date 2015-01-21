function createFileParamNode(Model,K,K_index,K_str)

f=fopen([Model '/' K_str '/base/data/file_param_node.dat'],'w');

fprintf(f,'401\n');
for i=1:401
    fprintf(f,[' ' num2str(i) ' 1 ' num2str(K_index) ' ' num2str(K) '\n']);
end

fclose(f);