function [W, Rank] = ladmap_fix(X, P, InitialW, lambda, PType, tol2, rho)
% Linearized ADM

clear global;
global M;

%addpath PROPACK;

tol1 = 1e-4;

if nargin < 6
    disp('No rho specified!');
    rho = 1.9;
end
if nargin < 5
    disp('No tol2 specified!');
    tol2 = 1e-5; %same arg as ladmap_lrr
end
if nargin < 4
    disp('No PType specified!');
    PType = 'Nothing';
end
if nargin < 3
    disp('No lambda specified!');
    lambda = 20;
end

if strcmp(PType, 'abs')
    P = full(abs(P));
elseif strcmp(PType, 'realimag')
    P = full(P);
    P = [real(P);imag(P)];
else %nothing
    P = full(P);
end


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
[d,n] = size(X);
df = size(P,1);

%% parameter setting
mu = 1;
mu = 0.9;
muMax = 1e10;
rho = 1.1;
maxIter = 3000;
W = zeros(d,d);
eta = norm(P)^2*norm(X)^2*1.02;
PX = P*X;
PPXX = P'*PX*X';
PP = P'*P;
XX = X*X';

%%
k = lambda;

% optimization
for iter = 1:maxIter
    tic;
    W = W + (PPXX-PP*W*XX)/(mu*eta);
    [Uk,Sk,Vk] = lansvd(W,k,'L');
    W = Uk*Sk*Vk';
    %[U,S,V] = svd(W);
    %W = U(:, 1:k)*S(1:k, 1:k)*V(:,1:k)';

    
%     mu = min(muMax,rho*mu);
 if mod(iter,500)==0,
    fval = 0.5*norm(abs(PX)-abs(P*W*X),'fro')^2;
%     fprintf('iter%d, rank(W)=%d, fval=%f, mu=%f\n',...
%         iter,rank(W,1e-3),fval,mu);
        fprintf('iter%d, rank(W)=%d, fval=%f, mu=%f\n',...
        iter,0,fval,mu);
    toc
 end
    
end
options=[];
options.ReducedDim = 50;
[eigvector, eigvalue] = PCA(X,options);
WPCA = eigvector*eigvector';
fval = 0.5*norm(abs(PX)-abs(P*WPCA*X),'fro')^2;
fprintf('PCA fval=%f\n',fval);
Rank = rank(W);




