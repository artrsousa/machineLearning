% type = ['linear','diaglinear','pseudolinear','quadratic','diagquadratic','pseudoquadratic']; 
% Get Data as inputTable of [n,p]dim. As predictor use inputTable(:,p-1), the P column is the response class  
function [trainedClassifier, validationAccuracy, partitionedModel, validationAccuracyHistory] = enssubc(trainingData)
    type = ["discriminant", "knn"]; 
    validationAccuracyHistory = [];
    
    for x=1:size(type, 2)
        trainedClassifier = classifier(trainingData, char(type(x)));
        partitionedModel = crossval(trainedClassifier.Classification, 'KFold', 5);
        [~, ~] = kfoldPredict(partitionedModel);
        validationAccuracyHistory = [validationAccuracyHistory, 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError')];
    end
    
    [~, index] = max(validationAccuracyHistory);
    trainedClassifier = classifier(trainingData, type(index));
        
    % Perform and compute cross-validation
    partitionedModel = crossval(trainedClassifier.Classification, 'KFold', 5);
    [~, ~] = kfoldPredict(partitionedModel);
        
    % Compute validation accuracy
    validationAccuracy = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError');
    validationAccuracy = [validationAccuracy, type(index)];
    
    function trainedClassifier = classifier(trainingData, type)
        [~, p] = size(trainingData);
        inputTable = trainingData;
        predictorNames = trainingData.Properties.VariableNames(1:p-1);
        predictors = inputTable(:, predictorNames);
        response = inputTable{:, p};

        % Train a classifier
        subspaceDimension = max(1, min(1, width(predictors) - 1));
        classifier = fitcensemble(...
            predictors, ...
            response, ...
            'Method', 'Subspace', ...
            'NumLearningCycles', 30, ...
            'Learners', type, ...
            'NPredToSample', subspaceDimension, ...
            'ClassNames', unique(response));
        
        % Create the result struct with predict function
        predictorExtractionFcn = @(t) t(:, predictorNames);
        classifierPredictFcn = @(x) predict(classifier, x);
        trainedClassifier.predictFcn = @(x) classifierPredictFcn(predictorExtractionFcn(x));

        % Add additional fields to the result struct
        trainedClassifier.RequiredVariables = predictorNames;
        trainedClassifier.Classification = classifier;
    end

    return;
end