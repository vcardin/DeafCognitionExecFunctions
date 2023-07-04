
clear
% load('ConnectivityValuesToL_Only.mat')
% load('ConnectivityValuesRest.mat')
load('ConnectivityValues_ToL_and_rest.mat')
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
    
    
    if contains(names{i},'tol_task')
        if contains(names{i},'Task') & ~contains(names{i},'TN') & ~contains(names{i},'STC')
            tol_TP(:,c1)=data(:,i);
            tol_TP_names{c1}=names{i};
            c1=c1+1;
            
        elseif contains(names{i},'TN') & ~contains(names{i},'Task')  & ~contains(names{i},'STC')
            
            tol_TN(:,c2)=data(:,i);
            tol_TN_names{c2}=names{i};
            c2=c2+1;
            
        elseif contains(names{i},'TN') & contains(names{i},'Task')
            tol_inter(:,c3)=data(:,i);
            tol_inter_names{c3}=names{i};
            c3=c3+1;
        end
        
    elseif contains(names{i},'tol_ctr')
        
        if contains(names{i},'Task') & ~contains(names{i},'TN') & ~contains(names{i},'STC')
                    ctrtol_TP(:,c4)=data(:,i);
            ctrtol_TP_names{c4}=names{i};
            c4=c4+1;

        elseif contains(names{i},'TN') & ~contains(names{i},'Task')  & ~contains(names{i},'STC')
            
            ctrtol_TN(:,c5)=data(:,i);
            ctrtol_TN_names{c5}=names{i};
            c5=c5+1;
            
        elseif contains(names{i},'TN') & contains(names{i},'Task')
                ctrtol_inter(:,c6)=data(:,i);
            ctrtol_inter_names{c6}=names{i};
            c6=c6+1;
            
        end
        
    end
    
end
 meanTolAll= [mean(tol_TP,2) , mean(ctrtol_TP,2), mean(tol_TN,2)  ,mean(ctrtol_TN,2) ,  mean( tol_inter,2) ,mean(ctrtol_inter,2)    ]

%counters
c1=1;c2=1;
c3=1;c4=1;c5=1;c6=1;






for i = 1:numel(names)
    
    
    if contains(names{i},'rest_hf')
        if contains(names{i},'Task') & ~contains(names{i},'TN') & ~contains(names{i},'STC')
            rest_TP(:,c1)=data(:,i);
            rest_TP_names{c1}=names{i};
            c1=c1+1;
            
        elseif contains(names{i},'TN') & ~contains(names{i},'Task')  & ~contains(names{i},'STC')
            
            rest_TN(:,c2)=data(:,i);
            rest_TN_names{c2}=names{i};
            c2=c2+1;
            
        elseif contains(names{i},'TN') & contains(names{i},'Task')
            rest_inter(:,c3)=data(:,i);
            rest_inter_names{c3}=names{i};
            c3=c3+1;
        end
    end
end

meanRest=[mean(rest_TP,2) , mean(rest_TN,2) , mean( rest_inter,2)    ];


% % Deaf group mean values
%  D_tol_TP=mean(tol_TP(21:45,:),2);
%  D_tol_TP(isnan(D_tol_TP))=[];
%   D_ctrtol_TP = mean(ctrtol_TP(21:45,:),2);
%  D_ctrtol_TP(isnan(D_ctrtol_TP))=[];
%  
%  D_ctrtol_inter = mean(ctrtol_inter(21:45,:),2);
%  D_ctrtol_inter(isnan(D_ctrtol_inter))=[];
%  
%   H_tol_TP=mean(tol_TP(1:20,:),2);
%  H_tol_TP(isnan(H_tol_TP))=[];
%   H_ctrtol_TP = mean(ctrtol_TP(1:20,:),2);
%  H_ctrtol_TP(isnan(H_ctrtol_TP))=[];
%  
%  H_ctrtol_inter = mean(ctrtol_inter(1:20,:),2);
%  H_ctrtol_inter(isnan(H_ctrtol_inter))=[];
 
 