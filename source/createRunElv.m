function createRunElv(Model)

f = fopen([Model '/base/runelv'],'w');

fprintf(f,'# $1 number of processes\n');
fprintf(f,'# $2 input data file with full path\n');
fprintf(f,'# $3 output identifier with full path of output directory\n');
%fprintf(f,['# nohup mpirun -np $1 ~/Software/Elvira/' Model '/fem_mpi/bin/mainelv -i $2 -o $3 </dev/null 2>&1 &\n']);
%fprintf(f,['nohup mpirun -np $1 ~/Software/Elvira/' Model '/fem_mpi/bin/mainelv -i $2 -o $3 </dev/null 2>&1\n']);
fprintf(f,['nohup mpirun -np $1 ~/Software/Elvira/' Model '/bin/mainelv_openmpi_intel -i $2 -o $3 </dev/null 2>&1\n']);

fclose(f);
    
