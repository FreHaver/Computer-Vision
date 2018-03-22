function [descriptor_matrix] = retrieve_descriptors(categories, n_files, colorspace, dense)

for j=1:length(categories)
    % get the filenames of the images in the training set of a specific
    % category
    filename = strcat('ImageSets/', categories(j), '_train.txt');
    file_open = fopen(filename);
    formatSpec = '%22c';
    A = strcat(strsplit(fscanf(file_open,formatSpec), '\n'), '.jpg');
    fclose(file_open);
    
    % make a list with all the file names in that map
    file_list = fullfile('ImageData', A); 
    
    % initialize the matrix with the first feature descriptors
    da = image_to_descriptors(file_list(n_files(1)), colorspace, dense);
    
    % if there are more than 1 images to be 
    if (n_files(2) - n_files(1)) > 0
    % loop over filenames from n_files(1) till n_files(2)
        for i=(n_files(1) + 1) : n_files(2)
            new_da = image_to_descriptors(file_list(i), colorspace, dense);

            % concatinate all descriptors
            da = horzcat(da, new_da);

        end
    end
end

% remove the first column of zeros and return descriptor matrix
descriptor_matrix = single(da);
end