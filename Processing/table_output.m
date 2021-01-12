%%
clear
clc

%%
load('figure2A_output.mat')
load('figure2B_output.mat')
load('figure2D_output.mat')

% percent infected
A_pct = mean(recovered_mat_1(:,end))*100/140000;
B_pct = mean(recovered_mat_2(:,end))*100/140000;
D_pct = mean(recovered_mat_4(:,end))*100/140000;

% mean qpp
format shortG
A_qpp = mean(qpp_1)/140000*1000000;
B_qpp = mean(qpp_2)/140000*1000000;
D_qpp = mean(qpp_4)/140000*1000000;


% mean ipp
format shortG
A_ipp = mean(ipp_1)/140000*1000000;
B_ipp = mean(ipp_2)/140000*1000000;
D_ipp = mean(ipp_4)/140000*1000000;

% output string
strcat("&", num2str(round(A_pct,4)), '&', num2str(round(A_ipp,2)), '&', num2str(round(A_qpp, 2)), '&', num2str(round(fail_rate_1,3)))
strcat("&",num2str(round(B_pct,3)), '&', num2str(round(B_ipp,2)), '&', num2str(round(B_qpp, 2)), '&', num2str(round(fail_rate_2,3)))
strcat("&",num2str(round(D_pct,3)), '&', num2str(round(D_ipp,2)), '&', num2str(round(D_qpp, 2)), '&', num2str(round(fail_rate_4,3)))

%% 
clear 
clc
load("global_output.mat")
pct = mean(recovered_mat_5(:,end))*100/140000;
qpp = mean(qpp_5)/140000*1000000;
ipp = mean(ipp_5)/140000*1000000;

strcat("&", num2str(round(pct,4)), '&', num2str(round(ipp,2)), '&', num2str(round(qpp, 2)))

%%
clear
clc
load('figure3A_output.mat')
load('figure3B_output.mat')
load('figure3C_output.mat')
load('figure3D_output.mat')

A_pct = mean(recovered_mat_1(:,end))*100/140000;
B_pct = mean(recovered_mat_2(:,end))*100/140000;
C_pct = mean(recovered_mat_3(:,end))*100/140000;
D_pct = mean(recovered_mat_4(:,end))*100/140000;

% mean qpp
format shortG
A_qpp = mean(qpp_1)/140000*1000000;
B_qpp = mean(qpp_2)/140000*1000000;
C_qpp = mean(qpp_4)/140000*1000000;
D_qpp = mean(qpp_4)/140000*1000000;


% mean ipp
format shortG
A_ipp = mean(ipp_1)/140000*1000000;
B_ipp = mean(ipp_2)/140000*1000000;
C_ipp = mean(ipp_3)/140000*1000000;
D_ipp = mean(ipp_4)/140000*1000000;

%frac requarantined
A_req = mean(req_1)/40;
B_req = mean(req_2)/40;
C_req = mean(req_3)/40;
D_req = mean(req_4)/40;

%high threshold
C_high = 1-mean(high_3);
D_high = 1- mean(high_4);

strcat("&", num2str(round(A_pct,2)), '&', num2str(round(A_ipp,2)), '&', num2str(round(A_qpp, 2)), '&', num2str(round(A_req,3)))
strcat("&",num2str(round(B_pct,2)), '&', num2str(round(B_ipp,2)), '&', num2str(round(B_qpp, 2)), '&', num2str(round(B_req,3)))
strcat("&",num2str(round(C_pct,2)), '&', num2str(round(C_ipp,2)), '&', num2str(round(C_qpp, 2)), '&', num2str(round(C_req,3)), "&", num2str(round(C_high, 3)))
strcat("&",num2str(round(D_pct,2)), '&', num2str(round(D_ipp,2)), '&', num2str(round(D_qpp, 2)), '&', num2str(round(D_req,3)), "&", num2str(round(D_high, 3)))



