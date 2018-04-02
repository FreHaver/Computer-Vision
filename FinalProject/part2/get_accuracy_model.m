function accuracies = get_accuracy_model(modelname)
% modelnames can be: 
%               freezing-40epochs, freezing-80epochs,
%               freezing-120epochs
%               augmented-rotation, augmented-noise, 
%               augmented-saturation, augmented-none, augmented-combination
%               augmented-finetunenoise
%               best-model, worst-model

% initialize accuracies
accuracies = zeros(3, 1);

% filename
if modelname == "best-model"
    next_folder = "40_50" ;
    filename = "epoch-40_batch-50" ;
elseif modelname == "worst-model"
    next_folder = "80_100" ;
    filename = "epoch-80_batch-100" ;
else
    file_info = strsplit(modelname, '-') ;
    next_folder = file_info(1) ;
    filename = file_info(2) ;
end

nets.fine_tuned = load(fullfile("trained_nets", next_folder, strcat(filename, ".mat"))); nets.fine_tuned = nets.fine_tuned.net;
nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat')); nets.pre_trained = nets.pre_trained.net; 
data = load(fullfile("data", "cnn_assignment-lenet", 'imdb-caltech.mat'));

% get accuracy and write to matrix
[cnn_acc, svm_pre_acc, svm_post_acc] = train_svm(nets, data);
accuracies(1) = cnn_acc;
accuracies(2) = svm_pre_acc;
accuracies(3) = svm_post_acc;

end