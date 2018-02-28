% sizes of box and median filter
sizes = [3, 5, 7];

% load images
image_saltpepper = imread('images/image1_saltpepper.jpg');
image_gaussian = imread('images/image1_gaussian.jpg');
actual_im = imread('images/image1.jpg');

% boolean determining whether or not to show images
show = false;

% denoise images with box filter
PSNR_box_gaus = denoiseImages('box', sizes, image_gaussian, show, 'gaussian');
PSNR_box_sp = denoiseImages('box', sizes, image_saltpepper, show, 'saltpepper');

% denoise images with median filter
PSNR_med_gaus = denoiseImages('median', sizes, image_gaussian, show, 'gaussian');
PSNR_med_sp = denoiseImages('median', sizes, image_saltpepper, show, 'saltpepper');

% denoise images with Gaussian filter
pars = [0.5, 3; 1, 3; 2, 3];
PSNR_gaus_gaus = denoiseImages('gaussian', pars, image_gaussian, show, 'gaussian');

function [PSNR] = denoiseImages(filter, argin, im, fig, noise)

    % initialize figure if fig set to true
    if fig == true
        figure;
    end
    
    % intialize vector for PSNR values per par
    PSNR = zeros([length(argin), 1]);
    
    % for each par in argin 
    for i = 1:length(argin)
        
        % if filter is Gaussian use extra par and set name for imaeg title
        if strcmp(filter, 'gaussian')
            name = ' sigma ';
            denoised = denoise(im, filter, argin(i,2), argin(i,1));
        else
            name = ' size ';
            denoised = denoise(im, filter, argin(i));
        end
        
        % if fig set to true show images
        if fig == true
            subplot(1, length(argin), i);
            imshow(denoised)
            title([noise ' noise, ' filter ' filter, ' name num2str(argin(i))])
        end
        
        % calculte PSNR
        PSNR(i) = myPSNR(im, denoised);
    end
end