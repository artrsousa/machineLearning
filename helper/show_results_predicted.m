function show_results_predicted(image,labels,colors,imtitle)
    figure; imshow(image); hold on;
    title(imtitle);
    for i = 1:length(labels)
      scatter([],[],1,colors(i,:),'filled','DisplayName',labels{i});
    end
    hold off; legend('Location','bestoutside');
end