%% CONFIGURE ENVIRONMENT
close all; clc; clear;

%   add folders to path
config;

% LOAD DATASET
%   BANANA - HSI
%       casca_maca, casca_marmelo, casca_nanica, casca_prata
%       polpa_maca, polpa_nanica, polpa_prata
load casca_maca;
load polpa_maca;
load casca_nanica;
load polpa_nanica;

% HSI FUNCTIONS
%   [Y,C,sumd,D] = getClusters( PCAscore, pcs, k )
%   X = hsi2matrix(CUBE)
%   [image] = hsiGetImageLayer(CUBE, layer)
%   [I] = hsiGetLayer(CUBE,layer)
%   [normalizedCUBE] = hsiNormalize(CUBE)
%   [Y] = hsiRemoveBackground(X)
%   [image] = hsiShowLayer(CUBE,layer)
%   [] = hsiShowSpectrum(CUBE,x,y)
%   [CUBE] = matrix2hsi(X,n,p)
%   [gray_image,rgb_image,fig] = showClusterOnImage(image,idx,cluster,r,g,b)

%%  GENERATE THE HYPERCUBE
banana_maca = cat(1,casca_maca,polpa_maca);
banana_nanica = cat(1,casca_nanica,polpa_nanica);
% banana_prata = cat(1,casca_maca,polpa_maca);

hsi_samples = {banana_maca,banana_nanica};
predictor_names = {'banana_maca', 'banana_nanica'};

hsi_classifiers(hsi_samples,predictor_names);



