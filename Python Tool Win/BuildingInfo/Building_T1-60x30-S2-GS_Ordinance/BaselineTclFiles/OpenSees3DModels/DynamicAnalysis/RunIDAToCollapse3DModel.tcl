##############################################################################################################################
# RunIDAToCollapse                                                                                                           #
#	This module runs incremental dynamic analyses for a given model for a specified number of ground motions to collapse     #
#                                                                                                                            #
# 	Created by: Henry Burton, Stanford University, October 7, 2012                                                           #
#                                                                                                                            #
# Units: kips, inches, seconds                                                                                               #
##############################################################################################################################

wipe all;	# Clears memory

# Define model properties
set NStories *nStories*

# Source procedures used to check for collapse
source ExtractBiDirectionalMaxDrift3DModel.tcl

set baseDir [pwd];					# sets base directory as current directory 
set dataDir Model
append dataDir BiDirectionalIDAToCollapseOutput;

# Define the periods to use for the Rayleigh damping calculations
set periodForRayleighDamping_1 *firstModePeriod*;	# Mode 1 period - NEEDS to be UPDATED
set periodForRayleighDamping_2 *thirdModePeriod*;	# Mode 3 period - NEEDS to be UPDATED

# Creating Output Directory
file mkdir $dataDir;

# Initializing processor information
set np [getNP]; # Getting the number of processors
set pid [getPID]; # Getting the processor ID number

# Setting up vector of ground motion ids
set groundMotionXIDs {}; 
set numberOfGroundMotionXIDs *NumberOfGroundMotions*; 
for {set gm 2} {$gm <= [expr 2*$numberOfGroundMotionXIDs]} {incr gm 2} {
	lappend groundMotionXIDs $gm
}

set groundMotionZIDs {}; 
set numberOfGroundMotionZIDs *NumberOfGroundMotions*; 
for {set gm 1} {$gm <= [expr 2*$numberOfGroundMotionZIDs]} {incr gm 2} {
	lappend groundMotionZIDs $gm
}

set RunIDs *ID*;
set PairingIDs *PairingID*;
#set RunIDs {}; 
#set numberOfRunIDs *NumberOfGroundMotions*; 
#for {set gm 1} {$gm <= $numberOfRunIDs} {incr gm} {
#	lappend RunIDs $gm
#}

puts "Ground motion ID's defined"

# Setting up vector with number of steps per ground motion
set groundMotionNumPoints {}; 
set pathToTextFile $baseDir/GroundMotionInfo;
set groundMotionNumPointsFile [open $pathToTextFile/GMNumPoints.txt r];
while {[gets $groundMotionNumPointsFile line] >= 0} {
	lappend groundMotionNumPoints $line;
}
close $groundMotionNumPointsFile;
puts "Ground motion number of steps defined"
	
# Setting up vector with size of time step for each ground motion
set groundMotionTimeStep {}; 
set groundMotionTimeStepFile [open $pathToTextFile/GMTimeSteps.txt r];
while {[gets $groundMotionTimeStepFile line] >= 0} {
	lappend groundMotionTimeStep $line;
}
close $groundMotionTimeStepFile;
puts "Ground motion time steps defined"

# Setting up vector with MCE scale factor for each ground motion pair
set MCEScaleFactors {}; 
set MCEScaleFactorsFile [open $pathToTextFile/BiDirectionMCEScaleFactors.txt r];
while {[gets $MCEScaleFactorsFile line] >= 0} {
	lappend MCEScaleFactors $line;
}
close $MCEScaleFactorsFile;
puts "MCE Scale Factors defined"

# # Initial increment for ground motion scales
# set initialGroundMotionScaleIncrement *InitialGroundMotionIncrementScaleForCollapse*;
# set reducedGroundMotionScaleIncrement *ReducedGroundMotionIncrementScaleForCollapse*;

# # Define response parameter limits used to check for collapse
# # Drift Limit For Collapse
# set collapseDriftLimit *CollapseDriftLimit*;

set IDAStartT [clock seconds]


# Create folders used to store output
cd $dataDir
file mkdir IDAMaxXDrifts
file mkdir IDAMaxZDrifts
file mkdir IDAGMScales


cd $baseDir
set currentGrounMotionScale *ScaleID*

# Looping over alll ground motions
set Pairing $PairingIDs
set runNumber $RunIDs

    # Define ground motion parameters
    set groundMotionXNumber [lindex $groundMotionXIDs [expr $runNumber - 1]];
    set groundMotionZNumber [lindex $groundMotionZIDs [expr $runNumber - 1]];
    set scale $currentGrounMotionScale
    set dt [lindex $groundMotionTimeStep [expr $groundMotionZNumber - 1]];
    set eqXNumber $groundMotionXNumber;
    set eqZNumber $groundMotionZNumber;
    set eqNumber $runNumber;
    set numPoints [lindex $groundMotionNumPoints [expr $groundMotionZNumber - 1]];
    set MCE_SF [lindex $MCEScaleFactors [expr $runNumber - 1]];
    puts "Ground parameters defined"
	
	# Run IDA until collapse response parameter limit is exceeded

    # Sourcing model to run
    cd $baseDir	
    source Model.tcl
    wipe;
	
set IDAEndT [clock seconds];
set IDARunTime [expr ($IDAEndT - $IDAStartT)/60];
puts "Run Time = $IDARunTime Minutes"
	
	