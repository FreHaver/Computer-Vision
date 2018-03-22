function [images, score_list, annotation] = system_test(category, C, n_clusters, colorspace, dense, weight, bias)

% open text file of the specific category with the test images
fprintf('retrieving test images for category %s \n', category)
filename = strcat('Annotation/', category, '_test.txt');
file_open = fopen(filename, 'r');
formatSpec = '%22c';
A = fscanf(file_open,formatSpec);
B = strsplit(A, '\n');
b_len = length(B);
annotation = zeros(b_len-1,1);

% for every line, split the filename from the annotation
for j=1:(b_len - 1)
   splitted = strsplit(char(B(j)), ' ');
   imname(j) = splitted(1);
   annotation(j) = str2num(char(splitted(2)));
end
D = strcat(imname, '.jpg');
fclose(file_open);
file_list = fullfile('ImageData', D); 

% for all the images in the text file, retrieve the score with the weight
% and bias/offset. Also store the histogram data in a list
score_list = zeros(b_len-1,1);
hist_list = zeros(b_len-1, n_clusters);
lab_list = zeros(b_len-1,1);
for j=1:(b_len - 1)
    da = image_to_descriptors(file_list(j), colorspace, dense);
    index = vl_ikmeanspush(uint8(da), int32(C));
    hist = histogram(index, n_clusters, 'Normalization', 'probability');
    hist_data = 100 * hist.Values;
    hist_list(j,:) = hist_data;
    if contains(file_list(j), "air")
        lab_list(j) = 1;
    elseif contains(file_list(j), "car")
        lab_list(j) = 2;
    elseif contains(file_list(j), "fac")
        lab_list(j) = 3;
    else
        lab_list(j) = 4;
    end
    score_list(j) = dot(weight, hist_data) + bias;
end 

[score_list, sort_index] = sort(score_list, 'descend');
images = imname(sort_index);
annotation = annotation(sort_index);
mappedX = tsne(hist_list);
x = mappedX(:,1);
y = mappedX(:,2);

label_name = strcat('label_',string(category),'.mat');
save(label_name, 'lab_list')
matrix_name = strcat('xy_', string(category),'.mat');
save(matrix_name, 'x', 'y');

end