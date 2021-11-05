function varargout = Ground_Truth_GUI(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Ground_Truth_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Ground_Truth_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function Ground_Truth_GUI_OpeningFcn(hObject, eventdata, handles, varargin)

handles.version = 'v.NoGuts';

P = mfilename('fullpath');
pidx = regexp(P,'\');
handles.indir = P(1:pidx(end));
handles.outdir = handles.indir;
clear P pidx

handles.band = eval(get(handles.img_band_value,'String'));
handles.gtruth_class_string = '';
handles.color = [1,1,1];
handles.line_width = 0;
handles.pick_method_value = get(handles.pick_method,'Value');
handles.class_idx = 0;  % 
handles.gtruth_group = [];
handles.process_flag = 0;  
handles.delete_flag = 0;

handles.mask_list = {'Pick from Mask List'}; %
handles.mask_idx = 0; 
handles.gtruth_list = get(handles.gtruth_class_type,'string');
handles.mask_color_list = [];


set(handles.pick_polygon,'Enable','off');
set(handles.pick_pixels,'Enable','off');
set(handles.pick_pixels_on_line,'Enable','off');
set(handles.text9,'Enable','off');
set(handles.line_width_pixels,'Enable','off');
set(handles.accept_tiff,'Enable','off');
set(handles.redo,'Enable','off');
set(handles.classify,'Enable','off');
set(handles.exit,'Enable','off');
set(handles.img_band_value,'Enable','off');
set(handles.img_bands,'Enable','off')
set(handles.text10,'Enable','off')
set(handles.Add_CoverType_2List,'Enable','off');
set(handles.gtruth_class_type,'Enable','off');
set(handles.method,'Enable','off');
set(handles.pick_method,'Enable','off');
set(handles.pass_mask_2_classification,'Enable','off');
set(handles.import_cover_type_file,'Enable','off');
set(handles.gtruth_mask_toggle,'Enable','off'); 
set(handles.mask_from_class_results,'Enable','off');
set(handles.mask_invert,'Enable','off')
set(handles.UnMask,'Enable','off')
set(handles.Group_current_masks,'Enable','off')
set(handles.lock_region,'Enable','off')
set(handles.load_locked_region,'Enable','off')
set(handles.select_delete,'Enable','off')
set(handles.Clear_All,'Enable','off');
set(handles.text12,'enable','off')
set(handles.list_avail_in_tiffs,'Enable','on')
set(handles.load_saved_file,'Enable','off')
set(handles.working_dir,'Enable','off')

set(handles.status_text,'String','Browse to location of input files');
    
handles.unwanted = {'in';'Xin';'Yin';'output';'class_idx';'line_width';'line_width_value';'color';'in_tiff'; ...
            'list_avail_in_tiffs';'accept_tiff';'exit';'redo'; ...
            'pick_polygon';'pick_pixels';'pick_pixels_on_line';'gtruth_class_type_value'; ...
            'img_band_value';'img_bands';'gtruth_class_type'; ...
            'line_width_pixels';'figure1';'import_cover_type_file';'classification'; ...
            'method';'pick_method';'pick_method_value';'load_saved_file';'gtruth_mask_toggle'; ...
            'status_text';'gtruth_class_string';'gtruth_class_maybe';'text10';'text9';'Add_CoverType_2List'; ...
            'mask_invert';'text11';'mask_from_class_results';'classify';'mask_idx';'r';'c'; ...
            'pass_mask_2_classification';'select_delete';'load_locked_region';'lock_region'; ...
            'Group_current_masks';'Clear_All';'UnMask';'working_dir';'text12';'mask_class_idx';'delete_idx'};


handles.output = hObject;


guidata(hObject, handles);


function varargout = Ground_Truth_GUI_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;



function working_dir_Callback(hObject, eventdata, handles)



function list_avail_in_tiffs_Callback(hObject, eventdata, handles)

[junk1,junk2,status] = uigetfile([handles.indir,'*.tif'],'Choose Input Tiff',100,100);

if status~=0  

    handles.fname = junk1;
    handles.indir = junk2;
    handles.outdir = handles.indir;
    clear junk*
    
    [handles.in_tiff, handles.in_tiff_raw, handles.in_gtruth] = load_input_tiff([handles.indir,handles.fname],handles.band);
    
    handles.class_list = {};
    handles.color_list = [];
    handles.mask_used_list = {};
    handles.in_mask = false(size(handles.in_gtruth));

    set(handles.gtruth_class_type,'Enable','on');
    set(handles.list_avail_in_tiffs,'Enable','off');
    set(handles.load_saved_file,'Enable','off');
    set(handles.status_text,'String','Orient figure(1) and Choose/Add Cover type');
    set(handles.text10,'Enable','on')
    set(handles.Add_CoverType_2List,'Enable','on');
    
    guidata(hObject, handles);
    
end 


function load_saved_file_Callback(hObject, eventdata, handles)

function import_cover_type_file_Callback(hObject, eventdata, handles)

function img_band_value_Callback(hObject, eventdata, handles)

handles.band = eval(get(handles.img_band_value,'String'));
guidata(hObject, handles);

function img_band_value_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function gtruth_mask_toggle_Callback(hObject, eventdata, handles)

function UnMask_Callback(hObject, eventdata, handles)

function Add_CoverType_2List_Callback(hObject, eventdata, handles)

set(handles.pick_polygon,'Enable','off');
set(handles.pick_pixels,'Enable','off');
set(handles.pick_pixels_on_line,'Enable','off');
set(handles.text9,'Enable','off');
set(handles.line_width_pixels,'Enable','off');
set(handles.gtruth_mask_toggle,'Enable','off');
set(handles.text12,'enable','off')
set(handles.mask_from_class_results,'Enable','off');
set(handles.mask_invert,'Enable','off')
set(handles.method,'Enable','off');
set(handles.pick_method,'Enable','off');
set(handles.mask_invert,'Enable','off')
set(handles.Group_current_masks,'Enable','off')
set(handles.load_locked_region,'Enable','off')
set(handles.import_cover_type_file,'Enable','off');
set(handles.Clear_All,'Enable','off');
set(handles.load_locked_region,'Enable','off')

        junk = get(handles.gtruth_class_type,'string');  
        junk{length(junk)+1} = get(handles.Add_CoverType_2List,'string'); 
        set(handles.gtruth_class_type,'string',junk);
        
        if get(handles.gtruth_mask_toggle,'value')==0
            handles.gtruth_list = junk;
            set(handles.status_text,'String','New cover type is now available in pop up list')
        else % ==1
            handles.mask_list = junk;
            set(handles.status_text,'String','New mask is now available in pop up list')
        end
        
        set(handles.Add_CoverType_2List,'string','');
        clear junk
        
set(handles.text10,'Enable','off')        
set(handles.Add_CoverType_2List,'Enable','off')

guidata(hObject, handles);

function Add_CoverType_2List_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function mask_from_class_results_Callback(hObject, eventdata, handles)

function mask_from_class_results_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function load_locked_region_Callback(hObject, eventdata, handles)

function mask_invert_Callback(hObject, eventdata, handles)

    set(handles.load_locked_region,'Enable','off')

function Group_current_masks_Callback(hObject, eventdata, handles)

function gtruth_class_type_Callback(hObject, eventdata, handles)

set(handles.import_cover_type_file,'Enable','off');
set(handles.text10,'Enable','off')
set(handles.Add_CoverType_2List,'Enable','off')
set(handles.method,'Enable','off');
set(handles.select_delete,'enable','off')
set(handles.pass_mask_2_classification,'Enable','off');
set(handles.pick_method,'Enable','off');
set(handles.classify,'Enable','off');
set(handles.exit,'Enable','off');
set(handles.gtruth_mask_toggle,'Enable','off');
set(handles.text12,'enable','off')
set(handles.mask_from_class_results,'Enable','off');
set(handles.mask_invert,'Enable','off')
set(handles.Group_current_masks,'Enable','off')
set(handles.import_cover_type_file,'Enable','off');
set(handles.Clear_All,'Enable','off');

 handles.gtruth_class_type_value = get(handles.gtruth_class_type,'Value'); %

 if handles.gtruth_class_type_value ~=1  % 
     
    junk = get(handles.gtruth_class_type,'string');  % 
    handles.gtruth_class_maybe = junk{handles.gtruth_class_type_value}; % 
    clear junk


    switch get(handles.gtruth_mask_toggle,'value')

        case 0  
        
             check4same = strmatch(lower(handles.gtruth_class_maybe),lower([handles.class_list]),'exact'); % 'lower' for capitaliziation mismatch
            if isempty(check4same)  % 
                handles.gtruth_class_string = handles.gtruth_class_maybe;
                handles = rmfield(handles, 'gtruth_class_maybe');
           
                handles.class_idx = length([handles.class_list]) + 1;
                handles.class_list{handles.class_idx} = handles.gtruth_class_string;
                handles.color = uisetcolor;  % 
                handles.color_list(handles.class_idx,1:3) = handles.color;
            
            else                 
                handles.color = handles.color_list(check4same,:);
                handles.class_idx = check4same;
                handles.gtruth_class_string = handles.class_list{check4same};
    
            end
            set(handles.status_text,'String','Identify ground truth region with Polygon, Line, or Pixels')
                

        case 1 
        
               
    end 
    
                set(handles.pick_polygon,'Enable','on');
                set(handles.pick_pixels,'Enable','on');
                set(handles.pick_pixels_on_line,'Enable','on');
                set(handles.gtruth_class_type,'Enable','off');
                set(handles.select_delete,'enable','off')
                
 else
     
    set(handles.text10,'Enable','on') 
    set(handles.Add_CoverType_2List,'Enable','on')
    set(handles.exit,'Enable','on');
    set(handles.gtruth_class_type,'Enable','on');
     
 end 

guidata(hObject, handles);


function gtruth_class_type_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function lock_region_Callback(hObject, eventdata, handles)

function pick_polygon_Callback(hObject, eventdata, handles)

figure(1); zoom off; pan off;

set(handles.status_text,'String','Left click on verticies, Right click to close, Hover to edit, Double to finish')

set(handles.gtruth_class_type,'Enable','off');
set(handles.pick_polygon,'Enable','off');
set(handles.pick_pixels,'Enable','off');
set(handles.pick_pixels_on_line,'Enable','off');
set(handles.text9,'Enable','off');
set(handles.line_width_pixels,'Enable','off');
set(handles.select_delete,'Enable','off')
set(handles.UnMask,'Enable','off')
set(handles.Clear_All,'Enable','off');

    [handles.in] = pick_poly([size(handles.in_tiff)]);

if (sum(handles.in(:))>0) & (get(handles.gtruth_mask_toggle,'value')==0) % cover typing active
    [handles.r,handles.c] = find(handles.in);
    
    
   [handles.in_gtruth_maybe] = update_fig1_fig2(handles.in, ...
                      handles.in_gtruth, 0, ...
                      handles.class_idx, handles.in_tiff, handles.in_tiff_raw, ...
                      handles.band, handles.color_list);
                  
    display_gtruth_hist(handles.in_tiff,handles.in,handles.band);
    
    set(handles.pick_polygon,'Enable','off');
    set(handles.accept_tiff,'Enable','on');
    set(handles.redo,'Enable','on'); 
    set(handles.status_text,'String','Accept this region or Redo')
  
    guidata(hObject, handles);
    
elseif (sum(handles.in(:))>0) & (get(handles.gtruth_mask_toggle,'value')==1) % masking active


else
    set(handles.text10,'Enable','on')
    set(handles.Add_CoverType_2List,'Enable','on');
    set(handles.gtruth_class_type,'Enable','on');
    set(handles.pick_polygon,'Enable','on');
    set(handles.pick_pixels,'Enable','on');
    set(handles.pick_pixels_on_line,'Enable','on');
    set(handles.accept_tiff,'Enable','off');
    set(handles.redo,'Enable','off')
    set(handles.exit,'Enable','on');
  
end

function pick_pixels_on_line_Callback(hObject, eventdata, handles)

figure(1); zoom off; pan off;

set(handles.status_text,'String','Left click along center line of path, Right click to finish')

set(handles.gtruth_class_type,'Enable','off');
set(handles.pick_polygon,'Enable','off');
set(handles.pick_pixels,'Enable','off');
set(handles.pick_pixels_on_line,'Enable','off');
set(handles.text9,'Enable','off');
set(handles.line_width_pixels,'Enable','off');
set(handles.select_delete,'Enable','off')
set(handles.UnMask,'Enable','off')
set(handles.Clear_All,'Enable','off');

 [handles.in] = pick_line(size(handles.in_tiff), handles.line_width);
 
 [handles.r,handles.c] = find(handles.in);
    
if (sum(handles.in(:))>0) & (get(handles.gtruth_mask_toggle,'value')==0) %

    [handles.in_gtruth_maybe] = update_fig1_fig2(handles.in, ...
                      handles.in_gtruth, 0,  ...
                      handles.class_idx,handles.in_tiff, handles.in_tiff_raw, ...
                      handles.band, handles.color_list);
                  
    display_gtruth_hist(handles.in_tiff,handles.in,handles.band);
 
    set(handles.accept_tiff,'Enable','on');
    set(handles.redo,'Enable','on');

    set(handles.status_text,'String','Accept this line or Redo')
 
    guidata(hObject, handles);
    
elseif (sum(handles.in(:))>0) & (get(handles.gtruth_mask_toggle,'value')==1) % masking active
    

else
    set(handles.text10,'Enable','on')
    set(handles.Add_CoverType_2List,'Enable','on');
    set(handles.gtruth_class_type,'Enable','on');
    set(handles.pick_polygon,'Enable','on');
    set(handles.pick_pixels,'Enable','on');
    set(handles.pick_pixels_on_line,'Enable','on');
    set(handles.accept_tiff,'Enable','off');
    set(handles.redo,'Enable','off')
    set(handles.exit,'Enable','on');
 end

 
function pick_pixels_Callback(hObject, eventdata, handles)

figure(1); zoom off; pan off;

set(handles.status_text,'String','Left click on individual pixels, Right click to finish');

set(handles.gtruth_class_type,'Enable','off');
set(handles.pick_polygon,'Enable','off');
set(handles.pick_pixels,'Enable','off');
set(handles.pick_pixels_on_line,'Enable','off');
set(handles.text9,'Enable','off');
set(handles.line_width_pixels,'Enable','off');
set(handles.select_delete,'Enable','off')
set(handles.UnMask,'Enable','off')
set(handles.Clear_All,'Enable','off');

    [handles.in] = pick_points([size(handles.in_tiff)]);
   
    [handles.r,handles.c] = find(handles.in);
    
if (sum(handles.in(:))>0) & (get(handles.gtruth_mask_toggle,'value')==0) % cover typing active
  
    [handles.in_gtruth_maybe] = update_fig1_fig2(handles.in, ...
                      handles.in_gtruth, 0,  ...
                      handles.class_idx, handles.in_tiff, handles.in_tiff_raw, ...
                      handles.band, handles.color_list);
                  
    display_gtruth_hist(handles.in_tiff, handles.in, handles.band);
    
    set(handles.accept_tiff,'Enable','on');
    set(handles.redo,'Enable','on'); 

    set(handles.status_text,'String','Accept these pixels or Redo')
    
    guidata(hObject, handles);
elseif (sum(handles.in(:))>0) & (get(handles.gtruth_mask_toggle,'value')==1) % masking active
    
else
    set(handles.text10,'Enable','on')
    set(handles.Add_CoverType_2List,'Enable','on');
    set(handles.gtruth_class_type,'Enable','on');
    set(handles.pick_polygon,'Enable','on');
    set(handles.pick_pixels,'Enable','on');
    set(handles.pick_pixels_on_line,'Enable','on');
    set(handles.accept_tiff,'Enable','off');
    set(handles.redo,'Enable','off')
    set(handles.exit,'Enable','on');
end

function line_width_pixels_Callback(hObject, eventdata, handles)

function line_width_pixels_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function select_delete_Callback(hObject, eventdata, handles)

function accept_tiff_Callback(hObject, eventdata, handles)

 if get(handles.gtruth_mask_toggle,'value')==0 
     
     handles.in_gtruth = handles.in_gtruth_maybe;
 
    if logical(handles.delete_flag) 
          
    else  
        gidx = length(handles.gtruth_group)+1;
        handles.gtruth_group(gidx).pixel_coordinates = [handles.r,handles.c];
        handles.gtruth_group(gidx).class_idx = handles.class_idx;
        handles.gtruth_group(gidx).class_string = handles.gtruth_class_string;
    clear gidx
    end
  
    [handles.in_gtruth] = update_fig1_fig2(handles.in, ...
                      handles.in_gtruth, handles.delete_flag, ...
                      handles.class_idx,handles.in_tiff, handles.in_tiff_raw, ...
                      handles.band, handles.color_list);

                  
    handles = rmfield(handles,{'in_gtruth_maybe';'r';'c'});
 
    if ~logical(handles.delete_flag);
        display_gtruth_hist(handles.in_tiff,handles.in,handles.band);
    end
   
    set(handles.status_text,'String','Reorient figure(1) and stick with this cover type or begin new cover type')

    
 else   
 end    
 
set(handles.text10,'Enable','on')
set(handles.Add_CoverType_2List,'Enable','on');
set(handles.gtruth_class_type,'Enable','on');
set(handles.pick_polygon,'Enable','on');
set(handles.pick_pixels,'Enable','on');
set(handles.pick_pixels_on_line,'Enable','on');
set(handles.accept_tiff,'Enable','off');
set(handles.redo,'Enable','off')
set(handles.exit,'Enable','on');

handles.delete_flag = 0; 

guidata(hObject, handles);


function redo_Callback(hObject, eventdata, handles)

try; close 2; catch; end
try; close 3; catch; end

clear handles.in_gtruth_maybe;

if get(handles.gtruth_mask_toggle,'value')==0 % cover typing active
    refresh_fig1_fig2(handles.in_tiff, handles.in_tiff_raw, handles.band, handles.color_list, handles.in_gtruth)
    set(handles.status_text,'String','Reorient figure(1) and stick with this cover type or begin new cover type')

else

end
set(handles.text10,'Enable','on')
set(handles.Add_CoverType_2List,'Enable','on');
set(handles.gtruth_class_type,'Enable','on');
set(handles.pick_polygon,'Enable','on');
set(handles.pick_pixels,'Enable','on');
set(handles.pick_pixels_on_line,'Enable','on');
set(handles.accept_tiff,'Enable','off');
set(handles.redo,'Enable','off')

function Clear_All_Callback(hObject, eventdata, handles)

function pick_method_Callback(hObject, eventdata, handles)

function pick_method_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pass_mask_2_classification_Callback(hObject, eventdata, handles)

function classify_Callback(hObject, eventdata, handles)

function exit_Callback(hObject, eventdata, handles)

 output.groundTruth.name = handles.class_list;
 output.groundTruth.value = 1:length(handles.class_list);
 output.groundTruth.matrix = handles.in_gtruth;
 
 dt = datestr(now,30);
 save([handles.outdir,handles.fname(1:end-4),'_GTOutput_',dt,'.mat'], 'output');
 
clear all
set(0,'ShowHiddenHandles','on')
delete(get(0,'Children'))


return





