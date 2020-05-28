%{
getClusters.m
  Transoforms PCA into Clusters
  
  Inputs:
      PCAscore: PCA Results
      pcs:  
      k:  
  Outputs:
      Y: 
      C: 
      sumd: 
      D: 
%}
function [Y,C,sumd,D] = getClusters( PCAscore, pcs, k )
  [Y,C,sumd,D] = kmeans(PCAscore(:, 1:pcs), k);
end