function[Classification]=ProbLabRelax(A,g,nx,ny,nclasses,iter)
%
% This file takes a multi-spec classified image and computes a weighted
% neighborhood of the discriminant function.  The idea is that the
% probability labels are relaxed based on the central pixel and its
% neighborhood pixels' probabilities. 5-10 iterations are commonly
% suggested. See Richards & Jia, Remote Sensing, Digital Image Analaysis,
% Springer-Verlag 2006.
%
% %%%%%%%%%%%%%%%%%%%%%%%%% inputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A        - The 8-bit classification obtained under QDA in
%            SupervisedClassification.m from the original image.
%
% g        - The probabilites from the discriminant function, found in
%            SupervisedClassification.m under QDA.
%
% nx       - The number of rows in the classification matrix.
%
% ny       - The number of columns in the classification matrix.
%
% nclasses - The number of ground truthing types or classes to be 
%            delineated during the classification.
%
% iter     - The number of iterations on which to relax probability labels.
%
% %%%%%%%%%%%%%%%%%%%%%%%%% outputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Classification - This is the 8-bit label-relaxed classification of the
%                  original image.
% 
% This code was written by Marylesa Wilde and John Bardsley,
% final version Feb. 25, 2010.
%-------------------------------------------------------------------------

F = [0 1 0; 1 1 1; 0 1 0]/5;
A = reshape(A,nx,ny);
Aprime = A';
% Determine Compatibility Coefficients from initial classification
compatCoMat = zeros(nclasses,nclasses);
for i=1:nclasses
    index = [];
    % Find values to the right of a given label
    Atemp = A(:,1:ny-1);
    j = find(Atemp==i);
    index = [index; A(j+nx)];
    % Find values to the left of a given label
    Atemp = A(:,2:ny);
    j = find(Atemp==i);
    index=[index; A(j)];
    % Find values above a given label
    Atemp = A(2:nx,:)';
    j = find(Atemp==i);
    index = [index; Aprime(j)];
    % Find values below a given label
    Atemp = A(1:nx-1,:)';
    j = find(Atemp==i);
    index = [index; Aprime(j+ny)];
    for m=1:nclasses
        compatCoMat(m,i) = sum(index==m)/length(index);
    end
end
for w=1:iter
    fprintf('PLR iter = %d\n',w)
    % Calculate Sum_j [pmn(wi|wj)*pn(wj)]
    q = g*compatCoMat';
    % Calculate Q_i (w_i)
    Q = zeros(size(q));
    for i = 1:nclasses
        qtemp = reshape(q(:,i),nx,ny);
        Qtemp = conv2(qtemp,F,'same');
        Q(:,i) = reshape(Qtemp,nx*ny,1);
    end
    % Calculate discriminant probabilities & normalize
    g = g.*Q;
    g2 = sum(g,2);
    g2 = repmat(g2,1,nclasses);
    g = g./g2;
end
[dummy,A] = max(g,[],2);
A = reshape(A,nx,ny);
Classification = uint8(A);
