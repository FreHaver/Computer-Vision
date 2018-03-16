%% just trying, in the end everything has to be split up in different functions etc.
clear all
clc

% categories to use to extract images from
categories = ["airplanes", "cars", "faces", "motorbikes"];

% number of images used per category, maximum = 200
n_clustermaking = [1, 20];

% retrieve descriptors of n random images in the files
fprintf('retrieve descriptors of %i images of each category \n', n_clustermaking(2))
da = retrieve_descriptors(categories, n_clustermaking);

% vl_kmeans returns the idx of which feature is assigned to which cluster and
% the cluster centroid matrix C
n_clusters = 400;
fprintf('compute kmeans with %i clusters \n', n_clusters)
[C, idx] = vl_kmeans(da, n_clusters);


% number to use for the training of the svm
n_s = 10;

fprintf('get the weight and ofset for svm airplanes \n')
[W_air, B_air, histogram_list] = svmtrainer(categories(1), categories, C, n_clusters, n_clustermaking, n_s);
fprintf('get the weight and ofset for svm cars \n')
[W_cars, B_cars, ~] = svmtrainer(categories(2), categories, C, n_clusters, n_clustermaking, n_s);
fprintf('get the weight and ofset for svm faces \n')
[W_faces, B_faces, ~] = svmtrainer(categories(3), categories, C, n_clusters, n_clustermaking, n_s);
fprintf('get the weight and ofset for svm cars \n')
[W_motor, B_motor, ~] = svmtrainer(categories(4), categories, C, n_clusters, n_clustermaking, n_s);

%%% test one image
%compute the different weights for an airplane image
air_score = dot(W_air', histogram_list(23,:)) + B_air;
car_score = dot(W_cars', histogram_list(23,:)) + B_cars;
fac_score = dot(W_faces', histogram_list(23,:)) + B_faces;
mot_score = dot(W_motor', histogram_list(23,:)) + B_motor;

score_vector = [air_score; car_score; fac_score; mot_score];
soft_score = softmax(score_vector);

