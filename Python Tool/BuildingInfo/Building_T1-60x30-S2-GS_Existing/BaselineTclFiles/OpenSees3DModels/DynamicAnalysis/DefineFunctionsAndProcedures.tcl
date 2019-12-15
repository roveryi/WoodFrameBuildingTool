#####################################################################################################

# #

# procUniaxialPinching.tcl #

# procedure for activating the pinching material given its parameters in the form of list #

# created NM (nmitra@u.washington.edu) dated : Feb 2002 #

#####################################################################################################

proc procUniaxialPinching { matTag ePf1 ePd1 ePf2 ePd2 ePf3 ePd3 ePf4 ePd4 rDispP rForceP uForceP gD1 gDlim gK1 gKlim damage WallLength WallHeight} {

# add material - command: uniaxialMaterial ...... paramaters as shown

#uniaxialMaterial Pinching4 tag

#### stress1P strain1P stress2P strain2P stress3P strain3P stress4P strain4P

#### stress1N strain1N stress2N strain2N stress3N strain3N stress4N strain4N

#### rDispP rForceP uForceP rDispN rForceN uForceN

#### gammaK1 gammaK2 gammaK3 gammaK4 gammaKLimit

#### gammaD1 gammaD2 gammaD3 gammaD4 gammaDLimit

#### gammaF1 gammaF2 gammaF3 gammaF4 gammaFLimit gammaE $damage

    
	set Length [expr $WallLength/12.];
	set Drift [expr $WallHeight/100.];
	set FFactor $Length;
	set DFactor $Drift;
	
	set ePf1 [expr $ePf1*$FFactor/1000];    #Backbone forces [kip]
	set ePf2 [expr $ePf2*$FFactor/1000]; 
	set ePf3 [expr $ePf3*$FFactor/1000]; 
	set ePf4 [expr $ePf4*$FFactor/1000]; 
	
	set ePd1 [expr $ePd1*$DFactor];         # Backbone displacements [in]
	set ePd2 [expr $ePd2*$DFactor]; 
	set ePd3 [expr $ePd3*$DFactor]; 
	set ePd4 [expr $ePd4*$DFactor];

	set gK 0
	set gD 0
	set gF 0
	set gFLim 0
	set gE 0
	set dmgType "energy" 
uniaxialMaterial Pinching4 $matTag $ePf1 $ePd1 $ePf2 $ePd2 $ePf3 $ePd3 $ePf4 $ePd4 [expr -$ePf1] [expr -$ePd1] [expr -$ePf2] [expr -$ePd2] [expr -$ePf3] [expr -$ePd3] [expr -$ePf4] [expr -$ePd4] $rDispP $rForceP $uForceP $rDispP $rForceP $uForceP $gK1 $gK $gK $gK $gKlim $gD1 $gD $gD $gD $gDlim  $gF $gF $gF $gF $gFLim $gE $damage
}

# Procedure for defining multi-point constraint
###########################################################################################################
# Formal arguments
#       eleID   - unique element ID for this zero length rotational spring
#       nodeR   - node ID which will be retained by the multi-point constraint
#       nodeC   - node ID which will be constrained by the multi-point constraint
#
##########################################################################################################

proc CreatePinJointRXRYRZ {eleID nodeR nodeC StiffMat SoftMat} {

	# Create the material and zero length element (spring)	
	element zeroLength $eleID $nodeR $nodeC -mat $StiffMat $StiffMat $StiffMat $SoftMat $SoftMat $SoftMat -dir 1 2 3 4 5 6

	# Constrain the translational DOF with a multi-point constraint	
	#   		retained constrained DOF_1 DOF_2 DOF_2
	#equalDOF    $nodeR     $nodeC     1     2     3
}

proc CreatePinJointRXRZ {eleID nodeR nodeC StiffMat SoftMat} {

	# Create the material and zero length element (spring)	
	element zeroLength $eleID $nodeR $nodeC -mat $StiffMat $StiffMat $StiffMat $SoftMat $StiffMat $SoftMat -dir 1 2 3 4 5 6

}

