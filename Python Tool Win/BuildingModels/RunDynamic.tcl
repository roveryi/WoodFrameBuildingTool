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

set RunOnHoffman 0;
set baseDir [pwd];					# sets base directory as current directory 
cd $baseDir

set TimeHistoryAnalysisType IDA; 

set np [getNP]; # Getting the number of processors
set pid [getPID]; # Getting the processor ID number

##############################################################################################################################
# Need to modify
set Scale_Sa_GM {*Scale_Sa_GM*}; 
set GMset_Num {*GMset_Num*}; #list contains the number of ground motions in each hazard levle

set Model_Num 1; # set up for single model
set GMset_Series {}; # Number of analysis have been done after each hazard level in each case
set GMset_Acumu 0; # Record total number of simulations in each model, submission of all number of ground motions
##############################################################################################################################

foreach iGMset_Num $GMset_Num {
	set GMset_Acumu [expr $GMset_Acumu+$iGMset_Num];
	lappend GMset_Series $GMset_Acumu;
}

set RunIDs {}; 
set SingleModelNumberOfRunIDs 0; # Total number of cases in each case
foreach iGMset_Num $GMset_Num {
	set SingleModelNumberOfRunIDs [expr $SingleModelNumberOfRunIDs+$iGMset_Num];
}
set numberOfRunIDs [expr $SingleModelNumberOfRunIDs * $Model_Num]; # Total number of runs for all cases

for {set gm 0} {$gm < $numberOfRunIDs} {incr gm} {
	lappend RunIDs $gm
} 
puts "Routine ID's defined"

# set globalCounter [lindex $argv 0];
set globalCounter *globalCounter*;

