function result_process(result_file, show_confusion_matrix, show_compare_results, show_classified_label, idx, response, img)
  load(result_file);
  label = results{1,3};
  figure;
  confusionchart(response,label);
  classes = unique(label);
  classes_idx_matrix = zeros(size(idx, 1), size(classes, 1));
  count = 1;
  sizelabel = size(label, 1);
  sizeidx = size(idx, 1);
  try
      for i = 1:sizeidx
       if(idx(i) ~= 0)
          for j = 1:size(classes)
              className = classes(j);
              labelClassName = label{count, 1};
              if(strcmp(className{1}, labelClassName))
                  classes_idx_matrix(i, j) = 1;
                  
              end
          end
          count = count + 1;
       end
      end
catch exception
    sdfsfd = 2;
  end
  

  
  colors = distinguishable_colors(size(classes, 1)) * 255;
  colors = uint8(colors);
  result_image = cat(3, img, img, img);
  %load('color.mat');
  quantidade1 = sum(classes_idx_matrix(:) == 1);
  for c = 1:size(classes)
    result_image = paint_image(result_image, classes_idx_matrix(:, c), 1, colors(c, 1), colors(c, 2), colors(c, 3));
  end
  
  show(result_image, classes, colors);
  
end