%Tower of London first level


clear all;
spm('Defaults','fMRI');
spm_jobman('initcfg');

%spm_get_defaults('cmdline',true);
mainfolder='/Users/raz18eku/Documents/MATLAB/Data';

taskfolders={'toweroflondon'};
taskname={'_TowerofLondon'};
%taskfolders={'taskswitching';'toweroflondon'};

subjs={ '122'; '123'};%These are letter strings (not numbers). Make sure they are all the same legnth(3 digits)
%subjs=['006';'007'];

for n=1:size(subjs,1)

data_path=strcat(mainfolder,'/sub-',subjs(n,:),'/funct/',taskfolders);
regressor_ToL_name=strcat(data_path,'/sub-',subjs(n,:),taskname,'.csv');
regressor_ToL=string(regressor_ToL_name);
data=csvread(regressor_ToL);
t0=data(1,9);

%control trials
contrials=find(data(:,1)==0);
onset_con=data(contrials,4)-t0;
dur_con=data(contrials,5)- data(contrials,4);

%tol trials
toltrials=find(data(:,1));
onset_tol=data(toltrials,4)-t0;
dur_tol=data(toltrials,5) - data(toltrials,4);

%left response
lefthand=find(data(:,6)==4);
onset_lh=data(lefthand,5)-t0;

%right hand response
righthand=find(data(:,6)==9);
onset_rh=data(righthand,5)-t0;


funct= spm_select ('FPList', data_path, '^sw.*\.nii$') ;
motionfile=spm_select ('FPList', data_path, '^r.*\.txt$');

matlabbatch{1}.spm.stats.fmri_spec.sess.scans = cellstr(funct);
matlabbatch{1}.spm.stats.fmri_spec.dir = data_path;
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 3;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 50;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 25;

%-------control
%con = struct([]);
c=1;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = 'Control trials';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = onset_con;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = dur_con;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).orth = 1;

%--------ToL
c=c+1;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name = 'ToL trials';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset = onset_tol;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = dur_tol;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).orth = 1;



%--------Left hand

c=c+1;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).name = 'Left hand';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).onset = onset_lh;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).duration = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).orth = 1;


%--------Right hand

c=c+1;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).name = 'Right hand';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).onset = onset_rh;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).duration = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).orth = 1;

%----------Motion File


matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {motionfile};
matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

%-----estimate
SPMfile=strcat (data_path, '/SPM.mat');
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cellstr(SPMfile);
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
%------ToL > Control

matlabbatch{3}.spm.stats.con.spmmat = cellstr(SPMfile);
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'ToL > Control';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [-1 1 0 0];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

%------Left hand > Right hand

matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Left hand > Right hand';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0 0 1 -1];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';


%------Control > ToL

matlabbatch{3}.spm.stats.con.spmmat = cellstr(SPMfile);
matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = ' Control > ToL';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [1 -1 0 0];
matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';

%------Right hand > Left hand 

matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'Right hand > Left hand';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = [0 0 -1 1];
matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;

% spm_contrasts(SPMfile,1:ind-1);

disp(strcat('Running Tower of London first level analysis participant... ',subjs(n,:)))

spm_jobman('run',matlabbatch);
disp(strcat('Done Tower of London first level analysis participant... ',subjs(n,:)))
disp('')

clear matlabbatch funct

end

disp('The end')