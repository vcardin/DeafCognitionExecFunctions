% Deaf Cognition
%Executive Functions August 15, 2018
%Happy Ferragosto to me!!
clear all;
spm('Defaults','fMRI');
spm_jobman('initcfg');

mainfolder='/Users/deafneuralplasticitylab/Documents/MATLAB/Data';
taskfolder_WM= {'workingmemory'};
taskfolder_ToL={'toweroflondon'};
taskfolder_TS={'taskswitching'};
taskfolder_ST={'simontask'};

dir=strcat(mainfolder,'/Executive_Function_First_Lev/'); 
directory=mkdir(dir); 

%dir=strcat(mainfolder,'/Executive_Function_First_Lev/s',subjs(n,:));
%

%taskfolders={ 'workingmemory';'toweroflondon'; 'taskswitching'; 'simontask_run1'; 'simontask_run2'};
% taskfolders={ 'workingmemory'}
% taskname= {'_WorkingMemory'; }
% taskname= {'_WorkingMemory'; '_TowerofLondon'; '_TaskSwitch';'_Simon'};
%subjs={'131';'134';'136'; '007'; '008'; '101';'102';'108'};
%subjs={'017';'023';'031';'032';'041'};
%subjs={'110';'116';'118';'119';'122';'123';'124';'127'}
subjs={'021'};

for n=1:size(subjs,1)
%     dir=strcat(mainfolder,'/Executive_Function_First_Lev/s'); 
%     directory=mkdir(dir); 
    directory_sub=strcat(dir,'sub-', subjs(n,:));
    dir2=char(directory_sub);
    %directory2=mkdir(dir2); 
    %% %%      WORKING MEMORY REGRESSORS
    for t=1:size(taskfolder_WM,1)
        datafolder_WM=strcat(mainfolder,'/sub-',subjs(n,:),'/funct/',taskfolder_WM{t}); %functional data
          
        regressor_WM_name=strcat(mainfolder,'/sub-',subjs(n,:),'/funct/','workingmemory','/sub-',subjs(n,:),'_WorkingMemory','.csv');
        regressor_WM=char(regressor_WM_name);
        data=csvread(regressor_WM);
        t0=data(1,9);

        %control trials
        contrials=find(data(:,1)==0);
        onset_con_WM=data(contrials,4)-t0;
        dur_con_WM=data(contrials,5)- data(contrials,4);

        %wm trials
        wmtrials=find(data(:,1));
        onset_wm=data(wmtrials,4)-t0;
        dur_wm=data(wmtrials,5) - data(wmtrials,4);
            
        %left response
        lefthand_WM=find(data(:,6)==4);
        onset_lh_WM=data(lefthand_WM,5)-t0;

        %right hand response
        righthand_WM=find(data(:,6)==9);
        onset_rh_WM=data(righthand_WM,5)-t0;
        clear 'data' 't0'  'contrials'  
        
        
        
        funct_WM= spm_select ('FPList', datafolder_WM, '^sw.*\.nii$') ;
        motionfile_WM=spm_select ('FPList', datafolder_WM, '^r.*\.txt$');
%        
        c=1;
        d=1;
        
        matlabbatch{1}.spm.stats.fmri_spec.dir = directory_sub;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).scans = cellstr(funct_WM);
        matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
        matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 3;
        matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 50;%changed accordingly with slice time correction n of slice BM
        matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 25;%changed accordingly with slice time correction ref slice BM        
%         
%         %--------set control condition
  
% 
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).name = 'Control';
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).onset = onset_con_WM;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).duration = dur_con_WM;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).orth = 1;
% %
% %-------set WM condition
        c=c+1;
% % 
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).name = 'Working Memory';
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).onset = onset_wm;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).duration = dur_wm;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).orth = 1;
% % ---------set Left Hand answer
        c=c+1;
% 
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).name = 'Left hand';
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).onset = onset_lh_WM;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).duration = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).orth = 1;
% %
%---------set Right Hand answer
        c=c+1;
% 
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).name = 'Right Hand';
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).onset = onset_rh_WM;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).duration = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).orth = 1;
% 
% --------set multipme regressor rp file
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).multi = {''};
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).regress = struct('name', {}, 'val', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).multi_reg = cellstr(motionfile_WM);
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).hpf = 128;
        matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
        matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
        matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
        matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
        matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
        matlabbatch{1}.spm.stats.fmri_spec.mask = {'/Users/deafneuralplasticitylab/Documents/MATLAB/Data/mask_deaf_cogn.nii'};
        matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
    end
      %% %% TOWER OF LONDON REGRESSORS 
    for b=1:size(taskfolder_ToL,1)
