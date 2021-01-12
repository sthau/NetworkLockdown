%%
clear
clc

load('figure3A_output.mat')
load('figure3C_output.mat')
load('figure3B_output.mat')
load('figure3D_output.mat')

%%
sum(infection_mat_1(:,1))
sum(infection_mat_1(:,end))

sum(infection_mat_2(:,1))
sum(infection_mat_2(:,end))

sum(infection_mat_3(:,1))
sum(infection_mat_3(:,end))

sum(infection_mat_4(:,1))
sum(infection_mat_4(:,end))

%%
[~,ind1] = min(infection_mat_1');
[~,ind2] = min(infection_mat_2');
[~,ind3] = min(infection_mat_3');
[~,ind4] = min(infection_mat_4');


%%
t = 250;
hist(q_idx_3(:,t))
hold on
xline(mean(q_idx_3(:,t)),'r')


