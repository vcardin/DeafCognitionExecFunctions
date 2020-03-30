%Jan 8 2020
%MARBAR batch Tower of London CONDITION
%This script run individual ROIs analysis starting from the subject
%anatomical ROI

clear all;

marsbar_dir='/Users/b.manini/Documents/MATLAB/spm12/toolbox/marsbar-0.44';
%cd=marsbar_dir;
mainfolder_Data='/Users/b.manini/Documents/MATLAB/Data/Lev1st_TowerofLondon/';%changes on the base of the task
mainfolder_ROI='/Users/b.manini/Documents/MATLAB/Data/ROI_freesurf/';
% Start marsbar to make sure spm_get works
marsbar('on')
%all the subjs (select on the base of the task)
%This are all the deaf subject who have TS data
%subjs={'101';'104'; '106'; '107';'108'; '110';'111'; '115'; '116'; '118';'119'; '122';'124';'127'; '129'; '130';  '131'; '132'; '133';'134'; '136'};
subjs={'002';'003';'004'; '006';'007';'008'; '011';'013';'014';'015';'017';'021';'023';'028';'031';'032';'041';'042'; '101'; '104'; '107';'108'; '110';'111'; '113'; '115'; '116'; '118';'119'; '122';'124';'127'; '129'; '131'; '132'; '133';'134'; '135'; '136'};
    
 %tol

% MarsBaR version check
if isempty(which('marsbar'))
  error('Need MarsBaR on the path');
end
v = str2num(marsbar('ver'));
if v < 0.35
  error('Batch script only works for MarsBaR >= 0.35');
end
marsbar('on');  % needed to set paths etc
%%
%ToL TASK
for n=1:size(subjs,1)

    %subjroot:first level analysis folder

    %subjroot:first level analysis folder
    subjroot = strcat(mainfolder_Data,'s',subjs(n,:));
    subjroot = char(subjroot);
    
    %roi_dir: Directory to store (and load) ROIs
     roi_dir  = strcat(mainfolder_ROI, 'sub-', subjs(n,:), '/');
     roi_dir  = char(roi_dir );    
     %save_directory=mkdir(roi_dir, 'wm_task');
    
    
    % Set up the SPM defaults, just in case
    spm('defaults', 'fmri');

    % Subdirectory for reconfigured design
    mars_sdir = 'Mars_ana';
      
    % select the STC ROI
    r = dir(fullfile(roi_dir,'/R_Planum_Temporale_1_roi.mat'));
    PT_R_name = [r.name];
    roinames  = strcat(roi_dir, PT_R_name);
    %roi_array{1} = maroi(stc_R_name); %right STC
    
    %load con file
    P= dir(fullfile(subjroot ,'con_0005.nii')); % con= 0 1 0 0 Tower of London task % get images from contrast directory where they are stored
    V = spm_vol(P);
