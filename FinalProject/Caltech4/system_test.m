function [accuracy, air_im, car_im, fac_im, mot_im, ...
    air_sc, car_sc, fac_sc, mot_sc, ...
    air_an, car_an, fac_an, mot_an] = system_test(w_a, w_c, w_f, w_m, ...
    b_a, b_c, b_f, b_m, C, n_clusters, colorspace, dense)

% get the test images
[files, ~, n_files] = get_file_list("test", "airplanes");

% initalize the score an annotation lists for the different categories
air_sc = zeros(n_files - 1, 1);
car_sc = zeros(n_files - 1, 1);
fac_sc = zeros(n_files - 1, 1);
mot_sc = zeros(n_files - 1, 1);

air_an = zeros(n_files - 1, 1);
car_an = zeros(n_files - 1, 1);
fac_an = zeros(n_files - 1, 1);
mot_an = zeros(n_files - 1, 1);

% initialize the histogram matirx and label list
hist_list = zeros(n_files - 1, n_clusters);
lab_list = zeros(n_files - 1, 1);

% set the counters to zero
counter = 0;
air_count = 0;
car_count = 0;
fac_count = 0;
mot_count = 0;

% loop over the test images
for j=1:(n_files - 1)
    % get the descriptors of one image
    da = image_to_descriptors(files(j), colorspace, dense);
    
    % get the histogram data and put in in the hist_list matrix
    hist_data = get_hist_values(da, C, n_clusters);
    hist_list(j,:) = hist_data;
    
    % compute the score for the different binary classifiers, using its
    % weight and offset
    air_sc(j) = dot(w_a, hist_data) + b_a;
    car_sc(j) = dot(w_c, hist_data) + b_c;
    fac_sc(j) = dot(w_f, hist_data) + b_f;
    mot_sc(j) = dot(w_m, hist_data) + b_m;
    
    % if an image is from a certain category and the binary classifier of
    % that category gives a score > 0 it should receive a point. Also when
    % the image is not in the category and the other classifiers give a
    % score < 0, they should get a point.
    if contains(files(j), "air")
        lab_list(j) = 1;
        air_an(j) = 1;
        if air_sc(j) > 0
            air_count = air_count + 1;
        end
        if car_sc(j) < 0
            car_count = car_count + 1;
        end
        if fac_sc(j) < 0
            fac_count = fac_count + 1;
        end
        if mot_sc(j) < 0
           	mot_count = mot_count + 1;
        end       
    elseif contains(files(j), "car")
        lab_list(j) = 2;
        car_an(j) = 1;
        if air_sc(j) < 0
            air_count = air_count + 1;
        end
        if car_sc(j) > 0
            car_count = car_count + 1;
        end
        if fac_sc(j) < 0
            fac_count = fac_count + 1;
        end
        if mot_sc(j) < 0
           	mot_count = mot_count + 1;
        end
    elseif contains(files(j), "fac")
        lab_list(j) = 3;
        fac_an(j) = 1;
        if air_sc(j) < 0
            air_count = air_count + 1;
        end
        if car_sc(j) < 0
            car_count = car_count + 1;
        end
        if fac_sc(j) > 0
            fac_count = fac_count + 1;
        end
        if mot_sc(j) < 0
           	mot_count = mot_count + 1;
        end
    else
        lab_list(j) = 4;
        mot_an(j) = 1;
        if air_sc(j) < 0
            air_count = air_count + 1;
        end
        if car_sc(j) < 0
            car_count = car_count + 1;
        end
        if fac_sc(j) < 0
            fac_count = fac_count + 1;
        end
        if mot_sc(j) > 0
           	mot_count = mot_count + 1;
        end
    end
    
    % get the index of the highest scoring classifier. If this index is
    % equal to the category label, the whole system gets a point.
    [~, index] = max([air_sc(j), car_sc(j), fac_sc(j), mot_sc(j)]);
    if index == lab_list(j)
        counter = counter + 1;
    end
    
end 

% compute the accuracies by dividing the counters by the number of files
accuracy = counter / n_files;
air_acc = air_count / n_files;
car_acc = car_count / n_files;
fac_acc = fac_count / n_files;
mot_acc = mot_count / n_files;

% sort the scores in descending order and store the sorting order
[air_sc, air_sort_index] = sort(air_sc, 'descend');
[car_sc, car_sort_index] = sort(car_sc, 'descend');
[fac_sc, fac_sort_index] = sort(fac_sc, 'descend');
[mot_sc, mot_sort_index] = sort(mot_sc, 'descend');

% use the sorting order to rearrange the images and annotations
air_im = files(air_sort_index);
car_im = files(car_sort_index);
fac_im = files(fac_sort_index);
mot_im = files(mot_sort_index);

air_an = air_an(air_sort_index);
car_an = car_an(car_sort_index);
fac_an = fac_an(fac_sort_index);
mot_an = mot_an(mot_sort_index);

% use tsne to convert the hist_list data into two dimensions.
mappedX = tsne(hist_list);
x = mappedX(:,1);
y = mappedX(:,2);

save('label.mat', 'lab_list')
save('xy.mat', 'x', 'y');

% show the accuracies
fprintf('the accuracy of for airplane svm: %f \n', air_acc)
fprintf('the accuracy of for cars svm:     %f \n', car_acc)
fprintf('the accuracy of for faces svm:    %f \n', fac_acc)
fprintf('the accuracy of for motorbikes svm: %f \n', mot_acc)

end