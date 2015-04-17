function createFileParamNode(pathToSave,K,K_index,K_control,nNodes,dx,HZ,BZ,IZ)

f=fopen([pathToSave '/data/file_param_node.dat'],'w');

fprintf(f,[num2str(nNodes) '\n']);
for i=1:nNodes
    position = (i-1)*dx;
    if(position>HZ)
      if(position>HZ+BZ)
          K_value = K;
      else
          K_value = (K-K_control)*(position-HZ)/BZ+K_control;
      end
      fprintf(f,[' ' num2str(i) ' 1 ' num2str(K_index) ' ' num2str(K_value) '\n']);
    end
end
fclose(f);

disp('File file_param_node.dat created')