# Each global counter corresponds to one ground motion in one hazard level, for all cases
for {set i 0} {$i <= $Model_Num-1} {incr i} {

	set runNumber [expr $globalCounter - 1]; # Record which global analysis is running

	# set ModelID [expr int($runNumber / $Model_Num)]; 
	set ModelID [expr $i]
	set ModelID1 [expr $ModelID+1];	# Record which model is currently running

	# set SingleModelID [expr int($runNumber % $Model_Num) + 1]; # Record which analysis of a model is running 
	set SingleModelID [expr $globalCounter];

	set ScaleID 0; # Record which hazard level is running 
	foreach iGMset_Series $GMset_Series {
		if {$SingleModelID > $iGMset_Series} {
			set ScaleID [expr $ScaleID+1];
		}
	} 
	set ScaleID1 [expr $ScaleID+1]; # Current hazard level

	if {$ScaleID == 0} {
			set GMNumBase 0;
	} else {
		set GMNumBase [lindex $GMset_Series [expr $ScaleID-1]];
	}

	set GMindex [expr $SingleModelID-$GMNumBase-1]; # Record current ground motion



	# Setting up vector of ground motion ids
	set groundMotionXIDs {}; 
	set numberOfGroundMotionXIDs [lindex $GMset_Num $ScaleID]; 
	for {set gm 1} {$gm <= [expr 2*$numberOfGroundMotionXIDs]} {incr gm 2} {
		lappend groundMotionXIDs $gm
	}
	# set currentGMXIDs $groundMotionXIDs [expr $GMindex]

	set groundMotionZIDs {}; 
	set numberOfGroundMotionZIDs [lindex $GMset_Num $ScaleID]; 
	for {set gm 2} {$gm <= [expr 2*$numberOfGroundMotionZIDs]} {incr gm 2} {
		lappend groundMotionZIDs $gm
	}
	# set currentGMZIDs $groundMotionZIDs [expr $GMindex]
	# set groundMotionIDs {3}; 

	set groundMotionIDs {}; 
	set numberOfGroundMotionIDs [lindex $GMset_Num $ScaleID]; 
	for {set gm 0} {$gm < $numberOfGroundMotionIDs} {incr gm} {
		lappend groundMotionIDs $gm
	}
	puts "Ground motion ID's defined"

	# Setting up vector with number of steps per ground motion
	set groundMotionNumPoints {}; 


	set pathToTextFile *pathToGMTextFile*;


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
	# set currentMCEScaleFactor $MCEScaleFactors [expr $GMindex]
	puts "MCE Scale Factors defined"

	# Setting up vector with names of ground motions
	set groundMotionFileNames {}; 
	set groundMotionFileNamesFile [open $pathToTextFile/GMFileNames.txt r];
	while {[gets $groundMotionFileNamesFile line] >= 0} {
		lappend groundMotionFileNames $line;
	}
	close $groundMotionFileNamesFile;

	# set currentGMXName $groundMotionFileNames [expr $currentGMXIDs-1]
	# set currentGMZName $groundMotionFileNames [expr $currentGMZIDs-1]
	puts "Ground motion file names defined"

	cd	$baseDir
	
	set LoadCaseStartT [clock seconds];

	set GMIDs [lindex $groundMotionIDs $GMindex];		
	puts "*GMID : $GMIDs ";

	set GM_XNumber [lindex $groundMotionXIDs $GMIDs];		
	puts "*GM_XNumber : $GM_XNumber ";

	set GM_ZNumber [lindex $groundMotionZIDs $GMIDs];
	puts "*GM_ZNumber : $GM_ZNumber ";

	set GM_Number $GMIDs;
	if {$GM_Number<10} {
		set GM_Number_Tag [format %s%s%s Pair0 $GM_Number Folder];
	} else {
		set GM_Number_Tag [format %s%s%s Pair $GM_Number Folder];
	}
			
	set GM_dt [lindex $groundMotionTimeStep [expr $GM_ZNumber - 1]];
	set GM_numPoints [lindex $groundMotionNumPoints [expr $GM_ZNumber - 1]];
	set MCE_SF [lindex $MCEScaleFactors $GMIDs];

	puts "*$GM_dt";
	puts "*$GM_dt";


	set An_dt [expr 0.5*$GM_dt];		# timestep of initial analysis	
	set GM_time [expr $GM_dt*$GM_numPoints];

	set GM_XFileName [format %s%s%s%s%s%s $baseDir /*GM_Info*/ $ScaleID1 /histories/ [lindex $groundMotionFileNames [expr $GM_XNumber-1]] .txt];
	set GM_ZFileName [format %s%s%s%s%s%s $baseDir /*GM_Info*/ $ScaleID1 /histories/ [lindex $groundMotionFileNames [expr $GM_ZNumber-1]] .txt];

	set GMX_FileName $GM_XFileName
	set GMZ_FileName $GM_ZFileName


	puts "Ground parameters defined"



	cd $baseDir	
	set scale [lindex $Scale_Sa_GM $ScaleID];
	puts  " scale : $scale ";


	set Sa_Scale_Tag [format %s%s $scale g];

	puts " Sa_Scale_Tag : $Sa_Scale_Tag ";


	puts "********************************************************************************"
	puts "         Ground Motion Pairs [expr $GMIDs + 0 ] (Scale:[format {%s} $Sa_Scale_Tag]) starts to run       "
	puts "********************************************************************************"



	set pathToModel $baseDir/*ModelName*/DynamicAnalysis;
	cd	$pathToModel

	set dataDir Model
	append dataDir SingleScaleOutputBiDirection;
	file mkdir $dataDir;
	cd	$pathToModel/$dataDir
	file mkdir HazardLevel$ScaleID1
	set pathToResults $pathToModel/$dataDir/HazardLevel$ScaleID1;

	# set MCE_SF $scale
	set dt $GM_dt
	set numPoints $GM_numPoints
	set eqXNumber $GM_XNumber
	set eqZNumber $GM_ZNumber

	set PairingIDs *PairingID*;
	set Pairing *PairingID*; # Control apply ground motion directions, pairng = 1, put H1 in x direction, H2 in the other direction; pairing = 2, other direction 
	set eqNumber [expr $GMindex+1]

	cd	$pathToModel
	source Model.tcl



	puts "********************************************************************************"
	puts "          Ground Motion Pairs [expr $GMIDs + 0 ] (Scale:[format {%s} $Sa_Scale_Tag]) finished           "
	puts "         Ground Motion File Name in X Direction : $GM_XFileName       "
	puts "         Ground Motion File Name in Z Direction : $GM_ZFileName       "
	puts "********************************************************************************"


	wipe; 
		
		# }
	
# }


