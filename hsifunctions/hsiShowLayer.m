%{
hsiShowLayer.m
  Shows a hypercube layer
  
  Inputs:
      CUBE: HSI hypercube
  Outputs:
      image: Layer number
%}
function [ image ] = hsiShowLayer(CUBE, layer)
  image = hsiGetImageLayer(CUBE, layer);
  figure;
  imshow(image);
end