%     wm_file  = strcat(subjroot ,'/',wm_name);
    D = strvcat(V.name); %load images into format for Marsbar  
    D2= strcat(subjroot,'/' , D);
    roi_array= maroi(fullfile(roinames));
    % Extract data
    Ytol = get_marsy(roi_array, D2, 'mean');%get the values
    % %mars_arm('save', 'roi_data', 'test.mat');
    [datamean_tol datavar_tol o_tol] = summary_data(Ytol, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean
    regionname = char(region_name(Ytol)); %note the regionname   

   
      %load con file control task
    K= dir(fullfile(subjroot ,'con_0007.nii')); % con= 1 0 0 0 working memory task % get images from contrast directory where they are stored
    J = spm_vol(K);
%   wm_file  = strcat(subjroot ,'/',wm_name);
    H = strcat(J.name); %load images into format for Marsbar  
    H2= strcat(subjroot,'/' , H);
    roi_array= maroi(fullfile(roinames));   
    % Extract data
    Ycon = get_marsy(roi_array, H2, 'mean');%get the values
    
    % %mars_arm('save', 'roi_data', 'test.mat');
    [datamean_con datavar_con o_con] = summary_data(Ycon, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean
    %regionname = char(region_name(Y)); %note the regionname   
      
     data_file= fullfile (roi_dir,'Tower of London_R_Planum_Temporale_1_roi.mat');
     save(data_file, 'datamean_tol', 'datamean_con','regionname'); 
     
     clear subjroot roi_dir r stc_R_name roinames P V D D2 J K H H2 datamean_tol datavar_tol o_tol region_name datamean_con datavar_con o_con Ytol Wcon data_file
    
end 

%%
%%
%ToL TASK
for n=1:size(subjs,1)

    %subjroot:first level analysis folder

    %subjroot:first level analysis folder
    subjroot = strcat(mainfolder_Data,'s',subjs(n,:));
    subjroot = char(subjroot);
    
    %roi_dir: Directory to store (and load) ROIs
     roi_dir  = strcat(mainfolder_ROI, 'sub-', subjs(n,:), '/');
     roi_dir  = char(roi_dir );    
     %save_directory=mkdir(roi_dir, 'wm_task');
    
    
    % Set up the SPM defaults, just in case
    spm('defaults', 'fmri');

    % Subdirectory for reconfigured design
    mars_sdir = 'Mars_ana';
      
    % select the STC ROI
    r = dir(fullfile(roi_dir,'/L_Planum_Temporale_1_roi.mat'));
    PT_L_name = [r.name];
    roinames  = strcat(roi_dir, PT_L_name);
    %roi_array{1} = maroi(stc_R_name); %right STC
    
    %load con file
    P= dir(fullfile(subjroot ,'con_0005.nii')); % con= 0 1 0 0 Tower of London task % get images from contrast directory where they are stored
    V = spm_vol(P);
%     wm_file  = strcat(subjroot ,'/',wm_name);
    D = strvcat(V.name); %load images into format for Marsbar  
    D2= strcat(subjroot,'/' , D);
    roi_array= maroi(fullfile(roinames));
    % Extract data
    Ytol = get_marsy(roi_array, D2, 'mean');%get the values
    % %mars_arm('save', 'roi_data', 'test.mat');
    [datamean_tol datavar_tol o_tol] = summary_data(Ytol, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean
    regionname = char(region_name(Ytol)); %note the regionname   

   
      %load con file control task
    K= dir(fullfile(subjroot ,'con_0007.nii')); % con= 1 0 0 0 working memory task % get images from contrast directory where they are stored
    J = spm_vol(K);
%   wm_file  = strcat(subjroot ,'/',wm_name);
    H = strcat(J.name); %load images into format for Marsbar  
    H2= strcat(subjroot,'/' , H);
    roi_array= maroi(fullfile(roinames));   
    % Extract data
    Ycon = get_marsy(roi_array, H2, 'mean');%get the values
    
    % %mars_arm('save', 'roi_data', 'test.mat');
    [datamean_con datavar_con o_con] = summary_data(Ycon, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean
    %regionname = char(region_name(Y)); %note the regionname   
      
     data_file= fullfile (roi_dir,'Tower of London_L_Planum_Temporale_1_roi.mat');
     save(data_file, 'datamean_tol', 'datamean_con','regionname'); 
     
     clear subjroot roi_dir r stc_R_name roinames P V D D2 J K H H2 datamean_tol datavar_tol o_tol region_name datamean_con datavar_con o_con Ytol Wcon data_file
    
end 

%%
%ToL TASK
for n=1:size(subjs,1)

    %subjroot:first level analysis folder

    %subjroot:first level analysis folder
    subjroot = strcat(mainfolder_Data,'s',subjs(n,:));
    subjroot = char(subjroot);
    
    %roi_dir: Directory to store (and load) ROIs
     roi_dir  = strcat(mainfolder_ROI, 'sub-', subjs(n,:), '/');
     roi_dir  = char(roi_dir );    
     %save_directory=mkdir(roi_dir, 'wm_task');
    
    
    % Set up the SPM defaults, just in case
    spm('defaults', 'fmri');

    % Subdirectory for reconfigured design
    mars_sdir = 'Mars_ana';
      
    % select the STC ROI
    r = dir(fullfile(roi_dir,'/L_HerschlGyrus_1_roi.mat'));
    PT_L_name = [r.name];
    roinames  = strcat(roi_dir, PT_L_name);
    %roi_array{1} = maroi(stc_R_name); %right STC
    
    %load con file
    P= dir(fullfile(subjroot ,'con_0005.nii')); % con= 0 1 0 0 Tower of London task % get images from contrast directory where they are stored
    V = spm_vol(P);
%     wm_file  = strcat(subjroot ,'/',wm_name);
    D = strvcat(V.name); %load images into format for Marsbar  
    D2= strcat(subjroot,'/' , D);
    roi_array= maroi(fullfile(roinames));
    % Extract data
    Ytol = get_marsy(roi_array, D2, 'mean');%get the values
    % %mars_arm('save', 'roi_data', 'test.mat');
    [datamean_tol datavar_tol o_tol] = summary_data(Ytol, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean
    regionname = char(region_name(Ytol)); %note the regionname   

   
      %load con file control task
    K= dir(fullfile(subjroot ,'con_0007.nii')); % con= 1 0 0 0 working memory task % get images from contrast directory where they are stored
    J = spm_vol(K);
%   wm_file  = strcat(subjroot ,'/',wm_name);
    H = strcat(J.name); %load images into format for Marsbar  
    H2= strcat(subjroot,'/' , H);
    roi_array= maroi(fullfile(roinames));   
    % Extract data
    Ycon = get_marsy(roi_array, H2, 'mean');%get the values
    
    % %mars_arm('save', 'roi_data', 'test.mat');
    [datamean_con datavar_con o_con] = summary_data(Ycon, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean
    %regionname = char(region_name(Y)); %note the regionname   
      
     data_file= fullfile (roi_dir,'Tower of London_L_HerschlGyrus_1_roi.mat');
     save(data_file, 'datamean_tol', 'datamean_con','regionname'); 
     
     clear subjroot roi_dir r stc_R_name roinames P V D D2 J K H H2 datamean_tol datavar_tol o_tol region_name datamean_con datavar_con o_con Ytol Wcon data_file
    
end 

%%
%%
%ToL TASK
for n=1:size(subjs,1)

    %subjroot:first level analysis folder

    %subjroot:first level analysis folder
    subjroot = strcat(mainfolder_Data,'s',subjs(n,:));
    subjroot = char(subjroot);
    
    %roi_dir: Directory to store (and load) ROIs
     roi_dir  = strcat(mainfolder_ROI, 'sub-', subjs(n,:), '/');
     roi_dir  = char(roi_dir );    
     %save_directory=mkdir(roi_dir, 'wm_task');
    
    
    % Set up the SPM defaults, just in case
    spm('defaults', 'fmri');

    % Subdirectory for reconfigured design
    mars_sdir = 'Mars_ana';
      
    % select the STC ROI
    r = dir(fullfile(roi_dir,'/R_HerschlGyrus_1_roi.mat'));
    PT_L_name = [r.name];
    roinames  = strcat(roi_dir, PT_L_name);
    %roi_array{1} = maroi(stc_R_name); %right STC
    
    %load con file
    P= dir(fullfile(subjroot ,'con_0005.nii')); % con= 0 1 0 0 Tower of London task % get images from contrast directory where they are stored
    V = spm_vol(P);
%     wm_file  = strcat(subjroot ,'/',wm_name);
    D = strvcat(V.name); %load images into format for Marsbar  
    D2= strcat(subjroot,'/' , D);
    roi_array= maroi(fullfile(roinames));
    % Extract data
    Ytol = get_marsy(roi_array, D2, 'mean');%get the values
    % %mars_arm('save', 'roi_data', 'test.mat');
    [datamean_tol datavar_tol o_tol] = summary_data(Ytol, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean
    regionname = char(region_name(Ytol)); %note the regionname   

   
      %load con file control task
    K= dir(fullfile(subjroot ,'con_0007.nii')); % con= 1 0 0 0 working memory task % get images from contrast directory where they are stored
    J = spm_vol(K);
%   wm_file  = strcat(subjroot ,'/',wm_name);
    H = strcat(J.name); %load images into format for Marsbar  
    H2= strcat(subjroot,'/' , H);
    roi_array= maroi(fullfile(roinames));   
    % Extract data
    Ycon = get_marsy(roi_array, H2, 'mean');%get the values
    
    % %mars_arm('save', 'roi_data', 'test.mat');
    [datamean_con datavar_con o_con] = summary_data(Ycon, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean
    %regionname = char(region_name(Y)); %note the regionname   
      
     data_file= fullfile (roi_dir,'Tower of London_R_HerschlGyrus_1_roi.mat');
     save(data_file, 'datamean_tol', 'datamean_con','regionname'); 
     
     clear subjroot roi_dir r stc_R_name roinames P V D D2 J K H H2 datamean_tol datavar_tol o_tol region_name datamean_con datavar_con o_con Ytol Wcon data_file
    
end 









