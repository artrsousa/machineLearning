
%% CONFIGURE ENVIRONMENT
close all; clc; clear;

%   add folders to path
config;

% LOAD DATASET
%   BANANA - HSI
%       casca_maca, casca_marmelo, casca_nanica, casca_prata
%       polpa_maca, polpa_nanica, polpa_prata
%load casca_maca;
load polpa_maca;
%load casca_nanica;
load polpa_nanica;
%load casca_prata;
load polpa_prata;

% casca_maca = casca_maca(:,:,1:6);
% polpa_maca = polpa_maca(:,:,1:6);
% casca_nanica = casca_nanica(:,:,1:6);
% polpa_nanica = polpa_nanica(:,:,1:6);
% casca_prata = casca_prata(:,:,1:6);
% polpa_prata = polpa_prata(:,:,1:6);

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

%%  LOAD DATA
% banana_maca = cat(1,casca_maca,polpa_maca);
% banana_nanica = cat(1,casca_nanica,polpa_nanica);
% banana_prata = cat(1,casca_prata,polpa_prata);

% clear casca_maca polpa_maca casca_nanica polpa_nanica casca_prata polpa_prata;

%%  PREPARE DATA
hsi_samples = struct('banana_maca',{{polpa_maca}}, ...
    'banana_nanica',{{polpa_nanica}}, ...
    'banana_prata',{{polpa_prata}});

%%  CLASSIFIERS PIPELINE
hsi_classifiers_kmeans(hsi_samples);
% hsi_classifiers(hsi_samples,predictor_names);
