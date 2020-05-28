%{
hsiGetLayer.m
  Returns a layer from the HSI hypercube
  
  Inputs:
      CUBE: HSI hypercube
      layer: Number of layer
  Outputs:
      I: Layer
%}
function [ I ] = hsiGetLayer(CUBE, layer)
  I = CUBE(:,:,layer);
end

