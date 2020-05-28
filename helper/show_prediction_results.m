%{
show_prediction_results.m
  Shows images with the predicted results
  
  Inputs:
      image:   Samples image
      labels:  Labels
      colors:  Colors for each class
      imtitle: Title of the image
%}
function show_prediction_results(image,labels,colors,imtitle)
  figure; imshow(image); hold on;
  title(imtitle);
  for i = 1:length(labels)
    scatter([],[],1,colors(i,:),'filled','DisplayName',labels{i});
  end
  hold off; legend('Location','bestoutside');
end