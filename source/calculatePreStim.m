function [state, new_pre_dur] = calculatePreStim(pathToSave, K, h_index, j_index, fun_sodium,pre_dur, pre_step, dt, nodeOut, project)

if(isempty(dir([pathToSave '/base/data/restartPreStim_prc_0.bin'])))

  createFileStimulus([pathToSave '/base'],0,1,0);

  createMainFile([pathToSave '/base'],'main_file_preStim',...
                 project,...
                 ['Prestimulation to stabilize state variables with K = ' num2str(K) 'mM'] ,...
                 pre_dur,dt,[],'restartPreStim',pre_step)
  disp('Main file created')

  [s]=rmdir([pathToSave '/base-preStim'],'s');
  initialPath = cd([pathToSave '/base']);

  delete('data/restart_*_prc_0.bin');
  delete('post/*');

  ! ./runelv 1 data/main_file_preStim.dat post/preStim_
  cd ..
  copyfile('base','base-preStim')
  delete('base/*.*')
  delete('base/post/*')

  a=load(sprintf('base-preStim/post/preStim_prc0_%08d.var',nodeOut((end+1)/2)));
  V=a(:,2);
  step_save = a(2,1)-a(1,1);
  h=a(:,h_index);
  j=a(:,j_index);
  gates_stat = fun_sodium(V);
  err = abs((h.*j-gates_stat)./gates_stat)*100;
  [max_err,ind_err]=max(err);
  steps_pre = find(err(ind_err:end)<0.1,1,'first')+ind_err-1;
  if(isempty(steps_pre))
    state = false;
    new_pre_dur = pre_dur*2;
    cd(initialPath);
    return
  end
  restart_file_step =round(ceil(steps_pre*step_save/(pre_step/dt))*(pre_step/dt));
  cd([pathToSave '/base/data']);
  copyfile(['restartPreStim_' num2str(restart_file_step) '_prc_0.bin'],'restartPreStim_prc_0.bin');
  delete('restart_*_prc_0.bin');
  cd(initialPath);
end

state = true;
new_pre_dur = pre_dur;
