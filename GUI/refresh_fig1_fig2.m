function refresh_fig1_fig2(InTiff, InTiffRaw, bands, ColorList, IdxGrid) 
 %disp('refresh')   
 for ii = 1:2
    
    switch ii
        case 1
            
            wh = waitbar2a(0,'Building images ...', 'BarColor', 'g'); 
            
            figure(1)
            cla
            % a non-elegant way to maintain zoom
            junk = get(gca,'xlim');
            if junk(2)==1  % no data in figure
                axs = [0 0 0 0];
            else
                axs(1:2) = get(gca,'xlim');
                axs(3:4) = get(gca,'ylim');
            end
            clear junk  
            
            set(gcf,'position',[80 50 330 400])
            
            [ny,nx,nz] = size(InTiff);
            
             for jj = 1:3
                waitbar2a(jj/3, wh);                                   
                for ii = 1:size(ColorList,1)
                    for kk = 1:nx
                        junk = squeeze(InTiff(:,kk,jj));
                        junk(IdxGrid(:,kk) == ii) = uint8(ColorList(ii,jj).*255);
                        InTiff(:,kk,jj) = junk;
                        clear junk
                     end % of kk loop
                 end % of jj loop
            end % of ii loop
            
            close(wh)
            
            imagesc(InTiff);
            if sum(axs)~=0
                axis(axs)
            end
            axis ij  
            
            
        case 2
            
            figure(2)
            cla
            set(gcf,'position',[480 50 330 400])
            
            imagesc(squeeze(InTiffRaw(:,:,bands)));
            if sum(axs)~=0
                axis(axs)
            end
            axis ij  
    end
    
 end
 
   
        
        return
        
        
        
        % 