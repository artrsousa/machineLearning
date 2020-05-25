%% This function saves figures as .fig files and as images.
%% Function parameters:
%%  - fig: Figure to be saved
%%  - folder: Directory to be saved
%%  - filename: File name without extension
%%  - extension: (OPTIONAL) Image extension (.png as default)
function save_figure(fig, folder, filename, extension)
    try
        %% Create folders if they don't exist
        if ~exist(folder, 'dir')
            mkdir(folder);
        end
        
        %% If the extension is not passed as a parameter, assign .png as the default and add dot if don't startwith
        if ~exist('extension', 'var')
            extension = '.png';
        elseif(~strncmpi(extension, '.', 1))
            extension = ['.' extension];
        end
        
        %% Creates the full path of the fig
        fullfile_figure = fullfile(folder, [filename '.fig']);
        
        %% Creates the full path of the img
        fullfile_image = fullfile(folder,[filename extension]);
        
        %% Save fig and img
        savefig(fig, fullfile_figure);
        saveas(fig, fullfile_image);
    catch ME
       rethrow(ME)
    end 
end