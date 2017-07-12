function [scores,predicted_labels] = binary_classifier(theta, X)
sizeX = size(X);
size_use = length(X);
predicted_labels = [];
for i = 1:size_use
    scores(i) = sigmoid(theta'*X(:,i));
  predicted_labels(i) = round(sigmoid(theta'*X(:,i)));
end
