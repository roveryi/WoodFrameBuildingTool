
set num_modes 12; # Number of modes

# Defining mode-shape recorders
set recorderdir Analysis_Results/Modes; # Recorder folder
file mkdir $recorderdir; # Creating recorder folder if it doesn't exist
recorder Node -file $recorderdir/mode_shapes.out -dof 1 2 3 eigen; # Defining mode shape recorder for all modes


# Running eigen-analysis
set lambdalist [eigen -fullGenLapack $num_modes]; # Obtaining eigenvalues
# puts "$lambdalist"
foreach lambda $lambdalist {
	lappend omegalist [expr {sqrt($lambda)}]; # Obtaining angular frequencies
	lappend Tlist [expr {2*$pi/sqrt($lambda)}]; # Obtaining modal periods
}
# puts "$Tlist"
# puts "[lindex $Tlist 1]"; #[expr {$num_modes - 1}]]"
# puts "[lindex $Tlist 0]"
set T1 [lindex $Tlist 0]; # Fundamental modal period
set Tlowest [lindex $Tlist [expr {$num_modes - 1}]]; # Lowest modal period
set dt [expr $Tlowest/2.0/$pi];

# record; # Recording mode shapes into recorders

# Saving periods
set period_file [open $recorderdir/periods.out w];
foreach T $Tlist {
	puts $period_file "$T";
}
close $period_file

# Displaying information
puts "Fundamental mode period: [format "%.4f" $T1] s";
puts "Lowest modal period: [format "%.4e" $Tlowest]s";
puts "dT = [format "%.4e" $dt]s";
file delete $recorderdir/node_info.out;
print $recorderdir/node_info.out -node;