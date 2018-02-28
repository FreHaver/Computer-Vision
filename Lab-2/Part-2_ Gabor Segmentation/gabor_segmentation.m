%% Hyperparameters
k        = 2;      % number of clusters in k-means algorithm. By default, 
                   % we consider k to be 2 in foreground-background segmentation task.
image_id = 'Robin-1'; % Identifier to switch between input images.
                   % Possible ids: 'Kobi',    'Polar', 'Robin-1'
                   %               'Robin-2', 'Cows'

% Misc
err_msg  = 'Image not available.';

% Control settings
visFlag       = false;    %  Set to true to visualize filter responses.
smoothingFlag = false;   %  Set to true to postprocess filter outputs.

%% Read image
switch image_id
    case 'Kobi'
        img = imread('kobi.png');
        resize_factor = 0.25;
    case 'Polar'
        img = imread('./data/polar-bear-hiding.jpg');
        resize_factor = 0.75;
    case 'Robin-1'
        img = imread('./data/robin-1.jpg');
        resize_factor = 1;
    case 'Robin-2'
        img = imread('./data/robin-2.jpg');
        resize_factor = 0.5;
    case 'Cows'
        img = imread('./data/cows.jpg');
        resize_factor = 0.5;
    case 'SciencePark'
        img = imread('./data/sciencepark.jpg');
        img = permute(img,[2,1,3]);
        resize_factor = 0.2;      
        
    otherwise
        error(err_msg)
end

% Image adjustments
img      = imresize(img, resize_factor);
img_gray = rgb2gray(img);

% Display image
figure(1), imshow(img), title(sprintf('Input image: %s', image_id));

%% Design array of Gabor Filters
% In this code section, you will create a Gabor Filterbank. A filterbank is
% a collection of filters with varying properties (e.g. {shape, texture}).
% A Gabor filterbank consists of Gabor filters of distinct orientations
% and scales. We will use this bank to extract texture information from the
% input image. 

[numRows, numCols, ~] = size(img);

% Estimate the minimum and maximum of the wavelengths for the sinusoidal
% carriers. 
% ** This step is pretty much standard, therefore, you don't have to
%    worry about it. It is cycles in pixels. **   
lambdaMin = 4/sqrt(2);
lambdaMax = hypot(numRows, numCols);

% Specify the carrier wavelengths.  
% (or the central frequency of the carrier signal, which is 1/lambda)
n = floor(log2(lambdaMax/lambdaMin));
lambdas = 2.^(0:(n-2)) * lambdaMin;

% Define the set of orientations for the Gaussian envelope.
dTheta      = 2*pi/8;                  % \\ the step size
orientations = 0:dTheta:(pi/2);       

% Define the set of sigmas for the Gaussian envelope. Sigma here defines 
% the standard deviation, or the spread of the Gaussian. 
sigmas = [0.1, 0.2]; 

% Now you can create the filterbank. We provide you with a MATLAB struct
% called gaborFilterBank in which we will hold the filters and their
% corresponding parameters such as sigma, lambda and etc. 
% ** All you need to do is to implement createGabor(). Rest will be handled
%    by the provided code block. **
gaborFilterBank = struct();
tic
filterNo = 1;
for ii = 1:length(lambdas)
    for jj  = 1:length(sigmas)
        for ll = 1:length(orientations)
            % Filter parameter configuration for this filter.
            lambda = lambdas(ii);
            sigma  = sigmas(jj);            
            theta  = orientations(ll);
            psi    = 0;
            gamma  = 0.5;
            
            % Create a Gabor filter with the specs above. 
            % (We also record the settings in which they are created. )
            gaborFilterBank(filterNo).filterPairs = createGabor( sigma, theta, lambda, psi, gamma );
            gaborFilterBank(filterNo).test = gabor(lambda, theta);
            gaborFilterBank(filterNo).sigma       = sigma;
            gaborFilterBank(filterNo).lambda      = lambda;
            gaborFilterBank(filterNo).theta       = theta;
            gaborFilterBank(filterNo).psi         = psi;
            gaborFilterBank(filterNo).gamma       = gamma;
            filterNo = filterNo+1;
        end
    end
end
ctime = toc; 

fprintf('--------------------------------------\n \t\tDetails\n--------------------------------------\n')
fprintf('Total number of filters       : %d \n', length(gaborFilterBank));
fprintf('Number of scales (sigma)      : %d \n', length(sigmas));
fprintf('Number of orientations (theta): %d \n', length(orientations));
fprintf('Number of carriers (lambda)   : %d \n', length(lambdas));
fprintf('--------------------------------------\n')
fprintf('Filter bank created in %.3f seconds.\n', ctime);
fprintf('--------------------------------------\n')

