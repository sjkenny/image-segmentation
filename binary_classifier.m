% function predicted_labels=binary_classifier(theta, X)
sizeX = size(X);
size_use = size(2);
predicted_labels = [];
for i = 1:size_use
  predicted_labels(i) = round(sigmoid(theta'*X(:,i)));
end
