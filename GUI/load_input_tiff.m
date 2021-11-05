function [in_tiff, in_tiff_raw, in_gtruth] = load_input_tiff(fname,bands)

figure(1)
set(gcf,'position',[80 50 330 400])

hold on
    % load and display input tiff file
    in_tiff_raw = imread(fname);  %
    in_tiff_raw = uint8(squeeze(in_tiff_raw(:,:,bands)));
    in_tiff = in_tiff_raw;

    imagesc(in_tiff); 
    axis ij
    
        
  in_gtruth = zeros(size(in_tiff,1),size(in_tiff,2),'uint8');


return


