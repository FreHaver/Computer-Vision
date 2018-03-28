function [hist_values] = get_hist_values(da, C, n_clusters)
index = vl_ikmeanspush(uint8(da), int32(C));
hist = histogram(index, n_clusters, 'Normalization', 'probability');
hist_values = 100 * hist.Values;
end