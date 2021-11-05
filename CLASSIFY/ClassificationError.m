function [percent_misclassify,missByClass] = ClassificationError(...
    ImageStretch,GrndTruthStretch,m,C,percent_removed,nsamples,Ti)
%%%%%%%%%%%%%%%%%%%%%%%%% DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% In order to obtain a measure of the error in our classification scheme,
% we remove a percentage of the ground truth data and then use the
% remaining to reclassify the removed data. The percentage of
% misclassifications (which occur if the removed point is put into another
% class by the classification scheme) is then computed and an average is
% taken over all of the removal/reclassification steps.
%%%%%%%%%%%%%%%%%%%%%%%%%%%% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ImageStretch     - the uint8 image array
%
% GrndTruthStretch - the uint8 ground truth array with the same pixel
%                    dimension as ImageStretch with pixel values equal to i
%                    in the spatial location of IMAGE where the ground
%                    truth data for class_i has been collected. In all
%                    other locations, the pixel values should be set to
%                    some value not in the set {1,2,...,nclasses}, e.g. 0.
%
% nclasses         - number of classes
%
% percent_removed  - The percentage of the random ground truth data points
%                    removed for reclassification.
%
% nsamples         - number of times percent_removed data points are
%                    randomly removed.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% percent_misclassify - the average percentage of misclassifications.
%
% missByClass      -  number of pixels in that class that were
%                     misclassified and then divided by the total number 
%                     of pixels to give the error as a percent of the
%                     total.
% 
% This code was written by Marylesa Wilde and John Bardsley,
% final version Feb. 25, 2010.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find all indices where the Ground Truth exists
indices = find(GrndTruthStretch ~= 0);
% Store a temporary image for where there exists Ground Truth data
ImageTemp = ImageStretch(indices,:);
GrndTruthLeftToValidate = GrndTruthStretch(indices);
nclasses = length(m);
missByClass = zeros(1,nclasses);
% K-fold Cross validation (10 fold)
for i = 1:nsamples
    % Extract just the Ground Truth
    GrndTruthCV = GrndTruthStretch(indices);
    % Extract 10% of the Ground Truth Data from each class
    indices2 = [];
    for j = 1:nclasses
        % Find where Ground Truth exists for Class j that can be used to
        % assess error
        k = find(GrndTruthLeftToValidate == j);
        if i ~= nsamples
            % Randomly sample 10% of class j
            indicesTemp = randsample(k,floor(.01*percent_removed*sum(GrndTruthCV==j)),false);
            % Remove Grnd Truth data that has been assessed
            GrndTruthLeftToValidate(indicesTemp) = 0;
        else
            indicesTemp = k;
        end
        indices2 = [indices2; indicesTemp];
    end
    % Set aside the 10% of Ground Truth data to check against that which
    % will be classified
    GrndTruthCheck = zeros(size(GrndTruthCV));
    GrndTruthCheck(indices2) = GrndTruthCV(indices2);
    % Set the 10% Ground Truth data in the training set to 0.
    GrndTruthCV(indices2)=0;
    % Classify!
    ClassifyCV = SupervisedClassification(ImageTemp,m,C,Ti);
    % Find the number of pixels per class that have been classified as as
    % that class incorrectly.
    for l=1:nclasses
        indice3 = find(GrndTruthCheck==l);
        missByClass(l) = missByClass(l) + ...
                     (sum(GrndTruthCheck(indice3)~=ClassifyCV(indice3)));
    end
end
percent_misclassify = 100*sum(missByClass)/length(indices);
% This could have been calculated one of two ways.  Here, the % missed per
% class refers to the number of pixels in that class that were
% misclassified and then divided by the total number of pixels to give the
% error as a percent of the total.  Instead, we could have given the error
% by class which should all be around the ave_misclassify.
for m=1:nclasses
    missByClass(m) = missByClass(m)/length(indices);
end