%          
        datafolder_ToL=strcat(mainfolder,'/sub-',subjs(n,:),'/funct/',taskfolder_ToL);
        regressor_ToL_name=strcat(mainfolder,'/sub-',subjs(n,:),'/funct/','toweroflondon','/sub-',subjs(n,:),'_TowerofLondon','.csv');
          
        regressor_ToL=string(regressor_ToL_name);
        data=csvread(regressor_ToL);
        t0=data(1,9);
% 
%       %control trials
        contrials=find(data(:,1)==0);
        onset_con_ToL=data(contrials,4)-t0;
        dur_con_ToL=data(contrials,5)- data(contrials,4);
% 
%       %tol trials
        toltrials=find(data(:,1));
        onset_tol=data(toltrials,4)-t0;
        dur_tol=data(toltrials,5) - data(toltrials,4);
% 
%       %left response
        lefthand_ToL=find(data(:,6)==4);
        onset_lh_ToL=data(lefthand_ToL,5)-t0;
% 
%       %right hand response
        righthand_ToL=find(data(:,6)==9);
        onset_rh_ToL=data(righthand_ToL,5)-t0;
        
        
        funct_ToL= spm_select ('FPList', datafolder_ToL, '^sw.*\.nii$') ;
        motionfile_ToL=spm_select ('FPList', datafolder_ToL, '^r.*\.txt$');
                
        d=d+1;
%         
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).scans = cellstr(funct_ToL);
        %matlabbatch{1}.spm.stats.fmri_spec.dir = directory_sub;
        matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
        matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 3;
        matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 50;
        matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 25;
%       %-------control

        c=1;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).name = 'Control trials';
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).onset = onset_con_ToL;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).duration = dur_con_ToL;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).orth = 1;
% 
%         %--------ToL
        c=c+1;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).name = 'ToL trials';
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).onset = onset_tol;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).duration = dur_tol;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).orth = 1;
% 
%         %--------Left hand
% 
        c=c+1;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).name = 'Left hand';
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).onset = onset_lh_ToL;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).duration = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).orth = 1;
% 
% 
% %--------Right hand
% 
        c=c+1;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).name = 'Right hand';
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).onset = onset_rh_ToL;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).duration = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).orth = 1;
% 
% %----------Motion File
% 
% 
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).multi = {''};
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).regress = struct('name', {}, 'val', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).multi_reg = {motionfile_ToL};
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).hpf = 128;
        matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
        matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
        matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
        matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
        matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
        matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
        matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
%  
        clear 'data' 't0'  'contrials'
    end
     %% %% TASK SWITCHING REGRESSORS 
    for e=1:size(taskfolder_TS,1)
         
        datafolder_TS=strcat(mainfolder,'/sub-',subjs(n,:),'/funct/',taskfolder_TS);
        regressor_TS_name=strcat(mainfolder,'/sub-',subjs(n,:),'/funct/','taskswitching','/sub-',subjs(n,:),'_TaskSwitch','.csv');
        regressor_TS=string(regressor_TS_name);
         
        data=csvread(regressor_TS);
        t0=data(1,8);
          
        %cue stay
        % RTstaycue=find(data(:,7) & data(:,1)==0);
        staycue=find(data(:,2) & data(:,1)==0 );
        onset_sc=data(staycue,2)-t0;

        %cue switch
        switchcue=find(data(:,2) & data(:,1)==1);
        onset_swc=data(switchcue,2)-t0;

        %stay trials left
        stayL=find( data(:,1)==0 & data(:,5)==4 & data(:,7)); 
        onset_stl_vis=data(stayL,4)-t0;
        onset_stl=onset_stl_vis+data(stayL,7);

        %stay trials right
        stayR=find( data(:,1)==0 & data(:,5)==9 & data(:,7));
        onset_str_vis=data(stayR,4)-t0;
        onset_str=onset_str_vis+data(stayR,7);
        
        %stay trials right
        stayR=find( data(:,1)==0 & data(:,5)==9 & data(:,7));
        onset_str_vis=data(stayR,4)-t0;
        onset_str=onset_str_vis+data(stayR,7);
        
        %switch trials left 1st
        switchtrials=find( data(:,1) & data(:,5)==4 & data(:,2)& data(:,7));
        onset_swtl_first_vis=data(switchtrials,4)-t0;
        onset_swtl_first=onset_swtl_first_vis+data(switchtrials,7);
              
        clear switchtrials

        %switch trials left rest
        switchtrials=find(data(:,1) & data(:,5)==4 & data(:,2)==0 & data(:,7));
        onset_swtl_rest_vis=data(switchtrials,4)-t0;
        onset_swtl_rest=onset_swtl_rest_vis+data(switchtrials,7);

        %switch trials right 1st
        switchR=find( data(:,1) & data(:,5)==9 & data(:,2) & data(:,7));
        onset_swtr_first_vis=data(switchR,4)-t0;
        onset_swtr_first=onset_swtr_first_vis+data(switchR,7);

        clear switchR

        %switch trials right rest
        switchR=find( data(:,1) & data(:,5)==9 & data(:,2)==0 & data(:,7));
        onset_swtr_rest_vis=data(switchR,4)-t0;
        onset_swtr_rest=onset_swtr_rest_vis+data(switchR,7);
        
        clear 'data' 't0'  
        
        funct_TS= spm_select ('FPList', datafolder_TS, '^sw.*\.nii$') ;
        motionfile_TS=spm_select ('FPList', datafolder_TS, '^r.*\.txt$');
        d=d+1;
        %matlabbatch{1}.spm.stats.fmri_spec.dir = directory_sub;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).scans = cellstr(funct_TS);
        matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
        matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 3;
        matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 50;
        matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 25;

        %----switch_left_1
       
        c=c+1;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).name = 'switch_left_1';
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).onset = onset_swtl_first;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).duration = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).orth = 1;
        
        %------switch_right_1
        c=c+1;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).name = 'switch_right_1';
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).onset = onset_swtr_first;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).duration = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).orth = 1;
%------------switch_left_rest
        c=c+1;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).name = 'switch_left_rest';
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).onset = onset_swtl_rest;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).duration = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).orth = 1;
%------------switch_right_rest
        c=c+1;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).name = 'switch_right_rest';
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).onset = onset_swtr_rest;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).duration = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).orth = 1;
%-----------stay_left
        c=c+1;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).name = 'stay_left';
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).onset = onset_stl;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).duration = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).orth = 1;
%------stay_right
        c=c+1;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).name = 'stay_right';
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).onset = onset_str;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).duration = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).orth = 1;
%-------switchcue
        c=c+1;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).name = 'switchcue';
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).onset = onset_swc;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).duration = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).orth = 1;
%--------------staycue
        c=c+1;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).name = 'staycue';
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).onset = onset_sc;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).duration = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).orth = 1;

