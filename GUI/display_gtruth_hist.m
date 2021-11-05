function [out] = display_gtruth_hist(in_tiff,in,b)

figure(3)
clf(3)
set(gcf,'position',[880 50 330 400])
        
            subplot(311)
                band1 = in_tiff(:,:,1);
                out(:,1) = hist(double(band1(in)),255)';
                hist(double(band1(in)),255)
                set(gca,'xlim',[1 254])
                ylabel('Red')
                grid
                
            subplot(312)
                band2 = in_tiff(:,:,2);
                out(:,2) = hist(double(band2(in)),255)';
                hist(double(band2(in)),255)
                set(gca,'xlim',[1 254])
                ylabel('Green')
                grid
                
            subplot(313)
                band3 = in_tiff(:,:,3);
                out(:,3) = hist(double(band3(in)),255)';
                hist(double(band3(in)),255)
                set(gca,'xlim',[1 254])
                ylabel('Blue')
                xlabel('Intensity (8 bit)')
                grid
                
clear band* out in_tiff           
                
return
                

