function [outputs] = ImageClassify(inputs)
%
% This file takes a multi-spec image ground data and computes a 
% supervised classification using quadratic discriminat analysis. 
% Pre and post-classifiction filtering are also available.
%
% %%%%%%%%%%%%%%%%%%%%%%%%% input structure%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------------------------------------------------------------------------
% IMPORTANT NOTES: The following are contained within the inputs structure. 
% Input images must be 8 or 16 bit TIFF files.
%-------------------------------------------------------------------------
%
% IMAGE     - This is the 8 or 16 bit TIFF image to be classified.
%
% GRNDTRUTH - This 8 or 16 bit TIFF image has the same pixel dimension as IMAGE
%             with pixel values equal to i in the spatial location of IMAGE
%             where the ground truth data for class_i has been collected.
%             In all other locations, the pixel values should be set to
%             some value not in the set {1,2,...,nclasses}, e.g. 0.
%
% nclasses  - number of classes
%
% thresh    - chi^2 confidence value for thresholding. If it is not given, 
%             is empty or if thresh = 100, no thresholding is implemented.
%
% prefilt   - If this is empty ('[]') or zero, no prefiltering is computed. 
%             If it is 1, 2, or 3, it filters (denoises) via convolution by
%             increasingly large neighborhood matrices.
%
% smoothing - If this is empty ('[]') or zero, no post filtering is
%             computed. If it is equal to 1, a nonlinear postfiltering is 
%             computed using the mode function. If it is 2, probability 
%             label relaxation is implemented. If it is 3, Markov random 
%             fields are used.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% outputs.Image          - the original image in array format
%
% outputs.GrndTruth      - the ground truth image in array format
%
% outputs.Classification - the classified image in array format
%
% This code was written by Marylesa Wilde and John Bardsley,
% final version Feb. 25, 2010.
%-------------------------------------------------------------------------
xtrue     = inputs.IMAGE;
GrndTruth = inputs.GRNDTRUTH;
nclasses  = inputs.nclasses;
thresh    = inputs.thresh; 
prefilt   = inputs.prefilt;
smoothing = inputs.smoothing;
crossval  = inputs.crossval;
%-------------------------------------------------------------------------
% 1. Read IMAGE and GrndTruth into MatLab. They must be TIFF files. Convert 
%    to 8 bit if necessary. Then vectorize these two arrays for the 
%    classification step. Pre-classification filtering (denoising) is 
%    implemented and threshold values are computed.
%-------------------------------------------------------------------------
% Input image and prefilter/denoise
if ~isnumeric(xtrue)
  xtrue = double(imread(xtrue));
end
[nx,ny,nbands] = size(xtrue);
if ~exist('prefilt','var') | isempty(prefilt), prefilt = 0; end
if     prefilt==3, 
    F = 1/36*[0 0 1 0 0; 0 2 4 2 0; 1 4 8 4 1; 0 2 4 2 0; 0 0 1 0 0];
elseif prefilt==2
    F = 1/16*[1 2 1; 2 4 2; 1 2 1];
elseif prefilt==1
    F = 1/8*[0 1 0; 1 4 1; 0 1 0];
elseif prefilt==0 
    F = [0 0 0;0 1 0;0 0 0];
end
% buffer 3 pixels on all sides to account for neighborhoods
xtrueBuffered = padarray(xtrue,[3,3],'replicate');

b = zeros(size(xtrueBuffered(:,:,:)));
for i = 1:nbands
  b(:,:,i) = conv2(xtrueBuffered(:,:,i),F,'same');
end
Image = uint8(b(4:nx+3,4:ny+3,:));
[nx,ny,nbands]=size(Image);
ImageStretch = zeros(nx*ny,nbands);
for i = 1:nbands
    Temp = Image(:,:,i);
    ImageStretch(:,i)=Temp(:);
end
% Read in ground truth image and set non-groundtruth points to 0
if isempty(GrndTruth)
    for i=1:nclasses
        m{i} = inputs.means(i);
        C{i} = inputs.covariances(1:nbands,nbands*(i-1)+1:nbands*i);
    end
else
    GrndTruth = uint8(imread(GrndTruth));
    [nxg,nyg] = size(GrndTruth);
    if nx ~= nxg || ny ~= nyg
        disp('NO CLASSIFICATION since image and ground truth have different dimension.')
        return
    end
    GrndTruth(GrndTruth>nclasses | GrndTruth<1)=0;
    GrndTruthStretch = GrndTruth(:);
    % Create mean and covaraince of ground truth.
    for i = 1:nclasses
        pts  = ImageStretch(GrndTruthStretch==i,:);
        m{i} = mean(pts);
        C{i} = cov(pts)+sqrt(eps)*eye(nbands);
    end
end
% Obtain chi square value for threshold
if ~exist('thresh','var') | isempty(thresh) % no thresholding
    Ti = chi2inv(1,nbands);
else
    Ti = chi2inv(.01*thresh,nbands);
end
if ~exist('smoothing','var') | isempty(smoothing) 
    smoothing = 0; 
end

%--------------------------------------------------------------------------
% 2. Compute the supervised classification and thresholding using the QDA
%    classifier.
%--------------------------------------------------------------------------
[Classification,g] = SupervisedClassification(ImageStretch,m,C,Ti);

%--------------------------------------------------------------------------
% 3. Use K-fold cross validation to estimate the classification error.
%--------------------------------------------------------------------------
if crossval == 1 & ~isempty(GrndTruth)
    nsamples = 10; percent_removed = 10;
    [percent_misclassified,miss] = ClassificationError(ImageStretch,...
                        GrndTruthStretch,m,C,percent_removed,nsamples,Ti);
    fprintf('%d PERCENT RANDOM REMOVAL CROSS VALIDATION.\n',percent_removed)
    fprintf('Percent misclassified after %d removals = %2.4f\n',nsamples,percent_misclassified);
end

%--------------------------------------------------------------------------
% 4. Post classification smoothing
%--------------------------------------------------------------------------
if smoothing==1
    Classification=PostFilter(Classification,nx,ny);
elseif smoothing==2
    iter = inputs.iter;
    Classification = ProbLabRelax(Classification,g,nx,ny,nclasses,5);
elseif smoothing==3
    beta = inputs.beta; iter = inputs.iter;
    Classification = MarkovRandField(Classification,ImageStretch,nx,ny,...
                                                  m,C,nclasses,beta,iter);
else
    Classification = reshape(Classification,nx,ny);
end

outputs.Image = Image;
outputs.GrndTruth = GrndTruth;
outputs.Classification = Classification;