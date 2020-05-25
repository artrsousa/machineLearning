%{
idx2paint.m
  Paints a cluster on an image with the given color values of red, green and blue;
  
  Inputs:
      image:    Image to be painted
      idx:      Index of cluster
      cluster:  Cluster with the points 
      r:        Red value (0 - 255)
      g:        Green value (0 - 255)
      b:        Blue value (0 - 255)
  Outputs:
      rgb_image:Image painted
%}
function rgb_image = idx2paint(image, idx, cluster, r, g, b)
  rng(123); 

  idx = vec2mat(idx, size(image,2));
  [rows, cols] = find(idx==cluster);
  mypoints = arrayfun(@(x) [cols(x) rows(x)], 1:size(rows), 'uni', 0);
  pixels = vertcat(mypoints{:});
  ind = sub2ind([size(image, 1) size(image, 2)], pixels(:,2), pixels(:,1));
  
  red = image(:, :, 1);
  red(ind) = r;
  
  green = image(:, :, 2);
  green(ind) = g;
  
  blue = image(:, :, 3);
  blue(ind) = b;
  
  rgb_image = cat(3, red, green, blue);
end