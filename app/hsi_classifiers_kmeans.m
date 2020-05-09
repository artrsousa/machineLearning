%%  Test Hypercube with all classifiers
function [y,idx] = hsi_classifiers_kmeans(hsi_samples)
    % GET PREDICTOR NAMES
    pred_names = fieldnames(hsi_samples);

    % DEFINE RESULTS FILE
    %   variable must be 'results'

    
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

    % NORMALIZE - REMOVE MEAN
    % data = data - repmat(mean(data), size(data,1), 1);
    
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
    
    %showClusterOnImage(img, cell2mat(idx_train), 1, 0, 255, 0);
    %showClusterOnImage(img, cell2mat(idx_test), 1, 255, 0, 0);
    
    idx_train = boolean(cell2mat(idx_train));
    idx_test = boolean(cell2mat(idx_test));
    
    response = y(idx~=0,:);
    testeIds = idx_test(idx~=0,:);
    response_array = response(testeIds);
        
    idxResultado = zeros(size(idx));
    for x = 1:size(idx)
        if(idx(x) ~= 0 && idx_test(x) ~= 0)
            idxResultado(x) = 1;
        end
    end
    showClusterOnImage(img,idxResultado, 1, 255, 0, 0);

%%  CLASSIFY
    % path_discc = '../results/discc.mat';
    % create_file_result(path_discc);
    % discc(data(idx~=0,:),y,train_id,test_id,path_discc);

    % path_treec = '../results/treec';
    % create_file_result(path_treec);
    % treec(data(idx~=0,:),y,train_id,test_id,path_treec);

    % path_bayesc = '../results/bayesc';
    % create_file_result(path_bayesc);
    % bayesc(data(idx~=0,:),y,train_id,test_id,path_bayesc);

    % path_knnc = '../results/knnc';
    % create_file_result(path_knnc);
    % knnc(data(idx~=0,:),y,train_id,test_id,path_knnc);
    % load('img.mat');
    path_svmc = '../results/svmc.mat';
    create_file_result(path_svmc);
    svmc(data(idx~=0,:),y(idx~=0,:),idx_train(idx~=0,:),idx_test(idx~=0,:),path_svmc);
    result_process(path_svmc, true, true, true, idxResultado, response_array, img);

    % path_enssc = '../results/enssc';
    % create_file_result(path_enssc);
    % enssc(data(idx~=0,:),y,train_id,test_id,path_enssc);
end