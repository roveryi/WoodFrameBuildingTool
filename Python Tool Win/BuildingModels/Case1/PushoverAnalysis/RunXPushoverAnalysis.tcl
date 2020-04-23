# Clear memory 
wipe all 

# Define model builder 
model BasicBuilder -ndm 3 -ndf 6 

# Define pushover analysis parameters
set	IDctrlNode	3000
set	IDctrlDOF	1
set	Dincr	0.00100
set	Dmax	26.40000

# Set up output directory 
set dataDir Static-Pushover-Output-Model3D-XPushoverDirection
file mkdir $dataDir
set baseDir [pwd]
# Define variables 
source DefineVariables.tcl

# Define units and constants 
source DefineUnitsAndConstants.tcl

# Define functions and procedures 
source DefineFunctionsAndProcedures.tcl

# Source display procedures 
source DisplayModel3D.tcl
source DisplayPlane.tcl

# Source buliding model 
source Model.tcl 

# Define pushover loading 
source DefinePushoverXLoading3DModel.tcl 

# Define model run time parameters 
set	startT	[clock seconds]

# Run pushvoer analysis 
source RunStaticPushover.tcl 

# Define model run time parameters 
set	endT	[clock seconds]
set	RunTime	[expr ($endT - $endT)]
puts "Run Time = $RunTime Seconds"

