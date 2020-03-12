% type = ['linear','diaglinear','pseudolinear','quadratic','diagquadratic','pseudoquadratic']; 
% Get Data as inputTable of [n,p]dim. As predictor use inputTable(:,p-1), the P column is the response class  
function [trainedClassifier, validationAccuracy, partitionedModel, validationAccuracyHistory] = bayesc(trainingData)
    type = ["Kernel", "Normal"]; 
    validationAccuracyHistory = [];
    
    for x=1:size(type, 2)
        trainedClassifier = classifier(trainingData, char(type(x)));
        partitionedModel = crossval(trainedClassifier.Classification, 'KFold', 5);
        [~, ~] = kfoldPredict(partitionedModel);
        validationAccuracyHistory = [validationAccuracyHistory, 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError')];
    end
    
    [~, index] = max(validationAccuracyHistory);
    trainedClassifier = classifier(trainingData, char(type(index)));
        
    % Perform and compute cross-validation
    partitionedModel = crossval(trainedClassifier.Classification, 'KFold', 5);
    [~, ~] = kfoldPredict(partitionedModel);
        
    % Compute validation accuracy
    validationAccuracy = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError');
    validationAccuracy = [validationAccuracy, type(index)];
    
    function trainedClassifier = classifier(trainingData, distribution)
        [~, p] = size(trainingData);
        inputTable = trainingData;
        predictorNames = trainingData.Properties.VariableNames(1:p-1);
        predictors = inputTable(:, predictorNames);
        response = inputTable{:, p};
        
        isCategoricalPredictor = [false, false];

        % Train a classifier
        distributionNames =  repmat({distribution}, 1, length(isCategoricalPredictor));
        distributionNames(isCategoricalPredictor) = {'mvmn'};
        
        if any(strcmp(distributionNames,'Kernel'))
             classifier = fitcnb(...
                predictors, ...
                response, ...
                'Kernel', 'normal', ...
                'Support', 'Unbounded', ...
                'DistributionNames', distributionNames, ...
                'ClassNames', unique(response));
        else
            classifier = fitcnb(...
                predictors, ...
                response, ...
                'DistributionNames', distributionNames, ...
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