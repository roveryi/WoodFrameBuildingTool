# Defining nodes
source DefineNodes3DModel.tcl

# Defining rigid floor diaphragm constraints
source DefineRigidFloorDiaphragm3DModel.tcl

# Defining node fixities
source DefineFixities3DModel.tcl

# Defining wood panel material models
source DefineWoodPanelMaterials3DModel.tcl

# Defining wood panel elements
source DefineWoodPanels3DModel.tcl

# Defining leaning column
source DefineLeaningColumn3DModel.tcl

# Defining leaning column flexural springs
source DefineLeaningColumnFlexuralSprings3DModel.tcl

# Defining Moment Frames

# Defining masses
source DefineMasses3DModel.tcl

# Define gravity loads
source DefineGravityLoads3DModel.tcl

# Perform gravity analysis
source PerformGravityAnalysis.tcl

# Defining all recorders
source DefineAllRecorders3DModel.tcl

