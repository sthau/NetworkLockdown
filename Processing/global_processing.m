clear
clc

%%

load('global_outputa.mat')
det_mat_out_5=detection_mat_5;
infect_mat_out_5=infection_mat_5;
rec_mat_out_5=recovered_mat_5;
q_idx_out_5=q_idx_5;
ipp_out_5=ipp_5;
qpp_out_5=qpp_5;

load("global_outputb.mat")
det_mat_out_5=[det_mat_out_5;detection_mat_5];
infect_mat_out_5=[infect_mat_out_5;infection_mat_5];
rec_mat_out_5=[rec_mat_out_5;recovered_mat_5];
q_idx_out_5=[q_idx_out_5;q_idx_5];
ipp_out_5=[ipp_out_5;ipp_5];
qpp_out_5=[qpp_out_5;qpp_5];



detection_mat_5=det_mat_out_5;
infection_mat_5=infect_mat_out_5;
recovered_mat_5=rec_mat_out_5;
q_idx_5=q_idx_out_5;
ipp_5=ipp_out_5;
qpp_5=qpp_out_5;

save('global_output','detection_mat_5','infection_mat_5','recovered_mat_5','q_idx_5', 'ipp_5','qpp_5')


