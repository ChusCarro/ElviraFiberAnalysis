function createMainFile(pathToSave,title,duration,dt,load,save,step_restart)

f=fopen([pathToSave '/base/data/main_file_preStim.dat'],'w');

restart = false;
readRestart = false;
writeRestart = false;

if(~isempty(load))
  restart = true;
  readRestart = true;
end
if(~isempty(save))
  if(step_restart>0)
    restart = true;
    writeRestart = true;
  end
end

fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'#TITLE\n');
fprintf(f,[title '\n']);
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'#ANALYSISTYPE\n');
fprintf(f,'1\n');
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'#MATERIAL, FILE:"file_material.dat"\n');
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'#PROP_NOD, FILE:"file_prop_nod.dat"\n');
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'#PROP_ELEM, FILE:"file_prop_elem.dat"\n');
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'#NODES, FILE:"file_nodes.dat"\n');
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'#ELEMENTS, FILE:"file_elements.dat"\n');
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'#STEP\n');
fprintf(f,'Single stimulation\n');
fprintf(f,'!------------------------------------------------------\n');
if(restart)
  fprintf(f,['*RESTART, ' num2str(2+readRestart+writeRestart)])
  if(writeRestart)
    fprintf(f,[', FILE_R:"' load '"']);
  end
  if(writeRestart)
    fprintf(f,[', FILE_W:"' save '"\n']);
    fprintf(f,num2str(step_restart));
  fprintf(f,'\n!------------------------------------------------------\n');
end
fprintf(f,'*PARAM_NODE, FILE:"file_param_node.dat"\n');
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'*INTEG_SCH\n');
fprintf(f,'3\n');
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'*SOLVER\n');
fprintf(f,'1\n');
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'*TIME_INC\n');
fprintf(f,[num2str(dt) ' ' num2str(dt) ' ' num2str(duration) ' ' num2str(dt) ' 0\n']);
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'*STIMULUS, FILE:"file_stimulus.dat"\n');
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'*NODEOUTPUT, FILE:"file_node_output.dat"\n');
fprintf(f,'*G_OUTPUT\n');
fprintf(f,'1\n');
fprintf(f,'2 500\n');
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'#ENDSTEP\n');
fprintf(f,'#ENDPROBLEM\n');
fprintf(f,'\n');

fclose(f);
