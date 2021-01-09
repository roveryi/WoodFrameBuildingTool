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
# # Defining units and constants
# source A_DefineUnitsAndConstants.tcl
# # Defining functions and procedures
# source A_DefineFunctionsAndProcedures.tcl
##############################################################################################################################

# # switch to use benchmark model
# set BenchMark  1;

# # switch to turn on or off concentrated mass
# set LumpedMass 0;
# # set LumpedMass 0;

# # switch to turn on or off Panel Zone
# set PanelZone 1;
# # set PanelZone 0;

# # switch to turn on or off fiber hinge for column hinge
# set FiberColumnHinge 1;
# # set FiberColumnHinge 0;  # use bilin hinge for column hinge
# # set FiberColumnHinge 1;  # use fiber hinge for column hinge
# # set FiberColumnHinge 2;  # use force-based element for column

# # Switch model type
# set ModelType [format %s%s%s $LumpedMass $PanelZone $FiberColumnHinge];

# # switch to turn on or off annalysis real-time view
# set illustrateModel 0;

# switch to turn on or off running annalysis on Hoffman2
set RunOnHoffman 0;

# switch to turn on or off down sampling ground motion
# set DownSample 0;

# set RunLogFileName [format %s%s%s L_RunLog [clock format [clock seconds] -format %Y-%m-%d_%H-%M-%S] .txt];
# if {[catch {set RunLog [open $RunLogFileName w+]} err_msg]} {
	# puts "Failed to open the file for editing: $err_msg"
	# return
# }
set baseDir [pwd];					# sets base directory as current directory 

# if {$RunOnHoffman == 1} {
# 	set dataDir Result_IncrementalDynamicAnalysis;
# } else {
# 	set dataDir [format %s%s Result_IncrementalDynamicAnalysis_ [clock format [clock seconds] -format %Y-%m-%d_%H-%M-%S]];
# }

# # if { [file exists $dataDir] == 1 } { 
# 	# file delete -force $dataDir;
# # }

cd $baseDir

# puts "Results are stored in $dataDir."
# puts "BenchMark: $BenchMark."
# puts "ModelType: LumpedMass($LumpedMass) ; PanelZone($PanelZone) ; FiberColumnHinge($FiberColumnHinge)."
# Set up output parameters

# set RecorderBaseReactions ON; 
# set RecorderBeamHinges ON; 
# set RecorderColumnHinges ON; 
# set RecorderPanelZoneHinges ON; 
# set RecorderNodeDisplacements ON; 
# set RecorderNodeAccelerations ON; 
# set RecorderStoreyDrifts ON; 

# set RecorderGlobalBeamForces ON; 
# set RecorderGlobalColumnForces ON; 

# Define the periods to use for the Rayleigh damping calculations
# set periodForRayleighDamping_1 1.0;	# Mode 1 period - NEEDS to be UPDATED
# set periodForRayleighDamping_2 0.8;	# Mode 3 period - NEEDS to be UPDATED

# Define time histroy analysis parameters
set TimeHistoryAnalysisType IDA; 
# cd	$baseDir/histories
# set GM_FileName [glob *.txt]; # get ground motion file name in folder
# set NumberOfGroundMotions [expr [llength $GM_FileName]/2];

# Initializing processor information
set np [getNP]; # Getting the number of processors
set pid [getPID]; # Getting the processor ID number

set Scale_Sa_GM {0.178 0.274 0.444 0.560 0.652 0.790 0.982 1.246 1.564 2.014 2.417 3.021 3.625 4.028 4.431 5.035};
set GMset_Num {45 45 45 45 45 45 45 45 45 45 45 45 45 45 45 45}; #list contains the number of ground motions in each hazard levle
 # set Model_Num 100; # Total number of sensitivity study cases
# set Scale_Sa_GM {1.5103815	0.273467	0.444298	0.5601	0.65216	0.790259	0.982082	1.246203	1.563623	2.013842	2.2152262	2.4166104	2.6179946	2.8193788	3.020763	3.2221472	3.4235314	3.6249156	3.8262998	4.027684}; #输入你的gm Sa 20个数值，单位为g
# set GMset_Num {48 49 49 52 50 49 49 49 48 48 48 48 48 48 48 48 48 48 48 48}; #list contains the number of ground motions in each hazard levle
#
set Model_Num 1;
set GMset_Series {}; # Number of analysis have been done after each hazard level in each case
set GMset_Acumu 0; # Record total number of simulations in each model, submission of all number of ground motions

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

