function show_results(result_file,idx,response,img)
    load(result_file,'results');
 
    for k = 1:size(results,1)
        predicted = results{k,3};
        
        % Plot confusion matrix
        figure; 
        confusionchart(response,predicted);
        title(results{k,1});
 
        % Define pixels predicted labels
        labels = unique(predicted);
        idx_labels = zeros(size(idx,1),size(labels,1));
        itr = 1;
        
        % Assign predicted label to each IDX(whole idx samples)
        for i = 1:size(idx, 1)
            if idx(i) ~= 0
                for j = 1:size(labels)
                    if strcmp(labels{j,1},predicted{itr,1}) == 1
                        idx_labels(i,j) = 1;
                    end
                end
                
                itr = itr + 1;
            end
        end
        
        colors = uint8(distinguishable_colors(size(labels,1))*255);
        result_image = cat(3,img,img,img);

        for c = 1:size(labels)
            result_image = idx2paint(result_image,idx_labels(:,c),1,colors(c,1),colors(c,2),colors(c,3));
        end

        show_results_predicted(result_image,labels,colors,results{k,1});
    end
end