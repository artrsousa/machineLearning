%{
hsiGetImageLayer.m
  Returns a layer image from the HSI hypercube
  
  Inputs:
      CUBE: HSI hypercube sample
      layer: Number of layer
  Outputs:
      image: Layer image
%}
function [ image ] = hsiGetImageLayer(CUBE, layer)
  image = mat2gray(hsiGetLayer(CUBE, layer));
end