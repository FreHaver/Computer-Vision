function [hist_values] = get_hist_values(da, C, n_clusters)

% get the indexes of the closest cluster centroids per descriptor
index = vl_ikmeanspush(uint8(da), int32(C));

% create a histogram of the indexes, where a normalization has to
% be in place to correct for the number of descriptors.
hist = histogram(index, n_clusters, 'Normalization', 'probability');

% multiply the histogram values by 100 to make sure there is
% enough destinction between the values (without the svm performs
% very poorly)
hist_values = 100 * hist.Values;
end