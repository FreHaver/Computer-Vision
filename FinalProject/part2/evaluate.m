%% evaluation and visualization
clear;
close all;

% setup vl_feat
run(fullfile(fileparts(mfilename('fullpath')), ...
  '..', '..', '..', '..', '..', '..', 'MATLAB', 'matconvnet-1.0-beta25', 'matlab', 'vl_setupnn.m')) ;

%% uncomment this to run tsne on all network features in folder hyperpar_results and save results to .mat file
% feats = run_tsne();

%% uncomment this to get accuracy of all networks in folder hyperpar_results and write to var
accs = get_accuracy();  

%% uncomment this to plot all tsnes from folder tsne
% show_tsnes()

%% run and save tsne on all hyperpar settings for pretrained and finetuned
% opens files containing features from bottleneck layer in neural net
% runs tsne on these features
% saves output from tsne to file for later visualization
function [features] = run_tsne()

% all hyperpar settigns
epochs = [40, 80, 120];
batches = [50, 100];

% loop over all settings
for i = 1:length(epochs)
    for j = 1:length(batches)
        
        % open folder containing files from these settings
        foldername = strcat("trained_nets/", num2str(epochs(i)), "_", num2str(batches(j)));
        
        % loop over fine tuned and pre trained net
        filenames = ["fine_tuned", "pre_trained"];
        for h = 1:length(filenames)
            
            % load the features
            features = load(fullfile(foldername, strcat(filenames(h), "_features.mat")));
            
            % fine_tuned net saved features differently from pre_trained
            % net, convert sparse matrix to full
            if filenames(h) == "fine_tuned"
                features = full(features.features_post);
            else
                features = full(features.features_pre);
            end
            
            % run tsne and save to file
            mappedX = tsne(features);
            save(fullfile(foldername, strcat(filenames(h), "-tsne.mat")), 'mappedX');
        end
    end
end

end

%% run train_svm for all models in directory hyperpar_results and save accuracies
% outputs matrix with accuracies 
% (rows denoting epochs, cols denoting batchsize, depth denotes the net)
function accuracies = get_accuracy()

% all hyperpar settings
epochs = [40, 80, 120];
batches = [50, 100];

% initialize accuracies
accuracies = zeros(3, 2, 3);

% loop over all hyperpar settings
for i = 1:length(epochs)
    for j = 1:length(batches)
        
        % open correct folder and load finetuned and pretrained net and
        % data
        foldername = strcat("trained_nets/", num2str(epochs(i)), "_", num2str(batches(j)));
        nets.fine_tuned = load(fullfile(foldername, strcat("epoch-", num2str(epochs(i)), "_batch-", num2str(batches(j)), ".mat"))); nets.fine_tuned = nets.fine_tuned.net;
        nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat')); nets.pre_trained = nets.pre_trained.net; 
        data = load(fullfile("data", "cnn_assignment-lenet", 'imdb-caltech.mat'));

        % get accuracy and write to matrix
        [cnn_acc, svm_pre_acc, svm_post_acc] = train_svm(nets, data);
        accuracies(i, j, 1) = cnn_acc;
        accuracies(i, j, 2) = svm_pre_acc;
        accuracies(i, j, 3) = svm_post_acc;
    end
end

end

%% function that loops over saved tsne mat files and plots them
function show_tsnes()

% get correct directory and loop over all files in it
files = dir('tsne/*.mat');
for file = files'
    
    % load tsne x- and y-coordinates
    mappedX = load(fullfile('tsne', file.name));
    mappedX = mappedX.mappedX;
    
    % get info for plot title from file name
    file_info = strsplit(file.name, '-');
    
    % if its from pretrained net (meaning no batchsize or epochs specified in filename)
    if strcmp(file_info{1}, "pre_trained")
        
        % train or testset, load correct labels from this set
        set = file_info{2};

        % set up figure title
        figure ;
        title(strcat('pre-trained ', set))
    else
        
        % get number of epochs and batches from filename
        epochs = file_info{1};
        batches = strsplit(file_info{2}, "_");
        batches = batches(1);
        
        % get set and load correct labels
        set = file_info{3};
        
        % set up figure title
        figure ;
        title(strcat('fine-tuned ', epochs, ' epochs, batch size ', batches, ' ', set))
    end
    
    % get correct labels and plot
    labels = load(fullfile('tsne', 'labels', strcat('labels_', set, '.mat')));
    labels = labels.labels_post;
    gscatter(mappedX(:,1), mappedX(:,2), labels);

end
end