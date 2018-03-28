function write_to_html(air_im, car_im, fac_im, mot_im, n_im, n_clusters, n_svm, colorspace, dense)

if dense
    dense = "True";
else
    dense = "False";
end

filename = strcat('html_files/im',string(n_im),'_voc', string(n_clusters),'_svm', string(n_svm), '_kerLIN_', string(colorspace), '_', dense, '.txt');
fileID = fopen(filename, 'w');

fprintf(fileID, '%s \n', 'header');
for i = 1:length(air_im)
    fprintf(fileID, '<tr><td><img src="Caltech4/%s.jpg" /></td><td><img src="Caltech4/%s.jpg" /></td><td><img src="Caltech4/%s.jpg" /></td><td><img src="Caltech4/%s.jpg" /></td></tr> \n', ...
    char(air_im(i)), char(car_im(i)), char(fac_im(i)), char(mot_im(i)));
end

fclose(fileID);

end


