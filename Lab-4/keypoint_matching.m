function [matches, scores, x_a, x_b, y_a, y_b] = keypoint_matching(image1, image2)


Ia_single = single(image1);
Ib_single = single(image2);
[fa, da] = vl_sift(Ia_single);
[fb, db] = vl_sift(Ib_single) ;
[matches, scores] = vl_ubcmatch(da, db);
[h,w] = size(matches);
x_a = zeros(1,w);
x_b = zeros(1,w);
y_a = zeros(1,w);
y_b = zeros(1,w);
for i=1:w
    x_a(i) = fa(1, matches(i));
    x_b(i) = fb(1, matches(i));
    y_a(i) = fa(2, matches(i));
    y_b(i) = fb(2, matches(i));
end

[drop, perm] = sort(scores, 'descend') ;
matches = matches(:, perm);
scores  = scores(perm);

figure(1) ; clf ;
imagesc(cat(2, image1, image2)) ;
axis image off ;

figure(2) ; clf ;
imagesc(cat(2, image1, image2)) ;

xa = fa(1,matches(1,:)) ;
xb = fb(1,matches(2,:)) + size(image1,2) ;
ya = fa(2,matches(1,:)) ;
yb = fb(2,matches(2,:)) ;

hold on ;
h = line([xa ; xb], [ya ; yb]) ;
set(h,'linewidth', 1, 'color', 'b') ;

vl_plotframe(fa(:,matches(1,:))) ;
fb(1,:) = fb(1,:) + size(image1,2) ;
vl_plotframe(fb(:,matches(2,:))) ;
axis image off ;
end
% figure;
% imshow('boat1.pgm');
% hold on
% perm = randperm(size(f,2)) ;
% sel = perm(1:50) ;
% h1 = vl_plotframe(f(:,sel)) ;
% h2 = vl_plotframe(f(:,sel)) ;
% set(h1,'color','k','linewidth',3) ;
% set(h2,'color','y','linewidth',2) ;
% I
% I = vl_impattern(I) ;
% image(I) ;
% figure;
% I = vl_impattern('boat2.pgm') ;
% image(I) ;