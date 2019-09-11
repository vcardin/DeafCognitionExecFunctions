clear

 subjs={
     '002';'003';'004';'006';'007';'008';'011';'013';'014';'015';...
     '016';'017';'018';'021';'023';'028'; '031';'032';'041';'042';'101';'102';'103';'104';'106';'107';'108';'110';...
     '111';'114';'115';'116'; '118'; '119';
    '122';'123';'124'; '127';'129';'130';'131';'132';'133';'134';'135';'136'};
%subjs={'993'};
mainfolder=strcat('/Users/velia.cardin/Documents/DeafCognition/Data/');%CHANGE FOLDER


taskfolders={ 'taskswitching_run1';'taskswitching_run2'; 'workingmemory_run1';'workingmemory_run2';};
%taskfolders={ 'toweroflondon'; 'workingmemory';'taskswitching'; 'simontask_run1'; 'simontask_run2'};

%         matlabbatch{2}.spm.spatial.realignunwarp.data.scans = cellstr(funct);
%  reafile = spm_select('FPList', fullfile(datafolder), '^vdm5_.*\01-Real.nii$');

for s=1:length(subjs)
    for k=1:length(taskfolders)
        try
        datafolder=strcat(mainfolder,'sub-',subjs{s},'/funct/',taskfolders{k});
        
        
        funct = spm_select('FPList', fullfile(datafolder), '^arsAW.*\.nii$');
        reafile = spm_select('FPList', fullfile(datafolder), '^rp.*\.txt$');
        
        batch.P{1}   =funct;
        
        batch.M{1}   =reafile;
        art('sess_file',batch)        
        disp('completed')
        disp(subjs{s})
        disp(taskfolders{k})
        

        
        clear datafolder funct batch reafile
        catch
        end
        
    end
end