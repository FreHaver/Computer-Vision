
name1 = 'boat1.pgm';
name2 = 'boat2.pgm'; 


Ia = imread(name1);
Ib = imread(name2);

[matches, scores, x_a, x_b, y_a, y_b] = keypoint_matching(Ia,Ib);
% ransac(matches)