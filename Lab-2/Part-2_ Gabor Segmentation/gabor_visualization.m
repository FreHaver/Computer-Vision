close all
clear all
clc

% give the parameters a list of values they will take on.
theta = 0:0.3:pi/2;
sigma = 0.5:0.2:1.5;
gamma = 0.1:0.2:1.1;

% use the function below to create graphs of the theta, sigma and gamma
% parameter, while keeping the other two parameters constant.
creategraphs(theta, 2, "theta")
creategraphs(sigma, 1, "sigma")
creategraphs(gamma, 5, "gamma")
function graphs = creategraphs(pars, idx, name)
    % create a new figure for every parameter
    figure;
    for i=1:length(pars)
        % set all the parameters to one
        cur_p = ones(5);
        
        % change the right parameter to a different value
        cur_p(idx) = pars(i);
        
        % create the gabor filter and take the real part
        myGabor = createGabor(cur_p(1), cur_p(2), cur_p(3), cur_p(4), cur_p(5));
        myGabor_real = myGabor(:,:,1);
        
        % create a subplot for every parameter value
        subplot(2, 3, i);
        imshow(myGabor_real)
        title([name num2str(pars(i))])
    end
end
