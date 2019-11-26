##############################################################################################################################
# DefineUnitsAndConstants                                                                                                    #
#	This file will be used to define units and constants                                                                     #
#                                                                                                                            #
# Created by: Henry Burton, Stanford University, 2010                                                                        #
#                                                                                                                            #
# Units: kips, inches, seconds                                                                                               #
##############################################################################################################################
 

# Define units - With base units are kips, inches, and seconds
	set inch 1.0
	set kips 1.0
	set ft 12.0
	set lbs [expr 1/1000.0]
	#puts "Check lbs is $lbs "
	#puts "Check ft is $ft "
	set psf [expr ($lbs) * (1/$ft) * (1/$ft)]
	set pcf [expr ($lbs) * (1/$ft) * (1/$ft)* (1/$ft)]
	#puts "Check psf is $psf"
	set ksi 1.0
	set psi [expr 1/1000.0]
	set sec 1.0

# Define constants
	set pi 3.14159
	set hugeNumber 1000000000.0
	set g [expr 32.174 * $ft/($sec*$sec)]
	set Negligible 1e-9;					# a very smnumber to avoid problems with zero

puts "Units and Constants Defined"