%% Filter images using Gabor filter bank using quadrature pairs (real and imaginary parts)
% You will now filter the input image with each complex Gabor filter in 
% gaborFilterBank structure and store the output in the cell called 
% featureMaps. 
featureMaps = cell(length(gaborFilterBank),1);
for jj = 1 : length(gaborFilterBank)
    real_out = imfilter(img_gray, gaborFilterBank(jj).filterPairs(:,:,1), 'circular', 'corr');
    imag_out =  imfilter(img_gray, gaborFilterBank(jj).filterPairs(:,:,2), 'circular', 'corr'); 
    featureMaps{jj} = cat(3, real_out, imag_out);

    % Visualize the filter responses if you wish.
    if visFlag
        figure(2),
        subplot(121), imshow(real_out), title(sprintf('Re[h(x,y)], \\lambda = %f, \\theta = %f, \\sigma = %f',gaborFilterBank(jj).lambda,...
                                                                                                              gaborFilterBank(jj).theta,...
                                                                                                              gaborFilterBank(jj).sigma));
        subplot(122), imshow(imag_out), title(sprintf('Im[h(x,y)], \\lambda = %f, \\theta = %f, \\sigma = %f',gaborFilterBank(jj).lambda,...
                                                                                                              gaborFilterBank(jj).theta,...
                                                                                                              gaborFilterBank(jj).sigma));
        pause(1)
    end
end


%% Compute the magnitude
% Now, you will compute the magnitude of the output responses.
featureMags =  cell(length(gaborFilterBank),1);
for jj = 1:length(featureMaps)
    real_part = featureMaps{jj}(:,:,1);
    imag_part = featureMaps{jj}(:,:,2);
    featureMags{jj} = (double(real_part).^2 + double(imag_part).^2).^(1/2);
    % Visualize the magnitude response if you wish.
    if visFlag
        figure(3), 
        imshow(uint8(featureMags{jj})), title(sprintf('Re[h(x,y)], \\lambda = %f, \\theta = %f, \\sigma = %f',gaborFilterBank(jj).lambda,...
                                                                                                              gaborFilterBank(jj).theta,...
                                                                                                              gaborFilterBank(jj).sigma));
        pause(.3)    
    end
end

%% Prepare and Preprocess features 
% You can think of each filter response as a sort of feature representation
% for the pixels. Now that you have numFilters = |gaborFilterBank| filters, 
% we can represent each pixel by this many features. 
% \\ Q: What kind of features do you think gabor filters might correspond to? 

% You will now implement a smoothing operation over the magnitude images in
% featureMags. 
% \\ Hint: For each i in [1, length(featureMags)], smooth featureMags{i}
%          using an appropriate first order Gaussian kernel.
% \\ Hint: doc imfilter, doc fspecial or doc imgaussfilt.  
features = zeros(numRows, numCols, length(featureMags));
if smoothingFlag
    % apply gaussian filter to each gabor filtered image with parameter
    % based on the corresponding gabor filter
    % sigma is multiplied by 3 to have a larger smoothing neighborhood
    % inspired by: https://nl.mathworks.com/help/images/texture-segmentation-using-gabor-filters.html
    for jj = 1:length(gaborFilterBank)
        sigma = 0.5 * gaborFilterBank(jj).lambda;
        features(:,:,jj) = imgaussfilt(featureMags{jj}, 3*sigma); 
    end
else
    % Don't smooth but just insert magnitude images into the matrix
    % called features.
    
    for jj = 1:length(featureMags)
        features(:,:,jj) = featureMags{jj};
    end
end


% Reshape the filter outputs (i.e. tensor called features) of size 
% [numRows, numCols, numFilters] into a matrix of size [numRows*numCols, numFilters]
% This will constitute our data matrix which represents each pixel in the 
% input image with numFilters features.  
features = reshape(features, numRows * numCols, []);


% Standardize features by substracting the mean and dividing by st. dev.
% per feature (so per column)
mean_per_filter = mean(features, 1);
features_min_mean = features - mean_per_filter;
std_per_filter = std(features_min_mean, 0, 1);
features = features_min_mean ./ std_per_filter;

% (Optional) Visualize the saliency map using the first principal component 
% of the features matrix. It will be useful to diagnose possible problems 
% with the pipeline and filterbank.  
coeff = pca(features);
feature2DImage = reshape(features*coeff(:,1),numRows,numCols);
figure(4)
imshow(feature2DImage,[]), title('Pixel representation projected onto first PC')


% Apply k-means algorithm to cluster pixels using the data matrix,
% features. 
tic
pixLabels = kmeans(features, k, 'Replicates', 5);
ctime = toc;
fprintf('Clustering completed in %.3f seconds.\n', ctime);



% Visualize the clustering by reshaping pixLabels into original grayscale
% input size [numRows numCols].
pixLabels = reshape(pixLabels,[numRows numCols]);

figure(5)
imshow(label2rgb(pixLabels)), title('Pixel clusters');



% Use the pixLabels to visualize segmentation.
Aseg1 = zeros(size(img),'like',img);
Aseg2 = zeros(size(img),'like',img);
BW = pixLabels == 2;
BW = repmat(BW,[1 1 3]);
Aseg1(BW) = img(BW);
Aseg2(~BW) = img(~BW);
figure(6)
imshowpair(Aseg1,Aseg2,'montage')



