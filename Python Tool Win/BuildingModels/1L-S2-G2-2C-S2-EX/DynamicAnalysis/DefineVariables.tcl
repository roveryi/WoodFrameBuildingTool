##############################################################################################################################
# DefineVariables                                                                                                            #
#	This file will be used to define all variables that will be used in the analysis                                         #
#                                                                                                                            #
# Created by: Henry Burton, Stanford University, 2010                                                                        #
# Units: kips, inches, seconds                                                                                               #
##############################################################################################################################
 


##############################################################################################################################
#                                                Miscellaneous                                                               #
##############################################################################################################################

# Define Geometric Transformations
	set PDeltaTransf 1;
	set LinearTransf 2;
	
# set up geometric transformations of element
	geomTransf PDelta $PDeltaTransf 0 0 -1; 							# PDelta transformation



# UDamping ratio used for Rayleigh Damping
	set dampRat		0.050;		# Damping Ratio
	set dampRatF	1.0;		# Factor on the damping ratio.

# Define the periods to use for the Rayleigh damping calculations
	set periodForRayleighDamping_1 0.21;	# Mode 1 period - NEEDS to be UPDATED
	set periodForRayleighDamping_2 0.17;	# Mode 3 period - NEEDS to be UPDATED
	
# Define numbers to use for large and small stiffnesses
	set LargeNumber 1e9
	set SmallNumber 1e-12

	
# Define very stiff uniaxial material
	set StiffMat 1200
	uniaxialMaterial Elastic $StiffMat $LargeNumber;		# define truss material
	
# Define very stiff uniaxial material	
	set SoftMat 1300	
	uniaxialMaterial Elastic $SoftMat $SmallNumber;		# define truss material	
	
puts "Variables Defined"

