%{
hsi2matrix.m
  Transoforms a hypercube into a matrix
  
  Inputs:
      CUBE: HSI hypercube sample
  Outputs:
      X: Corresponding matrix
%}
function [ X ] = hsi2matrix( CUBE )

  if (ndims(CUBE) ~= 3)
    error('A entrada deve possuir 3 dimens�es n x p x \lambda.');
  end
  
  [rows, cols, wavelength] = size(CUBE);    
%      X = reshape(CUBE, rows*cols, wavelength);     

  X = zeros(rows*cols,size(CUBE,3));    
  for i = 1 : rows
    l = (i-1) * cols;
    for j = 1 : cols
      spectro = CUBE(i:i,j:j,:);
      X(l+j,:) = squeeze(spectro(:,1,:));
    end
  end
end

