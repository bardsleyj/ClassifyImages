%--------------------------------------------------------------------------
% Define the inputs.
%--------------------------------------------------------------------------
inputs.IMAGE       = double(imread('mickey_rand.tif'));
inputs.GRNDTRUTH   = []; % No ground truth image
inputs.means       = [1,90.1488,188,200,255]; % must include QDA means
inputs.covariances = [1,1,1,1,1]; % must include QDA covariances.
inputs.nclasses    = 5;    % number of classes
inputs.crossval    = 0;    % 1 for 10-fold cross validation; 0 otherwise
inputs.thresh      = 100;  % [],100 no thresholding; or alpha% chi^2 c.i.
inputs.prefilt     = 0;    % 0 no prefilt; 1,2,3 for 1st, 2nd, 3rd order nbhds.
inputs.smoothing   = 3;    % 0,[] nothing, 1 nlin filt, 2 PLR, 3 RMF 
inputs.iter        = 10;   % PLR or MRF iters
inputs.beta        = 7000; % beta (regularization parameter) in MRF

%--------------------------------------------------------------------------
% Now, classify the image
%--------------------------------------------------------------------------
tic
outputs = ImageClassify(inputs);
toc
%--------------------------------------------------------------------------
% Finally, output the results.
%--------------------------------------------------------------------------
Image = outputs.Image;
GrndTruth = outputs.GrndTruth;
Classification = outputs.Classification;

if isempty(inputs.thresh)==1
    inputs.thresh = -1;
end
if 0<inputs.thresh && inputs.thresh<100
    inputs.nclasses=inputs.nclasses+1;
end
figure(1)
    imagesc(Image)
    colorbar, colormap(gray)
figure(2)    
    imagesc(Classification)
    colorbar, colormap(gray)