%Working Memory regressormakerLoop
clear all;
spm('Defaults','fMRI');
spm_jobman('initcfg');

mainfolder='/Users/b.manini/Documents/MATLAB/Data';

taskfolders={'workingmemory'};
taskname={'_WorkingMemory'};
%taskfolders={'taskswitching';'toweroflondon'};

%subjs=['003';'006';'007';'008';'013';'102';'104'];%These are letter strings (not numbers). Make sure they are all the same legnth(3 digits)
%subjs={ '131';'134';'136'; '014'; '028'; '042';'111';'129'};
%subjs={ '007'; '008'; '101';'102'; '108'};
%subjs={'017';'023';'031';'032';'041'};
%subjs={'110';'116';'118';'119';'122';'123';'124';'127'}
%'004'; '006';'007';'008';'011';'013'; '014'; '015'; '016'; '017';
%'018';'021';'023';'031';'032';'041'; '042'; '101';'103';'106'; '107';
%'108'; '110';'111'; '114'; '115'; '116'; '118';'119'; '122';'123';'124';'127'; '129'; '130';  '131'; '132'; '133';}
subjs={ '002'};

for n=1:size(subjs,1)

data_path=strcat(mainfolder,'/sub-',subjs(n,:),'/funct/',taskfolders);
regressor_WM_name=strcat(data_path,'/sub-',subjs(n,:),taskname,'.csv');
regressor_WM=string(regressor_WM_name);
data=csvread(regressor_WM);
t0=data(1,9);

%control trials
contrials=find(data(:,1)==0);
onset_con=data(contrials,4)-t0;
dur_con=data(contrials,5)- data(contrials,4);


%control trials
contrials=find(data(:,1)==0);
onset_con=data(contrials,4)-t0;
dur_con=data(contrials,5)- data(contrials,4);


%wm trials
wmtrials=find(data(:,1));
onset_wm=data(wmtrials,4)-t0;
dur_wm=data(wmtrials,5) - data(wmtrials,4);

%left response
lefthand=find(data(:,6)==4);
onset_lh=data(lefthand,5)-t0;

%right hand response
righthand=find(data(:,6)==9);
onset_rh=data(righthand,5)-t0;

funct= spm_select ('FPList', data_path, '^sw.*\.nii$') ;
motionfile=spm_select ('FPList', data_path, '^r.*\.txt$');

dir=strcat(mainfolder,'/WorkingMemory/s',subjs(n,:));
dir1=cell2mat(dir);  
directory=mkdir(dir1);
% 

matlabbatch{1}.spm.stats.fmri_spec.dir = dir;
matlabbatch{1}.spm.stats.fmri_spec.sess.scans = cellstr(funct);
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 3;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 50;%changed accordingly with slice time correction n of slice BM
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 25;%changed accordingly with slice time correction ref slice BM
% 
%--------set control condition
c=1;
                
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = 'Control';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = onset_con;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = dur_con;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).orth = 1;
%
%-------set WM condition
c=c+1;
% 
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name = 'Working Memory';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset = onset_wm;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = dur_wm;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).orth = 1;
% ---------set Left Hand answer
c=c+1;

matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).name = 'Left hand';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).onset = onset_lh;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).duration = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).orth = 1;
%
%---------set Right Hand answer
c=c+1;
% 
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).name = 'Right Hand';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).onset = onset_rh;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).duration = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).orth = 1;
% 
% --------set multipme regressor rp file
matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = cellstr(motionfile);
matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
% 

%-----estimate

SPMfile=strcat (dir, '/SPM.mat');
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cellstr(SPMfile);
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
 


matlabbatch{3}.spm.stats.con.spmmat = cellstr(SPMfile)
%---WM > control
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Working Memory vs Control';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [-1 1 0 0];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
%----Left > right
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Left hand vs Right hand';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0 0 1 -1];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
%-----Control > WM
matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Control > Working Memory';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [1 -1 0 0];
matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
%----Right > Left
matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'Right hand > Left hand';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = [0 0 -1 1];
matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;
%---WM 
matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 'Working Memory';
matlabbatch{3}.spm.stats.con.consess{5}.tcon.weights = [0 1 0 0];
matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
%----Control
matlabbatch{3}.spm.stats.con.consess{6}.tcon.name = 'Control';
matlabbatch{3}.spm.stats.con.consess{6}.tcon.weights = [1 0 0 0];
matlabbatch{3}.spm.stats.con.consess{6}.tcon.sessrep = 'none';

%----Left hand
matlabbatch{3}.spm.stats.con.consess{7}.tcon.name = 'Left hand';
matlabbatch{3}.spm.stats.con.consess{7}.tcon.weights = [0 0 1 0];
matlabbatch{3}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
 %----Right  hand
matlabbatch{3}.spm.stats.con.consess{8}.tcon.name = 'Right hand';
matlabbatch{3}.spm.stats.con.consess{8}.tcon.weights = [0 0 0 1];
matlabbatch{3}.spm.stats.con.consess{8}.tcon.sessrep = 'none';

% spm_contrasts(SPMfile,1:ind-1);

spm_jobman('run',matlabbatch);

disp(strcat('Running Working Memory first level analysis participant... ',subjs(n,:)))

% spm_jobman('run',matlabbatch);
disp(strcat('Done Working Memory first level analysis participant... ',subjs(n,:)))
disp('')

clear matlabbatch funct

end


disp('The end')