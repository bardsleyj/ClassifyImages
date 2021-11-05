function [in] = pick_poly(sit)


    h = impoly;
    setColor(h,'yellow');
    fcn = makeConstrainToRectFcn('impoly',get(gca,'XLim'),get(gca,'YLim'));
    setPositionConstraintFcn(h,fcn);
    wait(h);  
    pos = getPosition(h);
    
in = false(sit(1), sit(2)); 
 Y = (1:sit(1))'; % vector of row numbers
 
wh = waitbar2a(0,'Processing polygon ...', 'BarColor', 'g'); 

for ii = 1:sit(2) % loop through each column
    X = ones(sit(1),1).*ii;
        if size(pos,1)>2 % need at least 3 point for a polygon
            in(:,ii) = inpolygon(X,Y,pos(:,1),pos(:,2));
        else
            disp('Error - Not enough points to define a polygon')
            break
        end
     
        if rem(ii,200)==0 ;
            waitbar2a(ii/sit(2), wh);
        end
      
end % of ii loop   
clear X Y sit pos 
close(wh)

return


