function [descriptor_matrix] = retrieve_descriptors(categories, n_files, colorspace, dense)

for j=1:length(categories)
    % get the filenames of the images in the training set of a specific
    % category
    [file_list, ~, ~] = get_file_list("train", categories(j));
    
    
    % initialize the matrix with the first feature descriptors
    da = image_to_descriptors(file_list(n_files(1)), colorspace, dense);
    
    % if there is more than 1 image to get the descriptors from, get the 
    % descriptors of the other images and concatenate them
    if (n_files(2) - n_files(1)) > 0
    % loop over filenames from n_files(1) till n_files(2)
        for i=(n_files(1) + 1) : n_files(2)
            new_da = image_to_descriptors(file_list(i), colorspace, dense);

            % concatinate all descriptors
            da = horzcat(da, new_da);

        end
    end
end

% return descriptor matrix
descriptor_matrix = single(da);
end