clear
clc

%% Load graph and parameters
load("graph.mat")
load("parameters.mat")

buffer=0;
eps=0;

%% Initialize
infection_mat_2=zeros(count,T);
detection_mat_2=zeros(count,T);
recovered_mat_2=zeros(count,T);
q_idx_2=zeros(count,T);
fails_2=zeros(count,1);

qpp_2=zeros(count,1);
ipp_2=zeros(count,1);

%% Run process
parfor kk=1:count
    tic
    rng(kk+partition*count)
    seed=seed_list(kk);
    [infection_mat,  detection_mat, recovered_mat, q_idx, fail_idx, ~]=...
    kx_policy_v3(K, T, alpha, theta, tau, x, G, R0, radius, buffer,eps, seed);

    infection_mat_2(kk,:)=sum(infection_mat);
    detection_mat_2(kk,:)=sum(detection_mat);
    recovered_mat_2(kk,:)=sum(recovered_mat);
    q_idx_2(kk,:)=sum(q_idx);
    fails_2(kk)=fail_idx;
    
    qpp_2(kk)=sum(q_idx,'all');
    ipp_2(kk)=sum(infection_mat,'all');
    toc
end

fail_rate_2=sum(fails_2)/count;

save('figure2B_output')
exit



