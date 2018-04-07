function visualize_tsne()

% load the '.mat' files obtained at the system_test function
load('xy', 'x', 'y');
load('label', 'lab_list');

% create a figure and visualize the features.
figure;
gscatter(x, y, lab_list);
title('tsne')
end