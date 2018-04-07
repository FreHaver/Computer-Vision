function write_to_html(air_im, car_im, fac_im, mot_im, n_im, n_clusters, n_svm, colorspace, dense)

% convert logical to string so it can be used in the filename
if dense
    dense = "True";
else
    dense = "False";
end

% create the filename using the different hyperparameters
filename = strcat('html_files/im',string(n_im),'_voc', string(n_clusters),'_svm', string(n_svm), '_kerLIN_', string(colorspace), '_', dense, '.txt');
fileID = fopen(filename, 'w');

% write the image lists in a html format
% !! NOTE !! The txt files in the html_files folder were made using an 
% older vesion of this function. They all had to be changed manually, while
% this giving the right piece of html
for i = 1:length(air_im)
    fprintf(fileID, '<tr><td><img src="../%s" /></td><td><img src="../%s" /></td><td><img src="../%s" /></td><td><img src="../%s" /></td></tr> \n', ...
    char(air_im(i)), char(car_im(i)), char(fac_im(i)), char(mot_im(i)));
end

% close the file
fclose(fileID);

end


