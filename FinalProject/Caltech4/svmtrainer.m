function [W, B] = svmtrainer(category, categories, colorspace, C, n_clusters, n_clustermaking, n_s, dense)

% make sure the images for training the K means are not used:
n_svm = (n_clustermaking(2) + 1) : (n_clustermaking(2) + n_s);
histogram_list = zeros(n_s *4, n_clusters);
label_list = [];

n_categories = length(categories);

for b=1:n_categories
    for a=1:n_s
        da = retrieve_descriptors(categories(b), [n_svm(a), n_svm(a)], colorspace, dense);
        index = vl_ikmeanspush(uint8(da), int32(C));
        hist = histogram(index, n_clusters, 'Normalization', 'probability');
        hist_data = 100 * hist.Values;
        hist_row = a + n_s * (b-1);
        histogram_list(hist_row,:) = hist_data;
        if strcmp(categories(b), category)
            label_list = vertcat(label_list, 1);
        else
            label_list = vertcat(label_list, -1);
        end
    end  
end

[W, B] = vl_svmtrain(histogram_list', label_list, 0.2);

end