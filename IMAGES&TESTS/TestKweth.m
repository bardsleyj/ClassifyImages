%--------------------------------------------------------------------------
% Define the inputs.
%--------------------------------------------------------------------------
inputs.IMAGE     = 'Kweth.tif';
inputs.GRNDTRUTH = 'Kweth_gtruth.tif';
inputs.nclasses  = 4;    % number of classes
inputs.crossval  = 1;    % 1 = k-fold cross validation; 0,[] = none.
inputs.thresh    = [];   % 100,[] = no threshold; alph = alpha% chi^2 c.i.
inputs.prefilt   = 1;    % [] or 0 = no prefilt, 1 = 1st, 2 = 2nd, 3 = 3rd 
                         % order neighborhoods
inputs.smoothing = 3;    % 0,[] = none; 1 = nonlin filter; 2 = PLR; 3 = MRF
inputs.iter      = 5;    % # iters in PLR or MRF.
inputs.beta      = 10;   % beta (regularization parameter) for MRF.

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
figure(2)
    imagesc(GrndTruth)
    colorbar, caxis([0,inputs.nclasses]) 
figure(3)
    imagesc(Classification) 
    colorbar, caxis([0,inputs.nclasses]) 