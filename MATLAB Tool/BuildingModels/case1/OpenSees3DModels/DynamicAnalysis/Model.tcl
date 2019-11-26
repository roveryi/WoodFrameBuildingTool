wipe all;

model BasicBuilder -ndm 3 -ndf 6;

source DefineUnitsAndConstants.tcl
source DefineVariables.tcl
source DefineFunctionsAndProcedures.tcl
# source Define_GM_Record_Info.tcl

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

# Define gravity loads
source DefineGravityLoads3DModel.tcl

# Defining recorders
# source DefineAllRecorders3DModel.tcl

# Perform gravity analysis
source PerformGravityAnalysis.tcl

# Defining masses
source DefineMasses3DModel.tcl

# Defining damping
source DefineDamping3DModel.tcl

# Define ground motion scale factor
set scalefactor [expr $g*100/100*$MCE_SF];

# Run Time History
source DefineBiDirectionalTimeHistory.tcl

puts "Analysis Completed"
