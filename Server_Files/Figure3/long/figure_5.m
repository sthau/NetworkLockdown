pc = parcluster('local');
parpool_tmpdir = ['~/.matlab/local_cluster_jobs/R2019a/slurm_jobID_',getenv('SLURM_ARRAY_JOB_ID'),'_',getenv('SLURM_ARRAY_TASK_ID')]
mkdir(parpool_tmpdir)
pc.JobStorageLocation = parpool_tmpdir

parpool(pc,12)
%% Load graph and parameters
load("graph.mat")
load("parameters.mat")
x=x*ones(loc,1);
adapt_idx=ones(loc,1);
quarantine_type=3;
T = 3500;

%% Run process
infection_mat_2=zeros(count,T);
detection_mat_2=zeros(count,T);
recovered_mat_2=zeros(count,T);
q_idx_2=zeros(count,T);

qpp_2=zeros(count,1);
ipp_2=zeros(count,1);
req_2=zeros(count,1);

parfor kk=1:count
    tic
    rng(kk+partition*count)
    seed=seed_list(kk);
    [infection_mat,  detection_mat, recovered_mat, q_idx, ~]=...
    jurisdiction_policy_new(K, T, num, loc, types, q_mat, quarantine_type, alpha, theta, tau, x, G, R0,seed, adapt_idx);

    infection_mat_2(kk,:)=sum(infection_mat);
    detection_mat_2(kk,:)=sum(detection_mat);
    recovered_mat_2(kk,:)=sum(recovered_mat);
    q_idx_2(kk,:)=sum(q_idx);
    
    qpp_2(kk)=3500*sum(q_idx,'all');
    ipp_2(kk)=sum(infection_mat,'all');
    req_2(kk)=nnz(sum(q_idx,2)>theta);
    toc
    
end


%%
delete(gcp('nocreate'));
save('figure3B_output')
exit
