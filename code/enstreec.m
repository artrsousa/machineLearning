% type = ["AdaBoostM2", "Bag", "RUSBoost"]; 
% Get Data as inputTable of [n,p]dim. As predictor use inputTable(:,p-1), the P column is the response class  
function [trainedClassifier, validationAccuracy, partitionedModel, validationAccuracyHistory] = enstreec(trainingData)
    splits = [20,309,20];
    type = ["AdaBoostM2","Bag","RUSBoost"];
    validationAccuracyHistory = [];
    
    for x=1:size(type, 2)
        trainedClassifier = classifier(trainingData, char(type(x)), splits(x));
        partitionedModel = crossval(trainedClassifier.Classification, 'KFold', 5);
        [~, ~] = kfoldPredict(partitionedModel);
        validationAccuracyHistory = [validationAccuracyHistory, 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError')];
    end
    
    [~, index] = max(validationAccuracyHistory);
    trainedClassifier = classifier(trainingData, type(index), splits(x));
        
    % Perform and compute cross-validation
    partitionedModel = crossval(trainedClassifier.Classification, 'KFold', 5);
    [~, ~] = kfoldPredict(partitionedModel);
        
    % Compute validation accuracy
    validationAccuracy = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError');
    validationAccuracy = [validationAccuracy, type(index)];
    
    function trainedClassifier = classifier(trainingData, type, splits)
        [~, p] = size(trainingData);
        inputTable = trainingData;
        predictorNames = trainingData.Properties.VariableNames(1:p-1);
        predictors = inputTable(:, predictorNames);
        response = inputTable{:, p};

        % Train a classifier
        template = templateTree(...
            'MaxNumSplits', splits);
       
        if strcmp(type, 'Bag')
            classifier = fitcensemble(...
            predictors, ...
            response, ...
            'Method', type, ...
            'NumLearningCycles', 30, ...
            'Learners', template, ...
            'ClassNames', unique(response));
        else
            classifier = fitcensemble(...
            predictors, ...
            response, ...
            'Method', type, ...
            'NumLearningCycles', 30, ...
            'Learners', template, ...
            'LearnRate', 0.1, ...
            'ClassNames', unique(response));
        end
        
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