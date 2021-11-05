function [Classification,g] = SupervisedClassification(ImageStretch,m,C,Ti)
%
% Using the points in IMAGE corresponding to the ground truth data in class
% i, a covariance matrix C and mean vector m are computed. Doing this for
% each i, one obtains nclass likelihood functions
%
% p_i(x) = exp[-0.5*(x-m)'*inv(C)*(x-m)] / sqrt( (2pi)^n det(C) ),
%
% The classification rule is then given by:
%
% x is in class i if p_i(x) > p_j(x) for all j not equal to i.
%
% For computational reasons, we instead use the equivalent rule:
%
% x is in class i if g_i(x):=-ln(p_i(x)) < -ln(p_j(x))=:g_j(x) for all j
% not equal to i.
%
% Reference: "Remote Sensing Digital Image Analysis," J. Richards and X.
% Jia, Springer 2006.
%
% %%%%%%%%%%%%%%%%%%%%%%%%% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ImageStretch     - the uint8 image array
%
% m                - a cell whose ith element is the mean of the ith class 
%                    of ground truth points.
%
% C                - a cell whose ith element is the covariance of the ith 
%                    class of ground truth points.
%
% Ti               - threshold value
%
%%%%%%%%%%%%%%%%%%%%%%%%%%% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Classification   - the classified image.
%
% g                - array of probabilities
% 
% This code was written by Marylesa Wilde and John Bardsley,
% final version Feb. 25, 2010.
%--------------------------------------------------------------------------
[n,nbands] = size(ImageStretch);
onevec = ones(n,1);
nclasses = length(m);
g = zeros(n,nclasses);
gtemp = zeros(n,nclasses);
for i = 1:nclasses
    meanmati=onevec*m{i};    
    residi = (ImageStretch-meanmati)';
    Ri = chol(C{i});
    g(:,i) = - log(det(C{i})) - sum(((Ri'\residi)').^2,2);
    gtemp(:,i) = -Ti - log(det(C{i}));
end

% Compute the classification by taking the maximum along the rows of g.
[maxg,Classification] = max(g,[],2);
% make g a probability if using PLR
g = (2*pi)^(-nclasses/2)*exp((1/2)*g);

% Check threshold, remove points beyond threshold
for placeholder=1:length(Classification)
    if gtemp(placeholder,Classification(placeholder))>maxg(placeholder)
        Classification(placeholder) = nclasses+1;
    end
end
Classification = uint8(Classification);
