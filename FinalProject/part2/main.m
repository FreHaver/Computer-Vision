%% main function 

% add correct path for training and predicting from liblinear instead of
% nnet
rmpath('/usr/local/MATLAB/R2018a/toolbox/nnet/')
addpath('/home/laura/Documents/AI/CV1/Computer-Vision/FinalProject/part2/liblinear-2.1/matlab/')

% setup vl_feat
run(fullfile(fileparts(mfilename('fullpath')), ...
  '..', '..', '..', '..', '..', '..', 'MATLAB', 'matconvnet-1.0-beta25', 'matlab', 'vl_setupnn.m')) ;

%% fine-tune cnn
[net, info, expdir] = finetune_cnn();

%% extract features and train svm
nets.fine_tuned = load(fullfile(expdir, 'net-epoch-60.mat')); nets.fine_tuned = nets.fine_tuned.net;
nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat')); nets.pre_trained = nets.pre_trained.net; 
data = load(fullfile(expdir, 'imdb-caltech.mat'));

%% visualize network structure
vl_simplenn_display(nets.pre_trained)

%% train classifier on extracted features
train_svm(nets, data);

%% show templates
