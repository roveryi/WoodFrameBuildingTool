##############################################################################################################################
# PerformGravityAnalysis									                            									 #
#	This file will apply a previously defined gravity load to the frame						     							 #
#	This file should be executed before running the EQ or pushover							     							 #
# 														            													     #
# Created by: Henry Burton, Stanford University, 2010									     								 #
#								     						             												     #
# Units: kips, inches, seconds                                                                                               #
##############################################################################################################################

# Gravity-analysis parameters -- load-controlled static analysis
# set Tol 1.0e-8;			# convergence tolerance for test
variable constraintsTypeGravity Plain;		# default;
if {  [info exists RigidDiaphragm] == 1} {
	if {$RigidDiaphragm=="ON"} {
		variable constraintsTypeGravity Transformation;	#  large model: try Transformation
	};	# if rigid diaphragm is on
};	# if rigid diaphragm exists
constraints $constraintsTypeGravity ;     		# how it handles boundary conditions
numberer RCM;			# renumber dof's to minimize band-width (optimization), if you want to
# set UmfPackLvalueFact 40
# system UmfPack -lvalueFact $UmfPackLvalueFact
# system SparseSPD
# system BandGeneral;
# system SparseSYM
system Mumps	
# test EnergyIncr $Tol 6 ; 		# determine if convergence has been achieved at the end of an iteration step
test NormDispIncr 1.0e-8 20 2; 
algorithm NewtonLineSearch 0.75
# algorithm Newton;			# use Newton's solution algorithm: updates tangent stiffness at every iteration
set NstepGravity 5;  		# apply gravity in 10 steps
set DGravity [expr 1./$NstepGravity]; 	# first load increment;
integrator LoadControl $DGravity;	# determine the next time step for an analysis
analysis Static;			# define type of analysis static or transient
analyze $NstepGravity;		# apply gravity
# analyze 10;		# apply gravity

# ------------------------------------------------- maintain constant gravity loads and reset time to zero
loadConst -time 0.0
# set Tol 1.0e-6;			# reduce tolerance after gravity loads
puts "Gravity Load Applied Successfully"