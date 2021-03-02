%% 
clear
clc
rng(1234)

%% Parameters
loc=40; %number of regions
num=3500*ones(loc,1); %number of nodes per region
K=sum(num); %track number of nodes total

% Spherical points and distances
lat_max=90;
lat_min=-90;
lat = (lat_max-lat_min).*rand(loc,1) + lat_min;

long_max=180;
long_min=-180;
long = (long_max-long_min).*rand(loc,1) + long_min;

coords=[lat, long];
unit_sphere=referenceSphere('Unit Sphere');
unit_sphere_gc=@(p1,p2) distance('gc',p1,p2,unit_sphere);
d_mat=squareform(pdist(coords, unit_sphere_gc));


%% Cross group links
a=-4;
b=-15;
prob=@(x) exp(a+b*x);
q_mat=prob(d_mat);
q_mat=q_mat-diag(diag(q_mat));


%make types matrix
types=zeros(K,loc);
types(1:num(1),1)=1;
for ll=2:loc
    types(sum(num(1:ll-1))+1:sum(num(1:ll)),ll)=1;
end

G=spalloc(K,K,20*K);

start=cumsum(num)-num+1;
stop=cumsum(num);


tic
for kk=1:loc
    for ii=1:kk
        q_base=q_mat(ii,kk).*ones(length(start(ii):stop(ii)),length(start(kk):stop(kk)));
        G(start(ii):stop(ii),start(kk):stop(kk))=rand(length(start(ii):stop(ii)),length(start(kk):stop(kk)))<q_base;
    end
end
toc
G=triu(G)+triu(G)'-diag(diag(triu(G)));

% RGG and ER Hybrid graphs for each internal region
d=13.5; %average degree within region from RGG
d_within=15.5; %average degree within region

tic
for ll=1:loc
    %pick r
    r=sqrt(d/pi/num(ll));
    
    %pick prob of iid links
    prob=(d_within-d)/num(ll);
   
    %generate points in Euclidean space
    points=rand(num(ll),2);
    
    %Build RGG
    G_temp=zeros(num(ll),num(ll));
    for i=1:num(ll)
        for k=1:i
            dist=norm(points(i,:)-points(k,:));

            if dist < r
                G_temp(i,k)=1;
            end
        end
    end
    G_temp=G_temp+G_temp'-diag(diag(G_temp));

    % Add iid links to get correct degree
    G_temp=G_temp+(rand(num(ll),num(ll))<prob*ones(num(ll),num(ll)));
    %Add to main adjacency matrix
    G(start(ll):stop(ll),start(ll):stop(ll))=G_temp;
end
toc

% Add shortcuts
p_add=1/2/K; %chance of adding a link

%Add links
tic
for kk=1:loc
    for ii=1:kk
        G_add=rand(length(start(ii):stop(ii)),length(start(kk):stop(kk)))<p_add.*ones(length(start(ii):stop(ii)),length(start(kk):stop(kk)));
        G(start(ii):stop(ii),start(kk):stop(kk))=G(start(ii):stop(ii),start(kk):stop(kk))+G_add;
    end
end
toc

%Clean up
G=triu(G)+triu(G)'-diag(diag(triu(G)));
G(G>1)=1;
G=G-diag(diag(G));

% Add a hub region
hub=randi(loc);
idx=ones(loc,1);
idx(hub)=0;
frac_link=0.01;
p_hub_link=frac_link./(num);

for kk=1:loc
    if kk==hub
        continue
    end
    
    G_hub=rand(num(kk),num(hub))<p_hub_link(ll);
    
    G(start(kk):stop(kk),start(hub):stop(hub))=G(start(kk):stop(kk),start(hub):stop(hub))+G_hub;
    G(start(hub):stop(hub),start(kk):stop(kk))=G(start(hub):stop(hub),start(kk):stop(kk))+G_hub;

end

%clean up again
G(G>1)=1;
G=triu(G)+triu(G)'-diag(diag(triu(G)));
G=G-diag(diag(G));


% Rebuild connection probability matrix
q_mat=zeros(loc,loc);

for kk=1:loc
    for ll=1:kk
        q_mat(ll,kk)=sum(G(start(ll):stop(ll),start(kk):stop(kk)),'all')/(num(ll)*num(kk));
    end
end

q_mat=triu(q_mat)+triu(q_mat)'-diag(diag(q_mat));

q_mat = q_mat - diag(diag(q_mat)) + diag(diag(q_mat)*3500/3499);

%% Save Output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
save('graph.mat','G','num','loc','types','q_mat','K','start','stop');

%% Graph Stats %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Mean Degree
disp('Avg Degree')
mean(sum(G))

% Average rate of connection across groups
count=0;

f_vec=zeros(K,1);
for kk=1:K
    neigh=find(G(:,kk));
    
    if length(neigh)==0
        f_vec(kk)=0;
        continue
    end
    
    for nn=1:length(neigh)
        if find(types(kk,:)) ~= find(types(neigh(nn),:))
            count=count+1;
        end
    end
    f_vec(kk)=count/length(neigh);
    count=0;
end

disp('fraction across groups')
mean(f_vec)


%% Average path length and diameter
graph_test=graph(G);
num_check=40;
sample=randsample(40,num_check);

mean_list=zeros(length(sample),1);
diam_list=zeros(length(sample),1);

b=start;
e=stop;


parfor kk=1:length(sample)
   tic
   dist=distances(graph_test,b(sample(kk)):e(sample(kk)),1:K);
   mean_list(kk)=mean(dist(~isinf(dist)),'all');
   diam_list(kk)=max(max(dist(~isinf(dist))));
   toc
end


avg_path=mean(mean_list)
diameter=max(diam_list)


%
%% clustering
num_check=140000;
sample=randsample(K,num_check);

graph_test=graph(G);
deg=sum(G,2);
C=zeros(num_check,1);
edge_list=zeros(num_check,1);


parfor ii=1:num_check
    n=sample(ii);
    
    tic
    if deg(ii)==0 || deg(ii)==1
        C(ii)=0;
        continue
    end
    
    nodes=neighbors(graph_test,n);
    edges=numedges(subgraph(graph_test,nodes));
    
    edge_list(ii)=edges;
    C(ii)=edges/(deg(ii)*(deg(ii)-1));
    toc
end

disp('Average Local Clustering Coefficient')
mean(C)


%%
num_check=5000;
sample=randsample(K,num_check);
graph_test=graph(G);
size=zeros(num_check,1);
radius=5;
seed=randi(K,num_check,1);


for kk=1:num_check
    tic
    size(kk)=length(nearest(graph_test, seed(kk), radius));
    toc
end

mean(size)



