function [in_gtruth] = update_fig1_fig2(in,in_gtruth,unMaskFlag, class_idx,in_tiff,in_tiff_raw, bands,clr_list)
%disp('update')

wh = waitbar2a(0,'Building images ...', 'BarColor', 'g'); 

for figloop = 1:2

    figure(figloop)
    cla
    
    switch figloop
        case 1
             set(gcf,'position',[80 50 330 400])
             
            % a non-elegant way to maintain zoom
            junk = get(gca,'xlim');
            if junk(2)==1  % no data in figure
                axs = [0 0 0 0];
            else
                axs(1:2) = get(gca,'xlim');
                axs(3:4) = get(gca,'ylim');
            end
            clear junk  
   
            in_gtruth(in) = class_idx;
            
            [ny,nx,nz] = size(in_tiff);
            
       
                for jj = 1:3
                    waitbar2a(jj/3, wh);    
                    for ii = 1:size(clr_list,1)
                        for kk = 1:nx
                            junk = squeeze(in_tiff(:,kk,jj));
                            junk(in_gtruth(:,kk) == ii) = uint8(clr_list(ii,jj).*255);
                            in_tiff(:,kk,jj) = junk;
                            clear junk
                        end % of kk loop
                    end % of jj loop
                end % of ii loop
            
                if unMaskFlag == 1
                    in_gtruth(in) = 0;
                    for jj = 1:3
                        %waitbar2a(jj/3, wh);    
                        for kk = 1:nx
                            junk = squeeze(in_tiff(:,kk,jj));
                            junk(in(:,kk) == 1) = in_tiff_raw((in(:,kk) == 1),kk,jj);
                            in_tiff(:,kk,jj) = junk;
                            clear junk
                        end % of kk loop
                    end % of jj loop
                end
                
            imagesc(in_tiff);
            if sum(axs)~=0
                axis(axs)
            end
            axis ij

         case 2
            set(gcf,'position',[480 50 330 400])
            imagesc(squeeze(in_tiff_raw(:,:,bands)));
            if sum(axs)~=0
                axis(axs)
            end
            axis ij
    end
    
        
end % of figloop

close(wh)

return