

%%DEAF COGNITION PRE-PROCESSING BATCH CODE September 15 2018
% Initialise SPM

% this script works for data in the following folder format:
% 
%  mainfolder
%            |___ sub-001
%                 sub-002
%                     .
%                     .
% %                   .
% %                 sub-n 
% %                       |____anat
%                              funct
%                                 |___ run task 1__ fmap
%                                      run task 2__ fmap
%                                            .
%                                            .
%                                            .
%                                      run task n__ fmap
%                                 
% %

%note: one fieldmap (fmap) folder in each functional run folder

%--------------------------------------------------------------------------
clear all;
spm('Defaults','fMRI');
spm_jobman('initcfg');



%spm_get_defaults('cmdline',true);

mainfolder='/Users/deafneuralplasticitylab/Documents/MATLAB/Data';
%mainfolder='/Users/velia/Documents/1_Work/DeafCognition/MRI/derivatives/func';

%taskfolders={'simontask_run1'; 'simontask_run2'};
taskfolders={'taskswitching';'toweroflondon'; 'workingmemory'};

subjs=['003'];%These are letter strings (not numbers). Make sure they are all the same legnth(3 digits)
%%
% % %% PART 1 
% % %Segmentation and normalization of the anatomica scan. All the functional
% % %data will be referred and normalized on the common anatomical scan. Do
% % %this process just once for each subject.
% % %Comment this loop if you only want to preprocess functional data.
% % % 
for n=1:size(subjs,1)
    
datafolder_anat=strcat(mainfolder,'/sub-',subjs(n,:),'/anat'); %%%% CHANGE TO MATCH THE NAME OF YOUR FOLDER

anat = spm_select('FPList', fullfile(datafolder_anat), '^sAW.*\.nii$');


matlabbatch{1}.spm.spatial.preproc.channel.vols  = cellstr(anat);
matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
matlabbatch{1}.spm.spatial.preproc.channel.write = [0 1];
matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {'/Users/deafneuralplasticitylab/Documents/MATLAB/spm12/tpm/TPM.nii,1'};
matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {'/Users/deafneuralplasticitylab/Documents/MATLAB/spm12/tpm/TPM.nii,2'};
matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {'/Users/deafneuralplasticitylab/Documents/MATLAB/spm12/tpm/TPM.nii,3'};
matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {'/Users/deafneuralplasticitylab/Documents/MATLAB/spm12/tpm/TPM.nii,4'};
matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {'/Users/deafneuralplasticitylab/Documents/MATLAB/spm12/tpm/TPM.nii,5'};
matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {'/Users/deafneuralplasticitylab/Documents/MATLAB/spm12/tpm/TPM.nii,6'};
matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
matlabbatch{1}.spm.spatial.preproc.warp.write = [0 1];

matlabbatch{2}.spm.spatial.normalise.write.subj.def      = cellstr(spm_file(anat,'prefix','y_','ext','nii'));
matlabbatch{2}.spm.spatial.normalise.write.subj.resample = cellstr(anat);
matlabbatch{2}.spm.spatial.normalise.write.woptions.vox  = [1 1 1];


disp(strcat('Running struct preprocessing participant... ',subjs(n,:)))



spm_jobman('run',matlabbatch);
disp(strcat('Done struct preprocessing participant... ',subjs(n,:)))
disp('')

clear matlabbatch anat datafolder_anat
 
end

%% PART 2




% functional data pre-processing 
clear n

for n=1:size(subjs,1)
    for t=1:size(taskfolders,1)
        
        datafolder=strcat(mainfolder,'/sub-',subjs(n,:),'/funct/',taskfolders{t}); %functional data
        
        datafolder_anat=strcat(mainfolder,'/sub-',subjs(n,:),'/anat'); %%%% CHANGE TO MATCH THE NAME OF YOUR FOLDER
        
        
        %Please choose the fieldmap temporally closer to the run session!!!!
