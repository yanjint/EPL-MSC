function [label,obj]=EPLMSC(G,X,F,c,alpha,beta,mu)

% disp('Start running the EPLMSC algorithm...');



%获取视图数目
m = length(X);

%获取样本数
n = size(X{1},2);

%% init W
W = orth(rand(n, c));

%% init E
% E = cell(1,m);
% for i=1:m
%     E{i} = zeros(n);
% end

%% init A
A = G;

%% init q
q = ones(1,m)/m;

K0 = zeros(n,n);  
for i = 1:m   
    K0 = K0 +F{i} * F{i}';
end

for it=1:50
    fprintf('----Iteration-----%d\n',it);
    %------------- update E -------------
    E =solveE(X,A,beta);
        
    %------------- update A -------------
    A=solveA(X,q,alpha,E,W);
    
    %     %------------- update q -------------
     q =solveq(A,W);
    
      %------------- update W -------------
    W =solveW(A,mu,K0,q,c);
    
    % Calculate Obj
    res = 0;
    for i = 1 : m
        res = res + norm(X{i}-X{i}*(A{i}+E{i}),'fro')^2+alpha*norm(A{i},'fro')^2+beta*norm(E{i},'fro')^2+q(i)*norm(W*W' - A{i}, 'fro')^2;
    end
    obj(it) = res + (c*mu -mu*trace(W'*K0*W));
%     if it > 2 && abs(obj(it) - obj(it-1)) / abs(obj(it)) < 10^(-4)
%         break
%     end
    
    
    
   
end
S= W*W';
W = NormalizeFea(W,0);
label = kmeans(W, c, 'emptyaction', 'singleton', 'replicates', 100, 'display', 'off');
obj =obj;

%  fprintf('----Done-----\n');

 


end