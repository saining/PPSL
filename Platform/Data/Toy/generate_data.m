function [X,cids] = generate_data()
n = 200;
d = 10;
D = 100;
[U,S,V] = svd(rand(D));
cids = [];
U1 = U(:,1:d);
X = U1*rand(d,n);
cids = [cids,ones(1,n)];

for i=2:5
    R = orth(rand(D));
    U1 = R*U1;
    X = [X,U1*rand(d,n)];
    cids = [cids,i*ones(1,n)];
end
nX = size(X,2);
norm_x = sqrt(sum(X.^2,1));
norm_x = repmat(norm_x,D,1);
gn = norm_x.*randn(D,nX);
inds = rand(1,nX)<=0.3;
X(:,inds) = X(:,inds) + 0.3*gn(:,inds);