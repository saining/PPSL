function [] = demo()
clear all;
clc;

X = generate_data_xpdr();
%We transpose the data so that now X is 2000 by 100, where subspace basis dim is 20, i.e.
%their is only 100 samples, but 2000 dimensions, blonging to 
%10 subspace with corruptions.


P = eye(1000,1000);
X = generate_data_xpdr();

lambda = 1000;
[W, E] = ladmap_xpdr(X, P, lambda);



function [X,cids] = generate_data_xpdr()
    n = 1000;
    d = 20;
    D = 200;
    [U,S,V] = svd(rand(D));
    cids = [];
    U1 = U(1:d,:);
    X = U1'*rand(d,n);
    cids = [cids;ones(D,1)];

    for i=2:5
        R = orth(rand(D));
        U1 = U1*R;
        X = [X;U1'*rand(d,n)];
        cids = [cids;i*ones(D,1)];
    end

    nX = size(X,2);
    nD = size(X,1);
    norm_x = sqrt(sum(X.^2,2));
    norm_x = repmat(norm_x,1,nX);
    gn = norm_x.*randn(nD,nX);
    inds = rand(nD,1)<=0.3;
    X(inds,:) = X(inds,:) + 0.3*gn(inds,:);
