function[Classification] = PostFilter(Classification,nx,ny)
%
% This file takes a multi-spec classified image and computes a convolution
% with a pre-specified 1st, 2nd, or 3rd order neighborhood.  This post
% filter smoothing uses the mode function and MATLAB's nlinfilter function.
%
% %%%%%%%%%%%%%%%%%%%%%%%%% inputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------------------------------------------------------------------------
% IMPORTANT NOTES: Input images must be 8 or 16 bit TIFF files. 
%-------------------------------------------------------------------------
%
% Classification - This is the 8-bit classification obtained in
%                  SupervisedClassification.m from the original image.
%
% nx             - The number of rows in the classification matrix.
%
% ny             - The number of columns in the classification matrix.
%-------------------------------------------------------------------------

% %%%%%%%%%%%%%%%%%%%%%%%%% outputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------------------------------------------------------------------------
%
% Classification - This is the 8-bit post-filtered classification of the
%                  original image.
%
% This code was written by Marylesa Wilde and John Bardsley,
% final version Feb. 25, 2010.
%-------------------------------------------------------------------------

Classification = reshape(Classification,nx,ny);
Classification2 = padarray(Classification,[1,1],'replicate');
Classification2 = double(Classification2);
fun = @(x) mode(x(:));
Classification3 = nlfilter(Classification2,[3,3],fun);
Classification = uint8(Classification3(2:nx+1,2:ny+1));