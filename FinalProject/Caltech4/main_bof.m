function [ap_air, ap_car, ap_fac, ap_mot, air_im, car_im, fac_im, mot_im, ...
    air_sc, car_sc, fac_sc, mot_sc] = main_bof(n_clus_im, n_clusters, n_s, colorspace, dense)

% categories to use to extract images from
categories = ["airplanes", "cars", "faces", "motorbikes"];

fprintf('retrieve descriptors of %i images of each category \n', n_clus_im)
% number of images used per category, maximum = 200
n_clus_im = [1, n_clus_im];

% retrieve descriptors of the first n_clus_im images in the files
da = retrieve_descriptors(categories, n_clus_im, colorspace, dense);

if size(da,2) > 300000
    fprintf('size da: %i, %i \n', size(da));
    k = randperm(size(da,2));
    k = k(1:300000);
    da = da(:, k);
else
    fprintf('size is fine!\n')
    
% vl_kmeans returns the cluster centroid matrix C
fprintf('compute kmeans with %i clusters \n', n_clusters)
[C, ~] = vl_kmeans(da, n_clusters);

fprintf('get the weight and ofset for the four categories \n')
[w_a, b_a] = svmtrainer(categories(1), categories, C, n_clusters, n_clus_im, n_s);
[w_c, b_c] = svmtrainer(categories(2), categories, C, n_clusters, n_clus_im, n_s);
[w_f, b_f] = svmtrainer(categories(3), categories, C, n_clusters, n_clus_im, n_s);
[w_m, b_m] = svmtrainer(categories(4), categories, C, n_clusters, n_clus_im, n_s);

fprintf('get ranked list of images per categroy \n')
[air_im, air_sc, air_an] = system_test(categories(1), C, n_clusters, colorspace, dense, w_a, b_a);
[car_im, car_sc, car_an] = system_test(categories(2), C, n_clusters, colorspace, dense, w_c, b_c);
[fac_im, fac_sc, fac_an] = system_test(categories(3), C, n_clusters, colorspace, dense, w_f, b_f);
[mot_im, mot_sc, mot_an] = system_test(categories(4), C, n_clusters, colorspace, dense, w_m, b_m);

fprintf('get the average precision per category \n')

ap_air = get_ap(air_an);
ap_car = get_ap(car_an);
ap_fac = get_ap(fac_an);
ap_mot = get_ap(mot_an);
end

