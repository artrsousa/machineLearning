% type = ['linear','diaglinear','pseudolinear','quadratic','diagquadratic','pseudoquadratic']; 
% Get Data as inputTable of [n,p]dim. As predictor use inputTable(:,p-1), the P column is the response class  
function [trainedClassifier, validationAccuracy, partitionedModel, validationAccuracyHistory] = fitdisc(trainingData)
    type = ["linear","quadratic","diagLinear","quadratic","diagQuadratic","pseudoLinear", "pseudoQuadratic"]; 
    validationAccuracyHistory = [];
    
    for x=1:size(type, 2)
        trainedClassifier = discriminantClassifier(trainingData, type(x));
        partitionedModel = crossval(trainedClassifier.ClassificationDiscriminant, 'KFold', 5);
        [validationPredictions, validationScores] = kfoldPredict(partitionedModel);
        validationAccuracyHistory = [validationAccuracyHistory, 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError')];
    end
    
    [~, index] = max(validationAccuracyHistory);
    trainedClassifier = discriminantClassifier(trainingData, type(index));
        
    % Perform and compute cross-validation
    partitionedModel = crossval(trainedClassifier.ClassificationDiscriminant, 'KFold', 5);
    [validationPredictions, validationScores] = kfoldPredict(partitionedModel);
        
    % Compute validation accuracy
    validationAccuracy = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError');
    
    function trainedClassifier = discriminantClassifier(trainingData, discriminantType)
        [~, p] = size(trainingData);
        inputTable = trainingData;
        predictorNames = trainingData.Properties.VariableNames(1:p-1);
        predictors = inputTable(:, predictorNames);
        response = inputTable{:, p};

        % Train a classifier
        classificationDiscriminant = fitcdiscr(...
            predictors, ...
            response, ...
            'DiscrimType', discriminantType, ...
            'Gamma', 0, ...
            'Delta', 0, ...
            'FillCoeffs', 'off', ...
            'ClassNames', unique(response), ...
            'Prior', 'empirical', ...
            'ScoreTransform', 'none', ...
            'OptimizeHyperparameters', 'none');

        % Create the result struct with predict function
        predictorExtractionFcn = @(t) t(:, predictorNames);
        discriminantPredictFcn = @(x) predict(classificationDiscriminant, x);
        trainedClassifier.predictFcn = @(x) discriminantPredictFcn(predictorExtractionFcn(x));

        % Add additional fields to the result struct
        trainedClassifier.RequiredVariables = predictorNames;
        trainedClassifier.ClassificationDiscriminant = classificationDiscriminant;
    end

    return;
end