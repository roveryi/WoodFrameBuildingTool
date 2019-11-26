source DefineDynamicAnalysisParameters3DModel.tcl
source DynamicAnalysisBiDirectionCollapseSolver.tcl

# Ground motion parameters
set GM_dt $dt; #($eqNumber);
set GM_numPoints $numPoints; #($eqNumber);
# set GMX_FileName "histories/$eqFileName($eqXNumber)";
# set GMZ_FileName "histories/$eqFileName($eqZNumber)";
# set GaccelX "Series -dt $GM_dt -filePath $GMX_FileName -factor $scalefactor"
# set GaccelZ "Series -dt $GM_dt -filePath $GMZ_FileName -factor $scalefactor"

timeSeries Path 1 -dt  $GM_dt -filePath $GMX_FileName -factor $scalefactor 
timeSeries Path 2 -dt  $GM_dt -filePath $GMZ_FileName -factor $scalefactor

timeSeries Path 11 -dt  $GM_dt -filePath $GMX_FileName -factor $scalefactor 
timeSeries Path 12 -dt  $GM_dt -filePath $GMZ_FileName -factor $scalefactor

source DefineAllRecorders3DModel.tcl

if {$Pairing == 1} {
	pattern UniformExcitation  2   1  -accel   1
	pattern UniformExcitation  3   3  -accel   2
} else {
	pattern UniformExcitation  2   3  -accel   1
	pattern UniformExcitation  3   1  -accel   2
}	

# pattern UniformExcitation  2   1  -accel   $GaccelX
# pattern UniformExcitation  3   3  -accel   $GaccelZ

# Call Dynamic Analysis Solver and run for collapse tracing
set currentTime [getTime];
set dtAn [expr 1.0*$GM_dt];		# timestep of initial analysis	
set GMtime [expr $GM_dt*$GM_numPoints];
set firstTimeCheck [clock seconds];	
		
		
		
# input Motion  simul. step  duration numStories Drift Limit    List Nodes    StoryH 1   StoryH Typical    Analysis Start Time
DynamicAnalysisBiDirectionCollapseSolver    $GM_dt  	$dtAn       $GMtime  $NStories     0.1   	   $FloorNodes   $HFirstStory    $HTypicalStory          $firstTimeCheck

# input Motion  simul. step  duration numStories Drift Limit    List Nodes    StoryH 1   StoryH Typical    Analysis Start Time
# DynamicAnalysisCollapseSolver    $GM_dt  	$dtAn       $GMtime  $NStories     0.05   	   $FloorNodes   $HFirstStory    $HTypicalStory          $firstTimeCheck     $groundMotionDirection