wipe all;

cd $baseDir

if {  [info exists PushDirection] == 1 } {
	if {$PushDirection == "X"} {
		set LogFileName "L3_PushoverXDirAnalysisLog.out";		
	}
	if {$PushDirection == "Z"} {
		set LogFileName "L4_PushoverZDirAnalysisLog.out";		
	}
}

if {[catch {set chanLog [open $LogFileName w+]} err_msg]} {
	puts "Failed to open the file for editing: $err_msg"
	return
}

# Source display procedures
if {$illustrateModel == 1} {
	source A_DisplayModel3D.tcl
	source A_DisplayPlane.tcl}

# Defining model builder
RunLog "model BasicBuilder -ndm 3 -ndf 6"
puts $chanLog "# Defining model builder";

# Defining seismic parameters
puts $chanLog "# Defining seismic parameters";
source B0b_DefineSeismicParameters.tcl

# Defining geometry and model variables
puts $chanLog "# Defining geometry and model variables";
source B0_DefineVariables.tcl

# Choosing model type
# source B0z_SourceModel.tcl
source PoModel.tcl

# Defining all recorders
puts $chanLog "# Defining all recorders";
source C0_DefineAllRecorders3DModel.tcl

# Perform gravity analysis
source E1_PerformGravitySolver.tcl

# display deformed shape:
set ViewScale 10;
DisplayModel3D DeformedShape $ViewScale ;
    
# Define pushover loading
if {  [info exists PushDirection] == 1 } {
	if {$PushDirection == "X"} {
		source B14a_DefinePushoverXLoading3DModel.tcl		
	}
	if {$PushDirection == "Z"} {
		source B14b_DefinePushoverZLoading3DModel.tcl		
	}
}

close $chanLog
puts "Pushover Analysis Model has been Built"
