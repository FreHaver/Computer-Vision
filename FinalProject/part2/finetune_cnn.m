function [net, info, expdir] = finetune_cnn(varargin)

%% Define options
run(fullfile(fileparts(mfilename('fullpath')), ...
  '..', '..', '..', '..', '..', '..', 'MATLAB', 'matconvnet-1.0-beta25', 'matlab', 'vl_setupnn.m')) ;

opts.modelType = 'lenet' ;
[opts, varargin] = vl_argparse(opts, varargin) ;

opts.expDir = fullfile('data', ...
  sprintf('cnn_assignment-%s', opts.modelType)) ;
[opts, varargin] = vl_argparse(opts, varargin) ;

opts.dataDir = './data/' ;
opts.imdbPath = fullfile(opts.expDir, 'imdb-caltech.mat');
opts.whitenData = true ;
opts.contrastNormalization = true ;
opts.networkType = 'augmentednn' ;
% possibilities of augmentation: rotate, saturation, noise, none or
% combination (combines best working augmentations)
opts.augmentation = 'saturation' ;
opts.augmentationFrequency = 0.8;
opts.train = struct() ;
opts = vl_argparse(opts, varargin) ;
if ~isfield(opts.train, 'gpus'), opts.train.gpus = []; end;

opts.train.gpus = [];



%% update model
net = update_model();

%% TODO: Implement getCaltechIMDB function below
if exist(opts.imdbPath, 'file')
    imdb = load(opts.imdbPath);
else
    imdb = getCaltechIMDB() ;
    mkdir(opts.expDir) ;
    save(opts.imdbPath, '-struct', 'imdb') ;
end

%%
net.meta.classes.name = imdb.meta.classes(:)' ;

% -------------------------------------------------------------------------
%                                                                     Train
% -------------------------------------------------------------------------

trainfn = @cnn_train ;
[net, info] = trainfn(net, imdb, getBatch(opts), ...
  'expDir', opts.expDir, ...
  net.meta.trainOpts, ...
  opts.train, ...
  'val', find(imdb.images.set == 2)) ;

expdir = opts.expDir;
end
% -------------------------------------------------------------------------
function fn = getBatch(opts)
% -------------------------------------------------------------------------
switch lower(opts.networkType)
  case 'simplenn'
    fn = @(x,y) getSimpleNNBatch(x,y) ;
  case 'augmentednn'
    fn = @(x,y) getAugmentedNNBatch(x,y,opts.augmentation,opts.augmentationFrequency) ;
  case 'dagnn'
    bopts = struct('numGpus', numel(opts.train.gpus)) ;
    fn = @(x,y) getDagNNBatch(bopts,x,y) ;
end

end

function [images, labels] = getSimpleNNBatch(imdb, batch)
% -------------------------------------------------------------------------
images = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(1,batch) ;
if rand > 0.5
    images=fliplr(images) ;
end
end

function [images, labels] = getAugmentedNNBatch(imdb, batch, type, frequency)
% -------------------------------------------------------------------------
images = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(1,batch) ;
num = rand;
if num > (1 - frequency)
    switch type
        case 'none'
            images = images;
        case 'noise'
            for i = 1:size(images, 4)
                images(:,:,:,i) = imnoise(images(:,:,:,i), "gaussian");
            end
        case 'saturation'
            for i = 1:size(images, 4)
                
                % convert to hsv
                hsv_im = rgb2hsv(images(:,:,:,i)) ;
                % increase saturation
                hsv_im(:,:,2) = hsv_im(:,:,2) * 1.2 ;
                % threshold too high values
                hsv_im(hsv_im > 1) = 1 ;
                % convert back to rgb
                images(:,:,:,i) = hsv2rgb(hsv_im) ;
                
            end
        case 'rotate'
            angles = 0:10:180;
            for i = 1:size(images, 4)
                % rotate image a different angle
                images(:,:,:,i) = imresize(imrotate(images(:,:,:,i), angles(mod(i, length(angles)) + 1)), [32 32]) ;
            end
        case 'combination'
            num2 = rand;
            if num2 < 0.5
                images=fliplr(images) ;
            elseif num2 > 0.5
                for i = 1:size(images, 4)
                
                    % convert to hsv
                    hsv_im = rgb2hsv(images(:,:,:,i)) ;
                    % increase saturation
                    hsv_im(:,:,2) = hsv_im(:,:,2) * 1.2 ;
                    % threshold too high values
                    hsv_im(hsv_im > 1) = 1 ;
                    % convert back to rgb
                    images(:,:,:,i) = hsv2rgb(hsv_im) ;

                end
            end
    end 
end

end

% -------------------------------------------------------------------------
function imdb = getCaltechIMDB()
% -------------------------------------------------------------------------
% Preapre the imdb structure, returns image data with mean image subtracted
classes = {'airplanes', 'cars', 'faces', 'motorbikes'};
splits = {'train', 'test'};

%% TODO: Implement your loop here, to create the data structure described in the assignment
data = zeros(32, 32, 3, 1);
labels = [];
sets = [];
for i = 1:length(classes)
    
    for j = 1:length(splits)
        % get the filenames of the specific category
        filename = fullfile('..', 'Caltech4', 'ImageSets', strcat(classes{i}, '_', splits{j}, '.txt'));
        file_open = fopen(filename);

        formatSpec = '%22c';
        A = strcat(strsplit(fscanf(file_open, formatSpec), '\n'), '.jpg');
        fclose(file_open);

        % make a list with all the file names in that map
        file_list = fullfile('..', 'Caltech4', 'ImageData', A); 

        % loop over filenames from n_files(1) till n_files(2)
        for h = 1:length(file_list)
            im_color = single(imread(file_list{h}));
            im_color = imresize(im_color, [32 32]);
            if length(size(im_color)) == 2
                continue
            end
            data = cat(4, data, im_color);
            labels = horzcat(labels, single(i));
            sets = horzcat(sets, single(j));
        end
    end
end
data = data(:, :, :, 2:end);

%%
% subtract mean
dataMean = mean(data(:, :, :, sets == 1), 4);
data = bsxfun(@minus, data, dataMean);

imdb.images.data = data ;
imdb.images.labels = single(labels) ;
imdb.images.set = sets;
imdb.meta.sets = {'train', 'val'} ;
imdb.meta.classes = classes;

perm = randperm(numel(imdb.images.labels));
imdb.images.data = imdb.images.data(:,:,:, perm);
imdb.images.labels = imdb.images.labels(perm);
imdb.images.set = imdb.images.set(perm);

end