##############################################################################################
# This routine creates a uniaxial material spring with deterioration
# 
# Spring follows: Bilinear Response based on Modified Ibarra Krawinkler Deterioration Model 
#
# Written by: Dimitrios G. Lignos, Ph.D.
#
# Variables
# 	$eleID = 	Element Identification (integer)
# 	$nodeR = 	Retained/master node
# 	$nodeC = 	Constrained/slave node
# 	$K = 		Initial stiffness after the modification for n (see Ibarra and Krawinkler, 2005)
# 	$asPos = 	Strain hardening ratio after n modification (see Ibarra and Krawinkler, 2005)
# 	$asNeg = 	Strain hardening ratio after n modification (see Ibarra and Krawinkler, 2005)
# 	$MyPos = 	Positive yield moment (with sign)
# 	$MyNeg = 	Negative yield moment (with sign)
# 	$LS = 		Basic strength deterioration parameter (see Lignos and Krawinkler, 2009)
# 	$LK = 		Unloading stiffness deterioration parameter (see Lignos and Krawinkler, 2009)
# 	$LA = 		Accelerated reloading stiffness deterioration parameter (see Lignos and Krawinkler, 2009)
# 	$LD = 		Post-capping strength deterioration parameter (see Lignos and Krawinkler, 2009)
# 	$cS = 		Exponent for basic strength deterioration
# 	$cK = 		Exponent for unloading stiffness deterioration
# 	$cA = 		Exponent for accelerated reloading stiffness deterioration
# 	$cD = 		Exponent for post-capping strength deterioration
# 	$th_pP = 	Plastic rotation capacity for positive loading direction
# 	$th_pN = 	Plastic rotation capacity for negative loading direction
# 	$th_pcP = 	Post-capping rotation capacity for positive loading direction
# 	$th_pcN = 	Post-capping rotation capacity for negative loading direction
# 	$ResP = 	Residual strength ratio for positive loading direction
# 	$ResN = 	Residual strength ratio for negative loading direction
# 	$th_uP = 	Ultimate rotation capacity for positive loading direction
# 	$th_uN = 	Ultimate rotation capacity for negative loading direction
# 	$DP = 		Rate of cyclic deterioration for positive loading direction
# 	$DN = 		Rate of cyclic deterioration for negative loading direction
#
# References:
#		Ibarra, L. F., and Krawinkler, H. (2005). “Global collapse of frame structures under seismic excitations,” Technical Report 152, The John A. Blume Earthquake Engineering Research Center, Department of Civil Engineering, Stanford University, Stanford, CA.
# 		Ibarra, L. F., Medina, R. A., and Krawinkler, H. (2005). “Hysteretic models that incorporate strength and stiffness deterioration,” International Journal for Earthquake Engineering and Structural Dynamics, Vol. 34, No.12, pp. 1489-1511.
# 		Lignos, D. G., and Krawinkler, H. (2010). “Deterioration Modeling of Steel Beams and Columns in Support to Collapse Prediction of Steel Moment Frames”, ASCE, Journal of Structural Engineering (under review).
# 		Lignos, D. G., and Krawinkler, H. (2009). “Sidesway Collapse of Deteriorating Structural Systems under Seismic Excitations,” Technical Report 172, The John A. Blume Earthquake Engineering Research Center, Department of Civil Engineering, Stanford University, Stanford, CA.
#
############################################################################################
#
proc rotSpring3DRotZModIKModel {eleID nodeR nodeC K asPos asNeg MyPos MyNeg LS LK LA LD cS cK cA cD th_pP th_pN th_pcP th_pcN ResP ResN th_uP th_uN DP DN} {
#
# Create the zero length element
      uniaxialMaterial Bilin  $eleID  $K  $asPos $asNeg $MyPos $MyNeg $LS $LK $LA $LD $cS $cK $cA $cD $th_pP $th_pN $th_pcP $th_pcN $ResP $ResN $th_uP $th_uN $DP $DN;
      element zeroLength $eleID $nodeR $nodeC -mat 199999 199999 199999 99999 99999 $eleID -dir 1 2 3 4 5 6

# Constrain the translational DOF with a multi-point constraint
#            retained constrained DOF_1 DOF_2 ... DOF_n
# equalDOF    $nodeR     $nodeC     1    2         3 
}


proc rotSpring3DRotXModIKModel {eleID nodeR nodeC K asPos asNeg MyPos MyNeg LS LK LA LD cS cK cA cD th_pP th_pN th_pcP th_pcN ResP ResN th_uP th_uN DP DN} {
#
# Create the zero length element
      uniaxialMaterial Bilin  $eleID  $K  $asPos $asNeg $MyPos $MyNeg $LS $LK $LA $LD $cS $cK $cA $cD $th_pP $th_pN $th_pcP $th_pcN $ResP $ResN $th_uP $th_uN $DP $DN;
      element zeroLength $eleID $nodeR $nodeC -mat 199999 199999 199999 $eleID 99999 99999 -dir 1 2 3 4 5 6

# Constrain the translational DOF with a multi-point constraint
#           retained  constrained DOF_1 DOF_2 ... DOF_n
# equalDOF    $nodeR     $nodeC     1     2        3 
}

puts "FUNCTIONS and PROCEDURES: Sourced"

