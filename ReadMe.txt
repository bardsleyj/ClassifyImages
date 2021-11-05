%-------------------------------------------------------------------------
% To run the test examples.
%-------------------------------------------------------------------------

Type

>> startup

in the MATLAB prompt and press enter. 

To see how the software can be used, try on of the test m-files:

TestHotAirBalloon -- 3-banded multi-spec imagery, 200,000+ pixels
TestNyack  -- 4-banded multi-spec imagery, 2,000,000+ pixels
TestKweth  -- 3-banded multi-spec imagery, 100,000+ pixels
TestMickey -- 1-banded, gray-scale
TestZebra  -- 1-banded, binary

To run these files in MATLAB, type

>> filename

and press enter. The files themselves are in the directory IMAGES&TESTS.

%-------------------------------------------------------------------------
% To run the GUI
%-------------------------------------------------------------------------

Type

>> RUN_GUI

and press enter. Then follow the directions from the paper, "MATLAB 
Software for Supervised Classification in Remote Sensing and Image 
Processing", Bardsley, et. al. reproduced here:

The GUI will open in a separate box. First, click the ``Load a raw tiff'' 
button and choose the image to be classified. The image to be worked upon 
will open as Figure 1.

Next, either choose a cover type from the drop down menu labeled ``Pick 
from cover type list'' or create a new cover type by typing it into the box 
labeled ``Add new cover type to list'' and then pressing the ENTER key.  
If the latter was performed, the newly created cover type is now available 
in the drop down menu ``Pick from cover type list''. Once a cover type is 
selected, a corresponding color needs to be chosen.  

Ground truth is delineated either by polygons, lines or individual pixels. 
If the image requires being zoomed in upon to view ground truth pixels for 
selection, this adjustment needs to be completed before selecting the 
preferred button for delineating ground truth.  Once the image is at the 
necessary resolution, select the button for method of ground truthing: 
``polygon'', ``line'' or ``points''.  This brings up cross-hairs on the 
image.  A left click selects verticies for the ``polygon'' or ``line'' and 
individual pixels for the ``pixels''.  Right click ends the selection.  
Once the selection is ended, use a left click to edit vertices or pixels.  
A double click ends the session for that cover type.

Two new figures will open. Figure 2 is a repeated image of Figure 1, 
though Figure 1 now contains delineation of the recently acquired ground 
truth. Figure 3 contains a histogram of the recently acquired 
ground truth for the first three bands of data. The ground truth must be 
accepted or redone using the corresponding buttons on the GUI.  If ``Redo''
is chosen, the most recently acquired ground truth is rejected.  If 
``Accept" is chosen, the user has the choice of generating more ground 
truth - either for the same or a different cover type - or of finishing the
session by selecting ``Save/Exit''. 

Once the ``Save/Exit" button is clicked, the ground truth is saved in the 
same directory as the original image in a *.mat file beginning with the 
name of the image used, then ``_GTOutput_'', followed by the date and time. 
To save the ground truth as an 8-bit *.tif file, first load it into MATLAB 
with the command ``load'', followed by the name of the *.mat file sans 
*.mat.  The command 
``imwrite(output.groundTruth.matrix,`groundtruth.tif',`tiff')'' writes the 
ground truth to the file groundtruth.tif. To call the corresponding 
classes, use the command ``output.groundTruth.name''.