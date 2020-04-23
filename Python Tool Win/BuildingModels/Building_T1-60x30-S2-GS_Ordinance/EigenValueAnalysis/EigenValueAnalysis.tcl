# Thif file is used for performing eigen value analysis 

set	pi	[expr 2.0*asin(1.0)];
set	nEigen1	1;
set	nEigen2	2;
set	nEigen3	3;
set	nEigen4	4;
set	lambdaN	[eigen $nEigen4];
puts	$lambdaN
foreach lambda $lambdaN {
	lappend Tlist [expr {2*$pi/sqrt($lambda)}];
} 
# Saving periods
set recorderdir Analysis_Results/Modes;   # Recorder folder 
file mkdir $recorderdir;   # Creating recorder folder if it does not exist 
set period_file [open $recorderdir/periods.out w];
foreach T $Tlist {
	puts $period_file "$T";
} 
close $period_file

puts "eigen value analysis - periods done!" 

# Saving mode shapes
set mode_file [open $recorderdir/mode_shape.out w];
puts $mode_file "[nodeEigenvector 2000 1 1]	[nodeEigenvector 2000 2 1]	[nodeEigenvector 2000 3 1]	[nodeEigenvector 2000 4 1]	"
puts $mode_file "[nodeEigenvector 3000 1 1]	[nodeEigenvector 3000 2 1]	[nodeEigenvector 3000 3 1]	[nodeEigenvector 3000 4 1]	"
close $mode_file
puts "eigen value analysis - mode shape done!"