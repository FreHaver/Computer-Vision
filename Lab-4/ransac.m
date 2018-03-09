function [output] = ransac(matches, points, n)
    
    for i=1:n
        [h, w] = size(matches);
        k = randperm(w);
        sample_matches = matches(:, k(1:points));
        
    end
    
   

    
end