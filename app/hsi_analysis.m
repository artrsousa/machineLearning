%{
hsi_analysis.m
  This is script runs the pipeline for
  the classification
%}
disp('hsi_analysis: Started');
% Prepares the data
hsi_samples = struct('BananaMaca',{{polpa_maca}}, ...
  'BananaNanica',{{polpa_nanica}}, ...
  'BananaPrata',{{polpa_prata}});
% Classifiers Pipeline
hsi_classifiers_kmeans(hsi_samples);
disp('hsi_analysis: Finished');