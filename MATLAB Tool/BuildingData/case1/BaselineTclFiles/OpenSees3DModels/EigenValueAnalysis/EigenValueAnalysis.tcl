
####################################################################################################
#                                                                                                  #
#                                    Eigenvalue Analysis                                           #
#                                                                                                  #
####################################################################################################

	set pi [expr 2.0*asin(1.0)];						# Definition of pi
	set nEigenI 1;										# mode i = 1
	set nEigenJ 2;										# mode j = 2
    set nEigenK 3;										# mode i = 3
    set nEigenL 4;										# mode j = 4

	set lambdaN [eigen $nEigenL];				# eigenvalue analysis for nEigenL modes
	puts $lambdaN

	# set eig1 [nodeEigenvector 1000 4 3];
	# set eig2 [nodeEigenvector 2000 4 3];
	# set eig3 [nodeEigenvector 3000 4 3];
	# puts "eigen vector"
	# puts $eig1
	# puts $eig2
	# puts $eig3
	
	# set lambdaI [lindex $lambdaN 0]; 		# eigenvalue mode i
    # set lambdaJ [lindex $lambdaN 2]; 	# eigenvalue mode j
    # set omegaI [expr pow($lambdaI,0.5)];
    # set omegaJ [expr pow($lambdaJ,0.5)];

	# set TimePeriodI [expr 2*$pi/$omegaI];
	# set TimePeriodJ [expr 2*$pi/$omegaJ];

	# set Tlist $TimePeriodI;
	# lappend Tlist $TimePeriodJ;

	foreach lambda $lambdaN {
		# lappend omegalist [expr {sqrt($lambda)}]; # Obtaining angular frequencies
		lappend Tlist [expr {2*$pi/sqrt($lambda)}]; # Obtaining modal periods
	}

	# Saving periods
	# Defining mode-shape recorders
	set recorderdir Analysis_Results/Modes;   # Recorder folder
	file mkdir $recorderdir;   # Creating recorder folder if it doesn't exist
	set period_file [open $recorderdir/periods.out w];
	foreach T $Tlist {
		puts $period_file "$T";
	}
	close $period_file

	puts "eigen value analysis"
	
	