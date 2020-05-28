%{
loadDataset.m
  This script will load the six datasets
  to the workspace memory
%}
disp('Loading the dataset');
load casca_maca;
load polpa_maca;
load casca_nanica;
load polpa_nanica;
load casca_prata;
load polpa_prata;
disp('Dataset loaded');