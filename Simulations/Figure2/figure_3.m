pc = parcluster('local');
parpool_tmpdir = ['~/.matlab/local_cluster_jobs/R2019a/slurm_jobID_',getenv('SLURM_ARRAY_JOB_ID'),'_',getenv('SLURM_ARRAY_TASK_ID')]
mkdir(parpool_tmpdir)
pc.JobStorageLocation = parpool_tmpdir

parpool(pc,12)
%% Load graph and parameters
load("graph.mat")
load("parameters.mat")

buffer=0;
eps=0.05;

%% Initialize
infection_mat_4=zeros(count,T);
detection_mat_4=zeros(count,T);
recovered_mat_4=zeros(count,T);
q_idx_4=zeros(count,T);
fails_4=zeros(count,1);

qpp_4=zeros(count,1);
ipp_4=zeros(count,1);
close_4=zeros(count,1);
search_4=zeros(count,1);

%% Run process
parfor kk=1:count
    tic
    rng(kk+partition*count)
    seed=seed_list(kk);
    [infection_mat,  detection_mat, recovered_mat, q_idx, fail_idx, q_ball_close, q_ball_check, enforce]=...
        kx_policy_new(K, T, alpha, theta, tau, x, G, R0, radius, buffer,seed,eps);
    
    infection_mat_4(kk,:)=sum(infection_mat);
    detection_mat_4(kk,:)=sum(detection_mat);
    recovered_mat_4(kk,:)=sum(recovered_mat);
    q_idx_4(kk,:)=sum(q_idx);
    fails_4(kk)=fail_idx;
    
    qpp_4(kk)=sum(enforce.*q_idx,'all');
    ipp_4(kk)=sum(infection_mat,'all');
    close_4(kk)=length(q_ball_close);
    search_4(kk)=length(q_ball_check);
    toc
end

fail_rate_4=sum(fails_4)/count;

save('figure2D_output')
exit



