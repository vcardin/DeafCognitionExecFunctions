   
% by V. Cardin 2020
% This script combined two marsbar rois (r1 and r2) following the function specified in
% func. At the moment, that function is 'r2 & ~r1'
% Where you see a *** --> you need to replace this with your own info
%subjs={ '002'; '004'; '006';'007';'008';'011'; '013';'014'; '015'; '016'; '017'; '018';'021';'023';'028';'031';'032';'041'; '042';'101'; '103'; '104';  '106'; '107';'108'; '110';'111';'114'; '115'; '116'; '118';'119'; '122';'124';'127'; '129'; '130';  '131'; '132'; '133';'134';'135'; '136'};
subjs={'003'};

for s=1:size(subjs,1) %**** loop this into your list of subjects
   
 % directory of subject from which data is extracted
    TE10_dir = strcat('/Users/deafneuralplasticitylab/Documents/MATLAB/TE10_ROIanalysis/'); %***
    TE10_dir = char(TE10_dir);
    
    %roi_dir: Directory to store (and load) ROIs
     roi_dir  = strcat('/Users/deafneuralplasticitylab/Documents/MATLAB/Data/ROI_freesurf/', 'sub-', subjs(s),'/' ); %***
     roi_dir  = char(roi_dir );    
     
    %  STC ROI file
    rlist{1} = strcat(TE10_dir,'wPM_te10_49_-17_7_roi.mat'); %***
     
     % sujbect specific roi  
    rlist{2}=  char([strcat(roi_dir,'R_HerschlGyrus_1_roi.mat'),' ']);  %***

%makes the filenames the same size by padding the shorter one with spaces
rlist=pad(rlist);

%transforms the cell array intocharacter stringes

roilist=char(rlist);


roilist=maroi('load_cell',roilist); % roilist contains the 2 ROIs
    [Finter,Fgraph,CmdLine] = spm('FnUIsetup','Combine ROIs');
    func = ('r2 & r1');

    
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
    
    roi_filename=strcat(roi_dir,'/','Right_Te1.0','_roi','.mat'); %****
    
    
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
%%

% by V. Cardin 2020
% This script combined two marsbar rois (r1 and r2) following the function specified in
% func. At the moment, that function is 'r2 & ~r1'
% Where you see a *** --> you need to replace this with your own info
%subjs={ '002'; '004'; '006';'007';'008';'011'; '013';'014'; '015'; '016'; '017'; '018';'021';'023';'028';'031';'032';'041'; '042';'101'; '104';  '106'; '107';'108'; '110';'111'; '115'; '116'; '118';'119'; '122';'124';'127'; '129'; '130';  '131'; '132'; '133';'134';'135'; '136'};
subjs={'003'};

for s=1:size(subjs,1) %**** loop this into your list of subjects
   
 % directory of subject from which data is extracted
    TE10_dir = strcat('/Users/deafneuralplasticitylab/Documents/MATLAB/TE10_ROIanalysis/'); %***
    TE10_dir = char(TE10_dir);
    
    %roi_dir: Directory to store (and load) ROIs
     roi_dir  = strcat('/Users/deafneuralplasticitylab/Documents/MATLAB/Data/ROI_freesurf/', 'sub-', subjs(s),'/' ); %***
     roi_dir  = char(roi_dir );    
     
    %  STC ROI file
    rlist{1} = strcat(TE10_dir,'wPM_te10_-50_-17_8_roi.mat'); %***
     
     % sujbect specific roi  
    rlist{2}=  char([strcat(roi_dir,'L_HerschlGyrus_1_roi.mat'),' ']);  %***

%makes the filenames the same size by padding the shorter one with spaces
rlist=pad(rlist);

%transforms the cell array intocharacter stringes

roilist=char(rlist);


roilist=maroi('load_cell',roilist); % roilist contains the 2 ROIs
    [Finter,Fgraph,CmdLine] = spm('FnUIsetup','Combine ROIs');
    func = ('r2 & r1');

    
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
    
    roi_filename=strcat(roi_dir,'/','Left_Te1.0','_roi','.mat'); %****
    
    
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
