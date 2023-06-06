
clear;


    % Set up the SPM defaults, just in case
    spm('defaults', 'fmri');
%STEP 1: Set the directories name

%Replace with your Marsbar directory
marsbar_dir='/Users/velia/Documents/spm12/toolbox/marsbar-0.44'; 

%Replace with the directory where the first-level analysis are contained (the script will automatically loop into each participant folder)
mainfolder_Data='/Users/velia/Documents/DeafCognition/FirstLevel/Lev1st_WM_buttonpressbyhand/';

%Replace with the directory where your ROIs are kept (the script will automatically loop into each participant folder)
mainfolder_ROI='/Users/velia/Documents/DeafCognition/ROIsFoxPNAS'; 

% Start marsbar to make sure spm_get works
marsbar('on')
subjs={ '002';'004'; '006';'007';'008';'011'; '013';'014'; '015'; '016'; '017'; '018';'021';'023';'028';'031';'032';'041'; '042'; '101';'103';'104';'106'; '107';'108'; '110';'111'; '114'; '115'; '116'; '118';'119';'122'; '124';'127'; '129'; '130';'131';'132';'133';'134';'135'; '136'}; 

% MarsBaR version check
if isempty(which('marsbar'))
  error('Need MarsBaR on the path');
end
v = str2num(marsbar('ver'));
if v < 0.35
  error('Batch script only works for MarsBaR >= 0.35');
end
marsbar('on');  % needed to set paths etc


%lists all rois in directory
cd (mainfolder_ROI)
roi_list=dir('*.mat');

for r=2:length(roi_list)


    % select the  ROI 
%     roinames  = strcat(roi_dir,'/' ,preSMA_name);
			roinames  =	char(strcat(mainfolder_ROI,'/',roi_list(r).name));

for n=1:size(subjs,1)

    %subjroot:first level analysis folder
    subjroot = strcat(mainfolder_Data,'s',subjs(n,:));
    subjroot = char(subjroot);
    
% 				%if each participant has different rois
%     %roi_dir: Directory from where the ROIs are loaded and where the data
%     %are stored
%      roi_dir  = strcat(mainfolder_ROI, 'sub-', subjs(n,:));
%      roi_dir  = char(roi_dir );     
  
%if all participants have the same ROI

% roi_dir  = char(strcat(mainfolder_ROI,'/',roi_list(n).name));


    
    %load con file: load the relevant contrast files from the first level
    %analysis folder
    P= dir(fullfile(subjroot ,'con_0005.nii')); % con= 0 1 0 0 working memory condition% get images from the contrast directory where they are stored
    V = spm_vol(P);
    D = strvcat(V.name); %load images into format for Marsbar  
    D2= strcat(subjroot,'/' , D);
    roi_array= maroi(fullfile(roinames));
    % Extract data
    Ywm = get_marsy(roi_array, D2, 'mean');%get the values
    % %mars_arm('save', 'roi_data', 'test.mat');
    [datamean_wm datavar_wm o_wm] = summary_data(Ywm, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean
    regionname = char(region_name(Ywm)); %note the regionname   
   
    %load con file control task
    K= dir(fullfile(subjroot ,'con_0006.nii')); % con= 1 0 0 0 control condition % get images from contrast directory where they are stored
    J = spm_vol(K);
    H = strcat(J.name); %load images into format for Marsbar  
    H2= strcat(subjroot,'/' , H);
    roi_array= maroi(fullfile(roinames));   
    % Extract data
    Ycon = get_marsy(roi_array, H2, 'mean');%get the values

    [datamean_con datavar_con o_con] = summary_data(Ycon, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean 
      
%      data_file= fullfile (roi_dir,'/WorkingMemory_ preSMA_roi.mat');

					all_data(n,:,r)=[ datamean_wm, datamean_con, str2num(char([subjs(n,:)]))];
     
     clear subjroot roi_dir  L_HG_name  P V D D2 J K H H2 datamean_wm datavar_wm o_wm region_name datamean_con datavar_con o_con Ywm Wcon %data_file
    
end     

%save(data_file, 'datamean_wm', 'datamean_con','regionname'); %save the data in the given participant' directory

disp(roi_list(r).name)
disp ('wm v con all')
[a,b,c]=ttest(all_data(:,1,r),all_data(:,2,r))
disp('mean hearing')
hearing=all_data(1:19,1:2,r);
mean(hearing)
disp('mean deaf')
deaf=all_data(20:43,1:2,r);
mean(deaf)
disp('group comp wm')
 [a,b,c]=ttest2(hearing(:,1),deaf(:,1))
	disp('group comp con')
[a,b,c]=ttest2(hearing(:,2),deaf(:,2))
disp('group comp interaction')
 [a,b,c]=ttest2([hearing(:,1)-hearing(:,2)],[deaf(:,1)-deaf(:,2)])

disp("...")
clear roinames

end

c=1;
for l=1:length(roi_list)
header{c}=strcat('WM_',roi_list(l).name);
c=c+1;
header{c}=strcat('Con_',roi_list(l).name);
c=c+1;
header{c}=strcat('roi',num2str(l));
c=c+1;
end


fprintf(file, '%s\n', header);


