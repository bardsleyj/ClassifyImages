%-------------------------------------------------------------------------
% To run the test examples.
%-------------------------------------------------------------------------

Type

>> startup

in the MATLAB prompt and press enter. 

To see how the software can be used, try one of the test m-files:

TestHotAirBalloon -- 3-banded multi-spec imagery, 200,000+ pixels
TestNyack  -- 4-banded multi-spec imagery, 2,000,000+ pixels
TestKweth  -- 3-banded multi-spec imagery, 100,000+ pixels
TestMickey -- 1-banded, gray-scale
TestZebra  -- 1-banded, binary

To run these files in MATLAB, type

>> filename

and press enter. The files themselves are in the directory IMAGES&TESTS.
The first four files generate the examples from the accompaying paper. 

%-------------------------------------------------------------------------
% To run the GUI
%-------------------------------------------------------------------------

Type

>> RUN_GUI

and press enter. The GUI will open in a separate box. First, click the 
``Load a raw tiff'' button and choose the image to be classified. The image 
to be worked upon will open as Figure 1.

Next, either choose a cover type from the drop down menu labeled ``Pick 
from cover type list'' or create a new cover type by typing it into the box 
labeled ``Add new cover type to list'' and then pressing the ENTER key.  
If the latter was performed, the newly created cover type is now available 
in the drop down menu ``Pick from cover type list''. Once a cover type is 
selected, a corresponding color needs to be chosen. Color choices that
contrast with the background image allow the user to more easily locate 
small cover type regions.

Ground truth pixels that represent a cover type (e.g. groups of similar 
trees) are isolated by enclosing within a polygon or by intersecting with a 
line or point. If the image requires being zoomed in upon to view ground 
truth pixels for selection, this adjustment needs to be completed before 
selecting the preferred button for delineating ground truth.  Once the image 
is at the necessary resolution, select the button for method of ground truthing: 
``polygon'', ``line'' or ``points''.  This brings up cross-hairs on the 
image.  A left click selects verticies for the ``polygon'' or ``line'' and 
individual pixels for the ``pixels''.  Right click ends the selection.  
Once the selection is ended, use a left click to edit vertices or pixels.  
A double click ends the session for that cover type.

Two new figures will open. Figure 2 is a repeated image of Figure 1, 
though Figure 1 now contains delineation of the recently acquired ground
truth. Figure 3 contains a frequency distribution of the recently acquired 
ground truth for the first three bands of data. The ground-truth must be 
accepted or redone using the corresponding buttons on the GUI.  If ``Redo'' 
is chosen, the most recently acquired ground-truth is rejected.  If 
``Accept" is chosen, the user has the choice of generating more ground 
truth -- either for the same or a different cover type -- or of finishing 
the session by selecting ``Save/Exit''. 

Once the ``Save/Exit" button is clicked, the ground truth is saved in the 
same directory as the original image in a *.mat file beginning with the 
name of the image used, then ``_GTOutput_'', followed by the date and time. 
To save the ground truth as an 8-bit *.tif file, first load it into MATLAB 
with the command ``load'', followed by the name of the *.mat file sans 
*.mat.  The command 
``imwrite(output.groundTruth.matrix,`groundtruth.tif',`tiff')'' writes the 
ground truth to the file groundtruth.tif. To call the corresponding 
classes, use the command ``output.groundTruth.name''.

Once the ``Save/Exit" button is clicked, the ground-truth is saved in the 
same directory as the original image in a *.mat file beginning with the 
name of the image used, then ``_GTOutput_'', followed by the date and time. 
To save the ground-truth as an 8-bit *.tif file, first load it into MATLAB 
with the command ``load,'' followed by the name of the *.mat file. The command 

>> imwrite(output.groundTruth.matrix,'groundtruth.tif','tiff')

writes the ground-truth to the file groundtruth.tif. To call the corresponding 
classes, use the command ``output.groundTruth.name''. This ground truth data 
can then be used to perform a classification by modifying one of the files 
mentioned at the top of this file. Note that this version of the GUI loads only 
three banded data, so modifications to the number of classes in the above example 
may need to be made.
