%%  Test Hypercube with all classifiers
function [y,idx] = hsi_classifiers_kmeans(hsi_samples)
% GET PREDICTOR NAMES
    pred_names = fieldnames(hsi_samples);

% DEFINE RESULTS FILE
%   Variable must be 'results'
%   it'll be clear in each start
%
    file = 'results/banana.mat';
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
    img = hsiGetImageLayer(finalcube,2);
    idx = hsiRemoveBackground(data);

    showClusterOnImage(img, idx, 1, 0, 255, 0);  % show image to get which cluster is the background
    showClusterOnImage(img, idx, 2, 0, 0, 255);  %

    sample = input('Which image has the background painted? 1(green) or 2(blue)');
    
% 0 TO BACKGROUND SPECTRUMS 
    idx(idx==sample) = 0;
    
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
    y = {};
    idx_test = {};
    idx_train = {}; 
    
    for k=1:size(pred_names,1)
        x = hsi_samples.(pred_names{k,1});
        
        for n=1:size(x,2)
            X = x{1,n};
            [rows, cols, ~] = size(X);
            a = rows*cols;
            s2train = round(a/2);
            s2test = a - s2train;

            idx_train(s+1:s+s2train,1) = {1};
            idx_train(s+s2train+1:s+s2train+s2test) = {0};
            idx_test(s+1:s+s2train,1) = {0};
            idx_test(s+s2train+1:s+s2train+s2test) = {1};
                        
            y(s+1:s+s2train+s2test,1) = pred_names(k,1);
            s = s+a;
        end
    end
    
    idx_train = boolean(cell2mat(idx_train));
    idx_test = boolean(cell2mat(idx_test));
    
%% PLOT TRAIN/TEST SET
    response = y(idx~=0,:);
    response = response(idx_test(idx~=0,:));
    
    idx_test_samples = zeros(size(idx));
    idx_train_samples = zeros(size(idx));
    for k = 1:size(idx)
        if idx(k) ~= 0
            if idx_test(k) ~= 0
                idx_test_samples(k) = 1;
            elseif idx_train(k) ~= 0
                idx_train_samples(k) = 1;
            end
        end
    end
    
    showClusterOnImage(img,idx_test_samples,1,255,0,0);
    showClusterOnImage(img,idx_train_samples,1,0,0,255);
    
%%  CLASSIFY
    discc(data(idx~=0,:),y(idx~=0,:),idx_train(idx~=0,:),idx_test(idx~=0,:),file);
    treec(data(idx~=0,:),y(idx~=0,:),idx_train(idx~=0,:),idx_test(idx~=0,:),file);
    bayesc(data(idx~=0,:),y(idx~=0,:),idx_train(idx~=0,:),idx_test(idx~=0,:),file);
    knnc(data(idx~=0,:),y(idx~=0,:),idx_train(idx~=0,:),idx_test(idx~=0,:),file);
    svmc(data(idx~=0,:),y(idx~=0,:),idx_train(idx~=0,:),idx_test(idx~=0,:),file);
        
    show_results(file,idx_test_samples,response,img);
    
