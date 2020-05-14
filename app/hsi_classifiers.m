%%  Test Hypercube with all classifiers
function hsi_classifiers(hsi_samples,pred_names)
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
    
    %%  GENERATE RESPONSE VECTOR
    y = {};
    s = 0;
    for k=1:size(hsi_samples,2)
        [rows, cols, ~] = size(hsi_samples{1,k});

        nsamples = (rows*cols);
        y(s+1:s+nsamples,1) = pred_names(1,k);
        s = s+nsamples;
    end
    clear s cube;
    
    %% CLASSIFY
    [rows, ~] = size(data);
    pmdl = cvpartition(rows,'HoldOut',0.3);
    train_id = training(pmdl);
    test_id = test(pmdl);
    
%       Discriminant analysis...
%     discc(data,y,train_id,test_id,file);

    %   Classification tree
%     treec(score(:,1:2),y,train_id,test_id,file);

    %   Nayve Bayes
%     bayesc(score(:,1:2),y,train_id,test_id,file);

    %   KNN - Classifier
%     knnc(score(:,1:2),y,train_id,test_id,file);

    %   SVM - Classifier
%     svmc(data,y,train_id,test_id,file);

    %   Enssembles Subspace - Classifier
%     enssc(score(:,1:2),y,train_id,test_id,file);

end