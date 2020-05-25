   
% by V. Cardin 2020
% This script combined two marsbar rois (r1 and r2) following the function specified in
% func. At the moment, that function is 'r2 & ~r1'
% Where you see a *** --> you need to replace this with your own info



for s=1 %**** loop this into your list of subjects
   
 % directory of subject from which data is extracted
    subjroot = strcat('/Users/velia.cardin/Documents/DeafCognition/Level1st/Lev1st_TaskSwitching/s004/'); %***
    subjroot = char(subjroot);
    
    %roi_dir: Directory to store (and load) ROIs
     roi_dir  = strcat('/Users/velia.cardin/Documents/DeafCognition/CountingVoxelsInROis/marsbarrois/'); %***
     roi_dir  = char(roi_dir );    
     
    %  STC ROI file
    rlist{1} = strcat(roi_dir,'rL_STC_001_-59_-38_10_roi.mat'); %***
     
     % sujbect specific roi  
    rlist{2}=  char([strcat(roi_dir,'L_Planum_Temporale_1_roi.mat'),' ']);  %***

%makes the filenames the same size by padding the shorter one with spaces
rlist=pad(rlist);

%transforms the cell array intocharacter stringes

roilist=char(rlist);


roilist=maroi('load_cell',roilist); % roilist contains the 2 ROIs
    [Finter,Fgraph,CmdLine] = spm('FnUIsetup','Combine ROIs');
    func = ('r2 & ~r1');

    
    for i = 1:length(roilist)
        eval(sprintf('r%d = roilist{%d};', i, i));
    end
    
    try
        eval(['o=' func ';']);
    catch
        warning(['Hmm, probem with function ' func ': ' lasterr]);
        return
    end
    
    if isempty(o)
        warning('Empty object resulted');
        return
    end
    
    if is_empty_roi(o)
        warning('No volume resulted for ROI');
        return
    end
    
    roi_filename=strcat('PTwithoutSTC_subj',num2str(s),'_roi'); %****
    
    
    if isa(o, 'maroi')
%         o = label(o, [P{a},'_','lMFG']); % P contains subject IDs
                o = label(o, func); %
           saveroi(o, roi_filename);
        if ~isempty(o)
            fprintf('\nSaved ROI as %s\n', source(o));
        end
    else
        warning(sprintf('\nNo ROI resulted from function %s...\n', func));
    end

end
