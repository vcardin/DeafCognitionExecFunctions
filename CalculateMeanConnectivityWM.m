
clear
load('ConnectivityValues.mat')
% Iterate over each element in the cell array
for i = 1:numel(names)
    % Check if the element is equal to 'Cluster'
    
    % Replace 'Cluster' with 'c'
    names{i} =erase(names{i},'connectivity between');
    names{i} =erase(names{i},'Cluster');
    names{i} =erase(names{i},'Fox');
end


%counters
c1=1;c2=1;
c3=1;c4=1;c5=1;c6=1;

for i = 1:numel(names)
    
    
    if contains(names{i},'wm_task')
        if contains(names{i},'Task') & ~contains(names{i},'TN') & ~contains(names{i},'STC')
            wm_TP(:,c1)=data(:,i);
            wm_TP_names{c1}=names{i};
            c1=c1+1;
            
        elseif contains(names{i},'TN') & ~contains(names{i},'Task')  & ~contains(names{i},'STC')
            
            wm_TN(:,c2)=data(:,i);
            wm_TN_names{c2}=names{i};
            c2=c2+1;
            
        elseif contains(names{i},'TN') & contains(names{i},'Task')
            wm_inter(:,c3)=data(:,i);
            wm_inter_names{c3}=names{i};
            c3=c3+1;
        end
        
    elseif contains(names{i},'wm_ctr')
        
        if contains(names{i},'Task') & ~contains(names{i},'TN') & ~contains(names{i},'STC')
                    ctrwm_TP(:,c4)=data(:,i);
            ctrwm_TP_names{c4}=names{i};
            c4=c4+1;

        elseif contains(names{i},'TN') & ~contains(names{i},'Task')  & ~contains(names{i},'STC')
            
            ctrwm_TN(:,c5)=data(:,i);
            ctrwm_TN_names{c5}=names{i};
            c5=c5+1;
            
        elseif contains(names{i},'TN') & contains(names{i},'Task')
                ctrwm_inter(:,c6)=data(:,i);
            ctrwm_inter_names{c6}=names{i};
            c6=c6+1;
            
        end
        
    end
    
end

% % Deaf group mean values
%  D_wm_TP=mean(wm_TP(21:45,:),2);
%  D_wm_TP(isnan(D_wm_TP))=[];
%   D_ctrwm_TP = mean(ctrwm_TP(21:45,:),2);
%  D_ctrwm_TP(isnan(D_ctrwm_TP))=[];
%  
%  D_ctrwm_inter = mean(ctrwm_inter(21:45,:),2);
%  D_ctrwm_inter(isnan(D_ctrwm_inter))=[];
%  
%   H_wm_TP=mean(wm_TP(1:20,:),2);
%  H_wm_TP(isnan(H_wm_TP))=[];
%   H_ctrwm_TP = mean(ctrwm_TP(1:20,:),2);
%  H_ctrwm_TP(isnan(H_ctrwm_TP))=[];
%  
%  H_ctrwm_inter = mean(ctrwm_inter(1:20,:),2);
%  H_ctrwm_inter(isnan(H_ctrwm_inter))=[];
 
  [mean(wm_TP,2) , mean(ctrwm_TP,2), mean(wm_TN,2)  ,mean(ctrwm_TN,2) ,  mean( wm_inter,2) ,mean(ctrwm_inter,2)    ]
 