
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
load casca_prata;
load polpa_prata;

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

%%  PREPARE DATA
hsi_samples = struct('banana_maca',{{polpa_maca,casca_maca}}, ...
    'banana_nanica',{{polpa_nanica,casca_nanica}}, ...
    'banana_prata',{{polpa_prata,casca_prata}});

%%  CLASSIFIERS PIPELINE
hsi_classifiers_kmeans(hsi_samples);
