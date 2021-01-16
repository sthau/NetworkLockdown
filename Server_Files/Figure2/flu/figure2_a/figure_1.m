clear
clc

%% Load graph and parameters
load("graph.mat")
load("parameters.mat")

tau=0;
buffer=0;
eps=0;

%% Initialize
infection_mat_1=zeros(count,T);
detection_mat_1=zeros(count,T);
recovered_mat_1=zeros(count,T);
q_idx_1=zeros(count,T);
fails_1=zeros(count,1);

qpp_1=zeros(count,1);
ipp_1=zeros(count,1);
close_1=zeros(count,1);
search_1=zeros(count,1);

%% Run process
parfor kk=1:count
    tic
    rng(kk+partition*count)
    seed=seed_list(kk);
    [infection_mat,  detection_mat, recovered_mat, q_idx, fail_idx, q_ball_close, q_ball_check, ~]=...
        kx_policy_new(K, T, alpha, theta, tau, x, G, R0, radius, buffer,seed,eps);

    infection_mat_1(kk,:)=sum(infection_mat);
    detection_mat_1(kk,:)=sum(detection_mat);
    recovered_mat_1(kk,:)=sum(recovered_mat);
    q_idx_1(kk,:)=sum(q_idx);
    fails_1(kk)=fail_idx;
    
    qpp_1(kk)=sum(q_idx,'all');
    ipp_1(kk)=sum(infection_mat,'all');
    close_1(kk)=length(q_ball_close);
    search_1(kk)=length(q_ball_check);
    toc
end

fail_rate_1=sum(fails_1)/count;

save('figure2A_output')
exit



