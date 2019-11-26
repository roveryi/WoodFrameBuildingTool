##############################################################################################################################
#   DefineUnitsAndConstants								 		               					   					         #
#	This file will be used to define units and constants				     											     #
# 														           															 #
#   Created by: Xiaolei Xiong, Tongji University, 2017																	     #
#								     						          													     #
#   Units: N, m, seconds                                                                                             #
##############################################################################################################################
 

# Define units - With base units are N, m, and second
	set inch 0.0254
	set kips 4448.22
	set ft [expr 12.0*$inch];
	set LunitTXT "inch";			# define basic-unit text for output
	set FunitTXT "kip";			# define basic-unit text for output
	set TunitTXT "sec";			# define basic-unit text for output
	set lbs [expr 1/1000.0*$kips]
	#puts "Check lbs is $lbs "
	#puts "Check ft is $ft "
	set psf [expr ($lbs) * (1/$ft) * (1/$ft)]
	set pcf [expr ($lbs) * (1/$ft) * (1/$ft)* (1/$ft)]
	#puts "Check psf is $psf"
	set ksi [expr 1000 * $kips * (1/$inch) * (1/$inch)]
	set psi [expr 1/1000.0]
	set sec 1.0
	set meter 1.0
	set kN [expr 1000 * 1.0]

# Define constants
	set pi 3.14159
	set hugeNumber 1000000000.0
	set g 9.8
	set Negligible 1e-9;					# a very smnumber to avoid problems with zero

puts "Units and Constants Defined"