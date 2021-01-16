%%
clear
clc
rng(1234)

%%
%Generate tree
layers=5;
children=3;
K=sum(children.^[0:layers-1]);

G_tree=zeros(K,K);

for k=1:sum(children.^[0:layers-2])
    G_tree(k,2+(k-1)*children:1+(k)*children)=1;
end

G_tree=G_tree+G_tree';

%generate line
llen=layers+1;
G_line = zeros(llen,llen); % empty graph

for k=1:llen-1
   G_line(k,k+1)=1;
end

G_line=G_line+G_line';

%combine tree and line
G=zeros(length(G_line)+length(G_tree),length(G_line)+length(G_tree));
G(1:length(G_line),1:length(G_line))=G_line;
G(length(G_line)+1:end,length(G_line)+1:end)=G_tree;
G(length(G_line),length(G_line)+1)=1;
G(length(G_line)+1,length(G_line))=1;
nodes=length(G);


%% highlights failure
undetected=zeros(nodes, 1);
undetected(1:6)=1;
undetected=logical(undetected);

detected=zeros(nodes, 1);
detected=logical(detected);

figure
plot_graph=graph(G);
p1=plot(plot_graph);
layout(p1,'layered')
labelnode(p1,1:length(G),'')
labelnode(p1,6,'i0')
p1.NodeFontSize=18
highlight(p1,undetected,'nodecolor','g')
highlight(p1,detected,'nodecolor','r')
highlight(p1,1:nodes,'MarkerSize',5)
set(gca,'Visible','off')

hold on
yline(10.5,'--','Quarantine Radius','FontSize',16)
yline(1.5,'--','Quarantine Radius','FontSize',16)

hold on;                                      
ax=plot(NaN,NaN,'ob',NaN,NaN,'og',NaN,NaN,'or'); 
legend(ax,'Suceptible','Undetected Infections','Detected Infections');
legend('FontSize',18)
legend('Location','NorthWest')
legend boxoff
x0=10;
y0=10;
width=800;
height=800;
set(gcf,'position',[x0,y0,width,height])


%% success
figure 
undetected(1:2)=0;
undetected(7:11)=1;
undetected(13:15)=1;
undetected(17)=1;
undetected(21)=1;
undetected(27:31)=1;
undetected(34)=1;
undetected(39)=1;
undetected(37)=1;

detected(5)=1;
detected(7)=1;
detected(13)=1;
plot_graph=graph(G);
p1=plot(plot_graph);
layout(p1,'layered')
labelnode(p1,1:length(G),'')
labelnode(p1,6,'i0')
p1.NodeFontSize=18
highlight(p1,undetected,'nodecolor','g')
highlight(p1,detected,'nodecolor','r')
highlight(p1,1:nodes,'MarkerSize',5)
set(gca,'Visible','off')

hold on
yline(10.5,'--','Quarantine Radius','FontSize',16)
yline(1.5,'--','Quarantine Radius','FontSize',16)

hold on;                                      
ax=plot(NaN,NaN,'ob',NaN,NaN,'og',NaN,NaN,'or'); 
legend(ax,'Suceptible','Undetected Infections','Detected Infections'); 
legend('FontSize',18)
legend('Location','NorthWest')
legend boxoff

x0=10;
y0=10;
width=800;
height=800;
set(gcf,'position',[x0,y0,width,height])

%% 
clear
clc
rng(1234)


% Generate Graph
loc=3;
n=45;

K=n*loc;
r=0.44;
i0=randi(K);

points(1:n,1)=rand(n,1);
points(1:n,2)=rand(n,1);

points(n+1:2*n,1)=2+rand(n,1);
points(n+1:2*n,2)=rand(n,1);

points(2*n+1:3*n,1)=0.75+rand(n,1);
points(2*n+1:3*n,2)=2+rand(n,1);





for i=1:K
    for k=1:i
        dist=norm(points(i,:)-points(k,:));
                
        if dist < r
            G(i,k)=1;
        end
    end
end
G=G+G'-2*eye(K);
G(26,58)=1;
G(58,26)=1;
G(58,127)=1;
G(127,58)=1;

graph_r=graph(G);

dist_r=distances(graph_r,i0);
dist1=dist_r==1;
dist2=dist_r==2;
dist3=dist_r==3;
dist4=dist_r==4;



% rewire
G_old=G;
G(26,58)=0;
G(58,26)=0;
G(127,26)=1;
G(26,127)=1;

graph_n=graph(G);

dist_n=distances(graph_n,i0);
dist1_n=dist_n==1;
dist2_n=dist_n==2;
dist3_n=dist_n==3;
dist4_n=dist_n==4;


figure
p1=plot(graph_r)
highlight(p1,dist1,'NodeColor','g')
highlight(p1,dist2,'NodeColor','b')
highlight(p1,dist3,'NodeColor','m')
highlight(p1,dist4,'NodeColor','k')
highlight(p1,1:K,'MarkerSize',5)
highlight(p1,i0,'MarkerSize',10)
highlight(p1,i0,'NodeColor','r')
p1.NodeLabel={};
p1.XData=points(:,1);
p1.YData=points(:,2);
%set(gca, 'visible', 'off');
title('Initial Graph','FontSize',16)

hold on
ax=plot(NaN,NaN,'og',NaN,NaN,'ob',NaN,NaN,'om',NaN,NaN,'ok',NaN,NaN,'or'); 
legend(ax,'Distance 1','Distance 2','Distance 3','Distance 4','i_0'); 
legend('FontSize',14)
legend('Location','EastOutside')

figure
p2=plot(graph_n)
highlight(p2,dist1_n,'NodeColor','g')
highlight(p2,dist2_n,'NodeColor','b')
highlight(p2,dist3_n,'NodeColor','m')
highlight(p2,dist4_n,'NodeColor','k')
highlight(p2,1:K,'MarkerSize',5)
highlight(p2,i0,'MarkerSize',10)
highlight(p2,i0,'NodeColor','r')
p2.NodeLabel={};
p2.XData=points(:,1);
p2.YData=points(:,2);
%set(gca, 'visible', 'off');
title('Rewired Graph','FontSize',16)

hold on
ax=plot(NaN,NaN,'og',NaN,NaN,'ob',NaN,NaN,'om',NaN,NaN,'ok',NaN,NaN,'or'); 
legend(ax,'Distance 1','Distance 2','Distance 3','Distance 4','i_0'); 
legend('FontSize',14)
legend('Location','EastOutside')





