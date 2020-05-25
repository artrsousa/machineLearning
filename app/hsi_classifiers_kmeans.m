%{
hsi_classifiers_kmeans.m
  Inputs:
      hsi_samples: The structured samples (made by hsi_analysis.m)
  Outputs:
      y : 
      idx: 
%}
function [y,idx] = hsi_classifiers_kmeans(hsi_samples)
  % Get predictor names
  pred_names = fieldnames(hsi_samples);

% Defines the results file
%   Variable must be 'results'
%   it'll be clear in each start
%
  file = 'results/banana.mat';
%  results = {};
%  save(file,'results');
%  clear results;
 
  %%  Creates Hypercube
  cube = cell(size(pred_names,1),1);
  for c = 1:size(pred_names,1)
      x = hsi_samples.(pred_names{c,1});
      cube(c,1) = {cat(1,x{:})};
  end

  %% Transform Hypercube to Matrix
  finalcube = cat(1,cube{:});
  data = hsi2matrix(finalcube);
    
  %% Pre-processing - KMEANS
  img = hsiGetImageLayer(finalcube,2);
  idx = hsiRemoveBackground(data);

  %% Shows Clusters Images for use
  showClusterOnImage(img,idx,1,0,255,0,'Cluster1');
  showClusterOnImage(img,idx,2,0,0,255,'Cluster2');

  %% User should select the background clusters
  sample = input('Which image has the background painted? 1(green) or 2(blue)');
    
  %% Assigns 0 to background spectrums 
  idx(idx==sample) = 0;
    
%%  Generates response vector
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
    
  %%   Prepare Training/Test and generate Response Vector
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
  
  %% Prepares the sets to show as image
  idx_train = boolean(cell2mat(idx_train));
  idx_test = boolean(cell2mat(idx_test));
    
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
  
  %% Plots the Train and Test set
  showClusterOnImage(img,idx_test_samples,1,255,0,0,'Test Set');
  showClusterOnImage(img,idx_train_samples,1,0,0,255,'Train Set');
  
  %% Data analysis 
  % Shows first N elements in each sample on hypercube
  % Ex. hsi_samples = ({polpa_nanica, casca_nanica}, {polpa_prata, casca_prata})
  % The first N spectrums of each sample will be showed 
  % The mean of all spectrums of each class will be showed
  data_analysis(hsi_samples,data,idx_train_samples,idx_test_samples,50);
  
  %%  Passes the sets to Classifiers
  discc(data(idx~=0,:),y(idx~=0,:),idx_train(idx~=0,:),idx_test(idx~=0,:),file);
  treec(data(idx~=0,:),y(idx~=0,:),idx_train(idx~=0,:),idx_test(idx~=0,:),file);
  bayesc(data(idx~=0,:),y(idx~=0,:),idx_train(idx~=0,:),idx_test(idx~=0,:),file);
  %   knnc(data(idx~=0,:),y(idx~=0,:),idx_train(idx~=0,:),idx_test(idx~=0,:),file);
  svmc(data(idx~=0,:),y(idx~=0,:),idx_train(idx~=0,:),idx_test(idx~=0,:),file);
  enssc(data(idx~=0,:),y(idx~=0,:),idx_train(idx~=0,:),idx_test(idx~=0,:),file);

  % Show final results
  show_results(file,idx_test_samples,response,img);

