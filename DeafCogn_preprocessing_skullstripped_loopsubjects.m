
%%DEAF COGNITION PRE-PROCESSING BATCH CODE September 15 2018
%Modified VC Sept 2019
%Major changes include normalisation of a skullstripped anatomical scan
%(normalisation not always working before)

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

mainfolder='/Users/velia.cardin/Documents/DeafCognition/Data';

taskfolders={ 'toweroflondon'; 'workingmemory';'taskswitching'; 'simontask_run1'; 'simontask_run2';'taskswitching_run1';'taskswitching_run2'; 'workingmemory_run1';'workingmemory_run2';};


%These are letter strings (not numbers). Make sure they are all the same legnth(3 digits)
subjs={ '003';'103';  '018';  '013';   '041'; '115';...
  '023';'028'; '032';'101';'104';'106';'107';'108';'110';...
         '111';'115';'116'; '118'; '119';
       '123';'124'; '127';'129';'130';'131';'133';'134';'135';'136';};

%% PART 1
%Segmentation and normalization of the anatomica scan. All the functional
%data will be referred and normalized on the common anatomical scan. Do
%this process just once for each subject.
%Comment this loop if you only want to preprocess functional data.
% % 
for n=1:size(subjs,1)
    try
        datafolder_anat=strcat(mainfolder,'/sub-',subjs(n,:),'/anat'); %%%% CHANGE TO MATCH THE NAME OF YOUR FOLDER
        
        anat = spm_select('FPList', fullfile(datafolder_anat), '^sAW.*\.nii$');
        biasanat = spm_select('FPList', fullfile(datafolder_anat), '^msAW.*\.nii$'); %bias-corrected anatomical scan
        sksnamestring=strcat('^',subjs(n,:),'skull.*\.nii$');
        sksanat=spm_select('FPList', fullfile(datafolder_anat),sksnamestring) ;%skull stripped anatomical scan
        
                
                matlabbatch{1}.spm.spatial.preproc.channel.vols  = cellstr(anat);
                matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
                matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
                matlabbatch{1}.spm.spatial.preproc.channel.write = [0 1];
                matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {'/Applications/spm12/tpm/TPM.nii,1'};
                matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
                matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0];
                matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
                matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {'/Applications/spm12/tpm/TPM.nii,2'};
                matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
                matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 0];
                matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
                matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {'/Applications/spm12/tpm/TPM.nii,3'};
                matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
                matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
                matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
                matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {'/Applications/spm12/tpm/TPM.nii,4'};
                matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
                matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [1 0];
                matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
                matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {'/Applications/spm12/tpm/TPM.nii,5'};
                matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
                matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [1 0];
                matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
                matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {'/Applications/spm12/tpm/TPM.nii,6'};
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
        %
        c=2;
        
        matlabbatch{c}.spm.spatial.normalise.estwrite.subj.vol = cellstr(sksanat);
        matlabbatch{c}.spm.spatial.normalise.estwrite.subj.resample =cellstr(sksanat);
        matlabbatch{c}.spm.spatial.normalise.estwrite.woptions.vox = [1 1 1];
        matlabbatch{c}.spm.spatial.normalise.estwrite.woptions.prefix = 'w';
        
        disp(strcat('Running struct preprocessing participant... ',subjs(n,:)))
        
        
        
        spm_jobman('run',matlabbatch);
        disp(strcat('Done struct preprocessing participant... ',subjs(n,:)))
        disp('')
        
        clear matlabbatch anat datafolder_anat biasanat sksanat c
    catch
        disp(strcat(' preprocessing DID NOT work participant... ',subjs(n,:)))
        disp('')
        
    end
    
end

    %% PART 2
