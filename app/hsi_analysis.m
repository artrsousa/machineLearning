%% CONFIGURE ENVIRONMENT
close all; clear; clc;

%   add folders to path
config;

% DEFINE RESULTS FILE
%   variable must be 'results'
file = '../results/banana.mat';
results = {};
save(file,'results');

% LOAD DATASET
%   BANANA - HSI
%       casca_maca, casca_marmelo, casca_nanica, casca_prata
%       polpa_maca, polpa_nanica, polpa_prata
%   biomechanical_features
load casca_maca;
load polpa_maca;

% HSI FUNCTIONS
%   [Y,C,sumd,D] = getClusters( PCAscore, pcs, k )
%   X = hsi2matrix(CUBE)
%   [image] = hsiGetImageLayer(CUBE, layer)
%   [I] = hsiGetLayer(CUBE,layer)
%   [normalizedCUBE] = hsiNormalize(CUBE)
%   [Y] = hsiRemoveBackground(X)
%   [image] = hsiShowLayer(CUBE,layer)
%   [] = hsiShowSpectrum(CUBE,x,y)
%   [CUBE] = matrix2hsi(X,n,p)
%   [gray_image,rgb_image,fig] = showClusterOnImage(image,idx,cluster,r,g,b)

%%  GENERATE THE HYPERCUBE
banana_maca = cat(1,casca_maca,polpa_maca);

%%  TRANSFORM HYPERCUBE TO MATRIX
full_data = hsi2matrix(banana_maca);

%%  GENERATE RESPONSE VECTOR
y = cell(size(banana_maca,1)*size(banana_maca,2),1);
y(1:size(casca_maca,1)*size(casca_maca,2),1) = {'casca_maca'};
y(size(casca_maca,1)*size(casca_maca,2)+1:...
    (size(casca_maca,1)*size(casca_maca,2)) + ...
    (size(polpa_maca,1)*size(polpa_maca,2))) = {'polpa_maca'};

%% CLASSIFY
[rows, ~] = size(full_data);
pmdl = cvpartition(rows,'HoldOut',0.3);
train_id = training(pmdl);
test_id = test(pmdl);

%   Discriminant analysis...
discc(full_data,y,train_id,test_id,file);

%   Classification tree
treec(full_data,y,train_id,test_id,file);

%   Nayve Bayes
bayesc(full_data,y,train_id,test_id,file);

%   KNN - Classifier
knnc(full_data,y,train_id,test_id,file)
 
%   SVM - Classifier
svmc(full_data,y,train_id,test_id,file);

%   Enssembles Subspace - Classifier
enssc(full_data,y,train_id,test_id,file);



