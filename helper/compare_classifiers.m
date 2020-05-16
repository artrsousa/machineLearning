function compare_classifiers(file)
    load(file,'results');    

    y = cell2mat(results(:,2)); x = results(:,1);

    figure; plot(y,'LineWidth',2); hold on;

    ax = gca; 
    ax.XTick = 1:size(results,1);
    ax.XTickLabels = x;
    
    ylim([0,100]); hold off;
end