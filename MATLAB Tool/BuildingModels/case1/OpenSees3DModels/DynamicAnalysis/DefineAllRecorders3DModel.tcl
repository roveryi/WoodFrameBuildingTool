# This file will be used to define all recorders


# Setting up folders
# set baseDir [pwd];
cd	$pathToResults/

if {$Pairing == 1} {
    set folderNumber $eqNumber
} else {
    set folderNumber [expr $eqNumber + $numberOfGroundMotionXIDs]
}
file mkdir EQ_$folderNumber
cd	$pathToResults/EQ_$folderNumber
# file mkdir Scale_$scale
# cd	$baseDir/$dataDir/EQ_$folderNumber/Scale_$scale

#file mkdir BaseReactions
#file mkdir WoodPanelShearForces
#file mkdir WoodPanelDeformations
#file mkdir NodeDisplacements
file mkdir NodeAccelerations
file mkdir StoryDrifts
#file mkdir NodeDampingForces

#cd $baseDir
#source DefineBaseReactionRecorders3DModel.tcl
#cd $baseDir
#source DefineWoodPanelRecorders3DModel.tcl
#cd $baseDir
#source DefineNodeDisplacementRecorders3DModel.tcl
cd $pathToModel
source DefineStoryDriftRecorders3DModel.tcl
cd $pathToModel
source DefineNodeAccelerationRecorders3DModel.tcl
cd $pathToModel
#source DefineNodeDampingForceRecorders3DModel.tcl
#cd $baseDir

