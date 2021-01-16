pc = parcluster('local');
parpool_tmpdir = ['~/.matlab/local_cluster_jobs/R2019a/slurm_jobID_',getenv('SLURM_ARRAY_JOB_ID'),'_',getenv('SLURM_ARRAY_TASK_ID')]
mkdir(parpool_tmpdir)
pc.JobStorageLocation = parpool_tmpdir

parpool(pc,12)
%% Load graph and parameters
load("graph.mat")
load("parameters.mat")

%% Specific Paremeters
x=x*ones(loc,1);
adapt_idx=ones(loc,1);
T = 2500;

%% Run process
quarantine_type=1;
infection_mat_1=zeros(count,T);
detection_mat_1=zeros(count,T);
recovered_mat_1=zeros(count,T);
q_idx_1=zeros(count,T);

qpp_1=zeros(count,1);
ipp_1=zeros(count,1);
req_1=zeros(count,1);

parfor kk=1:count
    tic
    rng(kk+partition*count)
    seed=seed_list(kk);
    [infection_mat,  detection_mat, recovered_mat, q_idx, ~]=...
    jurisdiction_policy_new(K, T, num, loc, types, q_mat, quarantine_type, alpha, theta, tau, x, G, R0,seed, adapt_idx);

    infection_mat_1(kk,:)=sum(infection_mat);
    detection_mat_1(kk,:)=sum(detection_mat);
    recovered_mat_1(kk,:)=sum(recovered_mat);
    q_idx_1(kk,:)=sum(q_idx);
    
    qpp_1(kk)=3500*sum(q_idx,'all');
    ipp_1(kk)=sum(infection_mat,'all');
    req_1(kk)=nnz(sum(q_idx,2)>theta);
    toc
    
end


%%
delete(gcp('nocreate'));
save('figure3A_output')
exit