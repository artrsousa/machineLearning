clear; close all; clc;
load ../dataset/biomechanical_features/biomechanical_features;

file = '../results/biomech.mat';
results = {};
save(file,'results');

[rows, col] = size(biomechanical_features);
predictorNames = biomechanical_features.Properties.VariableNames(1:col-1);
predictors = biomechanical_features(:, predictorNames);
response = biomechanical_features{:, col};

pmod = cvpartition(rows, 'HoldOut', 0.3);
train_id = training(pmod);
test_id = test(pmod);

% disp('Discriminant analysis...');
% discc(predictors,response,train_id,test_id,file);

% disp('Classification tree');
% treec(predictors,response,train_id,test_id,file);

% % disp('Nayve Bayes');
bayesc(predictors,response,train_id,test_id,file);

% 
% % disp('KNN - Classifier');
% knnc(predictors,response,train_id,test_id,file)

% 
% % disp('SVM - Classifier');
% svmc(predictors,response,train_id,test_id,file);

% 
% % disp('Enssembles Subspace - Classifier');
% enssc(predictors,response,train_id,test_id,file);

clear pmod train_id test_id rows col predictorNames predictors response results;