wipe all; 


model BasicBuilder -ndm 3 -ndf 6; 


source DefineUnitsAndConstants.tcl 
source DefineVariables.tcl 
source DefineFunctionsAndProcedures.tcl 
# Define nodes 
source DefineNodes3DModel.tcl

# Define rigid floor diaphragm constraints 
source DefineRigidFloorDiaphragm3DModel.tcl

# Define nodes fixities
source DefineFixities3DModel.tcl

# Define wood panel material models 
source DefineWoodPanelMaterials3DModel.tcl

# Define wood panel elements 
source DefineWoodPanels3DModel.tcl

# Define leaning column 
source DefineLeaningColumn3DModel.tcl

# Define leaning column flexural springs
source DefineLeaningColumnFlexuralSprings3DModel.tcl

# Define x-direction retrofit 
source DefineXMomentFrames3DModel.tcl

# Define masses 
source DefineMasses3DModel.tcl

# Define gravity loads 
source DefineGravityLoads3DModel.tcl

# Perform gravity analysis 
source PerformGravityAnalysis.tcl

# Define damping model
source DefineDamping3DModel.tcl 

# Define ground motion scale factor 
set scalefactor [expr $g*100/100*$MCE_SF]; 

# Run time history 
source DefineBiDirectionalTimeHistory.tcl 

# Define all recorders
source DefineAllRecorders3DModel.tcl

