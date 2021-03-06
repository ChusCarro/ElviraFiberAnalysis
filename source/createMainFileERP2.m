function createMainFileERP2(pathToSave,K_str,CI,CI_str,dt)

f=fopen([pathToSave '/' K_str '/' CI_str '/data/main_file_ERP2.dat'],'w');

fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'#TITLE\n');
fprintf(f,'1D cable without coupling\n');
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
fprintf(f,['*RESTART, 0, FILE_R:"restartS1_' num2str(11000/dt) '_prc_"\n']);
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'*PARAM_NODE, FILE:"file_param_node.dat"\n');
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'*INTEG_SCH\n');
fprintf(f,'3\n');
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'*SOLVER\n');
fprintf(f,'1\n');
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'*TIME_INC\n');
fprintf(f,[num2str(dt) ' ' num2str(dt) ' ' num2str(1000+CI) ' ' num2str(dt) ' ' num2str(dt) '\n']);
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'*STIMULUS, FILE:"file_stimulus_ERP.dat"\n');
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'*NODEOUTPUT, FILE:"file_node_output.dat"\n');
fprintf(f,'*G_OUTPUT\n');
fprintf(f,'1\n');
fprintf(f,'2    4500000\n');
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'#ENDSTEP\n');
fprintf(f,'#ENDPROBLEM\n');
fprintf(f,'\n');

fclose(f);
