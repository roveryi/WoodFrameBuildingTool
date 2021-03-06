##############################################################################################################################
# RunIDAToCollapse                                                                                                           #
#	This module runs incremental dynamic analyses for a given model for a specified number of ground motions to collapse     #
#                                                                                                                            #
# 	Created by: Henry Burton, Stanford University, October 7, 2012                                                           #
#                                                                                                                            #
# Units: kips, inches, seconds                                                                                               #
##############################################################################################################################

wipe all;	# Clears memory

set baseDir [pwd];					# sets base directory as current directory 
set dataDir Model
append dataDir IDAOutputBiDirection;

# Define the periods to use for the Rayleigh damping calculations
set periodForRayleighDamping_1 0.3579712230536529;	# Mode 1 period - NEEDS to be UPDATED
set periodForRayleighDamping_2 0.24321995087410625;	# Mode 3 period - NEEDS to be UPDATED

# Creating Output Directory
file mkdir $dataDir;
set GM_folder "C:/Users/User/Desktop/WoodFrameBuildingTool/Python Tool Win/BuildingModels/GM_sets/FEMA44-FarFault/"

# Initializing processor information
set np [getNP]; # Getting the number of processors
set pid [getPID]; # Getting the processor ID number

# Setting up vector of ground motion ids
set groundMotionXIDs {}; 
set numberOfGroundMotionXIDs 22; 
for {set gm 1} {$gm <= [expr 2*$numberOfGroundMotionXIDs]} {incr gm 2} {
	lappend groundMotionXIDs $gm
}

set groundMotionZIDs {}; 
set numberOfGroundMotionZIDs 22; 
for {set gm 2} {$gm <= [expr 2*$numberOfGroundMotionZIDs]} {incr gm 2} {
	lappend groundMotionZIDs $gm
}

set RunIDs {}; 
set numberOfRunIDs 1; 
for {set gm 1} {$gm <= $numberOfRunIDs} {incr gm} {
	lappend RunIDs $gm
}

# puts "Ground motion ID's defined"

# Setting up vector with number of steps per ground motion
set groundMotionNumPoints {}; 
# set pathToTextFile $baseDir/GroundMotionInfo;
set pathToTextFile $GM_folder/GroundMotionInfo
set groundMotionNumPointsFile [open $pathToTextFile/GMNumPoints.txt r];
while {[gets $groundMotionNumPointsFile line] >= 0} {
	lappend groundMotionNumPoints $line;
}
close $groundMotionNumPointsFile;
# puts "Ground motion number of steps defined"

# Setting up vector with size of time step for each ground motion
set groundMotionTimeStep {}; 
set groundMotionTimeStepFile [open $pathToTextFile/GMTimeSteps.txt r];
while {[gets $groundMotionTimeStepFile line] >= 0} {
	lappend groundMotionTimeStep $line;
}
close $groundMotionTimeStepFile;
# puts "Ground motion time steps defined"

# Setting up vector with names of ground motions
set groundMotionFileNames {}; 
set groundMotionFileNamesFile [open $pathToTextFile/GMFileNames.txt r];
while {[gets $groundMotionFileNamesFile line] >= 0} {
	lappend groundMotionFileNames $line;
}
close $groundMotionFileNamesFile;

# Setting up vector with MCE scale factor for each ground motion pair
set MCEScaleFactors {}; 
set MCEScaleFactorsFile [open $pathToTextFile/BiDirectionMCEScaleFactors.txt r];
while {[gets $MCEScaleFactorsFile line] >= 0} {
	lappend MCEScaleFactors $line;
}
close $MCEScaleFactorsFile;
# puts "MCE Scale Factors defined"

# Ground motion scales to run
set allScales {100};

# Set the single ground motion to run
set Pairing 1;
set GMIDs 1;

if {$Pairing == 1} {
	set GM_XNumber [lindex $groundMotionXIDs $GMIDs];		
	puts "*GM_XNumber : $GM_XNumber ";

	set GM_ZNumber [lindex $groundMotionZIDs $GMIDs];
	puts "*GM_ZNumber : $GM_ZNumber ";
} else {
	set GM_XNumber [lindex $groundMotionZIDs $GMIDs];		
	puts "*GM_XNumber : $GM_XNumber ";

	set GM_ZNumber [lindex $groundMotionXIDs $GMIDs];
	puts "*GM_ZNumber : $GM_ZNumber ";
}


set GM_XFileName [format %s%s%s%s $GM_folder /histories/ [lindex $groundMotionFileNames [expr $GM_XNumber-1]] .txt];
set GM_ZFileName [format %s%s%s%s $GM_folder /histories/ [lindex $groundMotionFileNames [expr $GM_ZNumber-1]] .txt];

set GMX_FileName $GM_XFileName
set GMZ_FileName $GM_ZFileName

# Set output directory
file mkdir SingleGM
cd $baseDir/SingleGM
file mkdir $GMIDs
set pathToResults $baseDir/SingleGM/$GMIDs
set pathToModel $baseDir

set IDAStartT [clock seconds];

# Looping over alll ground motions
foreach runNumber $RunIDs {
	if {[expr {$runNumber % $np}] == $pid} {
		set groundMotionXNumber [lindex $groundMotionXIDs [expr $runNumber - 1]];
		set groundMotionZNumber [lindex $groundMotionZIDs [expr $runNumber - 1]];
		set dt [lindex $groundMotionTimeStep [expr $groundMotionZNumber - 1]];
		set eqXNumber $groundMotionXNumber;
		set eqZNumber $groundMotionZNumber;
		set eqNumber $runNumber;
		set numPoints [lindex $groundMotionNumPoints [expr $groundMotionZNumber - 1]];
		set MCE_SF [lindex $MCEScaleFactors [expr $runNumber - 1]];
		# puts "Ground parameters defined"
	
		# Run IDA until maximum scale is reached
		foreach scale $allScales {	
			cd $baseDir
			source Model.tcl
			wipe;
		}
	}
}

set IDAEndT [clock seconds];
set IDARunTime [expr ($IDAEndT - $IDAStartT)/3600];
puts "Run Time = $IDARunTime Hours"
