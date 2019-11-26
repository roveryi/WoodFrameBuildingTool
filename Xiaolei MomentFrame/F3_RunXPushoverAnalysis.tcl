##############################################################################################################################
# 	RunIDAtoCollapse														                             		             #
#	This module runs incremental dynamic analyses for a given model for a specified number of ground motions to collapse     #
# 														             														 #
# 	Created by: Henry Burton, Stanford University, October 7, 2012									                         #
#								     						                                                                 #
#	Modified by: Xiaolei Xiong, Tongji University, December 4, 2017                                                          #
#								     						                                                                 #
# 	Units: kips, inches, seconds                                                                                             #
##############################################################################################################################

wipe all;	# Clears memory
set AllStartTime [clock seconds];
##############################################################################################################################
# Defining units and constants
source A_DefineUnitsAndConstants.tcl
# Defining functions and procedures
source A_DefineFunctionsAndProcedures.tcl
##############################################################################################################################

# switch to turn on or off concentrated mass
set LumpedMass 0;
# set LumpedMass 0;

# switch to turn on or off Panel Zone
set PanelZone 1;
# set PanelZone 0;

# switch to turn on or off fiber hinge for column hinge
set FiberColumnHinge 1;
# set FiberColumnHinge 0;  # use bilin hinge for column hinge
# set FiberColumnHinge 1;  # use fiber hinge for column hinge
# set FiberColumnHinge 2;  # use force-based element for column

# Switch model type
set ModelType [format %s%s%s $LumpedMass $PanelZone $FiberColumnHinge];

# switch to turn on or off annalysis real-time view
set illustrateModel 1;

# Define work path
set baseDir [pwd];

# Set up output directory
set dataDir [format %s%s Result_XPushoverAnalysis_ [clock format [clock seconds] -format %Y-%m-%d_%H-%M-%S]];
# if { [file exists $dataDir] == 1 } { 
	# file delete -force $dataDir;
# }
file mkdir $dataDir

# Set up output parameters
# Set up output parameters
set RunLogFileName [format %s%s%s L_XPushoverRunLog [clock format [clock seconds] -format %Y-%m-%d_%H-%M-%S] .txt];
if {[catch {set RunLog [open $RunLogFileName w+]} err_msg]} {
	puts "Failed to open the file for editing: $err_msg"
	return
}

RunAndLog $RunLog "Results are stored in $dataDir."
RunAndLog $RunLog "ModelType: LumpedMass($LumpedMass) ; PanelZone($PanelZone) ; FiberColumnHinge($FiberColumnHinge)."

 set RecorderBaseReactions ON; 
# set RecorderBeamHinges ON; 
# set RecorderColumnHinges ON; 
# set RecorderPanelZoneHinges ON; 
# set RecorderGlobalBeamForces ON; 
# set RecorderGlobalColumnForces ON; 
set RecorderNodeDisplacements ON; 
# set RecorderNodeAccelerations ON; 
# set RecorderStoreyDrifts ON; 

# Define pushover analysis parameters(other parameters see DefineVariables.)
set IDctrlDOF	1;
set PushDirection X;

# Source building model
source D3_BuildPushoverModel.tcl
# source D3N_BuildPushoverModel_NoPZ.tcl

# Define model run time parameters
set startT [clock seconds]

# Run pushover analysis
source E3_PerformStaticPushoverSolver.tcl

# display deformed shape:
if {$illustrateModel == 1} {
	set ViewScale 10;
	DisplayModel3D DeformedShape $ViewScale ;}

# Define model run time parameters
set EndT [clock seconds];
set RunTime [expr ($EndT - $AllStartTime)/3600];
set RunTimeMin [expr ($EndT - $AllStartTime)/60];
set RunTimeSec [expr ($EndT - $AllStartTime)];
RunAndLog $RunLog "\n**********************************\nTotal Runtime: $RunTime Hours ($RunTimeMin Mins) ($RunTimeSec Secs).\n**********************************\n"
RunAndLog $RunLog "Gravity load analysis finished"


print ColHingeMy
close $RunLog
