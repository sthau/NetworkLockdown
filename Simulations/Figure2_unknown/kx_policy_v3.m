function [infection_mat,  detection_mat, recovered_mat, q_idx, fail_idx, dist_list]=...
    kx_policy_v3(K, T, alpha, theta, tau, x, G, R0, radius, buffer,eps, seed)

%set transimission probability
p=1-(1-R0/mean(sum(G)))^(1/theta);

%initialize observed graph
obs_graph=graph(G);

%infection tracker
infection_mat=zeros(K,T);
infection_mat(seed, 1)=1; %set seed

%detection trackers and output
detection_mat=zeros(K,T);
detectable=zeros(K,T);

%recovery trackers
recovered_mat=zeros(K,T); 
recovered_mat(seed, theta+1:end)=1;

%quarantine trackers
q_left=zeros(K,1);
q_idx=zeros(K,T);
quarantine=zeros(K,1);

%indicators for initial quarantine having triggered
initial_quarantine_idx=0;
initial_quarantine_t=0;

%indicator for intial failure
fail_idx=0;

%quarantine radius
q_radius=radius+buffer+1;


%enforcement
enforce=rand(K,1)>eps; %1 is follow the rules, 0 is cannot be locked down

%set up
G_current=G;

%assign to avoid errors
dist_list = -1;


%run main process
for tt=2:T
    
   %detections 
   test=rand(K,1)<alpha;
   detection=test.*detectable(:,tt);
   detection_mat(logical(detection),tt:tt+theta-tau-1)=1;
   
   % Decide if you need to quarantine tomorrow based on yesterday's tests
   % initial trigger
   if sum(detection_mat(:,tt))>=x  && initial_quarantine_idx==0
        %find all nodes within radius based on observed graph
        detected_list = find(detection_mat(:,tt));
        dist_list = mean(distances(obs_graph,find(detection_mat(:,tt)), find(detection_mat(:,tt))),2);
        min_dist = min(dist_list);
        idx = randsample(find(dist_list == min_dist),1);
        est_seed = detected_list(idx);
        
        q_ball_close=nearest(obs_graph, est_seed, q_radius);
        q_ball_close=[q_ball_close; est_seed];
        
        quarantine(q_ball_close)=1;
        q_left(q_ball_close)=theta;

        initial_quarantine_idx=1;
        initial_quarantine_t=tt;
      
    end
    
    % if the intial trigger has happened, it's the next period, and there
    % was containment failure implement the repeated quarantining if needed
    if initial_quarantine_idx==1  && tt>initial_quarantine_t && isempty(setdiff(find(detection_mat(:,tt)), find(q_idx(:,tt))))==0
        %compare most recent detections to currently quarantined
        escaped=setdiff(find(detection_mat(:,tt)),find(q_idx(:,tt)));
                        
        for ii=1:length(escaped)
            %nodes within  radius of newly detected infections that are not
            %quarantined this period will be quarantined next period
            new_q=setdiff(nearest(obs_graph, escaped(ii), q_radius), find(q_idx(:,tt)));            
            new_q=[new_q; escaped(ii)];
            
            q_left(new_q)=theta;
            quarantine(new_q)=1;
        end
    end
            
    %new infections+old infections
    active=sprand(G_current)<(p.*G_current);
    new_infections=(G_current.*active)*infection_mat(:,tt-1); 
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
   
    %if not already a failure, check to see if the infection has spread
    %beyond the inital quarantine radius
    if fail_idx==0 && initial_quarantine_idx==1
        farthest=max(max(distances(obs_graph, est_seed, find(infection_mat(:,tt)))));
        
        if farthest>q_radius
            fail_idx=1;
        end
    end
    
    %quarantines begin or end
    %reset
    G_current=G;
    
    %nodes with quarantines left are quarantined
    G_current(logical(quarantine.*enforce),:)=0;
    G_current(:,logical(quarantine.*enforce))=0; 
    
    %what nodes were quarantined at time t
    q_idx(:,tt+1)=quarantine.*enforce;
   
    %quarantine days left updated
    q_left=q_left-ones(K,1);
    q_left(q_left<0)=0;
    quarantine(q_left==0)=0;
    
    %break if no infections and no quarantines
    if sum(q_idx(:,tt))==0 && sum(infection_mat(:,tt))==0
        infection_mat(:,tt+1:T)=0;
        detection_mat(:,tt+1:T)=0;
        recovered_mat(:,tt+1:T)=recovered_mat(:,tt).*ones(K,length(tt+1:T));
        q_idx(:,tt+1:T)=0;
        break
    end

end

infection_mat(:,T+1:end)=[];
detection_mat(:,T+1:end)=[];
recovered_mat(:,T+1:end)=[];
q_idx(:,T+1:end)=[];





