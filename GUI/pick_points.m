function [in] = pick_points(sit)
hold on

xv = []; yv = []; % initialize the points

while 1 % endless loop until right click

    [px,py,button] = ginput(1); 
    
    plot(px,py,'ko','markersize',4,'markerfacecolor','y')

    if button == 3; break; end  % button 3 = right click

    xv = [xv;px]; % stack point locations
    yv = [yv;py];
    
end

Xin = round(xv);
Yin = round(yv);
 in = false(sit(1), sit(2));

for ii = 1:length(Xin)
    in(Yin(ii),Xin(ii)) = true;
end

clear Xin Yin xv yv ii p*

return


