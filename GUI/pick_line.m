function [in] = pick_line(sit, num_pix)
hold on

xv = []; yv = []; % initialize the line

while 1 % endless loop until right click
   
    [px,py,button] = ginput(1); 
    
    if button == 3; break; end  % button 3 = right click
        
    plot(px,py,'ko','markersize',4,'markerfacecolor','y')
    
    xv = [xv;round(px)]; % stack polygon verticies
    yv = [yv;round(py)];
    
    if length(xv)>1
        plot([xv(end-1) xv(end)], [yv(end-1) yv(end)],'r-')
    end
     
end

in = false(sit(1),sit(2)); 

if length(xv)>1

    [cx,cy,junk] = improfile_noguts(in ,xv,yv); clear junk  % find image indexes for all points on the line/path
    
    
    cx = round(cx);  cy = round(cy);
    r = size(cx,1);
 
    if num_pix > 0
        for ii = 1:num_pix % create swarm of points around line, width = 2x num_pix
    
            cx = [cx; cx(1:r,1)+ii];  % increment x positive
            cy = [cy; cy(1:r,1)];     % without changing y
    
            cx = [cx; cx(1:r,1)-ii];  % increment x negative
            cy = [cy; cy(1:r,1)];     % without changing y
    
            cy = [cy; cy(1:r,1)+ii];  % increment y positive
            cx = [cx; cx(1:r,1)];     % without changing x
    
            cy = [cy; cy(1:r,1)-ii];  % increment y negative
            cx = [cx; cx(1:r,1)];     % without changing x
    
        end % of ii num_pix loop
    end

    junk = unique([cx,cy],'rows');

    Xin = junk(:,1);
    Yin = junk(:,2);  clear junk c* ii

    for ii = 1:length(Xin)
        in(Yin(ii),Xin(ii)) = true;
    end

else
   disp('Error..... not enough points to determine a line')
end

clear Xin Yin ii c* r x* y* p*

return


