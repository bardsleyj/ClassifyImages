function varargout = improfile_noguts(varargin)
%   CCG gutted this function for use with ground truth gui
%  not to be confused with improfile.m in image processing toolbox

[xa,ya,a,n,method,prof,getn,getprof] = parse_inputs(varargin{:});

RGB_image = (ndims(a)==3);

% Parametric distance along segments
s = [0; cumsum(sqrt( sum((diff(prof).^2),2) ))];

% Remove duplicate points if necessary.
killIdx = find(diff(s) == 0);
if (~isempty(killIdx))
    s(killIdx+1) = [];
    prof(killIdx+1,:) = [];
end

ma = size(a,1);
na = size(a,2);
xmin = min(xa(:)); ymin = min(ya(:));
xmax = max(xa(:)); ymax = max(ya(:));

if na>1
    dx = max( (xmax-xmin)/(na-1), eps );  
    xxa = xmin:dx:xmax;
else
    dx = 1;
    xxa = xmin;
end

if ma>1
    dy = max( (ymax-ymin)/(ma-1), eps );
    yya = ymin:dy:ymax;
else
    dy = 1;
    yya = ymin;
end

if getn,
    d = abs(diff(prof./(ones(size(prof,1),1)*[dx dy])));
    n = max(sum(max(ceil(d)')),2); % In pixel coordinates
end

% % Interpolation points along segments
% if ~isempty(prof)
    profi = interp1(s,prof,0:(max(s)/(n-1)):max(s));
    xg = profi(:,1);
    yg = profi(:,2);
% else
%     xg = []; yg = [];
% end

% if ~isempty(a) && ~isempty(xg)
% %     if RGB_image
% %         % Image values along interpolation points - r,g,b planes separately
% %         % Red plane
% % %         zr = interp2(xxa,yya,a(:,:,1),xg,yg,method); 
% % %         % Green plane
% % %         zg = interp2(xxa,yya,a(:,:,2),xg,yg,method); 
% % %         % Blue plane
% % %         zb = interp2(xxa,yya,a(:,:,3),xg,yg,method); 
% %     else
% %         % Image values along interpolation points - the g stands for Grayscale
% % %         zg = interp2(xxa,yya,a,xg,yg,method);
% %     end
%     
%     % Get profile points in pixel coordinates
% %     xg_pix = round(axes2pix(na, [xmin xmax], xg)); 
% %     yg_pix = round(axes2pix(ma, [ymin ymax], yg));  
%     
%     % If the result is uint8, Promote to double and put NaN's in the places
%     % where the profile went out of the image axes (these are zeros because
%     % there is no NaN in UINT8 storage class)
% %     if ~isa(zg, 'double')     
% %         prof_hosed = find( (xg_pix<1) | (xg_pix>na) | ...
% %                            (yg_pix<1) | (yg_pix>ma) );
% %         if RGB_image
% %             zr = double(zr); zg = double(zg); zb = double(zb);
% %             zr(prof_hosed) = NaN;
% %             zg(prof_hosed) = NaN;
% %             zb(prof_hosed) = NaN;
% %         else
% %             zg = double(zg);
% %             zg(prof_hosed) = NaN;
% %         end                 
% %     end
% else
%     % empty profile or image data
%     % initialize zr/zg/zb for RGB images; just zg for grayscale images;
% %     [zr zg zb] = deal([]);
% end

% if nargout == 0 && ~isempty(zg) % plot it
% %     if getprof,
% %         h = get(0,'children');
% %         fig = 0;
% %         for i=1:length(h),
% %             if strcmp(get(h(i),'name'),'Profile'),
% %                 fig = h(i);
% %             end
% %         end
% %         if ~fig, % Create new window
% %             fig = figure('Name','Profile');
% %         end
% %         figure(fig)
% %     else
% %         gcf;
% %     end
% %     if length(prof)>2
% %         if RGB_image
% %             plot3(xg,yg,zr,'r',xg,yg,zg,'g',xg,yg,zb,'b');
% %             set(gca,'ydir','reverse');
% %             xlabel X, ylabel Y;
% %         else
% %             plot3(xg,yg,zg,'b');
% %             set(gca,'ydir','reverse');
% %             xlabel X, ylabel Y;
% %         end
% %     else
% %         if RGB_image
% %             plot(sqrt((xg-xg(1)).^2+(yg-yg(1)).^2),zr,'r',...
% %                  sqrt((xg-xg(1)).^2+(yg-yg(1)).^2),zg,'g',...
% %                  sqrt((xg-xg(1)).^2+(yg-yg(1)).^2),zb,'b');
% %             xlabel('Distance along profile');
% %         else
% %             plot(sqrt((xg-xg(1)).^2+(yg-yg(1)).^2),zg,'b');
% %             xlabel('Distance along profile');
% %         end
% %     end
% else
    
%     if RGB_image
%         zg = cat(3,zr(:),zg(:),zb(:));
%     else
%         zg = zg(:);
%     end
%     xi = prof(:,1);
%     yi = prof(:,2);
%     switch nargout
%     case 0,   % If zg was [], we didn't plot and ended up here
%         return
%     case 1,
%         varargout{1} = zg;
%     case 3,
        varargout{1} = xg;
        varargout{2} = yg;
        varargout{3} = [];
%     case 5,
%         varargout{1} = xg;
%         varargout{2} = yg;
%         varargout{3} = zg;
%         varargout{4} = xi;
%         varargout{5} = yi;
%     otherwise
%         msgId = 'Images:improfile:invalidNumOutputArguments';
%         msg = 'The number of output arguments is invalid.';
%         error(msgId,'%s',msg);
%     end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Function: parse_inputs
%

function [Xa,Ya,Img,N,Method,Prof,GetN,GetProf]=parse_inputs(varargin)
% Outputs:
%     Xa        2 element vector for non-standard axes limits
%     Ya        2 element vector for non-standard axes limits
%     A         Image Data
%     N         number of image values along the path (Xi,Yi) to return
%     Method    Interpolation method: 'nearest','bilinear', or 'bicubic'
%     Prof      Profile Indices
%     GetN      Determine number of points from profile if true.
%     GetProf   Get profile from user via mouse if true also get data from image.

% Set defaults
N = [];
GetN = 1;    
GetProf = 0; 
GetCoords = 1;  %     GetCoords - Determine axis coordinates if true.
Method = 'nearest';

switch nargin
case 0,            % improfile
    GetProf = 1; 
    GetCoords = 0;
    
case 1,            % improfile(n) or improfile('Method')
    if ischar(varargin{1})
        Method = varargin{1}; 
    else 
        N = varargin{1}; 
        GetN = 0; 
    end
    GetProf = 1; 
    GetCoords = 0;
    
case 2,            % improfile(n,'method')
    Method = varargin{2};
    N = varargin{1}; 
    GetN = 0; 
    GetProf = 1; 
    GetCoords = 0;
    
case 3,   % improfile(a,xi,yi)
    A = varargin{1};
    Xi = varargin{2}; 
    Yi = varargin{3}; 
    
case 4,   % improfile(a,xi,yi,n) or improfile(a,xi,yi,'method')
    A = varargin{1};
    Xi = varargin{2}; 
    Yi = varargin{3}; 
    if ischar(varargin{4}) 
        Method = varargin{4}; 
    else 
        N = varargin{4}; 
        GetN = 0; 
    end
    
case 5, % improfile(x,y,a,xi,yi) or improfile(a,xi,yi,n,'method')
    if ischar(varargin{5}), 
        A = varargin{1};
        Xi = varargin{2}; 
        Yi = varargin{3}; 
        N = varargin{4}; 
        Method = varargin{5}; 
        GetN = 0; 
    else
        GetCoords = 0;
        Xa = varargin{1}; 
        Ya = varargin{2}; 
        A = varargin{3};
        Xi = varargin{4}; 
        Yi = varargin{5}; 
    end
    
case 6, % improfile(x,y,a,xi,yi,n) or improfile(x,y,a,xi,yi,'method')
    Xa = varargin{1}; 
    Ya = varargin{2}; 
    A = varargin{3};
    Xi = varargin{4}; 
    Yi = varargin{5}; 
    if ischar(varargin{6}), 
        Method = varargin{6}; 
    else 
        N = varargin{6};
        GetN = 0; 
    end
    GetCoords = 0;
    
case 7, % improfile(x,y,a,xi,yi,n,'method')
    if ~ischar(varargin{7}) 
        msgId = 'Images:improfile:invalidInputArrangementOrNumber';
        msg = 'The arrangement or number of input arguments is invalid.';
        error(msgId,'%s', msg);
    end
    Xa = varargin{1}; 
    Ya = varargin{2}; 
    A = varargin{3};
    Xi = varargin{4}; 
    Yi = varargin{5}; 
    N = varargin{6};
    Method = varargin{7}; 
    GetN = 0;
    GetCoords = 0; 
    
otherwise
    msgId = 'Images:improfile:invalidInputArrangementOrNumber';
    msg = 'The arrangement or number of input arguments is invalid.';
    error(msgId, '%s', msg);
end

% set Xa and Ya if unspecified
if (GetCoords && ~GetProf),
    Xa = [1 size(A,2)];
    Ya = [1 size(A,1)];
end

% error checking for N
if (GetN == 0)
    if (N<2 || ~isa(N, 'double'))
        msgId = 'Images:improfile:invalidNumberOfPoints';
        msg = 'N must be a number greater than 1.';
        error(msgId,'%s', msg);
    end
end

% Get profile from user if necessary using data from image
if GetProf, 
    [Xa,Ya,A,state] = getimage;
    if ~state
        msgId = 'Images:improfile:noImageinAxis';
        msg = 'Requires an image in the current axis.';
        error(msgId,'%s',msg);
    end
    Prof = getline(gcf); % Get profile from user
else  % We already have A, Xi, and Yi
    if numel(Xi) ~= numel(Yi)
        msgId = 'Images:improfile:invalidNumberOfPoints';
        msg = 'Xi and Yi must have the same number of points.';
        error(msgId, '%s',msg);
    end
    Prof = [Xi(:) Yi(:)]; % [xi yi]
end

% error checking for A
if (~isa(A,'double') && ~isa(A,'uint8') && ~isa(A, 'uint16') && ~islogical(A)) ...
      && ~isa(A,'single') && ~isa(A,'int16')
    msgId = 'Images:improfile:invalidImage';
    msg = 'I must be double, uint8, uint16, int16, single, or logical.';
    error(msgId, '%s', msg);
end

% Promote the image to single if it is not logical or if we aren't using nearest.
if islogical(A) || (~isa(A,'double') && ~strcmp(Method,'nearest')) 
    Img = uint8(A);
else
    Img = A;
end

% error checking for Xa and  Ya
if (~isa(Xa,'double') || ~isa(Ya, 'double'))
    msgId = 'Images:improfile:invalidClassForInput';
    msg = 'All inputs other than I must be of class double.';
    error(msgId,'%s',msg);
end   

% error checking for Xi and Yi
if (~GetProf && (~isa(Xi,'double') || ~isa(Yi, 'double')))
    msgId = 'Images:improfile:invalidClassForInput';
    msg = 'All inputs other than I must be of class double.';
    error(msgId,'%s',msg);
end

%error checking for Method
iptcheckstrs(Method,{'nearest', 'bilinear', 'bicubic'}, mfilename,'METHOD',nargin);