%----------motion file

        matlabbatch{1}.spm.stats.fmri_spec.sess(d).multi = {''};
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).regress = struct('name', {}, 'val', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).multi_reg = {motionfile_TS};
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).hpf = 128;
        matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
        matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
        matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
        matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
        matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
        matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
        matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
    end
     
     %% %% SIMON TASK RUN 1 & 2
    for f=1:size(taskfolder_ST,1)
        datafolder_ST_1=strcat(mainfolder,'/sub-',subjs(n,:),'/funct/',taskfolder_ST,'_run1');
        datafolder_ST_2=strcat(mainfolder,'/sub-',subjs(n,:),'/funct/',taskfolder_ST,'_run2');
    
        regressor_Simon_name=strcat(datafolder_ST_1,'/sub-',subjs(n,:),'_Simon','.csv');
        regressor_Simon_name2=strcat(datafolder_ST_2,'/sub-',subjs(n,:),'_Simon','.csv');
        regressor_Simon=char(regressor_Simon_name);
        regressor_Simon2=char(regressor_Simon_name2);
    
        data=csvread(regressor_Simon);
        data2=csvread(regressor_Simon2);
    
        t0=data(1,9);
        t02=data2(1,9);

        %%right visual field
        %run 1
        rvlhi=find(data(:,1)==0 & data(:,5)==4 & data(:,6)==1);
        rvrhc=find(data(:,1)==0 & data(:,5)==9 & data(:,6)==1);
        %run 2
        rvlhi2=find(data2(:,1)==0 & data2(:,5)==4 & data2(:,6)==1);
        rvrhc2=find(data2(:,1)==0 & data2(:,5)==9 & data2(:,6)==1);
        %left visual field
        %run 1
        lvrhi=find(data(:,1)==1 & data(:,5)==9 & data(:,6)==1);
        lvlhc=find(data(:,1)==1 & data(:,5)==4 & data(:,6)==1);
         %run 1
        lvrhi2=find(data2(:,1)==1 & data2(:,5)==9 & data2(:,6)==1);
        lvlhc2=find(data2(:,1)==1 & data2(:,5)==4 & data2(:,6)==1);
        % run 1
        onset_rvlhi_vis=data(rvlhi,4)-t0;%left hand incongruent
        onset_rvlhi=onset_rvlhi_vis + data(rvlhi,7);
        onset_rvrhc_vis=data(rvrhc,4)-t0;%right hand congruent
        onset_rvrhc=onset_rvrhc_vis + data(rvrhc,7);
        onset_lvrhi_vis=data(lvrhi,4)-t0;%right incongruent
        onset_lvrhi=onset_lvrhi_vis + data(lvrhi,7);
        onset_lvlhc_vis=data(lvlhc,4)-t0;%left congruent
        onset_lvlhc=onset_lvlhc_vis + data(lvlhc,7);
        % run 2
        onset_rvlhi_vis2=data2(rvlhi2,4)-t02;%left hand incongruent
        onset_rvlhi2=onset_rvlhi_vis2 + data2(rvlhi2,7);
        onset_rvrhc_vis2=data2(rvrhc2,4)-t02;%right hand congruent
        onset_rvrhc2=onset_rvrhc_vis2 + data2(rvrhc2,7);
        onset_lvrhi_vis2=data2(lvrhi2,4)-t02;%right incongruent
        onset_lvrhi2=onset_lvrhi_vis2 + data2(lvrhi2,7);
        onset_lvlhc_vis2=data2(lvlhc2,4)-t02;%left congruent
        onset_lvlhc2=onset_lvlhc_vis2 + data2(lvlhc2,7);    
        
        funct_ST_1= spm_select ('FPList', datafolder_ST_1, '^sw.*\.nii$') ;
        motionfile_ST_1=spm_select ('FPList', datafolder_ST_1, '^r.*\.txt$');
        
        d=d+1;
        
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).scans = cellstr(funct_ST_1);
        %matlabbatch{1}.spm.stats.fmri_spec.dir = directory_sub;
        matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
        matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 3;
        matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 50;
        matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 25;
