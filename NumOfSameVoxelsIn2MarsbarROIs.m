  
% by V. Cardin 2020
% Give two marsbar rois, this script tells you how many voxels they have in common
% The rois are usually used as masks from which to extract data from
% an image. The script tells you how many of those voxels from which data
% is extracted are the same for a given individual. 
% Where you see a *** --> you need to replace this with your own info

%vXYZ and STCvXYZ are the variables that have all the voxels with
%coordinates in voxel number. The size of those variables is the number of
%voxels. 


    clear
   
    % Set up the SPM defaults, just in case
    spm('defaults', 'fmri'); %only need to do this once at the beginning of the script
    
   
 % directory of subject from which data is extracted
    subjroot = strcat('/Users/velia.cardin/Documents/DeafCognition/Level1st/Lev1st_TaskSwitching/s004/'); %***
    subjroot = char(subjroot);
    
    %roi_dir: Directory to store (and load) ROIs
     roi_dir  = strcat('/Users/velia.cardin/Documents/DeafCognition/CountingVoxelsInROis/marsbarrois/'); %***
     roi_dir  = char(roi_dir );    
    
     %name of image from which data is extracted
     dataimg='con_0001.nii'; %***
     
    %  STC ROI file
     r = dir(fullfile(roi_dir,'rL_STC_001_-59_-38_10_roi.mat')); %***
     
     % sujbect specific roi  
     sr=  dir(fullfile(roi_dir,'L_Planum_Temporale_1_roi.mat'));  %***
     
     
     %% extracting No of voxels from STC roi
     roinames  = strcat(roi_dir, r.name);
    
    %load con file
    P=strcat (subjroot,dataimg); % con= 0 1 0 0 Tower of London task % get images from contrast directory where they are stored
    V = spm_vol(P);

    roi_array= maroi(fullfile(roinames)); %roi_array.XYZ has the voxels in mm

    %extract data from roi in roi_array and image file dataimg
 [y vals STCvXYZ mat]  = getdata(roi_array, V); %vXYZ has the coordinates of the voxels. That's the variable we want!

 
 clear roinames P V roi_array y vals mat
 
      %% extracting No of voxels from PT roi
     roinames  = strcat(roi_dir, sr.name);
    
    %load con file
    P=strcat (subjroot,dataimg); % % get images from contrast directory where they are stored
    V = spm_vol(P);

    roi_array= maroi(fullfile(roinames)); %roi_array.XYZ has the voxels in mm

    %extract data from roi in roi_array and image file dataimg
 [y vals vXYZ mat]  = getdata(roi_array, V); %vXYZ has the coordinates of the voxels. That's the variable we want!
 
  clear roinames P V roi_array y vals mat
 
 numsamevoxels=0;
%find if any two voxels in each roi are the same
for u=1:length(STCvXYZ)
compvoxels=sum(abs(vXYZ - STCvXYZ(:,u))); %finds if the values of one voxel (column) are equal to any column in the second roi (sum of subtraction should be = 0)
samevoxels=find (~ compvoxels);
if (samevoxels)
    numsamevoxels=numsamevoxels+length(samevoxels);
end
end

 disp (['Number of voxels is common =  ', num2str(numsamevoxels)])