function [m_remember, t_remember, max_inliers, a_remember, b_remember] = ransac(x_a, x_b, y_a, y_b, p, n)

    % TODO: calc least squares for final pars and inliers
    
    max_inliers = 0;
    for i=1:n
        fprintf('n is %i \n', i)
        % create a randomly shuffled list with numbers in the range 1 to
        % the lenth of x_a
        le = length(x_a);
        k = randperm(le);
        
        % use the first p points of the random shuffled list to randomly
        % sample the data.
        sample_x_a = x_a(k(1:p));
        sample_x_b = x_b(k(1:p));
        sample_y_a = y_a(k(1:p));
        sample_y_b = y_b(k(1:p));
        
        %initialization 
        inliers = 0;
        a_inliers = zeros(2,1);
        b_inliers = zeros(2,1);
        sample_size = length(sample_x_a);
        
        [A, b] = construct_matrices(sample_x_a, sample_y_a, sample_x_b, sample_y_b, p);
        
        x = pinv(A)*b;
        [m_matrix, t_vector] = get_transform_pars(x);
                
        %loop over all the interest points found by keypoint_matching
        for m = 1:le
            % transform the points from image 1 (a) with the m_matrix
            % and t vector
            x_y_trans = m_matrix * [x_a(m); y_a(m)] + t_vector;

            % compute the difference between the transformed values of
            % image 1 with the original values of image b
            x_difference = abs(x_y_trans(1) - x_b(m));
            y_difference = abs(x_y_trans(2) - y_b(m));

            % if difference in both x and y direction is smaller than
            % 10, count it as an inlier and add the points to the
            % specific array.
            if (x_difference < 10) && (y_difference < 10)
                inliers = inliers + 1;
                a_inliers = horzcat(a_inliers, [x_a(m);y_a(m)]);
                b_inliers = horzcat(b_inliers, [x_b(m);y_b(m)]);
            end
        end

        % if the amount of inliers is bigger than the amount of inliers
        % found before, store the value of the number of inliers, the m
        % matrix, t vector and the inlier points.
        if inliers > max_inliers
            max_inliers = inliers;
            fprintf('max_inliers is %i \n', max_inliers)
            a_remember = a_inliers(:,2:length(a_inliers));
            b_remember = b_inliers(:,2:length(b_inliers));
        end
    end
    
    % perform one last iteration of least squares on only inliers
    xa = a_inliers(1,:);
    xb = b_inliers(1,:);
    ya = a_inliers(2,:);
    yb = b_inliers(2,:);
    p = size(xa);
    [A, b] = construct_matrices(xa, ya, xb, yb, p(2));
    x = pinv(A)*b;
    [m_remember, t_remember] = get_transform_pars(x);
    
end

function [A, b] = construct_matrices(x_a, y_a, x_b, y_b, p)
    A = zeros(2*p, 6);
    b = zeros(2*p, 1);
    for j=1:p            
        % construct the A matrix and b vector and from those compute
        % the x vector (which is used to construct the m matrix and t
        % vector)
        A(j+j-1:j+j, :) = [x_a(j), y_a(j), 0, 0, 1, 0; 0, 0, x_a(j), y_a(j), 0, 1];
        b(j+j-1:j+j, :) = [x_b(j); y_b(j)];
    end
end

function [m, t] = get_transform_pars(x)
    m = [x(1), x(2); x(3), x(4)];
    t = [x(5); x(6)];
end