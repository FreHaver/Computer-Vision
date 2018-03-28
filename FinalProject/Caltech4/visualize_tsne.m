function visualize_tsne()

load('xy', 'x', 'y');
load('label', 'lab_list');

figure;
gscatter(x, y, lab_list);
title('tsne')
end