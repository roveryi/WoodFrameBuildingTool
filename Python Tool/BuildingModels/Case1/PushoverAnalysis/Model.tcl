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

# Define all recorders
source DefineAllRecorders3DModel.tcl

