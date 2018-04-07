function [W, B] = svmtrainer(category, categories, colorspace, C, n_clusters, n_clustermaking, n_s, dense)

% make sure the images for training the K means are not used:
n_svm = (n_clustermaking(2) + 1) : (n_clustermaking(2) + n_s);

% initialize histogram_list en label_list
histogram_list = zeros(n_s *4, n_clusters);
label_list = [];

% for every category loop over the images used to train the svm
n_categories = length(categories);
for b=1:n_categories
    for a=1:n_s
        % retrieve the descriptors of the index
        da = retrieve_descriptors(categories(b), [n_svm(a), n_svm(a)], colorspace, dense);
        
        % use descriptors and cluster centroids to get a histogram of the
        % image
        hist_data = get_hist_values(da, C, n_clusters);
        
        % insert the histogram data on the right row in the matrix
        hist_row = a + n_s * (b-1);
        histogram_list(hist_row,:) = hist_data;
        
        % create a label list with 1 if the image is from the category and 
        % -1 if the image is not from the category
        if strcmp(categories(b), category)
            label_list = vertcat(label_list, 1);
        else
            label_list = vertcat(label_list, -1);
        end
    end  
end

% use the histograms to train the svm.
[W, B] = vl_svmtrain(histogram_list', label_list, 0.2);

end