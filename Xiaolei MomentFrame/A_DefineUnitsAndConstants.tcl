##############################################################################################################################
#   DefineUnitsAndConstants                                                                                                  #
#   This file will be used to define units and constants                                                                     #
#                                                                                                                            #
#   Created by: Henry Burton, Stanford University, 2010                                                                      #
#                                                                                                                            #
#   Units: kips, inches, seconds                                                                                             #
##############################################################################################################################
 

# Define units - With base units are kips, inches, and seconds
    set inch 1.0
    set kips 1.0
	set sec 1.0
	
    set ft [expr 12.0 * $inch];
    set LunitTXT "inch";            # define basic-unit text for output
    set FunitTXT "kip";         # define basic-unit text for output
    set TunitTXT "sec";         # define basic-unit text for output
    set lbs [expr 1/1000.0*$kips];
    #puts "Check lbs is $lbs "
    #puts "Check ft is $ft "
    set psf [expr ($lbs) * (1/$ft) * (1/$ft)];
    set pcf [expr ($lbs) * (1/$ft) * (1/$ft)* (1/$ft)];
    #puts "Check psf is $psf"
    set ksi [expr 1.0 * $kips * (1/$inch) * (1/$inch)];
    set psi [expr 1/1000.0 * $kips * (1/$inch) * (1/$inch)];
    
    set meter [expr 39.37 * $inch];
    set kN [expr 0.2248 * $kips];

# Define constants
    set pi 3.1415926
    set hugeNumber 10000000000000.0
    set g [expr 32.174 * $ft/($sec*$sec)];  # 386.09 in/s2
    set Negligible 1e-9;                    # a very smnumber to avoid problems with zero

puts "Units and Constants Defined"