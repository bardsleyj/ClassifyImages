function[Classification]=MarkovRandField(A,ImageStretch,nx,ny,m,C,nclasses,beta,iter)
%
% This file takes a multi-spec classified image and penalizes a central
% pixel's probabilities based on the Markov property using neighboring
% pixels' probabilities.  5-10 iterations are commonly suggested.
% See Richards & Jia, Remote Sensing, Digital Image Analaysis,
% Springer-Verlag 2006
%
% %%%%%%%%%%%%%%%%%%%%%%%%% inputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A            - The 8-bit classification obtained under QDA in
%                SupervisedClassification.m from the original image.
%
% ImageStretch - The spectral values of the original nx rows by ny columns 
%                of an n-banded image reshaped into nx*ny rows by n
%                columns.  This is uint-8.
%
% nx           - The number of rows in the A matrix.
%
% ny           - The number of columns in the A matrix.
%
% m            - a cell whose ith element is the mean of the ith class 
%                of ground truth points.
%
% C            - a cell whose ith element is the covariance of the ith 
%                class of ground truth points.
%
% nclasses     - The number of ground truthing types or classes to be 
%                delineated during the classification.
%
% beta         - The scalar value used in penalizing probabilities based on
%                a central pixel's neighbors. (regularization parameter)
%
% iter         - The number of iterations on which to relax probability 
%                labels.
%
% %%%%%%%%%%%%%%%%%%%%%%%%% outputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Classification - This is the 8-bit RMF classification of the original 
%                  image.
% 
% This code was written by Marylesa Wilde and John Bardsley,
% final version Feb. 25, 2010.
%-------------------------------------------------------------------------

% Second order Neighborhood weights
[n,nbands]=size(ImageStretch);
F = [1/sqrt(2) 1 1/sqrt(2); 1 0 1; 1/sqrt(2) 1 1/sqrt(2)];
A = reshape(A,nx,ny);
onevec = ones(n,1);    
% MRF
for g =1:iter
    fprintf('MRF iter = %d\n',g)
    g2 = zeros(n,nclasses);
    for i = 1:nclasses
        % Find similar neighbors above and below.
        A2 = zeros(nx,ny);
        A2(A~=i) = 1;
        Q = conv2(A2,F,'same'); 
        q = reshape(Q,nx*ny,1);
        % Evaluate the negative-log likelihood function g_i at every pixel
        meanmati=onevec*m{i};
        residi = (ImageStretch-meanmati)';
        Ri = chol(C{i});
        g2(:,i) = -1/2*log(det(C{i})) - 1/2*sum(((Ri'\residi)').^2,2) - beta*q;
    end
    % Compute the classification by taking the maximum along the rows of g.
    [dummy,A] = max(g2,[],2);
end
A = reshape(A,nx,ny);
Classification = uint8(A);
