function visualize_tsne(category)

switch category
    case "airplanes"
        load('xy_airplanes', 'x', 'y');
        load('label_airplanes', 'lab_list');
    case "cars"
        load('xy_cars', 'x', 'y');
        load('label_cars', 'lab_list');
    case "faces"
        load('xy_faces', 'x', 'y');
        load('label_faces', 'lab_list');
    case "motorbikes"
        load('xy_motorbikes', 'x', 'y');
        load('label_motorbikes', 'lab_list');
end
figure;
length(x)
length(y)
length(lab_list)
gscatter(x, y, lab_list);
title(['tsne', category])
end