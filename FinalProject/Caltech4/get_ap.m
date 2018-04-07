function [ap] = get_ap(annotation)
% set k to the lengt of the annotation 
k = length(annotation);

% set the score and the total annotation to 0
score = 0;
ann_total = 0;

for i=1:k
    % increase ann_total with the annotation (which can be 0 or 1)
    ann_total = ann_total + annotation(i);
    
    % if the annotation is 1, increase the score with ann_total/i
    if annotation(i) == 1
        score = score + (ann_total/i);
    end
end

% compute the Average Precision by dividing the score by the total number
% of images with a annotation of 1.
ap = score / ann_total;
end