set globalCounter [lindex $argv 0];
# set globalCounter 95;

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


	set pathToTextFile $baseDir/GM_sets/PEER_CEA/SanFrancisco/$ScaleID1/GroundMotionInfo;


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
	# source B0b_DefineSeismicParameters.tcl

	# +++++++++++++++++++++++ use percentage of SaMCE +++++++++++++++++++++++
	# allScale_GM 百分比列表
	# allScale_Sa_GM 保留三位绝对值列表
	# Ground motion scales to run



	# set allScale_Sa_GM {};
	# foreach ScalesPercentage $allScale_GM {
		# set Scale_Sa_GM [expr round($ScalesPercentage/100.0*$SaMCE*1000)/1000.0]; #unit is g
		# lappend allScale_Sa_GM $Scale_Sa_GM;
	# }



	# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	# +++++++++++++++++++++++++ use absolute values +++++++++++++++++++++++++
	# allScale_GM 百分比列表
	# allScale_Sa_GM 保留三位绝对值列表
	# Ground motion scales to run

	# set IncrScale_Sa_GM 0.2; #unit is g
	# set StartScale_Sa_GM 0.2; #unit is g
	# set EndScale_Sa_GM 2.0; #unit is g

	# set Scale_Sa_GM $StartScale_Sa_GM;
	# set allScale_Sa_GM {};
	# while {$Scale_Sa_GM <= $EndScale_Sa_GM } {
		# lappend allScale_Sa_GM $Scale_Sa_GM;
		# set Scale_Sa_GM [expr $Scale_Sa_GM + $IncrScale_Sa_GM];
	# }


	# set allScale_GM {};
	# foreach iScale_Sa_GM $allScale_Sa_GM {
		# set iScale_GM [expr $iScale_Sa_GM/$SaMCE*100];
		# lappend allScale_GM $iScale_GM;
	# }

	# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++





	# set DriftLimit 0.1;


	# Looping over alll ground motions
	# foreach runNumber $RunIDs {
	# if {[expr {$runNumber % $np}] == $pid} {
	# set GMindex [expr int($runNumber / [llength $allScale_GM])];		
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

	set GM_XFileName [format %s%s%s $baseDir /GM_sets/PEER_CEA/SanFrancisco//histories/ [lindex $groundMotionFileNames [expr $GM_XNumber-1]]];
	set GM_ZFileName [format %s%s%s $baseDir /GM_sets/PEER_CEA/SanFrancisco//histories/ [lindex $groundMotionFileNames [expr $GM_ZNumber-1]]];

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



	set pathToModel $baseDir/case$ModelID1;
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

	set PairingIDs 1;
	set Pairing 1; # Control apply ground motion directions, pairng = 1, put H1 in x direction, H2 in the other direction; pairing = 2, other direction 
	set eqNumber [expr $GMindex+1]

	cd	$pathToModel
	source Model.tcl
	# source D4B_BuildDynamicAnalysisModelColHBilin.tcl
	# source D4F_BuildDynamicAnalysisModel_ColFE.tcl

	# source E4_PerformDynamicAnalysisBiDirectionCollapseSolverYuu.tcl
	# E4_PerformDynamicAnalysisBiDirectionCollapseSolverYuu $GM_dt $An_dt $GM_time $NStories $DriftLimit $RigidDiaphNodeItem $StoryHeight $firstTimeCheck

	# source E4_PerformDynamicAnalysisBiDirectionCollapseSolverXx.tcl

	# source Z_DynamicAnalysisBiDirectionCollapseSolver.tcl
	# DynamicAnalysisBiDirectionCollapseSolver $GM_dt $An_dt $GM_time $NStories $DriftLimit $RigidDiaphNodeItem $StoryHeight $firstTimeCheck

	# cd $dataDir
	# set MPLogFileName [format %s%s%s%s%s L_MPLogGMPair [expr $GMIDs + 0 ] Scale $Sa_Scale_Tag .txt];
	# if {[catch {set MPLog [open $MPLogFileName w+]} err_msg]} {
		# puts "Failed to open the file for editing: $err_msg"
		# return
	# }
	# RunAndLog $MPLog "********************************************************************************"
	# RunAndLog $MPLog "         Ground Motion Pairs [expr $GMIDs + 0 ] (Scale:[format {%0.3f} $Sa_Scale] g) starts to run       "
	# RunAndLog $MPLog "                      Process Number(nd) : $np   /   Process ID(pid) : $pid                             "
	# RunAndLog $MPLog "********************************************************************************"
	# close $MPLog

	# cd ..


	puts "********************************************************************************"
	puts "          Ground Motion Pairs [expr $GMIDs + 0 ] (Scale:[format {%s} $Sa_Scale_Tag]) finished           "
	puts "         Ground Motion File Name in X Direction : $GM_XFileName       "
	puts "         Ground Motion File Name in Z Direction : $GM_ZFileName       "
	puts "********************************************************************************"


	wipe; 
		
		# }
	
# }
}

