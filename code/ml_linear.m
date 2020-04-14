clear; close all; clc;

% path = 'D:\MachineLearning\machinelearning\';
path = pwd();
dataset = "biomechanical_features";

files = ["column_3C_weka.csv","column_2C_weka.csv"];
data = cell2table(readfromcsv(dataset, files(1)));
 
chdir(path);

[rows, col] = size(data);
predictorNames = data.Properties.VariableNames(1:col-1);
predictors = data(:, predictorNames);
response = data{:, col};

pmod = cvpartition(rows, 'HoldOut', 0.3);
train_id = training(pmod);
test_id = test(pmod);

% disp('Discriminant analysis...');
% discc(predictors,response,train_id,test_id);

% % disp('Classification tree');
% treec(predictors,response,train_id,test_id);

% % disp('Nayve Bayes');
% classifier = bayesc(predictors,response,train_id,test_id);

% 
% % disp('KNN - Classifier');
% knnc(predictors,response,train_id,test_id)

% 
% % disp('SVM - Classifier');
% classifier = svmc(predictors,response,train_id,test_id);

% 
% % disp('Enssembles Subspace - Classifier');
classifier = enssc(predictors,response,train_id,test_id);
