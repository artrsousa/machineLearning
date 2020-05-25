%{
treec.m
  This is the matlab implementation of Tree Classifier
  It's called from hsi_classifiers_kmeans.m.
  The data should be structured before run it.

  Inputs:
      predictors: Predictors structured
      response:   Response vector  
      train_id:   Train set
      test_id:    Test set
      file:       Result file
%}
function treec(predictors, response, train_id, test_id, file)
  load(file,'results');

  fprintf('\n\nTree Classifier - Optimize All Hyperparameters\n');    
  classifier = fitctree(...
    predictors(train_id,:), ...
    response(train_id), ...
    'ClassNames', unique(response(train_id)), ...
    'OptimizeHyperparameters', 'all', ...        
    'HyperparameterOptimizationOptions', struct('Holdout',0.3, ...
    'AcquisitionFunctionName', 'expected-improvement-plus', ...
    'UseParallel', true, ...
    'ShowPlots', false, ...
    'Verbose', 1));
        
  fprintf('Min Objective: %s\n', num2str(classifier.HyperparameterOptimizationResults.MinObjective));
  [label,~,~] = predict(classifier,predictors(test_id,:));
  total = cellfun(@strcmp, response(test_id), label);
  hits = total(total==1);
  accuracy = size(hits,1)/size(total,1);
  fprintf('Accuracy in test data: %s%%\n', num2str(accuracy*100));
  disp(classifier.ModelParameters);
  
  %   Save results
  row = size(results,1)+1;
  results{row,1} = classifier.ModelParameters;
  results{row,2} = accuracy*100;
  results{row,3} = label;
  save(file,'results');
end