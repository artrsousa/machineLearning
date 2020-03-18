clc();
clear();

path = 'D:\MachineLearning\machinelearning\';
dataset = "biomechanical_features";

files = ["column_3C_weka.csv", "column_2C_weka.csv"];

chdir(path);
data = cell2table(readfromcsv(dataset, files(1)));
dim = size(data);

data2test = data(1:dim(1), 1:2);
data2test = [data2test, data(1:dim(1), 7)];

chdir(path);

disp('Discriminant analysis...');
[classifier, accuracy, partitionedModel, history] = discc(data2test);
disp(accuracy);

disp('Classification tree');
[classifier, accuracy, partitionedModel, history] = treec(data2test);
disp(accuracy);

disp('Nayve Bayes');
[classifier, accuracy, partitionedModel, history] = bayesc(data2test);
disp(accuracy);

disp('KNN - Classifier');
[classifier, accuracy, partitionedModel, history] = knnc(data2test);
disp(accuracy);

disp('SVM - Classifier');
[classifier, accuracy, partitionedModel, history] = svmc(data2test);
disp(accuracy);

disp('Enssembles Tree - Classifier');
[classifier, accuracy, partitionedModel, history] = enstreec(data2test);
disp(accuracy);

disp('Enssembles Subspace - Classifier');
[classifier, accuracy, partitionedModel, history] = enssubc(data2test);
disp(accuracy);
