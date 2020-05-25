%{
main.m
  This is the main file of the toolbox.
  It sets up the workspace, loads the data,
  prepare and execute the HSI Analysis.

  The HSI Banana Dataset consists into 4 banana species:
  maça, marmelo, nanica and prata. For each specie,
  we have the banana peel and pulp, except the 'marmelo',
  which we have only the peel. The files with the data are
  in the 'dataset/banana' directory.
%}
% Initializes the workspace
init;
% Loads the dataset
loadDataset;
% Starts the HSI analysis
hsi_analysis;