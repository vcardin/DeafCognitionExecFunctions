


% copy files
clear
dest_root='/Users/velia.cardin/OneDrive - University College London/Study1_Data/ForLera/';



source_root='/Users/velia.cardin/Documents/DeafCognition/Data';


%subj={'028';'042'; '107'; '114'; '122'; '129'; '131'};
subj={ '002';  '004'; '003'; '006';'008';'007'; '011';'013';'014'; '015';'016';'017';'018';'021';'023';'028';'031';'032';'041';'042'; '101';'103';'104';'106';'107';'108';'110';'111';...
    '114';  '115';'116'; '118'; '119'; '122';'123';'124'; '127';'129';'130';'131';'132';'133';'134';'135';'136'};


taskfolders={ 'toweroflondon'; 'workingmemory';'taskswitching'; 'simontask_run1'; 'simontask_run2';'taskswitching_run1';'taskswitching_run2'; 'workingmemory_run1';'workingmemory_run2';};


for i=1:size(subj,1)
    for t=1:size(taskfolders,1)
        %     destfolder=strcat(dest_root,'sub-',subj{i},'/anat/');
        destfolder=strcat(dest_root,'sub-',subj{i},'/funct/',taskfolders{t});
        
        
        
        %     source=strcat(source_root,'/sub-',subj{i},'/anat/');
        source=strcat(source_root,'/sub-',subj{i},'/funct/',taskfolders{t});
        
        if exist(source,'dir')==7
            
            try
                mkdir(destfolder)
            catch
            end
            sourcefiles=strcat(source,'/wars*45*.nii');
            %       txtfile=strcat(source,'*.mat')
            %copyfile(txtfile,destfolder)
            copyfile(sourcefiles,destfolder)
            
        else
            disp('did not work')
            disp(subj{i})
        end
        
        %
        % disp(sourcefiles)
        % disp(destfolder)
    end
end
