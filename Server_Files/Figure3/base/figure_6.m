pc = parcluster('local');
parpool_tmpdir = ['~/.matlab/local_cluster_jobs/R2019a/slurm_jobID_',getenv('SLURM_ARRAY_JOB_ID'),'_',getenv('SLURM_ARRAY_TASK_ID')]
mkdir(parpool_tmpdir)
pc.JobStorageLocation = parpool_tmpdir

parpool(pc,12)
%% Load graph and parameters
load("graph.mat")
load("parameters.mat")
quarantine_type=1;
T = 2500;

%% Run process
infection_mat_3=zeros(count,T);
detection_mat_3=zeros(count,T);
recovered_mat_3=zeros(count,T);
q_idx_3=zeros(count,T);

qpp_3=zeros(count,1);
ipp_3=zeros(count,1);
req_3=zeros(count,1);
high_3=zeros(count,1);

parfor kk=1:count
    tic
    rng(kk+partition*count)
    x=ones(loc,1);
    high_threshold=threshold_list(kk,:);
    x(high_threshold)=5;
    adapt_idx=ones(loc,1);
    
    seed=seed_list(kk);
    [infection_mat,  detection_mat, recovered_mat, q_idx, loc_infections]=...
    jurisdiction_policy_new(K, T, num, loc, types, q_mat, quarantine_type, alpha, theta, tau, x, G, R0,seed, adapt_idx);

    infection_mat_3(kk,:)=sum(infection_mat);
    detection_mat_3(kk,:)=sum(detection_mat);
    recovered_mat_3(kk,:)=sum(recovered_mat);
    q_idx_3(kk,:)=sum(q_idx);
    
    qpp_3(kk)=3500*sum(q_idx,'all');
    ipp_3(kk)=sum(infection_mat,'all');
    req_3(kk)=nnz(sum(q_idx,2)>theta);
    
    temp=sum(loc_infections,2);
    high_3(kk)=sum(temp(high_threshold))/sum(temp);
    toc
    
end

%%
delete(gcp('nocreate'))
save('figure3C_output')
exit
