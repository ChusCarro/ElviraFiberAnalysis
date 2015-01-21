function [state, new_pre_dur] = calculatePreStim(Model, K_str, h_index, j_index, fun_sodium,pre_dur, pre_step, dt)

    if(isempty(dir([Model '/' K_str '/base/data/restartPreStim_prc_0.bin'])))

        createMainFilePreStim([Model '/' K_str],pre_dur,pre_step,dt)

        [s]=rmdir([Model '/' K_str '/base-preStim'],'s');
        cd([Model '/' K_str '/base'])

        delete('data/restart_*_prc_0.bin');
        delete('post/*');

        ! ./runelv 1 data/main_file_preStim.dat post/preStim_
        cd ..
        copyfile('base','base-preStim')
        delete('base/*.*')
        delete('base/post/*')
        a=load('base-preStim/post/preStim_00000201.var');
        cd ../..

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
            return
        end
        restart_file_step =round(ceil(steps_pre*step_save/(pre_step/dt))*(pre_step/dt));
        cd([Model '/' K_str '/base/data'])
        copyfile(['restart_' num2str(restart_file_step) '_prc_0.bin'],'restartPreStim_prc_0.bin');
        delete('restart_*_prc_0.bin');
        cd ../../../..
    end

    state = true;
    new_pre_dur = pre_dur;