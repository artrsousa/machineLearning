%{
hsiShowSpectrum.m
  Shows spectrum from hypercube
  
  Inputs:
      CUBE: HSI hypercube
      x: X-axis index
      y: Y-axis index
%}
function [] = hsiShowSpectrum( CUBE, x, y )
  figure;
  plot(hsi2matrix(CUBE(x:x,y:y,:)));
end

