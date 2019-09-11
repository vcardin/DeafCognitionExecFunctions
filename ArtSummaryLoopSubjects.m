% Creates ART summary matrix
% Matrix collumns:
% 1. Subject number 2. Task Number 3. Max Global mean 4. Max motion 5. No. of outliers

%Task Number:
%1.'toweroflondon'; %
% 2.'workingmemory';
% 3.'taskswitching'; 
% 4.'simontask_run1'; 
% 5.'simontask_run2';
% 6.'taskswitching_run1';
% 7.'taskswitching_run2'; 
% 8.'workingmemory_run1';
% 9.'workingmemory_run2';

clear

 subjs={
     '002';'003';'004';'006';'007';'008';'011';'013'; '014';'015';...
     '016';'017';'018';'021';'023';'028'; '031';'032';'041';'042';'101';'102';'103';'104';'106';'107';'108';'110';...
     '111';'114';'115';'116'; '118'; '119';
    '122';'123';'124'; '127';'129';'130';'131';'132';'133';'134';'135';'136'};

mainfolder=strcat('/Users/velia.cardin/Documents/DeafCognition/Data/');%CHANGE FOLDER


taskfolders={ 'toweroflondon'; 'workingmemory';'taskswitching'; 'simontask_run1'; 'simontask_run2';'taskswitching_run1';'taskswitching_run2'; 'workingmemory_run1';'workingmemory_run2';};

%         matlabbatch{2}.spm.spatial.realignunwarp.data.scans = cellstr(funct);
%  reafile = spm_select('FPList', fullfile(datafolder), '^vdm5_.*\01-Real.nii$');

c=1;%counter
for s=1:length(subjs)
    for k=1:length(taskfolders)
        try
        datafolder=strcat(mainfolder,'sub-',subjs{s},'/funct/',taskfolders{k});
        artfile = spm_select('FPList', fullfile(datafolder), '^art_regression_timeseries.*\.mat$');
        outliersfile = spm_select('FPList', fullfile(datafolder), '^art_regression_outliers_ars.*\.mat$');

        
        %load summary file
        load(artfile)
        
        ARTsummary(c,1:4)= [str2num(subjs{s}) k max(R)];  % find the maximum

        clear R
        
        
        %find how many outliers
        load(outliersfile)
        
                ARTsummary(c,5)= [size(R,2)];  % find number of outliers

%   
%         disp('completed')
%         disp(subjs{s})
%         disp(taskfolders{k})
        

        c=c+1;
        clear R *file datafolder
        catch
        end
        
    end
end