%         datafolder_fieldmap=strcat(mainfolder,'/sub-',subjs(n,:),'/funct/',taskfolders{t},'/fmap');%CHANGE FOLDER
        
        funct = spm_select('FPList', fullfile(datafolder), '^sAW.*\.nii$');
        anat = spm_select('FPList', fullfile(datafolder_anat), '^sAW.*\.nii$');
%         shortreal=spm_select('FPList', fullfile(datafolder_fieldmap), '^sAW.*\-01-Real.nii$');%short is alway the first and long is always the second image
%         longreal=spm_select('FPList', fullfile(datafolder_fieldmap), '^sAW.*\-02-Real.nii$');
%         shortimag=spm_select('FPList', fullfile(datafolder_fieldmap), '^sAW.*\-01-Imag.nii$');%short is alway the first and long is always the second image
%         longimag=spm_select('FPList', fullfile(datafolder_fieldmap), '^sAW.*\-02-Imag.nii$');
%         wrap_img=spm_select('FPList',fullfile(datafolder),'^sAW.*\-00001-000001-01.nii$');
%         %%dddd
%         %Fieldmap
%         %---------------------------------------------------------------------
%         matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.data.realimag.shortreal = cellstr(shortreal);
%         matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.data.realimag.shortimag = cellstr(shortimag);
%         matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.data.realimag.longreal = cellstr(longreal);
%         matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.data.realimag.longimag = cellstr(longimag);
%         matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.et = [4.4 6.9];
%         matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.maskbrain = 0;
%         matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.blipdir = -1;
%         matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.tert = 36.472;
%         matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.epifm = 0;   %%%MODIFIED BY VC
%         matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.ajm = 0;
%         matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.uflags.method = 'Mark3D';
%         matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.uflags.fwhm = 10;
%         matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.uflags.pad = 0;
%         matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.uflags.ws = 1;
%         %matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.mflags.template = {'/Users/deafneuralplasticitylab/Documents/MATLAB/spm12/toolbox/FieldMap/T1.nii'};
%         matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.mflags.fwhm = 5;
%         matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.mflags.nerode = 2;
%         matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.mflags.ndilate = 4;
%         matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.mflags.thresh = 0.5;
%         matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.mflags.reg = 0.02;
%         matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.session.epi = cellstr(wrap_img);
%         %matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.session.epi = {'/Users/velia/Documents/1_Work/DeafCognition/MRI/derivatives/func/sub-007/funct/simontask/sAW6876383258771527075950-0008-00001-000001-01.nii'};
%         matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.matchvdm = 1;%%%MODIFIED BY VC
%         matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.sessname = 'session';
%         matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.writeunwarped = 0;%%%MODIFIED BY VC
%         matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.anat = {''};%%%MODIFIED BY VC
%         matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.matchanat = 0;%%%MODIFIED BY VC
        
        
        
        
        
