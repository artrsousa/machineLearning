%%  Test Hypercube with all classifiers
function [y,idx] = hsi_classifiers_kmeans(hsi_samples)
    % GET PREDICTOR NAMES
    pred_names = fieldnames(hsi_samples);

    % DEFINE RESULTS FILE
    %   variable must be 'results'
    file = '../results/banana.mat';
    results = {};
    save(file,'results');
    clear results;
    
    %%  CREATE HYPERCUBE
    cube = cell(size(pred_names,1),1);
    for c = 1:size(pred_names,1)
        x = hsi_samples.(pred_names{c,1});
        cube(c,1) = {cat(1,x{:})};
    end
    
    %%  TRANSFORM HYPERCUBE TO MATRIX
    finalcube = cat(1,cube{:});
    data = hsi2matrix(finalcube);
    
    %%  PRE PROCESS - KMEANS
    img = hsiGetImageLayer(finalcube,30);
    idx = hsiRemoveBackground(data);

    showClusterOnImage(img, idx, 1, 0, 255, 0);  % show image to get which cluster is the background
    showClusterOnImage(img, idx, 2, 0, 0, 255);  %

    sample = input('Which image has the background painted? 1(green) or 2(blue)');

    % NORMALIZE - REMOVE MEAN
    % data = data - repmat(mean(data), size(data,1), 1);
    
    % 0 TO BACKGROUND SPECTRUMS 
    idx(idx~=sample) = 0;
    
    %%  GENERATE RESPONSE VECTOR
%     s = 0;
%     st = 0;
%     y = {};
%     for k=1:size(pred_names,1)
%         [rows, cols, ~] = size(cube{k,1});
% 
%         a = rows*cols;
%         nsamples = sum(idx(st+1:st+a,1))/sample;
%         y(s+1:s+nsamples,1) = pred_names(k,1);
%         s = s+nsamples;
%         st = st+a;
%     end
%     clear s X;
    
    %%   PREPARE TRAINING/TEST AND GENERATE RESPONSE VECTOR
    s = 0;
    idx_train = {};
    idx_test = {};
    y = {};
    for k=1:size(pred_names,1)
        x = hsi_samples.(pred_names{k,1});
        
        for n=1:size(x,2)
            X = x{1,n};
            [rows, cols, ~] = size(X);

            a = rows*cols;
            f2train = round(a/2);
            f2test = a - f2train;

            idx_train(s+1:s+f2train,1) = {1};
            idx_train(s+f2train+1:s+f2train+f2test) = {0};
            idx_test(s+1:s+f2train,1) = {0};
            idx_test(s+f2train+1:s+f2train+f2test) = {1};
            
            y(s+1:s+f2train+f2test,1) = pred_names(k,1);
            s = s+a;
        end
    end
    
    showClusterOnImage(img, cell2mat(idx_train), 1, 0, 255, 0);
    showClusterOnImage(img, cell2mat(idx_test), 1, 255, 0, 0);
    
    idx_train = boolean(cell2mat(idx_train));
    idx_test = boolean(cell2mat(idx_test));
        
%%  CLASSIFY
%     discc(score(:,1:2),y,train_id,test_id,file);
%     treec(score(:,1:2),y,train_id,test_id,file);
%     bayesc(score(:,1:2),y,train_id,test_id,file);
%     knnc(score(:,1:2),y,train_id,test_id,file);
    svmc(data(idx~=0,:),y(idx~=0,:),idx_train(idx~=0,:),idx_test(idx~=0,:),file);
%     enssc(score(:,1:2),y,train_id,test_id,file);
end