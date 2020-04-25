%%  Test Hypercube with all classifiers
function hsi_classifiers_kmeans(hsi_samples,pred_names)
    % DEFINE RESULTS FILE
    %   variable must be 'results'
    file = '../results/banana.mat';
    results = {};
    save(file,'results');
    clear results;
    
    %%  CREATE HYPERCUBE
    cube = cat(1,hsi_samples{:});    
    
    %%  TRANSFORM HYPERCUBE TO MATRIX
    data = hsi2matrix(cube);
    
    %%  PRE PROCESS - KMEANS
    img = hsiGetImageLayer(cube,30);
    idx = hsiRemoveBackground(data);

    showClusterOnImage(img, idx, 1, 0, 255, 0);  % show image to get which cluster is the background
    showClusterOnImage(img, idx, 2, 0, 0, 255);  %

    sample = input('Which image has the background highlighted? 1(green) or 2(blue)');

    % normalize
    data = data - repmat(mean(data), size(data,1), 1);
    
    % 0 to background spectrums 
    idx(idx~=sample) = 0;
    data = data(idx(idx~=0),:);
    
    %%  GENERATE RESPONSE VECTOR
    s = 0;
    st = 0;
    y = {};
    for k=1:size(hsi_samples,2)
        [rows, cols, ~] = size(hsi_samples{1,k});

        a = rows*cols;
        nsamples = sum(idx(st+1:st+a,1))/sample;
        y(s+1:s+nsamples,1) = pred_names(1,k);
        s = s+nsamples;
        st = st+a;
    end
    clear s cube;
    
    %% CLASSIFY
    [rows, ~] = size(data);
    pmdl = cvpartition(rows,'HoldOut',0.3);
    train_id = training(pmdl);
    test_id = test(pmdl);

    [coeff,score,latent,tsquared,explained,mu] = pca(data);
    fprintf('Var. Explained: %f', sum(explained(1:3, 1)));
    
    %   Discriminant analysis...
%     discc(score(:,1:2),y,train_id,test_id,file);

    %   Classification tree
%     treec(score(:,1:2),y,train_id,test_id,file);

    %   Nayve Bayes
%     bayesc(score(:,1:2),y,train_id,test_id,file);

    %   KNN - Classifier
%     knnc(score(:,1:2),y,train_id,test_id,file);

    %   SVM - Classifier
    svmc(score(:,1:3),y,train_id,test_id,file);

    %   Enssembles Subspace - Classifier
%     enssc(score(:,1:2),y,train_id,test_id,file);

end