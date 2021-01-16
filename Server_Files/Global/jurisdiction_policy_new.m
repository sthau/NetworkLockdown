function [infection_mat,  detection_mat, recovered_mat, q_idx, real_infection_archive]=...
    jurisdiction_policy_new(K, T, num, loc, types, q_mat, quarantine_type, alpha, theta, tau, x, G, R0,seed, adapt_idx)

%set transimission probability
p=1-(1-R0/mean(sum(G)))^(1/theta);

%infection tracker
infection_mat=zeros(K,T);
infection_mat(seed, 1)=1; %set seed
loc_infections=zeros(loc,1);
real_infection_archive=zeros(loc,T);
real_infect=zeros(loc,1);

%detection trackers and output
detection_mat=zeros(K,T);
detectable=zeros(K,T);

%recovery trackers
recovered_mat=zeros(K,T); 
recovered_mat(seed, theta+1:end)=1;

%quarantine trackers
q_left=zeros(loc,1);
q_idx=zeros(loc,T);
quarantine=zeros(loc,1);

%trackers for adaptive
w_archive=zeros(loc,T);
rec=zeros(loc,T);
new=zeros(loc,1);
detected_vec = zeros(loc, 1);

G_current=G;

q_left_archive=zeros(loc,T);

%run main process
for tt=2:T
   %detections 
   test=rand(K,1)<alpha;
   detection=test.*detectable(:,tt);
   detection_mat(logical(detection),tt:tt+theta-tau-1)=1;
   
   % Decide if you need to quarantine tomorrow
   %check for new quarantines
    if quarantine_type==1        
        
        for ll=1:loc
            %find cases in each region from last period
            type=find(types(:,ll));
            loc_infections(ll)=sum(detection_mat(type,tt));
            real_infect(ll)=sum(infection_mat(type,tt-1));
            
            if loc_infections(ll) >= x(ll) && q_idx(ll,tt)==0
                %find infections in region equal or exceed threhold
                %and not already on quarantine, set quarantine days left to
                %theta and turn on quarantine indicator
                q_left(ll)=theta;
                quarantine(ll)=1;
                
            end      
        end
    
        real_infection_archive(:,tt)=real_infect;
        
    elseif quarantine_type==2
        if sum(detection_mat(:,tt))>=x && sum(q_idx(:,tt))<1
            q_left=theta*ones(loc,1);
            quarantine=ones(loc,1);
        end
        
    elseif quarantine_type==3
        %find detected cases in each region from last period
        for ll=1:loc
            type=find(types(:,ll));
            detected_vec(ll)=sum(detection_mat(type,tt));
            real_infect(ll)=sum(infection_mat(type,tt-1));
        end
        
        real_infection_archive(:,tt)=real_infect;

        %track recoveries
        if tt-theta-1>0
            rec(:,tt)=w_archive(:,tt-theta)-w_archive(:,tt-theta-1)+rec(:,tt-theta);
        else
             rec(:,tt)=0;
        end

        %remove quarantined regions from calculation
        mat=q_mat;
        mat(:,logical(q_idx(:,tt-1)))=0;
        mat(logical(q_idx(:,tt-1)),:)=0;

        %calculate expected new infectiosn
        new=p*(mat.*repelem(num', loc,1))*w_archive(:,tt-1).*(1-q_idx(:,tt));
        
        %caculate w value and take max vs observed infections
        w_val=max([(w_archive(:,tt-1)+new-rec(:,tt)).*adapt_idx,detected_vec],[],2);
        
        w_val(w_val<0.01)=0;
        w_archive(:,tt)=w_val;
        
        for ll=1:loc
            if w_archive(ll,tt)>=x(ll) && q_idx(ll,tt)==0
                q_left(ll)=theta;
                quarantine(ll)=1;
            end
        end
        
    end
            
    %new infections+old infections
    new_infections=(G_current.*(sprand(G_current)<(p.*G_current)))*infection_mat(:,tt-1); 
    current_infections=new_infections+infection_mat(:,tt-1);
    
    %set multiple infections to 1
    current_infections(current_infections>1)=1; 
    new_infections(new_infections>1)=1;
    
    %already recovered nodes not infected
    new_infections(recovered_mat(:,tt)==1)=0;
    current_infections(recovered_mat(:,tt)==1)=0; 
    
    %record current infections
    infection_mat(:,tt)=current_infections;
               
    %set detection period for newly infected nodes
    detectable(logical(new_infections),tt+tau+1)=1;
    

    %set recoveries for newly infected nodes
    recovered_mat(logical(new_infections),tt+theta:end)=1;
    
    %quarantines begin or end
    %reset
    G_current=G;
    
    %regions with quarantines left are quarantined
    for ll=1:loc
        if q_left(ll)>0      
            type=find(types(:,ll));
            
            %remove all links in quarantined regions
            G_current(type,:)=0;
            G_current(:,type)=0;
        end
    end
    
    %what nodes were quarantined at time t
    q_idx(:,tt+1)=quarantine;
    q_left_archive(:,tt)=q_left;
   
    %quarantine days left updated
    q_left=q_left-ones(loc,1);
    q_left(q_left<0)=0;
    quarantine(q_left==0)=0;
    
    %break if no infections and no quarantines
    if sum(q_idx(:,tt+1))==0 && sum(infection_mat(:,tt))==0 
        infection_mat(:,tt+1:T)=0;
        detection_mat(:,tt+1:T)=0;
        recovered_mat(:,tt+1:T)=recovered_mat(:,tt).*ones(K,length(tt+1:T));
        q_idx(:,tt+1:T)=0;
        break
    end

end

recovered_mat(:,T+1:end)=[];
infection_mat(:,T+1:end)=[];
detection_mat(:,T+1:end)=[];
q_idx(:,T+1:end)=[];
real_infection_archive(:,T+1:end)=[];

