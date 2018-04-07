function [ap_air, ap_car, ap_fac, ap_mot, air_im, car_im, fac_im, mot_im, ...
    air_sc, car_sc, fac_sc, mot_sc] = main_bof(n_clus_im, n_clusters, n_s, colorspace, dense)

% categories to use to extract images from
categories = ["airplanes", "cars", "faces", "motorbikes"];

% number of images used per category, maximum = 200
n_clus_im = [1, n_clus_im];

% retrieve descriptors of the first n_clus_im images in the image folders
fprintf('retrieve descriptors of %i images of each category \n', n_clus_im(2))
da = retrieve_descriptors(categories, n_clus_im, colorspace, dense);
  
% with the descriptors retrieved above, use kmeans to create clusters,
% returns cluster centroids (C)
fprintf('compute kmeans with %i clusters \n', n_clusters)
[C, ~] = vl_kmeans(da, n_clusters);

% Use the cluster centroids and n_s images (other images than the ones to
% make the clusters) to train the SVM. Returns weight and offset for the
% four binary classifiers.
fprintf('get the weight and offset for the four categories \n')
[w_a, b_a] = svmtrainer(categories(1), categories, colorspace, C, n_clusters, n_clus_im, n_s, dense);
[w_c, b_c] = svmtrainer(categories(2), categories, colorspace, C, n_clusters, n_clus_im, n_s, dense);
[w_f, b_f] = svmtrainer(categories(3), categories, colorspace, C, n_clusters, n_clus_im, n_s, dense);
[w_m, b_m] = svmtrainer(categories(4), categories, colorspace, C, n_clusters, n_clus_im, n_s, dense);

% With the weights and offsets obtained above the scores are computed on
% the test set. The function system_test returns the system accuracy and
% the sorted image list with their score and annotation.
fprintf('test the system and retrieve accuracy and ranked lists \n')
[accuracy, air_im, car_im, fac_im, mot_im, ...
    air_sc, car_sc, fac_sc, mot_sc, ...
    air_an, car_an, fac_an, mot_an] = system_test(w_a, w_c, w_f, w_m, ...
    b_a, b_c, b_f, b_m, C, n_clusters, colorspace, dense);

fprintf('The system accuracy is %2.4f \n', accuracy)

% compute the average precision on the ordered list of annotations.
fprintf('get the average precision per category \n')
ap_air = get_ap(air_an);
ap_car = get_ap(car_an);
ap_fac = get_ap(fac_an);
ap_mot = get_ap(mot_an);
end