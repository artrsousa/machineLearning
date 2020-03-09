clc();
clear();

path = 'D:\MachineLearning\machinelearning\';
dataset = 'biomechanical_features';

% files = ["column_3C_weka.csv", "column_2C_weka.csv"];
files = ["column_3C_weka.csv", "column_2C_weka.csv"];

chdir(path);
data = cell2table(readData(dataset, files(1)));
dim = size(data);

data2test = data(1:dim(1), 1:2);
data2test = [data2test, data(1:dim(1), 7)];

chdir(path);

%X = data{2:dim(1), 1:2};
[classifier, accuracy, partitionedModel] = fitdisc(data2test);