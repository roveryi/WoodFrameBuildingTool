# This file will be used to define all recorders


# Setting up folders
# set baseDir [pwd];
set baseDir [pwd];
cd	$baseDir/$dataDir/


file mkdir BaseReactions
#file mkdir WoodPanelShearForces
#file mkdir WoodPanelDeformations
#file mkdir NodeDisplacements
# file mkdir NodeAccelerations
file mkdir StoryDrifts
#file mkdir NodeDampingForces

cd $baseDir
source DefineBaseReactionRecorders3DModel.tcl
#cd $baseDir
#source DefineWoodPanelRecorders3DModel.tcl
#cd $baseDir
#source DefineNodeDisplacementRecorders3DModel.tcl
cd $baseDir
source DefineStoryDriftRecorders3DModel.tcl
cd $baseDir