% 
%     % functional data pre-processing
    clear n

    for n=1:size(subjs,1)
        for t=1:size(taskfolders,1)
            try

                datafolder=strcat(mainfolder,'/sub-',subjs(n,:),'/funct/',taskfolders{t}); %functional data

                datafolder_anat=strcat(mainfolder,'/sub-',subjs(n,:),'/anat'); %%%% CHANGE TO MATCH THE NAME OF YOUR FOLDER


                %Please choose the fieldmap temporally closer to the run session!!!!
                datafolder_fieldmap=strcat(mainfolder,'/sub-',subjs(n,:),'/funct/',taskfolders{t},'/fmap');%CHANGE FOLDER

                funct = spm_select('FPList', fullfile(datafolder), '^sAW.*\.nii$');
                biasanat = spm_select('FPList', fullfile(datafolder_anat), '^msAW.*\.nii$');
                sksnamestring=strcat('^',subjs(n,:),'skull.*\.nii$');
                sksanat=spm_select('FPList', fullfile(datafolder_anat),sksnamestring) ;%skull stripped anatomical scan

                shortreal=spm_select('FPList', fullfile(datafolder_fieldmap), '^sAW.*\-01-Real.nii$');%short is alway the first and long is always the second image
                longreal=spm_select('FPList', fullfile(datafolder_fieldmap), '^sAW.*\-02-Real.nii$');
                shortimag=spm_select('FPList', fullfile(datafolder_fieldmap), '^sAW.*\-01-Imag.nii$');%short is alway the first and long is always the second image
                longimag=spm_select('FPList', fullfile(datafolder_fieldmap), '^sAW.*\-02-Imag.nii$');
                wrap_img=spm_select('FPList',fullfile(datafolder),'^sAW.*\-00001-000001-01.nii$');
                if ~exist(wrap_img)
                    wrap_img=spm_select('FPList',fullfile(datafolder),'^sAW.*\-00001-000051-01.nii$');
                    if ~exist(wrap_img)
                        wrap_img=spm_select('FPList',fullfile(datafolder),'^sAW.*\-00001-000951-01.nii$');
                        if ~exist(wrap_img)

                            disp('WARNING')
                            disp(wrap_img)
                            disp('DOES NOT EXIST')
                            disp('====')
                        end
                    end
                end

                %dddd
                %Fieldmap
%                 %---------------------------------------------------------------------
                matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.data.realimag.shortreal = cellstr(shortreal);
                matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.data.realimag.shortimag = cellstr(shortimag);
                matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.data.realimag.longreal = cellstr(longreal);
                matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.data.realimag.longimag = cellstr(longimag);
                matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.et = [4.4 6.9];
                matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.maskbrain = 0;
                matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.blipdir = -1;
                matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.tert = 36.472;
                matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.epifm = 0;   %%%MODIFIED BY VC
                matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.ajm = 0;
                matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.uflags.method = 'Mark3D';
                matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.uflags.fwhm = 10;
                matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.uflags.pad = 0;
                matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.uflags.ws = 1;
                %matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.mflags.template = {'/Applications/spm12/toolbox/FieldMap/T1.nii'};
                matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.mflags.fwhm = 5;
                matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.mflags.nerode = 2;
                matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.mflags.ndilate = 4;
                matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.mflags.thresh = 0.5;
                matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.mflags.reg = 0.02;
                matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.session.epi = cellstr(wrap_img);
                %matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.session.epi = {'/Users/velia/Documents/1_Work/DeafCognition/MRI/derivatives/func/sub-007/funct/simontask/sAW6876383258771527075950-0008-00001-000001-01.nii'};
                matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.matchvdm = 1;%%%MODIFIED BY VC
                matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.sessname = 'session';
                matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.writeunwarped = 0;%%%MODIFIED BY VC
                matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.anat = {''};%%%MODIFIED BY VC
                matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.matchanat = 0;%%%MODIFIED BY VC


                c=2;
                % Realign
                %--------------------------------------------------------------------------
                matlabbatch{c}.spm.spatial.realignunwarp.data.scans = cellstr(funct);
                matlabbatch{c}.spm.spatial.realignunwarp.data.pmscan = spm_select('FPList', fullfile(datafolder_fieldmap), '^vdm5_.*\01-Real.nii$');
                %matlabbatch{c}.spm.spatial.realignunwarp.data.pmscan = {'/Users/velia/Documents/1_Work/DeafCognition/MRI/derivatives/func/sub-007/fmap/vdm5_sAW6876383258771527075950-0011-00001-000003-01-Real.nii,1'};
                matlabbatch{c}.spm.spatial.realignunwarp.eoptions.quality = 0.9;
                matlabbatch{c}.spm.spatial.realignunwarp.eoptions.sep = 4;
                matlabbatch{c}.spm.spatial.realignunwarp.eoptions.fwhm = 5;
                matlabbatch{c}.spm.spatial.realignunwarp.eoptions.rtm = 0;
                matlabbatch{c}.spm.spatial.realignunwarp.eoptions.einterp = 2;
                matlabbatch{c}.spm.spatial.realignunwarp.eoptions.ewrap = [0 0 0];
                matlabbatch{c}.spm.spatial.realignunwarp.eoptions.weight = '';
                matlabbatch{c}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
                matlabbatch{c}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
                matlabbatch{c}.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
                matlabbatch{c}.spm.spatial.realignunwarp.uweoptions.jm = 0;
                matlabbatch{c}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
                matlabbatch{c}.spm.spatial.realignunwarp.uweoptions.sot = [];
                matlabbatch{c}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
                matlabbatch{c}.spm.spatial.realignunwarp.uweoptions.rem = 1;
                matlabbatch{c}.spm.spatial.realignunwarp.uweoptions.noi = 5;
                matlabbatch{c}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
                matlabbatch{c}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];
                matlabbatch{c}.spm.spatial.realignunwarp.uwroptions.rinterp = 4;
                matlabbatch{c}.spm.spatial.realignunwarp.uwroptions.wrap = [0 0 0];
                matlabbatch{c}.spm.spatial.realignunwarp.uwroptions.mask = 1;
                matlabbatch{c}.spm.spatial.realignunwarp.uwroptions.prefix = 'r';

               c=c+1;

                %Coregister
                %--------------------------------------------------------------------------
                matlabbatch{c}.spm.spatial.coreg.estimate.ref    = cellstr(biasanat);
                         matlabbatch{c}.spm.spatial.coreg.estimate.source = cellstr(spm_file(funct(1,:),'prefix','meanr'));