%         % Realign
%         %--------------------------------------------------------------------------
%         matlabbatch{2}.spm.spatial.realignunwarp.data.scans = cellstr(funct);
%         matlabbatch{2}.spm.spatial.realignunwarp.data.pmscan = spm_select('FPList', fullfile(datafolder_fieldmap), '^vdm5_.*\01-Real.nii$');
%         %matlabbatch{2}.spm.spatial.realignunwarp.data.pmscan = {'/Users/velia/Documents/1_Work/DeafCognition/MRI/derivatives/func/sub-007/fmap/vdm5_sAW6876383258771527075950-0011-00001-000003-01-Real.nii,1'};
%         matlabbatch{2}.spm.spatial.realignunwarp.eoptions.quality = 0.9;
%         matlabbatch{2}.spm.spatial.realignunwarp.eoptions.sep = 4;
%         matlabbatch{2}.spm.spatial.realignunwarp.eoptions.fwhm = 5;
%         matlabbatch{2}.spm.spatial.realignunwarp.eoptions.rtm = 0;
%         matlabbatch{2}.spm.spatial.realignunwarp.eoptions.einterp = 2;
%         matlabbatch{2}.spm.spatial.realignunwarp.eoptions.ewrap = [0 0 0];
%         matlabbatch{2}.spm.spatial.realignunwarp.eoptions.weight = '';
%         matlabbatch{2}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
%         matlabbatch{2}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
%         matlabbatch{2}.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
%         matlabbatch{2}.spm.spatial.realignunwarp.uweoptions.jm = 0;
%         matlabbatch{2}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
%         matlabbatch{2}.spm.spatial.realignunwarp.uweoptions.sot = [];
%         matlabbatch{2}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
%         matlabbatch{2}.spm.spatial.realignunwarp.uweoptions.rem = 1;
%         matlabbatch{2}.spm.spatial.realignunwarp.uweoptions.noi = 5;
%         matlabbatch{2}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
%         matlabbatch{2}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];
%         matlabbatch{2}.spm.spatial.realignunwarp.uwroptions.rinterp = 4;
%         matlabbatch{2}.spm.spatial.realignunwarp.uwroptions.wrap = [0 0 0];
%         matlabbatch{2}.spm.spatial.realignunwarp.uwroptions.mask = 1;
%         matlabbatch{2}.spm.spatial.realignunwarp.uwroptions.prefix = 'r';

%          matlabbatch{1}.spm.spatial.realign.estwrite.data = cellstr(funct);
%          matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
%          matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 4;
%          matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
%          matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
%          matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 2;
%          matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
%          matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
%          matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [2 1];
%          matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
%          matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
%          matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
%          matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
        % Realign
           %--------------------------------------------------------------------------
        matlabbatch{1}.spm.spatial.realign.estwrite.data{1} = cellstr(funct);
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
           
        %Time correction
        %--------------------------------------------------------------------------
        matlabbatch{2}.spm.temporal.st.scans{1} = cellstr(spm_file(funct,'prefix','r'));
        matlabbatch{2}.spm.temporal.st.nslices = 50;
        matlabbatch{2}.spm.temporal.st.tr = 3;
        matlabbatch{2}.spm.temporal.st.ta = 2.94;
        matlabbatch{2}.spm.temporal.st.so = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50];
        matlabbatch{2}.spm.temporal.st.refslice = 25;
        matlabbatch{2}.spm.temporal.st.prefix = 'a';
        
        %Coregister
        %--------------------------------------------------------------------------
        matlabbatch{3}.spm.spatial.coreg.estimate.ref    = cellstr(anat);
        matlabbatch{3}.spm.spatial.coreg.estimate.source = cellstr(spm_file(funct,'prefix','mean'));
        matlabbatch{3}.spm.spatial.coreg.estimate.other = cellstr(spm_file(funct,'prefix','ar'));
        
        
        % Normalise: Write
        %--------------------------------------------------------------------------
        matlabbatch{4}.spm.spatial.normalise.write.subj.def      = cellstr(spm_file(anat,'prefix','y_','ext','nii'));
        matlabbatch{4}.spm.spatial.normalise.write.subj.resample = cellstr(char(spm_file(funct,'prefix','ar')));
        matlabbatch{4}.spm.spatial.normalise.write.woptions.vox  = [3 3 3];
        matlabbatch{4}.spm.spatial.normalise.write.woptions.prefix = 'w';
        
        % Smooth
        %--------------------------------------------------------------------------
        matlabbatch{5}.spm.spatial.smooth.data = cellstr(spm_file(funct,'prefix','war'));
        matlabbatch{5}.spm.spatial.smooth.fwhm = [8 8 8];
        matlabbatch{5}.spm.spatial.smooth.prefix = 's';
        
        disp(strcat('Running funct preprocessing__ ', taskfolders{t}, '   participant... ',subjs(n,:)))
        
         spm_jobman('run',matlabbatch);
        
        clear matlabbatch  datafolder* funct anat 
        
        disp(strcat('Done funct preprocessing__ ', taskfolders{t}, '  participant... ',subjs(n,:)))
        disp('__')
        
    end
end
disp('THE END')