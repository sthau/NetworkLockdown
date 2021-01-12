clear
clc

%%
load('figure2A_outputa.mat')
load('figure2B_outputa.mat')
load('figure2D_outputa.mat')

infections_1=infection_mat_1;
detections_1=detection_mat_1;
recovered_1=recovered_mat_1;
 
infections_2=infection_mat_2;
detections_2=detection_mat_2;
recovered_2=recovered_mat_2;

infections_4=infection_mat_4;
detections_4=detection_mat_4;
recovered_4=recovered_mat_4;

fail_1=fail_rate_1;
fail_2=fail_rate_2;
fail_4=fail_rate_4;

qpp_1_out=qpp_1;
qpp_2_out=qpp_2;
qpp_4_out=qpp_4;

ipp_1_out=ipp_1;
ipp_2_out=ipp_2;
ipp_4_out=ipp_4;


load('figure2A_outputb.mat')
load('figure2B_outputb.mat')
load('figure2D_outputb.mat')

infections_1=[infection_mat_1; infections_1];
detections_1=[detection_mat_1; detections_1];
recovered_1=[recovered_mat_1; recovered_1];

infections_2=[infection_mat_2; infections_2];
detections_2=[detection_mat_2; detections_2];
recovered_2=[recovered_mat_2; recovered_2];

infections_4=[infection_mat_4; infections_4];
detections_4=[detection_mat_4; detections_4];
recovered_4=[recovered_mat_4; recovered_4];

qpp_1_out=[qpp_1; qpp_1_out];
qpp_2_out=[qpp_2; qpp_2_out];
qpp_4_out=[qpp_4; qpp_4_out];

ipp_1_out=[ipp_1; ipp_1_out];
ipp_2_out=[ipp_2; ipp_2_out];
ipp_4_out=[ipp_4; ipp_4_out];


infection_mat_1=infections_1;
infection_mat_2=infections_2;
infection_mat_4=infections_4;

detection_mat_1=detections_1;
detection_mat_2=detections_2;
detection_mat_4=detections_4;

recovered_mat_1=recovered_1;
recovered_mat_2=recovered_2;
recovered_mat_4=recovered_4;

fail_rate_1=0.5*(fail_rate_1+fail_1);
fail_rate_2=0.5*(fail_rate_2+fail_2);
fail_rate_4=0.5*(fail_rate_4+fail_4);

ipp_1=ipp_1_out;
ipp_2=ipp_2_out;
ipp_4=ipp_4_out;

qpp_1=qpp_1_out;
qpp_2=qpp_2_out;
qpp_4=qpp_4_out;


save('figure2A_output','infection_mat_1','detection_mat_1','recovered_mat_1','ipp_1','qpp_1','K','x','alpha','theta','tau', 'fail_rate_1')
save('figure2B_output','infection_mat_2','detection_mat_2','recovered_mat_2','ipp_2','qpp_2','K','x','alpha','theta','tau','fail_rate_2')
save('figure2D_output','infection_mat_4','detection_mat_4','recovered_mat_4','ipp_4','qpp_4','K','x','alpha','theta','tau','fail_rate_4')



