##############################################################################################################################
# Model                                                                                                                      #
#	This module is the root file that is used to run the simulation                                                          #
#                                                                                                                            #
# Created by: Henry Burton, Stanford University, 2010                                                                        #
#                                                                                                                            #
# Units: kips, inches, seconds                                                                                               #
##############################################################################################################################

# Clear the Memory
	wipe all

# Define Model Builder
	model BasicBuilder -ndm 3 -ndf 6;						# Define the model builder, ndm = #dimension, ndf = #dofs
	
# Define pushover parameters
	set IDctrlNode	*controlNode*;
	set IDctrlDOF *PushDOF*;
	set Dincr *incrementSize*;
	set Dmax *maximumDisplacement*;
	# Define PushoverDirection
	if {$IDctrlDOF == 1} {
		set PushoverDirection XDirection;
	}	else {
		set PushoverDirection ZDirection;
	}

# Set up output directory
	set dataDir Static-Pushover-Output-Model3D-$PushoverDirection;			# name of output folder
	file mkdir $dataDir;									# create output folder
	set baseDir [pwd];										# sets base directory as current directory 

# Define Variables, Units and Constants
	source DefineUnitsAndConstants.tcl
	source DefineVariables.tcl

# Source Display Procedures
	source DisplayModel3D.tcl;								# procedure for displaying a 2D perspective of model
	source DisplayPlane.tcl;								# procedure for displaying a plane in a model
	
# Build Model
	source DefineFunctionsAndProcedures.tcl
	source Model.tcl
	
# Define Loading
	if {$IDctrlDOF == 1} {
		source DefinePushoverXLoading3DModel.tcl
	}	else {
		source DefinePushoverZLoading3DModel.tcl
	}
	

# Define model run time parameters
	set startT [clock seconds];

# Run Pushover Analysis
	source RunStaticPushover.tcl

# Define model run time parameters
	set endT [clock seconds];
	set RunTime [expr ($endT - $startT)];
	puts "Run Time = $RunTime Seconds"
	
	