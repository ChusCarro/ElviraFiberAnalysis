function createFileParamNode(pathToSave,K,K_index,nNodes)

f=fopen([pathToSave '/data/file_param_node.dat'],'w');

fprintf(f,'!----------- FILE PARAM NODE --------------------------\n');

fprintf(f,[num2str(nNodes) '\n']);
for i=1:nNodes
    fprintf(f,[' ' num2str(i) ' 1 ' num2str(K_index) ' ' num2str(K) '\n']);
end

fclose(f);
