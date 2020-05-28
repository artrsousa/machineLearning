%{
matrix2hsi.m
  Transoforms a matrix into a hypercube
  
  Inputs:
      X: Corresponding matrix
      n: Hypercube width
      p: Hypercube heigth
  Outputs:
      CUBE: HSI hypercube
%}
function [ CUBE ] = matrix2hsi(X, n, p )
  if (~ismatrix(X))
    error('A entrada deve possuir 2 dimens�es n x p.');
  end
  if ((n * p ) ~= size(X,1))
    error('As novas dimens�es informadas (n e p) s�o incompat�veis com a entrada matriz.');
  end
  wavelength = size(X,2);    
  CUBE = reshape(X, n, p, wavelength);    
end

