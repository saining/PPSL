function [] = Jiashi(X, P)


% clear;
% clc;
% 
% d = 100; %dimension of samples
% n = 1000; %number of samples
% df = 50; %dimension of feature
% P = rand(df,d); %feature extraction matrix
% 
% %% data generation
% X = 2*rand(d,n)-1;
P = full(abs(P));
[d,n] = size(X);
df = size(P,1);

%% parameter setting
mu = 1;
muMax = 1e10;
rho = 1.1;
maxIter = 1000;
W = zeros(d,d);
eta = norm(P)^2*norm(X)^2*1.02;
PX = P*X;
PPXX = P'*PX*X';
PP = P'*P;
XX = X*X';

%%
k = 50;

% optimization
for iter = 1:maxIter
    W = W + (PPXX-PP*W*XX)/(mu*eta);
    [Uk,Sk,Vk] = lansvd(W,k,'L');
    %[U,S,V] = svd(W);
    W = Uk*Sk*Vk';
%     mu = min(muMax,rho*mu);
    fval = 0.5*norm(abs(PX)-abs(P*W*X),'fro')^2;
%     fprintf('iter%d, rank(W)=%d, fval=%f, mu=%f\n',...
%         iter,rank(W,1e-3),fval,mu);
        fprintf('iter%d, rank(W)=%d, fval=%f, mu=%f\n',...
        iter,0,fval,mu);
end

%% PCA result
% covX = X*X';
% [V,D] = eigs(covX,k);
% W = V*V';
options=[];
options.ReducedDim = 50;
[eigvector, eigvalue] = PCA(X,options);
W = eigvector*eigvector';
fval = 0.5*norm(abs(PX)-abs(P*W*X),'fro')^2;
fprintf('PCA fval=%f\n',fval);