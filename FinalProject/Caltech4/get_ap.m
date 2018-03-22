function [ap] = get_ap(annotation)
k = length(annotation);
score = 0;
ann_total = 0;
for i=1:k
    ann_total = ann_total + annotation(i);
    if annotation(i) == 1
        score = score + (ann_total/i);
    end
end
ap = score / ann_total;
end