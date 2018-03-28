function [accuracy, air_im, car_im, fac_im, mot_im, ...
    air_sc, car_sc, fac_sc, mot_sc, ...
    air_an, car_an, fac_an, mot_an] = system_test(w_a, w_c, w_f, w_m, ...
    b_a, b_c, b_f, b_m, C, n_clusters, colorspace, dense)

[files, ~, n_files] = get_file_list("test", "airplanes");

air_sc = zeros(n_files - 1, 1);
car_sc = zeros(n_files - 1, 1);
fac_sc = zeros(n_files - 1, 1);
mot_sc = zeros(n_files - 1, 1);

air_an = zeros(n_files - 1, 1);
car_an = zeros(n_files - 1, 1);
fac_an = zeros(n_files - 1, 1);
mot_an = zeros(n_files - 1, 1);

hist_list = zeros(n_files - 1, n_clusters);
lab_list = zeros(n_files - 1, 1);

counter = 0;
air_count = 0;
car_count = 0;
fac_count = 0;
mot_count = 0;


for j=1:(n_files - 1)
    da = image_to_descriptors(files(j), colorspace, dense);
    hist_data = get_hist_values(da, C, n_clusters);
    hist_list(j,:) = hist_data;
    
    air_sc(j) = dot(w_a, hist_data) + b_a;
    car_sc(j) = dot(w_c, hist_data) + b_c;
    fac_sc(j) = dot(w_f, hist_data) + b_f;
    mot_sc(j) = dot(w_m, hist_data) + b_m;
    
    
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
    
    [~, index] = max([air_sc(j), car_sc(j), fac_sc(j), mot_sc(j)]);
    if index == lab_list(j)
        counter = counter + 1;
    end
    
end 

accuracy = counter / n_files;
air_acc = air_count / n_files;
car_acc = car_count / n_files;
fac_acc = fac_count / n_files;
mot_acc = mot_count / n_files;


[air_sc, air_sort_index] = sort(air_sc, 'descend');
[car_sc, car_sort_index] = sort(car_sc, 'descend');
[fac_sc, fac_sort_index] = sort(fac_sc, 'descend');
[mot_sc, mot_sort_index] = sort(mot_sc, 'descend');

air_im = files(air_sort_index);
car_im = files(car_sort_index);
fac_im = files(fac_sort_index);
mot_im = files(mot_sort_index);

air_an = air_an(air_sort_index);
car_an = car_an(car_sort_index);
fac_an = fac_an(fac_sort_index);
mot_an = mot_an(mot_sort_index);

mappedX = tsne(hist_list);
x = mappedX(:,1);
y = mappedX(:,2);

save('label.mat', 'lab_list')
save('xy.mat', 'x', 'y');

fprintf('the accuracy of for airplane svm: %f \n', air_acc)
fprintf('the accuracy of for cars svm:     %f \n', car_acc)
fprintf('the accuracy of for faces svm:    %f \n', fac_acc)
fprintf('the accuracy of for motorbikes svm: %f \n', mot_acc)

end