function [descriptor_matrix] = retrieve_descriptors(categories, n_files)
da = zeros(128,1);

for j=1:length(categories)
    % get the filenames of the specific category
    filename = strcat('ImageSets/', categories(j), '_train.txt');
    file_open = fopen(filename);
    formatSpec = '%22c';
    A = strcat(strsplit(fscanf(file_open,formatSpec), '\n'), '.jpg');
    fclose(file_open);
    
    % make a list with all the file names in that map
    file_list = fullfile('ImageData', A); 
    
    % loop over filenames from n_files(1) till n_files(2)
    for i=n_files(1):n_files(2)
        try
            % convert image to grayscale
            I = rgb2gray(imread(char(file_list(i))));
        catch
            % if the image is already in grayscale, just read the image
            I = imread(char(file_list(i)));
            fprintf('file already in grayscale: %s \n', char(file_list(i)));
        end
        % convert the type of the image to single
        I = single(I);
        
        % apply sift and store the descriptors
        [~, new_da] = vl_sift(I);
        
        % concatinate all descriptors
        da = horzcat(da, new_da);
    end
end

% remove the first column of zeros and return descriptor matrix
descriptor_matrix = double(da(:,2:size(da,2)));
end