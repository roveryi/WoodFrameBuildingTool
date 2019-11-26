##############################################################################################################################
# PerformGravityAnalysis                                                                                                     #
#	This file will apply a previously defined gravity load to the frame                                                      #
#	This file should be executed before running the EQ or pushover                                                           #
#                                                                                                                            #
#                                                                                                                            #
##############################################################################################################################

# Gravity-analysis parameters -- load-controlled static analysis
set Tol 1.0e-8;			# convergence tolerance for test
constraints Transformation ;     		# how it handles boundary conditions
#constraints Penalty 1e8 1e8 ;           # how it handles boundary conditions
#constraints Lagrange ;     		# how it handles boundary conditions
numberer RCM;			# renumber dof's to minimize band-width (optimization), if you want to
#set UmfPackLvalueFact 40
#system UmfPack -lvalueFact $UmfPackLvalueFact
#system SparseSPD
system BandGeneral
test EnergyIncr $Tol 100; 		# determine if convergence has been achieved at the end of an iteration step
algorithm Newton;			# use Newton's solution algorithm: updates tangent stiffness at every iteration
set NstepGravity 100;  		# apply gravity in 10 steps
set DGravity [expr 1./$NstepGravity]; 	# first load increment;
integrator LoadControl $DGravity;	# determine the next time step for an analysis
analysis Static;			# define type of analysis static or transient
analyze $NstepGravity;		# apply gravity

# ------------------------------------------------- maintain constant gravity loads and reset time to zero
loadConst -time 0.0
set Tol 1.0e-2;			# reduce tolerance after gravity loads


puts "ANALYSIS: Gravity done"

