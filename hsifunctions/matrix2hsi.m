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