%    
        c=1;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).name = 'RVLHI';
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).onset = onset_rvlhi;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).duration = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).orth = 1;
%     
        c=c+1;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).name = 'LVRHI';
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).onset = onset_lvrhi;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).duration = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).orth = 1;
%     
        c=c+1;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).name = 'LVLHC';
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).onset = onset_lvlhc;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).duration = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).orth = 1;
%     
        c=c+1;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).name = 'RVRHC';
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).onset = onset_rvrhc;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).duration = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).orth = 1;
     
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).multi = {''};
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).regress = struct('name', {}, 'val', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).multi_reg = {motionfile_ST_1};
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).hpf = 128;
        matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
        matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
        matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
        matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
        matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
        matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
        matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
         
        funct_ST_2= spm_select ('FPList', datafolder_ST_2, '^sw.*\.nii$') ;
        motionfile_ST_2=spm_select ('FPList', datafolder_ST_2, '^r.*\.txt$');
        
        d=d+1; 
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).scans = cellstr(funct_ST_2);
        matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
        matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 3;
        matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 50;
        matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 25;
        
        c=1;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).name = 'RVLHI';
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).onset = onset_rvlhi2;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).duration = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).orth = 1;

        c=c+1;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).name = 'LVRHI';
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).onset = onset_lvrhi2;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).duration = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).orth = 1;
%     
        c=c+1;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).name = 'LVLHC';
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).onset = onset_lvlhc2;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).duration = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).orth = 1;
%     
        c=c+1;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).name = 'RVRHC';
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).onset = onset_rvrhc2;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).duration = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).cond(c).orth = 1;

        matlabbatch{1}.spm.stats.fmri_spec.sess(d).multi = {''};
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).regress = struct('name', {}, 'val', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).multi_reg = {motionfile_ST_2};
        matlabbatch{1}.spm.stats.fmri_spec.sess(d).hpf = 128;
        matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
        matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
        matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
        matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
        matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
        matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
        matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
        clear 'data' 't0'  'data2' 't02'
    end
    
        SPMfile=strcat(directory_sub, '/SPM.mat');
        
        matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cellstr(SPMfile);
        matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
        matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    
        % %     % ----Executive Function vs Control
        matlabbatch{3}.spm.stats.con.spmmat = cellstr(SPMfile);
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Executive Function vs Control';
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [-1 1 0 0 0 0 0 0 0 0    -1 1 0 0 0 0 0 0 0 0    1 1 0 0 -1 -1 0 0 0 0 0 0 0 0    1 1 -1 -1 0 0 0 0 0 0  1 1 -1 -1 0 0 0 0 0 0 ] ;
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
%       %------Congruent > incongruent
        matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = ' Control vs Executive Function';
        matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [1 -1 0 0 0 0 0 0 0 0    1 -1 0 0 0 0 0 0 0 0    -1 -1 0 0 1 1 0 0 0 0 0 0 0 0   -1 -1 1 1 0 0 0 0 0 0 -1 -1 1 1 0 0 0 0 0 0 ]            
        matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    
       spm_jobman('run',matlabbatch);
    
end 
 

%  

%         
        
disp('THE END')