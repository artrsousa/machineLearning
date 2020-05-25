%{
data_analysis.m
  Shows first N elements in each sample on hypercube
  Ex. hsi_samples = ({polpa_nanica, casca_nanica}, {polpa_prata, casca_prata})
  The first N spectrums of each sample will be showed 
  The mean of all spectrums of each class will be showed
  
  Inputs:
      hsi_samples:  The dataset samples in HSI
      data:         Matrix of hsi_samples
      idx_train:    Data matrix with Train Samples represented by ones
      idx_test:     Data matrix with Test Samples represented by ones
      n:            Number of the first N elements in each sample on hypercube 
%}
function data_analysis(hsi_samples,data,idx_train,idx_test,n)
  pred_names = fieldnames(hsi_samples);
  
  s = 0;
  t = 0;
  colors = distinguishable_colors(size(pred_names,1));
  legendText = cell(1,size(pred_names,1));
  axesplot_train = zeros(1,size(pred_names,1)); 
  axesplot_test = zeros(1,size(pred_names,1));

  % Define Figures
  fig1 = figure;fig2 = figure;
  fig3 = figure;fig4 = figure;

  for c = 1:size(pred_names,1)
    X = hsi_samples.(pred_names{c});
    legendText{c} = pred_names{c,1};

    for l = 1:size(X,2)
      sample = X{l};
      a = size(sample,1) * size(sample,2);

      % Get all N first spectrums
      idxTestSpectrum = find(idx_test(s+1:s+a));
      idxTrainSpectrum = find(idx_train(s+1:s+a));
      spectrumTrainSet = data(idxTrainSpectrum(1:n),:);
      spectrumTestSet = data(idxTestSpectrum(1:n),:);

      figure(fig1.Number), hold on;
      h = plot(spectrumTrainSet','color', colors(c,:));
      axesplot_train(1,c) = h(c);

      figure(fig2.Number), hold on;
      h = plot(spectrumTestSet','color', colors(c,:));
      axesplot_test(1,c) = h(c);

      s = s+a;
    end
    
    % Define the mean of spectrums
    idxMeanSpectrumTest = find(idx_test(t+1:t+(s-t)));
    idxMeanSpectrumTrain = find(idx_train(t+1:t+(s-t)));
    meanSpectrumTest = mean(data(idxMeanSpectrumTest(:),:));
    meanSpectrumTrain = mean(data(idxMeanSpectrumTrain(:),:));
    
    figure(fig3.Number), hold on;
    axMeanTrain(c) = plot(meanSpectrumTrain,'color',colors(c,:));
    
    figure(fig4.Number), hold on;
    axMeanTest(c) = plot(meanSpectrumTest,'color',colors(c,:));
    
    t = t+(s-t);
  end

  %% Shows the images of spectrums
  figure(fig1.Number);
  legend(axesplot_train,legendText,'Location','bestoutside');
  title('First N samples training set');
  hold off;

  figure(fig2.Number);
  legend(axesplot_test,legendText,'Location','bestoutside'); 
  title('First N samples test set');
  hold off;
  
  figure(fig3.Number);
  legend(axMeanTrain,legendText,'Location','bestoutside'); 
  title('Mean training set');
  hold off;
    
  figure(fig4.Number);
  legend(axMeanTest,legendText,'Location','bestoutside');
  title('Mean test set');
  hold off;
end