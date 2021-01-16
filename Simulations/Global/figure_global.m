pc = parcluster('local');
parpool_tmpdir = ['~/.matlab/local_cluster_jobs/R2019a/slurm_jobID_',getenv('SLURM_JOB_ID')]
mkdir(parpool_tmpdir)
pc.JobStorageLocation = parpool_tmpdir

parpool(pc,4)
%% Load graph and parameters
load("graph.mat")
load("parameters.mat")

%% Parameter adjustments
quarantine_type=2;
adapt_idx=ones(loc,1);

%% Run process
infection_mat_5=zeros(count,T);
detection_mat_5=zeros(count,T);
recovered_mat_5=zeros(count,T);
q_idx_5=zeros(count,T);

qpp_5=zeros(count,1);
ipp_5=zeros(count,1);

parfor kk=1:count
    tic
    rng(kk+partition*count)
    seed=seed_list(kk);
    [infection_mat,  detection_mat, recovered_mat, q_idx, ~]=...
    jurisdiction_policy_new(K, T, num, loc, types, q_mat, quarantine_type, alpha, theta, tau, x, G, R0,seed, adapt_idx);

    infection_mat_5(kk,:)=sum(infection_mat);
    detection_mat_5(kk,:)=sum(detection_mat);
    recovered_mat_5(kk,:)=sum(recovered_mat);
    q_idx_5(kk,:)=sum(q_idx);
    
    qpp_5(kk)=3500*sum(q_idx,'all');
    ipp_5(kk)=sum(infection_mat,'all');
    toc
    
end

%%
save('global_output')
delete(gcp('nocreate'))
exit