close all
theta = 0:30:150;
sigma = 0.5:0.2:1.5;
gamma = 0.1:0.15:0.85;

creategraphs(theta, 2, "theta")
creategraphs(sigma, 1, "sigma")
creategraphs(gamma, 5, "gamma")
function graphs = creategraphs(pars, idx, name)
    figure;
    for i=1:length(pars)
        cur_p = ones(5);
        cur_p(idx) = pars(i);
        myGabor = createGabor(cur_p(1), cur_p(2), cur_p(3), cur_p(4), cur_p(5));
        myGabor_real = myGabor(:,:,1);
        subplot(2, 3, i);
        imshow(myGabor_real)
        title([name num2str(pars(i))])
    end
end