%                 meanimage=spm_select('FPList', fullfile(datafolder), '^mean.*\.nii$');
%                 matlabbatch{c}.spm.spatial.coreg.estimate.source =    cellstr(meanimage);
                matlabbatch{c}.spm.spatial.coreg.estimate.other = cellstr(spm_file(funct,'prefix','r'));
                c=c+1;

                %Time correction
                %--------------------------------------------------------------------------
                matlabbatch{c}.spm.temporal.st.scans{1} = cellstr(spm_file(funct,'prefix','r'));
                matlabbatch{c}.spm.temporal.st.nslices = 50;
                matlabbatch{c}.spm.temporal.st.tr = 3;
                matlabbatch{c}.spm.temporal.st.ta = 2.94;
                matlabbatch{c}.spm.temporal.st.so = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50];
                matlabbatch{c}.spm.temporal.st.refslice = 25;
                matlabbatch{c}.spm.temporal.st.prefix = 'a';

                c=c+1;

                % Normalise: Write
                %--------------------------------------------------------------------------
                matlabbatch{c}.spm.spatial.normalise.write.subj.def      = cellstr(spm_file(sksanat,'prefix','y_','ext','nii'));
                matlabbatch{c}.spm.spatial.normalise.write.subj.resample = cellstr(char(spm_file(funct,'prefix','ar')));
                matlabbatch{c}.spm.spatial.normalise.write.woptions.vox  = [3 3 3];
                matlabbatch{c}.spm.spatial.normalise.write.woptions.prefix = 'w';
                c=c+1;

                % Smooth
                %--------------------------------------------------------------------------
                matlabbatch{c}.spm.spatial.smooth.data = cellstr(spm_file(funct,'prefix','war'));
                matlabbatch{c}.spm.spatial.smooth.fwhm = [8 8 8];
                matlabbatch{c}.spm.spatial.smooth.prefix = 's';


                disp(strcat('Running funct preprocessing__ ', taskfolders{t}, '   participant... ',subjs(n,:)))

                spm_jobman('run',matlabbatch);

                clear matlabbatch  datafolder* funct *anat c meanimage short* long* wrap_img

                disp(strcat('Done funct preprocessing__ ', taskfolders{t}, '  participant... ',subjs(n,:)))
                disp('__')
            catch
            end

        end
    end
    disp('THE END')