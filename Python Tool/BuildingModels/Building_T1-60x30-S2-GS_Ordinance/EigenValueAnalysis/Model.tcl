# Clear memory 
wipe all 

# Define model builder
model BasicBuilder -ndm 3 -ndf 6 

# Define variables 
source DefineVariables.tcl

# Define units and constants 
source DefineUnitsAndConstants.tcl

# Define functions and procedures 
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

# Define retrofit components
source DefineRetrofit3DModel.tcl

# Define masses 
source DefineMasses3DModel.tcl

# Define gravity loads 
source DefineGravityLoads3DModel.tcl

# Perform gravity analysis 
source PerformGravityAnalysis.tcl

# Perform eigen value analysis 
source EigenValueAnalysis.tcl

