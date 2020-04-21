function knnc(predictors, response, train_id, test_id, file)
    load(file,'results');

    fprintf('\n\nKNN Classifier - Optimize All HyperParameters\n');
    classifier = fitcknn(...
            predictors(train_id,:), ...
            response(train_id), ...
            'ClassNames', unique(response(train_id)), ...
            'OptimizeHyperparameters', 'all', ...        
            'HyperparameterOptimizationOptions', struct('Holdout',0.3, ...
            'AcquisitionFunctionName', 'expected-improvement-plus', ...
            'UseParallel', false, ...
            'ShowPlots', false, ...
            'Verbose', 0));
    
    fprintf('Min Objective: %s\n', num2str(classifier.HyperparameterOptimizationResults.MinObjective));
    [label,~,~] = predict(classifier,predictors(test_id,:));
    total = cellfun(@strcmp, response(test_id), label);
    hits = total(total==1);
    accuracy = size(hits,1)/size(total,1);
    fprintf('Accuracy in test data: %s%%\n', num2str(accuracy*100));
    disp(classifier.ModelParameters);
    
    %   Save results
    row = size(results,1)+1;
    results{row,1} = classifier;
    results{row,2} = accuracy*100;
    save(file,'results');
    
    fprintf('\n\nKNN Classifier - Optimize Minkowski Distance Exponent\n');
    classifier = fitcknn(...
            predictors(train_id,:), ...
            response(train_id), ...
            'ClassNames', unique(response(train_id)), ...
            'OptimizeHyperparameters', {'Exponent', 'NumNeighbors', 'Standardize', 'DistanceWeight'}, ...
            'Distance', 'minkowski', ...
            'HyperparameterOptimizationOptions', struct('Holdout',0.3, ...
            'AcquisitionFunctionName', 'expected-improvement-plus', ...
            'UseParallel', false, ...
            'ShowPlots', false, ...
            'Verbose', 0));
        
    fprintf('Min Objective: %s\n', num2str(classifier.HyperparameterOptimizationResults.MinObjective));
    [label,~,~] = predict(classifier,predictors(test_id,:));
    total = cellfun(@strcmp, response(test_id), label);
    hits = total(total==1);
    accuracy = size(hits,1)/size(total,1);
    fprintf('Accuracy in test data: %s%%\n', num2str(accuracy*100));
    disp(classifier.ModelParameters);
    
    %   Save results
    row = size(results,1)+1;
    results{row,1} = classifier;
    results{row,2} = accuracy*100;
    save(file,'results');
end