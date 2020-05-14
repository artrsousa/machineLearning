function data_analysis(hsi_samples)
    hsi_data = hsi_samples;
    pred_names = fieldnames(hsi_samples);

    for c = 1:size(pred_names,1)
        x = hsi_data.(pred_names{c,1});
        for l = 1:size(x,2)
            samples = x{l};
            
        end
    end