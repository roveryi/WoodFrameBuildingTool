# This file will be used to define all recorders


# Setting up folders
# set baseDir [pwd];

# Recorder Type


if { [info exists TimeHistoryAnalysisType] == 1 } {
	if {$TimeHistoryAnalysisType == "SingleScaleBiDirection"} {
		RunLog "cd	$baseDir/$dataDir/"
		file mkdir EQ_$GM_Number_Tag
		cd	$baseDir/$dataDir/EQ_$GM_Number_Tag
		set StoreDir [pwd];
	}
	if {$TimeHistoryAnalysisType == "IDA"} {
		cd	$baseDir/$dataDir/
		file mkdir EQ_$GM_Number_Tag
		cd	$baseDir/$dataDir/EQ_$GM_Number_Tag
		file mkdir Scale_$Sa_Scale_Tag
		cd	$baseDir/$dataDir/EQ_$GM_Number_Tag/Scale_$Sa_Scale_Tag
		set StoreDir [pwd];
	}
} else {
	cd	$baseDir/$dataDir/
	set StoreDir [pwd];
}

# Base Reactions Recorder
if {  [info exists RecorderBaseReactions] == 1 } {
	if {$RecorderBaseReactions == "ON"} {
		cd	$StoreDir
		file mkdir BaseReactions;
		cd $baseDir
		source C1_DefineBaseReactionRecorders3DModel.tcl		
	}
}

# Beam Hinges Recorder
if {  [info exists RecorderBeamHinges] == 1 } {
	if {$RecorderBeamHinges == "ON"} {
		cd	$StoreDir
		file mkdir BeamHingeForce
		file mkdir BeamHingeDeformations
		cd $baseDir
		source C2_DefineBeamHingeRecorders3DModel.tcl		
	}
}

# Column Hinges Recorder
if {  [info exists RecorderColumnHinges] == 1 } {
	if {$RecorderColumnHinges == "ON"} {
		cd	$StoreDir
		file mkdir ColumnHingeForce
		file mkdir ColumnHingeDeformations
		cd $baseDir
		source C3_DefineColumnHingeRecorders3DModel.tcl		
	}
}

# Panel Zone Hinges Recorder
if {  [info exists RecorderPanelZoneHinges] == 1 } {
	if {$RecorderPanelZoneHinges == "ON"} {
		cd	$StoreDir
		file mkdir PanelZoneHingeForce
		file mkdir PanelZoneHingeDeformations
		cd $baseDir
		source C4_DefinePanelZoneHingeRecorders3DModel.tcl		
	}
}

# Global Beam Forces Recorder
if {  [info exists RecorderGlobalBeamForces] == 1 } {
	if {$RecorderGlobalBeamForces == "ON"} {
		cd	$StoreDir
		file mkdir GlobalBeamForces
		cd $baseDir
		source C5_DefineGlobalBeamForceRecorders3DModel.tcl	
	}
}

# Global Column Forces Recorder
if {  [info exists RecorderGlobalColumnForces] == 1 } {
	if {$RecorderGlobalColumnForces == "ON"} {
		cd	$StoreDir
		file mkdir GlobalColumnForces
		cd $baseDir
		source C6_DefineGlobalColumnForceRecorders3DModel.tcl	
	}
}

# Node Displacements Recorder
# the node is in the Panel Zone Rigid Diaphgram
if {  [info exists RecorderNodeDisplacements] == 1 } {
	if {$RecorderNodeDisplacements == "ON"} {
		cd	$StoreDir
		file mkdir NodeDisplacements
		cd $baseDir
		# source C7_DefineNodeDisplacementRecorders3DModel.tcl	
		source C7_DefineNodeDisplacementRecorders3DModel.tcl	
	}
}

# Node Accelerations Recorder
# the node is in the Panel Zone Rigid Diaphgram
if {  [info exists RecorderNodeAccelerations] == 1 } {
	if {$RecorderNodeAccelerations == "ON"} {
		cd	$StoreDir
		file mkdir NodeAccelerations
		cd $baseDir
		# source C8_DefineNodeAccelerationsRecorders3DModel.tcl	
		source C8_DefineNodeAccelerationsRecorders3DModel.tcl	
	}
}

# Storey Drifts Recorder
if {  [info exists RecorderStoreyDrifts] == 1 } {
	if {$RecorderStoreyDrifts == "ON"} {
		cd	$StoreDir
		file mkdir StoreyDrifts
		cd $baseDir
		# source C9_DefineStoreyDriftRecorders3DModel.tcl
		source C9_DefineStoreyDriftRecorders3DModel.tcl
	}
}

cd $baseDir
puts $chanLog "# All Recorders Defined";
puts "All Recorders Defined"

# file mkdir BaseReactions
# file mkdir BeamHingeForce
# file mkdir BeamHingeDeformations
# file mkdir ColumnHingeForce
# file mkdir ColumnHingeDeformations
# file mkdir PanelZoneHingeForce
# file mkdir PanelZoneHingeDeformations
# file mkdir GlobalBeamForces
# file mkdir GlobalColumnForces
# file mkdir NodeDisplacements
# # the node is in the Panel Zone Rigid Diaphgram
# file mkdir NodeAccelerations
# # the node is in the Panel Zone Rigid Diaphgram
# file mkdir StoreyDrifts


# cd $baseDir
# source C1_DefineBaseReactionRecorders3DModel.tcl
# cd $baseDir
# source C2_DefineBeamHingeRecorders3DModel.tcl
# cd $baseDir
# source C3_DefineColumnHingeRecorders3DModel.tcl
# cd $baseDir
# source C4_DefinePanelZoneHingeRecorders3DModel.tcl
# cd $baseDir
# source C5_DefineGlobalBeamForceRecorders3DModel.tcl
# cd $baseDir
# source C6_DefineGlobalColumnForceRecorders3DModel.tcl
# cd $baseDir
# source C7_DefineNodeDisplacementRecorders3DModel.tcl
# cd $baseDir
# source C8_DefineNodeAccelerationsRecorders3DModel.tcl
# cd $baseDir
# source C9_DefineStoreyDriftRecorders3DModel.tcl