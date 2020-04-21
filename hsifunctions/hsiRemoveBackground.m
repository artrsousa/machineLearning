function [Y] = hsiRemoveBackground(X)
    [~, Xscore,~,~, Xexplained,~] = pca(X);    

    pcs = 1;
    while (sum(Xexplained(1:pcs,1)) < 95)
        pcs = pcs +1;
    end
    Y = getClusters(Xscore,pcs,2);
end

