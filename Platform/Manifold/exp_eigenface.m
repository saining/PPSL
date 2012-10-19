clear all;clc;
load YaleB_32x32.mat;

%============================================================
	%for basic PCA face recognition
	%fea 2414*1024 fea' = 1024*2414

maxValue = max(max(fea));
fea = fea/maxValue;
%==============Nomalize each vector to unit=================
fea = fea';
gnd = gnd';
totrounds = 50;
acc = zeros(totrounds, 1);
for rounds = 1:totrounds,	

	filename = sprintf('./Data/20Train/%d.mat', rounds);
	load(filename); %trainIdx and testIdx

	trainfea = fea(:,trainIdx);
	testfea  = fea(:,testIdx);
	traingnd = gnd(:,trainIdx);
	testgnd  = gnd(:,testIdx);
    
    tot_train_samples = length(traingnd);
	reductionFactor = 50;

	PCA()


	mean_face = mean(trainfea, 2);
	shifted_images = trainfea - repmat(mean_face, 1, tot_train_samples);

	%L = shifted_images'*shifted_images;

	C = shifted_images*shifted_images';
	num_eigenfaces = reductionFactor*size(trainfea, 1);

	[V, D] = eig(C);
	[vecD, idxD] =  sort(diag(D),'descend');
	kidx = idxD(1:num_eigenfaces);
	
	%evectors = shifted_images * V(:, kidx);
	evectors = V(:, kidx);
	proj_features = evectors' * shifted_images;

	tot_test_samples = length(testgnd);
    
    correct = 0;
	for i=1:tot_test_samples,

		feature_test = evectors' * (testfea(:,i) - mean_face);
		similarity_score = arrayfun(@(n) 1 / (1 + norm(proj_features(:,n) - feature_test)), 1:tot_train_samples);

		[match_score, match_ix] = max(similarity_score);
		
		if(testgnd(i) == traingnd(match_ix)) 
			correct = correct+1;
		end;
    end;

	acc(rounds) = correct/tot_test_samples;
	fprintf('The accuracy for the %d round is :%7.6f \n',rounds, acc(rounds));
	% display the eigenvectors
	%figure;
	%for n = 1:num_eigenfaces
	%    subplot(2, ceil(num_eigenfaces/2), n);
	%    evector = reshape(evectors(:,n), 32, 32);
	%    imshow(evector);
	%end
	%pause;

	% display the result
	%figure, imshow([input_image reshape(images(:,match_ix), image_dims)]);
	%title(sprintf('matches %s, score %f', filenames(match_ix).name, match_score));
end;
	disp('*******************************************\n')
	fprintf('The average accuracy is :%7.6f, std is: %7.6f', mean(acc),std(acc));
	disp('*******************************************\n')
