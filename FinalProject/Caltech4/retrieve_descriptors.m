function [descriptor_matrix] = retrieve_descriptors(categories, n_files, colorspace, dense)
da = zeros(128*3,1);

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
            I_color = imread(char(file_list(i)));
            I = rgb2gray(I_color);
        catch
            % if the image is already in grayscale, just read the image
            I_color = imread(char(file_list(i)));
            I = I_color;
            fprintf('file already in grayscale: %s \n', char(file_list(i)));
            continue
        end
        % convert the type of the image to single
        I = single(I);
        I_color = single(I_color);
        % apply sift and store the features
        [new_fa, ~] = vl_sift(I);
        
        % with the features, extract the descriptors of each layer
        if strcmp(colorspace, 'RGB')
            [R, G, B] = getColorChannels(I_color);
            [~, part_da_1] = vl_sift(R, 'Frames', new_fa);
            [~, part_da_2] = vl_sift(G, 'Frames', new_fa);
            [~, part_da_3] = vl_sift(B, 'Frames', new_fa);
            new_da = vertcat(part_da_1, part_da_2, part_da_3); 
        elseif strcmp(colorspace, 'rgb')
            I_rgb = rgb2normedrgb(I_color);
            [r, g, b] = getColorChannels(I_rgb);
            [~, part_da_1] = vl_sift(r, 'Frames', new_fa);
            [~, part_da_2] = vl_sift(g, 'Frames', new_fa);
            [~, part_da_3] = vl_sift(b, 'Frames', new_fa);
            new_da = vertcat(part_da_1, part_da_2, part_da_3);
        elseif strcmp(colorspace, 'opponent')
            I_opponent = rgb2opponent(I_color);
            [o1, o2, o3] = getColorChannels(I_opponent);
            [~, part_da_1] = vl_sift(o1, 'Frames', new_fa);
            [~, part_da_2] = vl_sift(o2, 'Frames', new_fa);
            [~, part_da_3] = vl_sift(o3, 'Frames', new_fa);
            new_da = vertcat(part_da_1, part_da_2, part_da_3);
        else
            fprintf('method not implemented');
        end
            
%         ConvertColorSpace(input_image, colorspace)

        % concatinate all descriptors
        da = horzcat(da, new_da);
    end
end

% remove the first column of zeros and return descriptor matrix
descriptor_matrix = double(da(:,2:size(da,2)));
end