##############################################################################################################################
# DefineFunctionsAndProcedures									                                                             #
#	This file will be used to define functions and procedures that are used in the rest of the program		                 #
# 														                                                                     #
# Created by: Henry Burton, Stanford University, 2010								                                	     #
# Edited by: Xiaolei Xiong, Tongji University, 2017		  	                                                                 #
# Units: kips, inches, seconds                                                                                               #
##############################################################################################################################
 
##############################################################################################################################
#          	  									 Run and Log Commands									    				 #
##############################################################################################################################

proc RunLog { Commands } {
	global chanLog;
	# puts $Commands;
	eval $Commands;
	puts $chanLog $Commands;
}

##############################################################################################################################
#          	  					 Run and Log in file and on screen Commands								    				 #
##############################################################################################################################

proc RunAndLog {channelLog Commands {coderun 0} } {
	# global chanLog;
	# puts $Commands;
	# defaultly not excute
	if {$coderun != 0} {
		eval $Commands;
	}
	puts $Commands;
	puts $channelLog $Commands;
}	

##############################################################################################################################
#          	  									 Check running time	and output							    				 #
##############################################################################################################################

proc RunTimeCheck {channelLog StartTime } {
	
set NowTime [clock seconds];
set RunTime [expr ($NowTime - $StartTime)/3600];
set RunTimeMin [expr ($NowTime - $StartTime)/60];
set RunTimeSec [expr ($NowTime - $StartTime)];
RunAndLog $channelLog "\n================================================================================\nFrom start till now, Runtime: [format {%0.1f} $RunTime] Hours ($RunTimeMin Mins) ($RunTimeSec Secs).\n================================================================================\n"
}
	
##############################################################################################################################
#          			Define Peak Oriented Ibarra Material for concrete Beam and Column Plastic Hinges	        		     #
##############################################################################################################################

proc CreateIbarraMaterial { matTag EIeff myPos myNeg mcOverMy thetaCapPos thetaCapNeg thetaPC lambda c resStrRatio stiffFactor1 stiffFactor2 eleLength } {

	# Do needed calculations
	global chanLog;
		set elstk 	[expr $stiffFactor1 * ((6 * $EIeff) / $eleLength)];	# Initial elastic stiffness
		set alphaHardUnscaled 	[expr ((($myPos*$mcOverMy)-$myPos)/($thetaCapPos)) / $elstk];
		set alphaHardScaled	[expr $alphaHardUnscaled * ((-$stiffFactor2 * $alphaHardUnscaled ) / ($alphaHardUnscaled * ($alphaHardUnscaled - $stiffFactor2)))];	# This altered the stiffness to account for the elastic element stiffness - see hand notes on 1-6-05
		set alphaCapUnscaled	[expr ((-$myPos*$mcOverMy)/($thetaPC)) / $elstk];
		set alphaCapScaled	[expr $alphaCapUnscaled * ((-$stiffFactor2 * $alphaCapUnscaled) / ($alphaCapUnscaled * ($alphaCapUnscaled - $stiffFactor2)))];	# This altered the stiffness to account for the elastic element stiffness - see hand notes on 1-6-05
		set lambdaA 0; 							# No accelerated stiffness deterioration
		set lambdaS [expr $lambda * $stiffFactor1];		# Strength
		set lambdaK 0;							# No unloading stiffness deterioration because there is a bug in this portion of the model
		#set lambdaK [expr 2.0 * $lambda * $stiffFactor1];	# Unloading stiffness (2.0 is per Ibarra chapter 3)
		set lambdaD [expr $lambda * $stiffFactor1];		# Capping strength
		set dPlus 			    1;															# Unloading stiffness deterioration
		set dNeg 			1;														# Capping strength deterioration
		set thetaUlt 10; # Value does not matter. Just needs to be large.
		# set thetaCapNeg [expr -1.0*$thetaCapNeg]
		# puts "$alphaHardUnscaled"
		# puts "$alphaHardScaled"

	# Create the material model
		RunLog "uniaxialMaterial Clough  $matTag $elstk $myPos $myNeg $alphaHardScaled $resStrRatio $alphaCapScaled	$thetaCapPos $thetaCapNeg $lambdaS $lambdaK $lambdaA $lambdaD  $c $c $c $c"
}

##############################################################################################################################
#          				Define Ibarra Material for concrete Column Shear			     									 #
##############################################################################################################################


proc CreateIbarraShearMaterial { matTag Ke FyPos FyNeg FcOverFy deltaCapPos deltaCapNeg deltaPC resStrRatio } {

	# Do needed calculations
	global chanLog;
		set elstk 	[expr $Ke];												# Initial elastic stiffness
		set alphaHard [expr ((($FyPos*$FcOverFy)-$FyPos)/($deltaCapPos)) / $Ke];		# Strain Hardening Ratio
		set alphaCap [expr ((-$FyPos*$FcOverFy)/($deltaPC)) / $Ke]; 					#Post-Capping Strain Hardening Ratio
		set lambdaA 0; 																# Accelerated stiffness deterioration
		set lambdaS 0;																# Strength Deterioration
		set lambdaK 0;																	# Unloading stiffness deterioration
		set lambdaD 0;																# Capping strength
		set c 1.0;
		set strainCapPos [expr $deltaCapPos];				# pre-capping positive strain				
		set strainCapNeg [expr $deltaCapNeg];				# pre-capping negative strain
		set strainPC [expr $deltaPC];				# pre-capping negative strain
		set dPlus	1;															# Unloading stiffness deterioration
		set dNeg	1;														# Capping strength deterioration
	

	# Create the material model
		RunLog "uniaxialMaterial Clough  $matTag $elstk $FyPos $FyNeg $alphaHard $resStrRatio $alphaCap $strainCapPos $strainCapNeg $lambdaS $lambdaK $lambdaA $lambdaD  $c $c $c $c"
}

##############################################################################################################################
#          	   Define 3D Rotational Spring with Ibarra Material for Beam Plastic Hinges					    				 #
##############################################################################################################################


proc rotXBeamSpring3DModIKModel {eleID nodeR nodeC matID stiffmatID} {
#
# Create the zero length element
    global chanLog;
 
    RunLog "element zeroLength $eleID $nodeR $nodeC -mat $stiffmatID $stiffmatID $stiffmatID $stiffmatID $stiffmatID $matID -dir 1 2 3 4 5 6 -orient 1 0 0 0 1 0"; 
}

proc rotZBeamSpring3DModIKModel {eleID nodeR nodeC matID stiffmatID} {
#
# Create the zero length element
    global chanLog;  
 
    RunLog "element zeroLength $eleID $nodeR $nodeC -mat $stiffmatID $stiffmatID $stiffmatID $stiffmatID $stiffmatID $matID -dir 1 2 3 4 5 6 -orient 0 0 -1 0 1 0"; 
}



##############################################################################################################################
#          	   				Define 3D Spring with Inelastic Flexural and Shear Materials					   				 #
##############################################################################################################################


proc rotColSpring3DModIKModel {eleID nodeR nodeC axialmatID shearLocalYmatID shearLocalZmatID flexLocalXmatID flexLocalYmatID flexLocalZmatID} {
#
# Create the zero length element
    global chanLog;  
 
    # RunLog "element zeroLength $eleID $nodeR $nodeC -mat $axialmatID $shearLocalYmatID $shearLocalZmatID $flexLocalXmatID $flexLocalYmatID  $flexLocalZmatID -dir 1 2 3 4 5 6 -orient 0 1 0 1 0 0";     
    RunLog "element zeroLength $eleID $nodeR $nodeC -mat $axialmatID $shearLocalYmatID $shearLocalZmatID $flexLocalXmatID $flexLocalYmatID  $flexLocalZmatID -dir 1 2 3 4 5 6";     
}

# puts "All Functions and Procedures have Been Sourced"



#===========================================================================================================================#
#												Steel members Part															#
#===========================================================================================================================#


##############################################################################################################################
#      Define Modified Ibarra Krawinkler Deterioration Bilin Material for steel Beam and Column Plastic Hinges	             #
##############################################################################################################################
#   Variables
# 	$matTag = 	Material Identification (integer)
#   $n=			stiffFactor for as modification, for use with concentrated plastic hinge elements
# 	$K0 = 		Initial stiffness before the modification for n (see Ibarra and Krawinkler, 2005)
# 	$asPos = 	Strain hardening ratio before n modification (see Ibarra and Krawinkler, 2005)
# 	$asNeg = 	Strain hardening ratio before n modification (see Ibarra and Krawinkler, 2005)
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
#		Ibarra, L. F., and Krawinkler, H. (2005). global collapse of frame structures under seismic excitations,?Technical Report 152, The John A. Blume Earthquake Engineering Research Center, Department of Civil Engineering, Stanford University, Stanford, CA.
# 		Ibarra, L. F., Medina, R. A., and Krawinkler, H. (2005). hysteretic models that incorporate strength and stiffness deterioration,?International Journal for Earthquake Engineering and Structural Dynamics, Vol. 34, No.12, pp. 1489-1511.
# 		Lignos, D. G., and Krawinkler, H. (2010). deterioration Modeling of Steel Beams and Columns in Support to Collapse Prediction of Steel Moment Frames? ASCE, Journal of Structural Engineering (under review).
# 		Lignos, D. G., and Krawinkler, H. (2009). sidesway Collapse of Deteriorating Structural Systems under Seismic Excitations,?Technical Report 172, The John A. Blume Earthquake Engineering Research Center, Department of Civil Engineering, Stanford University, Stanford, CA.

proc CreateBilinMaterial {matTag K0 n as My Lambda th_p th_pc Res th_u} {
		
		global chanLog;
	# Do needed calculations
		set K 	[expr $n * $K0];	# Initial elastic stiffness after modification
		set asM [expr $as*($n+1.0)/$n];
		set asPosScaled [expr ($asM)/(1.0+$n*(1.0-$asM))];			# modified strain hardening ratio (Ibarra & Krawinkler 2005, note: Eqn B.5 is incorrect)
		set asNegScaled $asPosScaled;
		set LS [expr $Lambda * $n];
		# set LK [expr $Lambda * $n];
		set LK 0.0;
		# set LA [expr $Lambda * $n];
		set LA 0.0;
		set LD [expr $Lambda * $n];
		set th_uS [expr $th_u * $n];
	
			
	# Create the material model
		# uniaxialMaterial Bilin $matTag $K0 $as_Plus $as_Neg $My_Plus $My_Neg $Lamda_S $Lamda_C $Lamda_A $Lamda_K $c_S $c_C $c_A $c_K $theta_p_Plus $theta_p_Neg $theta_pc_Plus $theta_pc_Neg $Res_Pos $Res_Neg $theta_u_Plus $theta_u_Neg $D_Plus $D_Neg <$nFactor>
		RunLog "uniaxialMaterial Bilin  $matTag  $K  $asPosScaled $asNegScaled $My [expr -1.0*$My] $LS $LK $LA $LD 1.0 1.0 1.0 1.0 $th_p $th_p $th_pc $th_pc $Res $Res $th_uS $th_uS 1.0 1.0";
		# uniaxialMaterial Bilin  $matTag  $K0  $as $as $My [expr -1.0*$My] $Lamda_S $Lamda_C $Lamda_A $Lamda_K 1.0 1.0 1.0 1.0 $th_p $th_p $th_pc $th_pc $Res $Res $th_u $th_u 1.0 1.0 $n;
}

##############################################################################################################################
#									Define Adjustment procedure for bilin fiber materials						   	         #
##############################################################################################################################

proc CreateAdjustBilinFiberMaterial {matTag n E ColumnFy A_McMy A_MrR AA_K0 AA_ThetaP AA_ThetaPc F_K0 F_My F_ThetaP F_ThetaPc F_Lambda O_ThetaP O_ThetaPc O_Lambda} {

	# Do needed calculations
	global chanLog;
	set A_K0 [expr $F_K0*$AA_K0*$E];
	set A_My [expr $F_My*$ColumnFy];
	set A_ThetaY [expr $A_My/$A_K0];
	set A_Lambda [expr $F_Lambda*$O_Lambda];
	set A_ThetaP [expr $F_ThetaP*$AA_ThetaP*$O_ThetaP];
	set A_ThetaPc [expr $F_ThetaPc*$AA_ThetaPc*$O_ThetaPc];
	set A_as [expr $A_My*($A_McMy-1)/$A_K0/$A_ThetaP];
	set A_ThetaU [expr $A_ThetaY+$A_ThetaP+$A_ThetaPc];
	
	set	K0	$A_K0;
	set	My	$A_My;
	set	Lambda $A_Lambda;
	set	ThetaP $A_ThetaP;
	set	ThetaPc $A_ThetaPc;
	set	as $A_as;
	set	MrR $A_MrR;
	set	ThetaU $A_ThetaU;
	CreateBilinMaterial $matTag $K0 $n $as $My $Lambda $ThetaP $ThetaPc $MrR $ThetaU;
}

##############################################################################################################################
#					Define steel02 Material for steel Beam and Column Plastic Hinges Fiber Section				   	         #
##############################################################################################################################
proc CreateSteel02Material {matTag Fy E} {
	global chanLog;
	RunLog "uniaxialMaterial Steel02 $matTag $Fy $E 0.02 15 0.925 0.15";

}	
	
##############################################################################################################################
#          	   	Define 3D Spring with Fiber Sections as to Steel Wide Flange Section Columns								 #
##############################################################################################################################

proc rotWFColSpring3DModFiber {eleID nodeR nodeC FSecID ESecID stiffmatID flexmatID d bf tf tw nfdw nftw nfbf nftf StrongAxis} {
	
	# eleID - element ID number
	# FSecID - fiber section ID number
	# ESecID - element section ID number
	# stiffmatID - material ID number of the huge elastic
	# flexmatID - material ID number of the steel02
	# d  = nominal depth
	# tw = web thickness
	# bf = flange width
	# tf = flange thickness
	# nfdw = number of fibers along web depth 
	# nftw = number of fibers along web thickness
	# nfbf = number of fibers along flange width
	# nftf = number of fibers along flange thickness
	# StrongAxis - the strong axis of the section in local coordinates system, 'Y' indicates the web is set along local y axis,
	# 'Z' or else indicates the web is set along local z axis
	global chanLog;
	set dw [expr $d - 2 * $tf]
	if {$StrongAxis == "Y"} {
		set y1 [expr -$d/2]
		set y2 [expr -$dw/2]
		set y3 [expr  $dw/2]
		set y4 [expr  $d/2]
	
		set z1 [expr -$bf/2]
		set z2 [expr -$tw/2]
		set z3 [expr  $tw/2]
		set z4 [expr  $bf/2]
	} else {
		set z1 [expr -$d/2]
		set z2 [expr -$dw/2]
		set z3 [expr  $dw/2]
		set z4 [expr  $d/2]
	
		set y1 [expr -$bf/2]
		set y2 [expr -$tw/2]
		set y3 [expr  $tw/2]
		set y4 [expr  $bf/2]
		}
	
  
	RunLog "section Fiber  $FSecID  {
   		#                    	 nfIJ  nfJK    yI  zI    yJ  zJ    yK  zK    yL  zL
   		patch quad  $flexmatID  $nfbf $nftf   $y1 $z4   $y1 $z1   $y2 $z1   $y2 $z4
   		patch quad  $flexmatID  $nftw $nfdw   $y2 $z3   $y2 $z2   $y3 $z2   $y3 $z3
   		patch quad	$flexmatID  $nfbf $nftf   $y3 $z4   $y3 $z1   $y4 $z1   $y4 $z4
	}"
	
	RunLog "section Aggregator $ESecID $stiffmatID Vy $stiffmatID Vz $stiffmatID T -section $FSecID";
	
    RunLog "element zeroLengthSection $eleID $nodeR $nodeC $ESecID -orient 0 1 0 1 0 0";	     
}

##############################################################################################################################
#          	   	Define 3D Spring with Fiber Sections as to Steel Wide Flange Section Beams									 #
##############################################################################################################################

proc rotWFXBeamSpring3DModFiber {eleID nodeR nodeC FSecID ESecID stiffmatID flexmatID d bf tf tw nfdw nftw nfbf nftf} {
	
	# eleID - element ID number
	# FSecID - fiber section ID number
	# ESecID - element section ID number
	# stiffmatID - material ID number of the huge elastic
	# flexmatID - material ID number of the steel02
	# d  = nominal depth
	# tw = web thickness
	# bf = flange width
	# tf = flange thickness
	# nfdw = number of fibers along web depth 
	# nftw = number of fibers along web thickness
	# nfbf = number of fibers along flange width
	# nftf = number of fibers along flange thickness
	
	global chanLog;
	set dw [expr $d - 2 * $tf];
	set y1 [expr -$d/2];
	set y2 [expr -$dw/2];
	set y3 [expr  $dw/2];
	set y4 [expr  $d/2];
  
	set z1 [expr -$bf/2];
	set z2 [expr -$tw/2];
	set z3 [expr  $tw/2];
	set z4 [expr  $bf/2];
  
	RunLog "section Fiber  $FSecID  {
   		#                    	 nfIJ  nfJK    yI  zI    yJ  zJ    yK  zK    yL  zL
   		patch quad  $flexmatID  $nfbf $nftf   $y1 $z4   $y1 $z1   $y2 $z1   $y2 $z4
   		patch quad  $flexmatID  $nftw $nfdw   $y2 $z3   $y2 $z2   $y3 $z2   $y3 $z3
   		patch quad  $flexmatID  $nfbf $nftf   $y3 $z4   $y3 $z1   $y4 $z1   $y4 $z4
	}"
	
	RunLog "section Aggregator $ESecID $stiffmatID Vy $stiffmatID Vz $stiffmatID T -section $FSecID";
	
    RunLog "element zeroLengthSection $eleID $nodeR $nodeC $ESecID -orient 1 0 0 0 1 0";	
}

proc rotWFZBeamSpring3DModFiber {eleID nodeR nodeC FSecID ESecID stiffmatID flexmatID d bf tf tw nfdw nftw nfbf nftf} {
	
	# eleID - element ID number
	# FSecID - fiber section ID number
	# ESecID - element section ID number
	# stiffmatID - material ID number of the huge elastic
	# flexmatID - material ID number of the steel02
	# d  = nominal depth
	# tw = web thickness
	# bf = flange width
	# tf = flange thickness
	# nfdw = number of fibers along web depth 
	# nftw = number of fibers along web thickness
	# nfbf = number of fibers along flange width
	# nftf = number of fibers along flange thickness
	global chanLog;
	set dw [expr $d - 2 * $tf];
	set y1 [expr -$d/2];
	set y2 [expr -$dw/2];
	set y3 [expr  $dw/2];
	set y4 [expr  $d/2];
  
	set z1 [expr -$bf/2];
	set z2 [expr -$tw/2];
	set z3 [expr  $tw/2];
	set z4 [expr  $bf/2];
  
	RunLog "section Fiber  $FSecID  {
   		#                    	 nfIJ  nfJK    yI  zI    yJ  zJ    yK  zK    yL  zL
   		patch quad  $flexmatID  $nfbf $nftf   $y1 $z4   $y1 $z1   $y2 $z1   $y2 $z4
   		patch quad  $flexmatID  $nftw $nfdw   $y2 $z3   $y2 $z2   $y3 $z2   $y3 $z3
   		patch quad  $flexmatID  $nfbf $nftf   $y3 $z4   $y3 $z1   $y4 $z1   $y4 $z4
	}"
	
	RunLog "section Aggregator $ESecID $stiffmatID Vy $stiffmatID Vz $stiffmatID T -section $FSecID";
	
    RunLog "element zeroLengthSection $eleID $nodeR $nodeC $ESecID -orient 0 0 -1 0 1 0";	
}

##############################################################################################################################
#          	  						 Build Box Section Item in Opensee.									    				 #
##############################################################################################################################

proc Bsection { FSecID ESecID stiffmatID flexmatID b t nfb {nft 2}} {
	# ###################################################################
	# Bection  $FSecID $ESecID $stiffmatID $flexmatID $b $t $nfb $nft 
	# ###################################################################
	# create a standard Box section given the nominal section properties
	# written: Xiaolei Xiong
	# date: 11/16
	# input parameters
	# FSecID - fiber section ID number
	# ESecID - element section ID number
	# stiffmatID - material ID number of the huge elastic
	# flexmatID - material ID number of the steel02
	# b = box edge length
	# h = hollow length
	# t = edge thickness
	# nfb = number of fibers along web depth 
	# nft = number of fibers along web thickness

  	global chanLog;
	set h [expr $b - 2*$t]
	set y1 [expr $b/2]
	set y2 [expr $h/2]
	set y3 [expr -$h/2]
	set y4 [expr -$b/2]
  
	set z1 [expr $b/2]
	set z2 [expr $h/2]
	set z3 [expr -$h/2]
	set z4 [expr -$b/2]
  
	RunLog "section fiberSec  $FSecID  {
   		#                    nfIJ nfJK    yI  zI    yJ  zJ    yK  zK    yL  zL
   		patch quadr  $flexmatID  $nfb $nft   $y2 $z1   $y2 $z4   $y1 $z4   $y1 $z1
		patch quadr  $flexmatID  $nfb $nft   $y4 $z1   $y4 $z4   $y3 $z4   $y3 $z1
   		patch quadr  $flexmatID  $nft [expr $nfb-2*$nft]   $y3 $z3   $y3 $z4   $y2 $z4   $y2 $z3
		patch quadr  $flexmatID  $nft [expr $nfb-2*$nft]   $y3 $z3   $y3 $z4   $y2 $z4   $y2 $z3
	}"
	
	RunLog "section Aggregator $ESecID $stiffmatID Vy $stiffmatID Vz $stiffmatID T -section $FSecID";
}

##############################################################################################################################
#          	  						 Build Wide Flange Section Item in Opensee.							    				 #
##############################################################################################################################

proc WFsection { FSecID ESecID stiffmatID flexmatID d bf tf tw nfdw nftw nfbf nftf} {
	# #############################################################################################
	# Bection  $FSecID $ESecID $stiffmatID $flexmatID $d $bf $tf $tw $nfdw $nftw $nfbf $nftf 
	# #############################################################################################
	# create a standard Wide Flange section given the nominal section properties
	# written: Xiaolei Xiong
	# date: 11/16
	# input parameters
	# FSecID - fiber section ID number
	# ESecID - element section ID number
	# stiffmatID - material ID number of the huge elastic
	# flexmatID - material ID number of the steel02
	# d  = nominal depth
	# tw = web thickness
	# bf = flange width
	# tf = flange thickness
	# nfdw = number of fibers along web depth 
	# nftw = number of fibers along web thickness
	# nfbf = number of fibers along flange width
	# nftf = number of fibers along flange thickness
	global chanLog;
	set dw [expr $d - 2 * $tf];
	set y1 [expr -$d/2];
	set y2 [expr -$dw/2];
	set y3 [expr  $dw/2];
	set y4 [expr  $d/2];
  
	set z1 [expr -$bf/2];
	set z2 [expr -$tw/2];
	set z3 [expr  $tw/2];
	set z4 [expr  $bf/2];
  
	RunLog "section Fiber  $FSecID  {
   		#                    	 nfIJ  nfJK    yI  zI    yJ  zJ    yK  zK    yL  zL
   		patch quad  $flexmatID  $nfbf $nftf   $y1 $z4   $y1 $z1   $y2 $z1   $y2 $z4
   		patch quad  $flexmatID  $nftw $nfdw   $y2 $z3   $y2 $z2   $y3 $z2   $y3 $z3
   		patch quad  $flexmatID  $nfbf $nftf   $y3 $z4   $y3 $z1   $y4 $z1   $y4 $z4
	}"
	
	RunLog "section Aggregator $ESecID $stiffmatID Vy $stiffmatID Vz $stiffmatID T -section $FSecID";	
}

##############################################################################################################################
#          	 		  	Define 3D Spring with Fiber Sections as to Steel Section Columns									 #
##############################################################################################################################

proc rotColSpring3DModFiber {eleID nodeR nodeC ESecID } {
	
	# eleID - element ID number
	# FSecID - fiber section ID number
	# ESecID - element section ID number
	# stiffmatID - material ID number of the huge elastic
	# flexmatID - material ID number of the steel02
	global chanLog;
	
    RunLog "element zeroLengthSection $eleID $nodeR $nodeC $ESecID -orient 0 1 0 1 0 0";	 
	
}

##############################################################################################################################
#          	   				Define 3D Spring with Fiber Sections as to Steel Section Beams									 #
##############################################################################################################################

proc rotXBeamSpring3DModFiber {eleID nodeR nodeC ESecID} {
	
	# eleID - element ID number
	# FSecID - fiber section ID number
	# ESecID - element section ID number
	# stiffmatID - material ID number of the huge elastic
	# flexmatID - material ID number of the steel02
	global chanLog;
	
    RunLog "element zeroLengthSection $eleID $nodeR $nodeC $ESecID -orient 1 0 0 0 1 0";	
}

proc rotZBeamSpring3DModFiber {eleID nodeR nodeC ESecID} {
	
	# eleID - element ID number
	# FSecID - fiber section ID number
	# ESecID - element section ID number
	# stiffmatID - material ID number of the huge elastic
	# flexmatID - material ID number of the steel02
	global chanLog;
	
    RunLog "element zeroLengthSection $eleID $nodeR $nodeC $ESecID -orient 0 0 -1 0 1 0";	
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

##############################################################################################################################
#          	 		  	Define Brace Fiber Sections as to Steel Wide Flange Section Braces									 #
##############################################################################################################################

proc WFSec3DFiber {FSecID ESecID stiffmatID flexmatID d bf tf tw nfdw nftw nfbf nftf StrongAxis} {
	
	
	# FSecID - fiber section ID number
	# ESecID - element section ID number
	# stiffmatID - material ID number of the huge elastic
	# flexmatID - material ID number of the steel02
	# d  = nominal depth
	# tw = web thickness
	# bf = flange width
	# tf = flange thickness
	# nfdw = number of fibers along web depth 
	# nftw = number of fibers along web thickness
	# nfbf = number of fibers along flange width
	# nftf = number of fibers along flange thickness
	# StrongAxis - the strong axis of the section in local coordinates system, 'Y' indicates the web is set along local y axis,
	# 'Z' or else indicates the web is set along local z axis
	global chanLog;
	set dw [expr $d - 2 * $tf]
	if {$StrongAxis == "Y"} {
		set y1 [expr -$d/2]
		set y2 [expr -$dw/2]
		set y3 [expr  $dw/2]
		set y4 [expr  $d/2]
	
		set z1 [expr -$bf/2]
		set z2 [expr -$tw/2]
		set z3 [expr  $tw/2]
		set z4 [expr  $bf/2]
	} else {
		set z1 [expr -$d/2]
		set z2 [expr -$dw/2]
		set z3 [expr  $dw/2]
		set z4 [expr  $d/2]
	
		set y1 [expr -$bf/2]
		set y2 [expr -$tw/2]
		set y3 [expr  $tw/2]
		set y4 [expr  $bf/2]
		}
	
  
	RunLog "section Fiber  $FSecID  {
   		#                    	 nfIJ  nfJK    yI  zI    yJ  zJ    yK  zK    yL  zL
   		patch quad  $flexmatID  $nfbf $nftf   $y1 $z4   $y1 $z1   $y2 $z1   $y2 $z4
   		patch quad  $flexmatID  $nftw $nfdw   $y2 $z3   $y2 $z2   $y3 $z2   $y3 $z3
   		patch quad	$flexmatID  $nfbf $nftf   $y3 $z4   $y3 $z1   $y4 $z1   $y4 $z4
	}"
	
	RunLog "section Aggregator $ESecID $stiffmatID Vy $stiffmatID Vz $stiffmatID T -section $FSecID";
	
}

##############################################################################################################################
#          	 			  	Define 3D Spring with Fiber Sections as to Steel XBrace Gusset			 						 #
##############################################################################################################################

proc rotXBraceSpring3DModFiber {eleID nodeR nodeC FSecID ESecID stiffmatID flexmatID Ww tg nfWw nftg eleDirect} {
	
	# eleID - element ID number
	# FSecID - fiber section ID number
	# ESecID - element section ID number
	# stiffmatID - material ID number of the huge elastic
	# flexmatID - material ID number of the steel02
	# Ww = Whitmore width
	# tg = gusset plate thickness
	# nfWw = number of fibers along Whitmore width 
	# nftg = number of fibers along gusset plate thickness
	# eleDirect = (Xend-Xstart)/(Yend-Ystart)
	global chanLog;
	set y1 [expr -$Ww/2];
	set y2 [expr $Ww/2];
	
	set z1 [expr -$tg/2];
	set z2 [expr $tg/2];
	
  
	RunLog "section Fiber  $FSecID  {
   		#                    	 nfIJ  nfJK    yI  zI    yJ  zJ    yK  zK    yL  zL
   		patch quad  $flexmatID  $nftg $nfWw   $y1 $z2   $y1 $z1   $y2 $z1   $y2 $z2   		
	}"
	
	RunLog "section Aggregator $ESecID $stiffmatID Vy $stiffmatID Vz $stiffmatID T -section $FSecID";
	
    RunLog "element zeroLengthSection $eleID $nodeR $nodeC $ESecID -orient $eleDirect 1 0 0 1 0";	
}


##############################################################################################################################
#          	 			  	Define 3D Spring with Fiber Sections as to Steel ZBrace Gusset			 						 #
##############################################################################################################################

proc rotZBraceSpring3DModFiber {eleID nodeR nodeC FSecID ESecID stiffmatID flexmatID Ww tg nfWw nftg eleDirect} {
	
	# eleID - element ID number
	# FSecID - fiber section ID number
	# ESecID - element section ID number
	# stiffmatID - material ID number of the huge elastic
	# flexmatID - material ID number of the steel02
	# Ww = Whitmore width
	# tg = gusset plate thickness
	# nfWw = number of fibers along Whitmore width 
	# nftg = number of fibers along gusset plate thickness
	# eleDirect = (Zend-Zstart)/(Yend-Ystart)
	global chanLog;
	set y1 [expr -$Ww/2];
	set y2 [expr $Ww/2];
	
	set z1 [expr -$tg/2];
	set z2 [expr $tg/2];
	
  
	RunLog "section Fiber  $FSecID  {
   		#                    	 nfIJ  nfJK    yI  zI    yJ  zJ    yK  zK    yL  zL
   		patch quad  $flexmatID  $nftg $nfWw   $y1 $z2   $y1 $z1   $y2 $z1   $y2 $z2   		
	}"
	
	RunLog "section Aggregator $ESecID $stiffmatID Vy $stiffmatID Vz $stiffmatID T -section $FSecID";
	
    RunLog "element zeroLengthSection $eleID $nodeR $nodeC $ESecID -orient 0 1 $eleDirect 0 1 0";	
}

##############################################################################################################################
#          	   Define 3D Rotational Spring with Steel02 Material for Brace Gusset Hinges				    				 #
##############################################################################################################################

proc rotXBraceSpring3DModSteel02 {eleID nodeR nodeC matID stiffmatID eleDirect} {

	# Create the zero length element
	# eleDirect = (Xend-Xstart)/(Yend-Ystart)
    global chanLog;  
    RunLog "element zeroLength $eleID $nodeR $nodeC -mat $stiffmatID $stiffmatID $stiffmatID $stiffmatID $stiffmatID $matID -dir 1 2 3 4 5 6 -orient $eleDirect 1 0 0 1 0"; 
}

proc rotZBraceSpring3DModSteel02 {eleID nodeR nodeC matID stiffmatID eleDirect} {

	# Create the zero length element
	# eleDirect = (Zend-Zstart)/(Yend-Ystart)
    global chanLog;  
    RunLog "element zeroLength $eleID $nodeR $nodeC -mat $stiffmatID $stiffmatID $stiffmatID $stiffmatID $stiffmatID $matID -dir 1 2 3 4 5 6 -orient 0 1 $eleDirect 0 1 0"; 
}

##############################################################################################################################
#          	  						 Define 3D Rotational Spring for leaning columns		(up hinge)						 #
##############################################################################################################################

proc rotLeaningCol {eleID nodeR nodeC stiffmatID SoftMatID} {

	global chanLog;
	# Create the material and zero length element (spring)
    # element zeroLength $eleID $nodeR $nodeC -mat $SoftMatID $SoftMatID -dir 4 6
	# RunLog "element zeroLength $eleID $nodeR $nodeC -mat $stiffmatID $stiffmatID $stiffmatID $SoftMatID $SoftMatID $SoftMatID -dir 1 2 3 4 5 6 -orient 0 1 0 1 0 0";
	RunLog "element zeroLength $eleID $nodeR $nodeC -mat $stiffmatID $stiffmatID $stiffmatID $SoftMatID $SoftMatID $SoftMatID -dir 1 2 3 4 5 6 ";
	# RunLog "element zeroLength $eleID $nodeR $nodeC -mat $stiffmatID $stiffmatID $stiffmatID $stiffmatID $stiffmatID $stiffmatID -dir 1 2 3 4 5 6 ";
	# RunLog "element zeroLength $eleID $nodeR $nodeC -mat $stiffmatID $stiffmatID $stiffmatID $SoftMatID $stiffmatID $SoftMatID -dir 1 2 3 4 5 6 ";
	
	# # Constrain the translational DOF with a multi-point constraint	
	# #   		retained constrained DOF_1 DOF_2 DOF_3  DOF_5
 
	# equalDOF    $nodeR     $nodeC     1     2     3     5
}

##############################################################################################################################
#          	  						 Define 3D Rotational Spring for leaning columns		(down hinge)    				 #
##############################################################################################################################

proc rotLeaningCol0 {eleID nodeR nodeC stiffmatID SoftMatID} {

	global chanLog;
	# Create the material and zero length element (spring)
    # element zeroLength $eleID $nodeR $nodeC -mat $SoftMatID $SoftMatID -dir 4 6
	# RunLog "element zeroLength $eleID $nodeR $nodeC -mat $stiffmatID $stiffmatID $stiffmatID $SoftMatID $stiffmatID $SoftMatID -dir 1 2 3 4 5 6 -orient 0 1 0 1 0 0";
	RunLog "element zeroLength $eleID $nodeR $nodeC -mat $stiffmatID $stiffmatID $stiffmatID $SoftMatID $stiffmatID  $SoftMatID -dir 1 2 3 4 5 6";
	# RunLog "element zeroLength $eleID $nodeR $nodeC -mat $stiffmatID $stiffmatID $stiffmatID $stiffmatID $stiffmatID $stiffmatID -dir 1 2 3 4 5 6";
	
	# # Constrain the translational DOF with a multi-point constraint	
	# #   		retained constrained DOF_1 DOF_2 DOF_3  DOF_5
 
	# equalDOF    $nodeR     $nodeC     1     2     3     5
}
##############################################################################################################################
#          	  			 		 Define 3D Rotational Spring and constraints for Panel Zone			    	 				 #
##############################################################################################################################

proc rotPanelZone3D {eleID nodeR E G Fy dc bf_c tf_c tp db Ry as stiffmatID SoftMatID} {

# Procedure that creates a rotational spring and constrains the corner nodes of a panel zone
# 
# The equations and process are based on: Krawinkler Model for Panel Zones
# Reference:  Gupta, A., and Krawinkler, H. (1999). "Seismic Demands for Performance Evaluation of Steel Moment Resisting Frame Structures,"
#            Technical Report 132, The John A. Blume Earthquake Engineering Research Center, Department of Civil Engineering, Stanford University, Stanford, CA.
#
#
# Written by: Dimitrios Lignos
# Date: 11/09/2008
#
# Modified by: Xiaolei Xiong
# Date: 5/16/2017
# Modification: changed it for 3D modeling
#
# Formal arguments
#       eleID   - unique element ID for this zero length rotational spring
#       nodeR   - node ID which will be retained by the multi-point constraint
#       nodeC   - node ID which will be constrained by the multi-point constraint , erased
#       E       - modulus of elasticity 
#       Fy      - yield strength
#       dc      - column depth
#       bf_c    - column flange width
#       tf_c    - column flange thickness
#       tp      - panel zone thickness
#       db      - beam depth
#       Ry      - expected value for yield strength --> Typical value is 1.2
#       as      - assumed strain hardening

	global chanLog;
	# scan $nodeR {%1d %1d %1d %1d %2d} Y X Z d id;
	regexp {[0-9]{3}$} $nodeR did
	regexp {^[0-9]} $did d	
	set nodeC [expr $nodeR + 1];
# Trilinear Spring
# Yield Shear
	set Vy [expr 0.55 * $Fy * $dc * $tp];
# Shear Modulus
	# set G [expr $E/(2.0 * (1.0 + 0.30))]
# Elastic Stiffness
	set Ke [expr 0.95 * $G * $tp * $dc];
	# set Ke [expr 0.95 * $G * $tp * $dc*1000];
# Plastic Stiffness
	set Kp [expr 0.95 * $G * $bf_c * ($tf_c * $tf_c) / $db];
	# set Kp [expr 0.95 * $G * $bf_c * ($tf_c * $tf_c) / $db*1000];
 
# Define Trilinear Equivalent Rotational Spring
# Yield point for Trilinear Spring at gamma1_y
	set gamma1_y [expr $Vy/$Ke]; set M1y [expr $gamma1_y * ($Ke * $db)];
# Second Point for Trilinear Spring at 4 * gamma1_y
	set gamma2_y [expr 4.0 * $gamma1_y]; set M2y [expr $M1y + ($Kp * $db) * ($gamma2_y - $gamma1_y)];
# Third Point for Trilinear Spring at 100 * gamma1_y
	set gamma3_y [expr 100.0 * $gamma1_y]; set M3y [expr $M2y + ($as * $Ke * $db) * ($gamma3_y - $gamma2_y)];
 
 
# Hysteretic Material without pinching and damage (same mat ID as Ele ID)
    RunLog "uniaxialMaterial Hysteretic $eleID $M1y $gamma1_y  $M2y $gamma2_y $M3y $gamma3_y [expr -$M1y] [expr -$gamma1_y] [expr -$M2y] [expr -$gamma2_y] [expr -$M3y] [expr -$gamma3_y] 1 1 0.0 0.0 0.0"
 
	# if {$d == 1} {
		# element zeroLength $eleID $nodeR $nodeC -mat $stiffmatID $stiffmatID $stiffmatID $SoftMatID $stiffmatID $eleID -dir 1 2 3 4 5 6 -orient 1 0 0 0 1 0;
	# } else {
		# element zeroLength $eleID $nodeR $nodeC -mat $stiffmatID $stiffmatID $stiffmatID $SoftMatID $stiffmatID $eleID -dir 1 2 3 4 5 6 -orient 0 0 -1 0 1 0;
	# }
	
	if {$d == 1} {
		RunLog "element zeroLength $eleID $nodeR $nodeC -mat $stiffmatID $stiffmatID $stiffmatID $SoftMatID $stiffmatID $eleID -dir 1 2 3 4 5 6 -orient 1 0 0 0 1 0";
	} else {
		RunLog "element zeroLength $eleID $nodeR $nodeC -mat $stiffmatID $stiffmatID $stiffmatID $SoftMatID $stiffmatID $eleID -dir 1 2 3 4 5 6 -orient 0 0 -1 0 1 0";
	}
 
	# Constrain the translational DOF with a multi-point constraint
	# Left Top Corner of PZ
	set nodeR_1 [expr $nodeR - 2];
	set nodeR_2 [expr $nodeR - 1];
	set eleID2 [expr $eleID + 1];
	# Right Bottom Corner of PZ
	set nodeR_5 [expr $nodeR + 2];
	set nodeR_6 [expr $nodeR + 3];
	set eleID3 [expr $eleID + 2];
	# Left Bottom Corner of PZ
	set nodeL_7 [expr $nodeR + 4];
	set nodeL_8 [expr $nodeR + 5];
	set eleID4 [expr $eleID + 3];
	if {$d == 1} {
		RunLog "element zeroLength $eleID2 $nodeR_1 $nodeR_2 -mat $stiffmatID $stiffmatID $stiffmatID $SoftMatID $stiffmatID $SoftMatID -dir 1 2 3 4 5 6 -orient 1 0 0 0 1 0";
		RunLog "element zeroLength $eleID3 $nodeR_5 $nodeR_6 -mat $stiffmatID $stiffmatID $stiffmatID $SoftMatID $stiffmatID $SoftMatID -dir 1 2 3 4 5 6 -orient 1 0 0 0 1 0";
		RunLog "element zeroLength $eleID4 $nodeL_7 $nodeL_8 -mat $stiffmatID $stiffmatID $stiffmatID $SoftMatID $stiffmatID $SoftMatID -dir 1 2 3 4 5 6 -orient 1 0 0 0 1 0";
	} else {
		RunLog "element zeroLength $eleID2 $nodeR_1 $nodeR_2 -mat $stiffmatID $stiffmatID $stiffmatID $SoftMatID $stiffmatID $SoftMatID -dir 1 2 3 4 5 6 -orient 0 0 -1 0 1 0";
		RunLog "element zeroLength $eleID3 $nodeR_5 $nodeR_6 -mat $stiffmatID $stiffmatID $stiffmatID $SoftMatID $stiffmatID $SoftMatID -dir 1 2 3 4 5 6 -orient 0 0 -1 0 1 0";
		RunLog "element zeroLength $eleID4 $nodeL_7 $nodeL_8 -mat $stiffmatID $stiffmatID $stiffmatID $SoftMatID $stiffmatID $SoftMatID -dir 1 2 3 4 5 6 -orient 0 0 -1 0 1 0";
	}
}

##############################################################################################################################
#          	  						 Look Up Section Properties from Database							    				 #
##############################################################################################################################

proc WFProp { shape } {
	set input_file  [file normalize "Database.csv"];
	set line {}
	set i 0
	if {[catch {set file_in [open $input_file r]} err_msg]} {
	puts "Failed to open the file for reading: $err_msg"
	return
	}
	set content [read $file_in]
	close $file_in
	
	foreach line [split $content "\n"] {
		set propde [split $line ","];
		set name1 [lindex $propde 2];
		set name2 [lindex $propde 80];
		if {[string equal $name1 $shape]} {
			set name [lindex $propde 2];  # lindex 0
			set d [lindex $propde 6];     # lindex 1
			set A [lindex $propde 5];     # lindex 2
			set bf [lindex $propde 11];   # lindex 3
			set tw [lindex $propde 16];   # lindex 4
			set tf [lindex $propde 19];   # lindex 5
			set Ix [lindex $propde 38];   # lindex 6 强轴
			set Iy [lindex $propde 42];   # lindex 7 弱轴
			set Zx [lindex $propde 39];   # lindex 8
			set Zy [lindex $propde 43];   # lindex 9
			set ry [lindex $propde 45];   # lindex 10
			set J [lindex $propde 49];    # lindex 11
		}
		if {[string equal $name2 $shape]} {
			set name [lindex $propde 80];                 # lindex 0  
			set d [lindex $propde 83];                    # lindex 1
			set A [lindex $propde 82];                    # lindex 2
			set bf [lindex $propde 88];                   # lindex 3
			set tw [lindex $propde 93];                   # lindex 4
			set tf [lindex $propde 96];                   # lindex 5
			set Ix [expr ([lindex $propde 115])*10**6];   # lindex 6
			set Iy [expr ([lindex $propde 119])*10**6];   # lindex 7
			set Zx [expr ([lindex $propde 116])*10**3];   # lindex 8
			set Zy [expr ([lindex $propde 120])*10**3];   # lindex 9
			set ry [lindex $propde 122];                  # lindex 10
			set J [expr ([lindex $propde 126])*10**3];    # lindex 11
		}
	}
	set Prop [list $name $d $A $bf $tw $tf $Ix $Iy $Zx $Zy $ry $J];
	return $Prop
}

##############################################################################################################################
#          	  						 Calculate Box Section Properties from Database						    				 #
##############################################################################################################################

proc BoxProp { shape } {
	scan $shape "B%dX%f" b t;
	set Aw [expr $b*$b];
	set edgeh [expr $b-2*$t];
	set Ah [expr $edgeh*$edgeh];
	set A [expr $Aw-$Ah];                                     # lindex 3
	set Iw [expr pow($b,4)/12];                                
	set edgeh [expr $b-2*$t];                                  
	set Ih [expr pow($edgeh,4)/12];                            
	set Ix [expr round([expr ($Iw-$Ih)*1000])/1000.0];        # lindex 4
	set Zx [expr round([expr $Ix*2.0/$b*1000])/1000.0];       # lindex 5
	set ry [expr round([expr sqrt($Ix/$A)*1000])/1000.0];     # lindex 6
	set Prop [list $shape $b $t $A $Ix $Zx $ry];
	return $Prop
}
	
##############################################################################################################################
#          	  						 	Identify Beam and Column Section for Panel Zone					    				 #
##############################################################################################################################

proc PanelZoneSize { level ColPier BeamSecs ColumnSecs SectionLevel XPier ZPier} {
	set BotmSecLevelID 0
	foreach i $SectionLevel {
		if {$level > $i} {
			incr BotmSecLevelID;
		}
	}
	set TopSecLevelID 0
	if {$level == [lindex $SectionLevel end]} {
		set TopSecLevelID [expr [llength $SectionLevel] - 1]
	} else {
		foreach i $SectionLevel {
			if {[expr $level + 1] > $i} {
				incr TopSecLevelID;
			}
		}
	}
	set x [lindex $ColPier 0];
	set z [lindex $ColPier 1];
	if {$x == 1 || $x == $XPier} {
		set CType 1;		
	} elseif {$z == 1 || $z == $ZPier} {
		set CType 2;
	} else {
		set CType 0;
	}
	if {$x == 1 || $x == $XPier} {
		set ZBType 0;		
	} else {
		set ZBType 1;
	}
	if {$z == 1 || $z == $ZPier} {
		set XBType 0;		
	} else {
		set XBType 2;
	}
	set XBSec [lindex $BeamSecs $XBType $BotmSecLevelID]; # XBSec = Beam Section in X direction
	set ZBSec [lindex $BeamSecs $ZBType $BotmSecLevelID]; # ZBSec = Beam Section in Z direction
	set TCSec [lindex $ColumnSecs $CType $TopSecLevelID]; # TCSec = Column Section above $level
	set BCSec [lindex $ColumnSecs $CType $BotmSecLevelID]; # BCSec = Column Section below $level
	set XPZvert [lindex [WFProp $XBSec] 1];
	set ZPZvert [lindex [WFProp $ZBSec] 1];
	set TPZhor [lindex [BoxProp $TCSec] 1];
	set BPZhor [lindex [BoxProp $BCSec] 1];
	set PZvert [expr max($XPZvert,$ZPZvert)];
	set PZhor [expr max($TPZhor,$BPZhor)];
	# set PanelSec [list $XBSec $ZBSec $TCSec $BCSec];
	set PanelSize [list $PZvert $PZhor];
	# return $PanelSec
	return $PanelSize
}

##############################################################################################################################
#          	  							Look Up Beam Section Type According to Section Level			    				 #
##############################################################################################################################

# Dir = 1 , X direction;2 , Z direction
proc BeamSectionName { level line BeamSecs SectionLevel Pier Dir } {
	set SecLevelID 0
	foreach i $SectionLevel {
		if {$level > $i} {
			incr SecLevelID;
		}
	}
	if {$line == 1 || $line == $Pier} {
		set BType 0;		
	} elseif {$Dir == 1} {
		set BType 2;
	} else {
		set BType 1;
	}
	set BSec [lindex $BeamSecs $BType $SecLevelID];
	return $BSec
}

##############################################################################################################################
#          	  							Look Up Column Section Type According to Section Level			    				 #
##############################################################################################################################
# look up column section below the input level 

proc ColumnSectionName { level ColPier ColumnSecs SectionLevel XPier ZPier } {
	set SecLevelID 0
	set x [lindex $ColPier 0];
	set z [lindex $ColPier 1];
	foreach i $SectionLevel {
		if {$level > $i} {
			incr SecLevelID;
		}
	}
	if {$x == 1 || $x == $XPier} {
		set CType 1;		
	} elseif {$z == 1 || $z == $ZPier} {
		set CType 2;
	} else {
		set CType 0;
	}
	set CSec [lindex $ColumnSecs $CType $SecLevelID];
	return $CSec
}

##############################################################################################################################
#          	  							Look Up Floor Expected Load According to Load Level				    				 #
##############################################################################################################################

proc FloorLoad { level LoadValueList LoadLevel } {
	set LoadLevelID 0
	foreach i $LoadLevel {
		if {$level > $i} {
			incr LoadLevelID;
		}
	}
	set FLoad [lindex $LoadValueList $LoadLevelID];
	return $FLoad
}

##############################################################################################################################
#          	  								 Define Nodes Around Panel Zone								    				 #
##############################################################################################################################

proc NodesAroundPanelZone1 { level ColPier XCor YCor ZCor PanelSize } {

# Node Naming Convention:
# YXZ_Did_Pid: Y:   number of floor levels
#			   X:   number of X-Direction column lines
#			   Z:   number of Z-Direction column lines
#			   Did: direction of frame that node attached in, 1 for X-Direction;2 for Z-Direction;0 for intersection of X and Z axis pid=10,12,14,16,17,18	
#			   Pid: The final two digits indicate the position of the nodes
# 				    01-12: nodes for Panel Zone
# 				    01: top left node
# 				    02: top left node
# 				    03: top right node
# 				    04: top right node
# 				    05: bottom right node
# 				    06: bottom right node
# 				    07: bottom left node
# 				    08: bottom left node
# 				    09: mid left node
# 				    10: top mid node
# 				    11: mid right node
# 				    12: bottom mid node
# 				    13-18: nodes for Plastic Hinge
# 				    13: left(negative) beam node
# 				    14: Top(positive) column node
# 				    15: right(positive) beam node
# 				    16: Bottom(negative) column node
# 				    17: bottom splice column node
# 				    18: top splice column node	
	set Y $level;
	set X [lindex $ColPier 0];
	set Z [lindex $ColPier 1];
	set xcoordinate [lindex $XCor [expr $X-1]];
	set ycoordinate [lindex $YCor [expr $Y-1]];
	set zcoordinate [lindex $ZCor [expr $Z-1]];
	set dh [expr ([lindex $PanelSize 1]) / 2.0];	
	set dv [expr ([lindex $PanelSize 0]) / 2.0];
	
	
       
	# define nodes in X direction panel zone 
	node [format %s%s%s%s%s $Y $X $Z 1 01] [expr $xcoordinate - $dh] [expr $ycoordinate + $dv] $zcoordinate;
	node [format %s%s%s%s%s $Y $X $Z 1 02] [expr $xcoordinate - $dh] [expr $ycoordinate + $dv] $zcoordinate;
	node [format %s%s%s%s%s $Y $X $Z 1 03] [expr $xcoordinate + $dh] [expr $ycoordinate + $dv] $zcoordinate;
	node [format %s%s%s%s%s $Y $X $Z 1 04] [expr $xcoordinate + $dh] [expr $ycoordinate + $dv] $zcoordinate;	
	node [format %s%s%s%s%s $Y $X $Z 1 05] [expr $xcoordinate + $dh] [expr $ycoordinate - $dv] $zcoordinate;
	node [format %s%s%s%s%s $Y $X $Z 1 06] [expr $xcoordinate + $dh] [expr $ycoordinate - $dv] $zcoordinate;
	node [format %s%s%s%s%s $Y $X $Z 1 07] [expr $xcoordinate - $dh] [expr $ycoordinate - $dv] $zcoordinate;
	node [format %s%s%s%s%s $Y $X $Z 1 08] [expr $xcoordinate - $dh] [expr $ycoordinate - $dv] $zcoordinate;
	node [format %s%s%s%s%s $Y $X $Z 1 09] [expr $xcoordinate - $dh] $ycoordinate $zcoordinate;	
	node [format %s%s%s%s%s $Y $X $Z 1 11] [expr $xcoordinate + $dh] $ycoordinate $zcoordinate;	
		
	# define nodes in Z direction panel zone
	node [format %s%s%s%s%s $Y $X $Z 2 01] $xcoordinate [expr $ycoordinate + $dv] [expr $zcoordinate - $dh];
	node [format %s%s%s%s%s $Y $X $Z 2 02] $xcoordinate [expr $ycoordinate + $dv] [expr $zcoordinate - $dh];
	node [format %s%s%s%s%s $Y $X $Z 2 03] $xcoordinate [expr $ycoordinate + $dv] [expr $zcoordinate + $dh];
	node [format %s%s%s%s%s $Y $X $Z 2 04] $xcoordinate [expr $ycoordinate + $dv] [expr $zcoordinate + $dh];	
	node [format %s%s%s%s%s $Y $X $Z 2 05] $xcoordinate [expr $ycoordinate - $dv] [expr $zcoordinate + $dh];
	node [format %s%s%s%s%s $Y $X $Z 2 06] $xcoordinate [expr $ycoordinate - $dv] [expr $zcoordinate + $dh];
	node [format %s%s%s%s%s $Y $X $Z 2 07] $xcoordinate [expr $ycoordinate - $dv] [expr $zcoordinate - $dh];
	node [format %s%s%s%s%s $Y $X $Z 2 08] $xcoordinate [expr $ycoordinate - $dv] [expr $zcoordinate - $dh];
	node [format %s%s%s%s%s $Y $X $Z 2 09] $xcoordinate $ycoordinate [expr $zcoordinate - $dh];
	node [format %s%s%s%s%s $Y $X $Z 2 11] $xcoordinate $ycoordinate [expr $zcoordinate + $dh];	
	
	# define nodes in the intersection of X and Z direction panel zone
	node [format %s%s%s%s%s $Y $X $Z 0 10] $xcoordinate [expr $ycoordinate + $dv] $zcoordinate;
	node [format %s%s%s%s%s $Y $X $Z 0 12] $xcoordinate [expr $ycoordinate - $dv] $zcoordinate;
	
	# define nodes for column hinge
	node [format %s%s%s%s%s $Y $X $Z 0 16] $xcoordinate [expr $ycoordinate - $dv] $zcoordinate;
	if {$Y != [llength $YCor]} {
		node [format %s%s%s%s%s $Y $X $Z 0 14] $xcoordinate [expr $ycoordinate + $dv] $zcoordinate;}
		
	# define nodes for xBeam hinge
	if {$X != 1} {
		node [format %s%s%s%s%s $Y $X $Z 1 13] [expr $xcoordinate - $dh] $ycoordinate $zcoordinate;}
	if {$X != [llength $XCor]} {
		node [format %s%s%s%s%s $Y $X $Z 1 15] [expr $xcoordinate + $dh] $ycoordinate $zcoordinate;}
			
	# define nodes for zBeam hinge
	if {$Z != 1} {
		node [format %s%s%s%s%s $Y $X $Z 2 13] $xcoordinate $ycoordinate [expr $zcoordinate - $dh];}
	if {$Z != [llength $ZCor]} {
		node [format %s%s%s%s%s $Y $X $Z 2 15] $xcoordinate $ycoordinate [expr $zcoordinate + $dh];}
}

##############################################################################################################################
#          	  								 Define Nodes Around Joint Node								    				 #
##############################################################################################################################

proc NodesAroundJointNode { level ColPier XCor YCor ZCor ZBeamline } {

# Node Naming Convention:
# YXZ_Did_Pid: Y:   number of floor levels
#			   X:   number of X-Direction column lines
#			   Z:   number of Z-Direction column lines
#			   Did: direction of frame that node attached in, 1 for X-Direction;2 for Z-Direction;0 for intersection of X and Z axis pid=10,12,14,16,17,18	
#			   Pid: The final two digits indicate the position of the nodes
# 				    01-12: nodes for Panel Zone
# 				    01: top left node
# 				    02: top left node
# 				    03: top right node
# 				    04: top right node
# 				    05: bottom right node
# 				    06: bottom right node
# 				    07: bottom left node
# 				    08: bottom left node
# 				    09: mid left node
# 				    10: top mid node
# 				    11: mid right node
# 				    12: bottom mid node
# 				    13-18: nodes for Plastic Hinge
# 				   *13: left(negative) beam node
# 				   *14: Top(positive) column node
# 				   *15: right(positive) beam node
# 				   *16: Bottom(negative) column node
# 				    17: bottom splice column node
# 				    18: top splice column node	
# 				    19: joint node	
	set Y $level;
	set X [lindex $ColPier 0];
	set Z [lindex $ColPier 1];
	set xcoordinate [lindex $XCor [expr $X-1]];
	set ycoordinate [lindex $YCor [expr $Y-1]];
	set zcoordinate [lindex $ZCor [expr $Z-1]];
	
	
       
	# define joint nodes 
	node [format %s%s%s%s%s $Y $X $Z 0 19] $xcoordinate $ycoordinate $zcoordinate;	
	
	# define nodes for column hinge
	node [format %s%s%s%s%s $Y $X $Z 0 16] $xcoordinate $ycoordinate $zcoordinate;
	if {$Y != [llength $YCor]} {
		node [format %s%s%s%s%s $Y $X $Z 0 14] $xcoordinate $ycoordinate $zcoordinate;}
		
	# define nodes for xBeam hinge
	if {$X != 1} {
		node [format %s%s%s%s%s $Y $X $Z 1 13] $xcoordinate $ycoordinate $zcoordinate;}
	if {$X != [llength $XCor]} {
		node [format %s%s%s%s%s $Y $X $Z 1 15] $xcoordinate $ycoordinate $zcoordinate;}
			
	# define nodes for zBeam hinge
	if {[lsearch $ZBeamline $X] != -1 } {
		if {$Z != 1} {
			node [format %s%s%s%s%s $Y $X $Z 2 13] $xcoordinate $ycoordinate $zcoordinate;}
		if {$Z != [llength $ZCor]} {
			node [format %s%s%s%s%s $Y $X $Z 2 15] $xcoordinate $ycoordinate $zcoordinate;}
	}
		
}

##############################################################################################################################
#          	  								 Define Nodes Around Joint Node	(force-based element for column)   				 #
##############################################################################################################################

proc NodesAroundJointNodeFE { level ColPier XCor YCor ZCor ZBeamline } {

# Node Naming Convention:
# YXZ_Did_Pid: Y:   number of floor levels
#			   X:   number of X-Direction column lines
#			   Z:   number of Z-Direction column lines
#			   Did: direction of frame that node attached in, 1 for X-Direction;2 for Z-Direction;0 for intersection of X and Z axis pid=10,12,14,16,17,18	
#			   Pid: The final two digits indicate the position of the nodes
# 				    01-12: nodes for Panel Zone
# 				    01: top left node
# 				    02: top left node
# 				    03: top right node
# 				    04: top right node
# 				    05: bottom right node
# 				    06: bottom right node
# 				    07: bottom left node
# 				    08: bottom left node
# 				    09: mid left node
# 				    10: top mid node
# 				    11: mid right node
# 				    12: bottom mid node
# 				    13-18: nodes for Plastic Hinge
# 				   *13: left(negative) beam node
# 				   *14: Top(positive) column node
# 				   *15: right(positive) beam node
# 				   *16: Bottom(negative) column node
# 				    17: bottom splice column node
# 				    18: top splice column node	
# 				    19: joint node	
	set Y $level;
	set X [lindex $ColPier 0];
	set Z [lindex $ColPier 1];
	set xcoordinate [lindex $XCor [expr $X-1]];
	set ycoordinate [lindex $YCor [expr $Y-1]];
	set zcoordinate [lindex $ZCor [expr $Z-1]];
	
	
       
	# define joint nodes 
	node [format %s%s%s%s%s $Y $X $Z 0 19] $xcoordinate $ycoordinate $zcoordinate;	
	
	# define nodes for column hinge
	# node [format %s%s%s%s%s $Y $X $Z 0 16] $xcoordinate $ycoordinate $zcoordinate;
	# if {$Y != [llength $YCor]} {
		# node [format %s%s%s%s%s $Y $X $Z 0 14] $xcoordinate $ycoordinate $zcoordinate;}
		
	# define nodes for xBeam hinge
	if {$X != 1} {
		node [format %s%s%s%s%s $Y $X $Z 1 13] $xcoordinate $ycoordinate $zcoordinate;}
	if {$X != [llength $XCor]} {
		node [format %s%s%s%s%s $Y $X $Z 1 15] $xcoordinate $ycoordinate $zcoordinate;}
			
	# define nodes for zBeam hinge
	if {[lsearch $ZBeamline $X] != -1 } {
		if {$Z != 1} {
			node [format %s%s%s%s%s $Y $X $Z 2 13] $xcoordinate $ycoordinate $zcoordinate;}
		if {$Z != [llength $ZCor]} {
			node [format %s%s%s%s%s $Y $X $Z 2 15] $xcoordinate $ycoordinate $zcoordinate;}
	}
		
}

##############################################################################################################################
#          	  					 Define Nodes Around Panel Zone Incorporating Longspan Factor			    				 #
##############################################################################################################################

proc NodesAroundPanelZone { level ColPier XCor YCor ZCor PanelSize ZBeamline } {

# Node Naming Convention:
# YXZ_Did_Pid: Y:   number of floor levels
#			   X:   number of X-Direction column lines
#			   Z:   number of Z-Direction column lines
#			   Did: direction of frame that node attached in, 1 for X-Direction;2 for Z-Direction;0 for intersection of X and Z axis pid=10,12,14,16,17,18	
#			   Pid: The final two digits indicate the position of the nodes
# 				    01-12: nodes for Panel Zone
# 				    01: top left node
# 				    02: top left node
# 				    03: top right node
# 				    04: top right node
# 				    05: bottom right node
# 				    06: bottom right node
# 				    07: bottom left node
# 				    08: bottom left node
# 				    09: mid left node
# 				    10: top mid node
# 				    11: mid right node
# 				    12: bottom mid node
# 				    13-18: nodes for Plastic Hinge
# 				    13: left(negative) beam node
# 				    14: Top(positive) column node
# 				    15: right(positive) beam node
# 				    16: Bottom(negative) column node
# 				    17: bottom splice column node
# 				    18: top splice column node	
#
# Longspan is set defaultly in X direction!

	global chanLog;
	set Y $level;
	set X [lindex $ColPier 0];
	set Z [lindex $ColPier 1];
	set xcoordinate [lindex $XCor [expr $X-1]];
	set ycoordinate [lindex $YCor [expr $Y-1]];
	set zcoordinate [lindex $ZCor [expr $Z-1]];
	set dh [expr ([lindex $PanelSize 1]) / 2.0];	
	set dv [expr ([lindex $PanelSize 0]) / 2.0];
	
	
       
	# define nodes in X direction panel zone 
	RunLog "node [format %s%s%s%s%s $Y $X $Z 1 01] [expr $xcoordinate - $dh] [expr $ycoordinate + $dv] $zcoordinate";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 1 02] [expr $xcoordinate - $dh] [expr $ycoordinate + $dv] $zcoordinate";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 1 03] [expr $xcoordinate + $dh] [expr $ycoordinate + $dv] $zcoordinate";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 1 04] [expr $xcoordinate + $dh] [expr $ycoordinate + $dv] $zcoordinate";	
	RunLog "node [format %s%s%s%s%s $Y $X $Z 1 05] [expr $xcoordinate + $dh] [expr $ycoordinate - $dv] $zcoordinate";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 1 06] [expr $xcoordinate + $dh] [expr $ycoordinate - $dv] $zcoordinate";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 1 07] [expr $xcoordinate - $dh] [expr $ycoordinate - $dv] $zcoordinate";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 1 08] [expr $xcoordinate - $dh] [expr $ycoordinate - $dv] $zcoordinate";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 1 09] [expr $xcoordinate - $dh] $ycoordinate $zcoordinate";	
	RunLog "node [format %s%s%s%s%s $Y $X $Z 1 11] [expr $xcoordinate + $dh] $ycoordinate $zcoordinate";	
		
	# define nodes in Z direction panel zone
	RunLog "node [format %s%s%s%s%s $Y $X $Z 2 01] $xcoordinate [expr $ycoordinate + $dv] [expr $zcoordinate - $dh]";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 2 02] $xcoordinate [expr $ycoordinate + $dv] [expr $zcoordinate - $dh]";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 2 03] $xcoordinate [expr $ycoordinate + $dv] [expr $zcoordinate + $dh]";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 2 04] $xcoordinate [expr $ycoordinate + $dv] [expr $zcoordinate + $dh]";	
	RunLog "node [format %s%s%s%s%s $Y $X $Z 2 05] $xcoordinate [expr $ycoordinate - $dv] [expr $zcoordinate + $dh]";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 2 06] $xcoordinate [expr $ycoordinate - $dv] [expr $zcoordinate + $dh]";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 2 07] $xcoordinate [expr $ycoordinate - $dv] [expr $zcoordinate - $dh]";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 2 08] $xcoordinate [expr $ycoordinate - $dv] [expr $zcoordinate - $dh]";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 2 09] $xcoordinate $ycoordinate [expr $zcoordinate - $dh]";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 2 11] $xcoordinate $ycoordinate [expr $zcoordinate + $dh]";	
	
	# define nodes in the intersection of X and Z direction panel zone
	RunLog "node [format %s%s%s%s%s $Y $X $Z 0 10] $xcoordinate [expr $ycoordinate + $dv] $zcoordinate";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 0 12] $xcoordinate [expr $ycoordinate - $dv] $zcoordinate";
	
	# define nodes for column hinge
	RunLog "node [format %s%s%s%s%s $Y $X $Z 0 16] $xcoordinate [expr $ycoordinate - $dv] $zcoordinate";
	if {$Y != [llength $YCor]} {
		RunLog "node [format %s%s%s%s%s $Y $X $Z 0 14] $xcoordinate [expr $ycoordinate + $dv] $zcoordinate";}
		
	# define nodes for xBeam hinge
	if {$X != 1} {
		RunLog "node [format %s%s%s%s%s $Y $X $Z 1 13] [expr $xcoordinate - $dh] $ycoordinate $zcoordinate";}
	if {$X != [llength $XCor]} {
		RunLog "node [format %s%s%s%s%s $Y $X $Z 1 15] [expr $xcoordinate + $dh] $ycoordinate $zcoordinate";}
			
	# define nodes for zBeam hinge
	
	if {[lsearch $ZBeamline $X] != -1 } {
		if {$Z != 1} {
			RunLog "node [format %s%s%s%s%s $Y $X $Z 2 13] $xcoordinate $ycoordinate [expr $zcoordinate - $dh]";}
		if {$Z != [llength $ZCor]} {
			RunLog "node [format %s%s%s%s%s $Y $X $Z 2 15] $xcoordinate $ycoordinate [expr $zcoordinate + $dh]";}
	}
}

##############################################################################################################################
#        		 Define Nodes Around Panel Zone Incorporating Longspan Factor(force-based element for column)				 #
##############################################################################################################################

proc NodesAroundPanelZoneFE { level ColPier XCor YCor ZCor PanelSize ZBeamline } {

# Node Naming Convention:
# YXZ_Did_Pid: Y:   number of floor levels
#			   X:   number of X-Direction column lines
#			   Z:   number of Z-Direction column lines
#			   Did: direction of frame that node attached in, 1 for X-Direction;2 for Z-Direction;0 for intersection of X and Z axis pid=10,12,14,16,17,18	
#			   Pid: The final two digits indicate the position of the nodes
# 				    01-12: nodes for Panel Zone
# 				    01: top left node
# 				    02: top left node
# 				    03: top right node
# 				    04: top right node
# 				    05: bottom right node
# 				    06: bottom right node
# 				    07: bottom left node
# 				    08: bottom left node
# 				    09: mid left node
# 				    10: top mid node
# 				    11: mid right node
# 				    12: bottom mid node
# 				    13-18: nodes for Plastic Hinge
# 				    13: left(negative) beam node
# 				    14: Top(positive) column node
# 				    15: right(positive) beam node
# 				    16: Bottom(negative) column node
# 				    17: bottom splice column node
# 				    18: top splice column node	
#
# Longspan is set defaultly in X direction!

	global chanLog;
	set Y $level;
	set X [lindex $ColPier 0];
	set Z [lindex $ColPier 1];
	set xcoordinate [lindex $XCor [expr $X-1]];
	set ycoordinate [lindex $YCor [expr $Y-1]];
	set zcoordinate [lindex $ZCor [expr $Z-1]];
	set dh [expr ([lindex $PanelSize 1]) / 2.0];	
	set dv [expr ([lindex $PanelSize 0]) / 2.0];
	
	
       
	# define nodes in X direction panel zone 
	RunLog "node [format %s%s%s%s%s $Y $X $Z 1 01] [expr $xcoordinate - $dh] [expr $ycoordinate + $dv] $zcoordinate";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 1 02] [expr $xcoordinate - $dh] [expr $ycoordinate + $dv] $zcoordinate";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 1 03] [expr $xcoordinate + $dh] [expr $ycoordinate + $dv] $zcoordinate";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 1 04] [expr $xcoordinate + $dh] [expr $ycoordinate + $dv] $zcoordinate";	
	RunLog "node [format %s%s%s%s%s $Y $X $Z 1 05] [expr $xcoordinate + $dh] [expr $ycoordinate - $dv] $zcoordinate";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 1 06] [expr $xcoordinate + $dh] [expr $ycoordinate - $dv] $zcoordinate";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 1 07] [expr $xcoordinate - $dh] [expr $ycoordinate - $dv] $zcoordinate";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 1 08] [expr $xcoordinate - $dh] [expr $ycoordinate - $dv] $zcoordinate";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 1 09] [expr $xcoordinate - $dh] $ycoordinate $zcoordinate";	
	RunLog "node [format %s%s%s%s%s $Y $X $Z 1 11] [expr $xcoordinate + $dh] $ycoordinate $zcoordinate";	
		
	# define nodes in Z direction panel zone
	RunLog "node [format %s%s%s%s%s $Y $X $Z 2 01] $xcoordinate [expr $ycoordinate + $dv] [expr $zcoordinate - $dh]";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 2 02] $xcoordinate [expr $ycoordinate + $dv] [expr $zcoordinate - $dh]";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 2 03] $xcoordinate [expr $ycoordinate + $dv] [expr $zcoordinate + $dh]";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 2 04] $xcoordinate [expr $ycoordinate + $dv] [expr $zcoordinate + $dh]";	
	RunLog "node [format %s%s%s%s%s $Y $X $Z 2 05] $xcoordinate [expr $ycoordinate - $dv] [expr $zcoordinate + $dh]";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 2 06] $xcoordinate [expr $ycoordinate - $dv] [expr $zcoordinate + $dh]";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 2 07] $xcoordinate [expr $ycoordinate - $dv] [expr $zcoordinate - $dh]";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 2 08] $xcoordinate [expr $ycoordinate - $dv] [expr $zcoordinate - $dh]";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 2 09] $xcoordinate $ycoordinate [expr $zcoordinate - $dh]";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 2 11] $xcoordinate $ycoordinate [expr $zcoordinate + $dh]";	
	
	# define nodes in the intersection of X and Z direction panel zone
	RunLog "node [format %s%s%s%s%s $Y $X $Z 0 10] $xcoordinate [expr $ycoordinate + $dv] $zcoordinate";
	RunLog "node [format %s%s%s%s%s $Y $X $Z 0 12] $xcoordinate [expr $ycoordinate - $dv] $zcoordinate";
	
	# define nodes for column hinge
	# RunLog "node [format %s%s%s%s%s $Y $X $Z 0 16] $xcoordinate [expr $ycoordinate - $dv] $zcoordinate";
	# if {$Y != [llength $YCor]} {
		# RunLog "node [format %s%s%s%s%s $Y $X $Z 0 14] $xcoordinate [expr $ycoordinate + $dv] $zcoordinate";}
		
	# define nodes for xBeam hinge
	if {$X != 1} {
		RunLog "node [format %s%s%s%s%s $Y $X $Z 1 13] [expr $xcoordinate - $dh] $ycoordinate $zcoordinate";}
	if {$X != [llength $XCor]} {
		RunLog "node [format %s%s%s%s%s $Y $X $Z 1 15] [expr $xcoordinate + $dh] $ycoordinate $zcoordinate";}
			
	# define nodes for zBeam hinge
	
	if {[lsearch $ZBeamline $X] != -1 } {
		if {$Z != 1} {
			RunLog "node [format %s%s%s%s%s $Y $X $Z 2 13] $xcoordinate $ycoordinate [expr $zcoordinate - $dh]";}
		if {$Z != [llength $ZCor]} {
			RunLog "node [format %s%s%s%s%s $Y $X $Z 2 15] $xcoordinate $ycoordinate [expr $zcoordinate + $dh]";}
	}
}

##############################################################################################################################
#          	  								 Define Nodes at Column Pier								    				 #
##############################################################################################################################

proc NodesAtColumnPier { level ColPier XCor YCor ZCor Yoffset } {
	global chanLog;
	set Y $level;
	set X [lindex $ColPier 0];
	set Z [lindex $ColPier 1];
	set xcoordinate [lindex $XCor [expr $X-1]];
	set ycoordinate [expr [lindex $YCor [expr $Y-1]] + $Yoffset];
	set zcoordinate [lindex $ZCor [expr $Z-1]];
	RunLog "node [format %s%s%s%s%s $Y $X $Z 0 17] $xcoordinate $ycoordinate $zcoordinate;"
	RunLog "node [format %s%s%s%s%s $Y $X $Z 0 18] $xcoordinate $ycoordinate $zcoordinate;"
}

##############################################################################################################################
#          	  										 Define Nodes at Base								    				 #
##############################################################################################################################

proc NodesAtBase { level ColPier XCor YCor ZCor Yoffset } {
	global chanLog;
	set Y $level;
	set X [lindex $ColPier 0];
	set Z [lindex $ColPier 1];
	set xcoordinate [lindex $XCor [expr $X-1]];
	set ycoordinate [expr [lindex $YCor [expr $Y-1]] + $Yoffset];
	set zcoordinate [lindex $ZCor [expr $Z-1]];
	RunLog "node [format %s%s%s%s%s $Y $X $Z 0 17] $xcoordinate $ycoordinate $zcoordinate;"
	# RunLog "node [format %s%s%s%s%s $Y $X $Z 0 18] $xcoordinate $ycoordinate $zcoordinate;"
}


##############################################################################################################################
#          	  					 Define Nodes for Leaning Column and Rigid Diaphragm	(Not used)		    				 #
##############################################################################################################################

proc NodesForLeaningColumn0 { level XCor YCor ZCor Top } {
	global chanLog;
	set xcoordinate $XCor;
	set ycoordinate [lindex $YCor [expr $level-1]];
	set zcoordinate $ZCor;
	RunLog "node [format %s%s%s $level 0 00] $xcoordinate $ycoordinate $zcoordinate"; # Mass Node 
	if {$level != $Top} {
		RunLog "node [format %s%s%s $level 0 01] $xcoordinate $ycoordinate $zcoordinate"; # Hinge Node
	}
	if {$level != 1} {
		RunLog "node [format %s%s%s $level 0 02] $xcoordinate $ycoordinate $zcoordinate"; # Master Node
	}
}

##############################################################################################################################
#          	  					 Define Nodes for Leaning Column and Rigid Diaphragm	(Not work)		    				 #
##############################################################################################################################

proc NodesForLeaningColumn1 { level XCor YCor ZCor Top } {
	global chanLog;
	set xcoordinate $XCor;
	set ycoordinate [lindex $YCor [expr $level-1]];
	set zcoordinate $ZCor;
	RunLog "node [format %s%s%s $level 0 02] $xcoordinate $ycoordinate $zcoordinate"; # Mass Node & Master Node
	RunLog "node [format %s%s%s $level 0 01] $xcoordinate $ycoordinate $zcoordinate"; # Hinge Node
	
}

##############################################################################################################################
#          	  					 Define Nodes for Leaning Column and Rigid Diaphragm					    				 #
##############################################################################################################################

proc NodesForLeaningColumn { level XCor YCor ZCor Top } {
	global chanLog;
	set xcoordinate $XCor;
	set ycoordinate [lindex $YCor [expr $level-1]];
	set zcoordinate $ZCor;
	# RunLog "node [format %s%s%s $level 0 02] $xcoordinate $ycoordinate $zcoordinate"; #  Mass Node & Master Node 
	if {$level != $Top} {
		RunLog "node [format %s%s%s $level 0 03] $xcoordinate $ycoordinate $zcoordinate"; # hp hinge Node
	}
	if {$level != 1} {
		RunLog "node [format %s%s%s $level 0 01] $xcoordinate $ycoordinate $zcoordinate"; # down hinge node
	}
}
##############################################################################################################################
#          	  								 Define Nodes for Rigid Diaphragm							    				 #
##############################################################################################################################

proc NodesForRigidDiaphram { level XCor YCor ZCor } {
	global chanLog;
	set xcoordinate $XCor;
	set ycoordinate [lindex $YCor [expr $level-1]];
	set zcoordinate $ZCor;
	if {$level != 1} {
		RunLog "node [format %s%s%s $level 0 02] $xcoordinate $ycoordinate $zcoordinate"; # Master Node
	}
}

##############################################################################################################################
#          	  								 Define Element within Panel Zone							    				 #
##############################################################################################################################

proc elemPanelZone3D {eleID nodeR E G S_la VerTransfTag HorTransfTag} {
# elemPanelZone3D.tcl
# Procedure that creates panel zone elements
# 
# The process is based on Gupta 1999
# Reference:  Gupta, A., and Krawinkler, H. (1999). "Seismic Demands for Performance Evaluation of Steel Moment Resisting Frame Structures,"
#            Technical Report 132, The John A. Blume Earthquake Engineering Research Center, Department of Civil Engineering, Stanford University, Stanford, CA.
#
#
# Written by: Dimitrios Lignos
# Date: 11/09/2008
#
# Modified by: Laura Eads
# Date: 1/4/2010
# Modification: changed numbering scheme for panel zone nodes
#
# Modified by: Xiaolei Xiong
# Date: 5/16/2017
# Modification: changed it for 3D modeling
# 
# Formal arguments
#	eleID     - unique element ID for the zero-length rotational spring
#	nodeR     - node ID for first point (top left) of panel zone --> this node creates all the others
#	E         - Young's modulus
#	G         - Shear modulus
#	S_la	  - Large number for J
#   A_PZ	  - area of rigid link that creates the panel zone
#   I_PZ      - moment of inertia of Rigid link that creates the panel zone
#   transfTag - geometric transformation

# define panel zone nodes
	# scan $nodeR {%1d %1d %1d %1d %2d} Y X Z d id;
	global chanLog;
	regexp {[0-9]{3}$} $nodeR did
	regexp {^[0-9]} $did d
	set node01 $nodeR;  			# top left of joint
	set node02 [expr $node01 + 1];	# top left of joint
	set node03 [expr $node01 + 2];	# top right of joint
	set node04 [expr $node01 + 3];	# top right of joint
	set node05 [expr $node01 + 4];	# btm right of joint
	set node06 [expr $node01 + 5];	# btm right of joint
	set node07 [expr $node01 + 6];	# btm left of joint
	set node08 [expr $node01 + 7];	# btm left of joint
	set node09 [expr $node01 + 8];	# middle left of joint (vertical middle, horizontal left)
	set node10 [expr $node01 + 9 - $d*100];	# top center of joint
	set node11 [expr $node01 + 10];	# middle right of joint (vertical middle, horizontal right)
	set node12 [expr $node01 + 11 - $d*100];	# btm center of joint
	
# create element IDs as a function of first input eleID (8 per panel zone)
	set x1 $eleID;			# left element on top of panel zone
	set x2 [expr $x1 + 1];	# right element on top of panel zone
	set x3 [expr $x1 + 2];	# top element on right side of panel zone
	set x4 [expr $x1 + 3];	# btm element on right side of panel zone
	set x5 [expr $x1 + 4];	# right element on btm of panel zone
	set x6 [expr $x1 + 5];	# left element on btm of panel zone
	set x7 [expr $x1 + 6];	# btm element on left side of panel zone
	set x8 [expr $x1 + 7];	# top element on left side of panel zone
	
	set A_PZ 1.0e5;	# area of panel zone element (make much larger than A of frame elements)
	set Ipz 1.0e8;  # moment of intertia of panel zone element (make much larger than I of frame elements)

# create panel zone elements
	#                            tag	ndI		ndJ		A_PZ	E	G	J		I_PZ	I_PZ	transfTag
	RunLog "element elasticBeamColumn    $x1	$node02	$node10	$A_PZ	$E	$G	$S_la	$Ipz	$Ipz	$HorTransfTag";
	RunLog "element elasticBeamColumn    $x2	$node10	$node03	$A_PZ	$E	$G	$S_la	$Ipz	$Ipz	$HorTransfTag";
	RunLog "element elasticBeamColumn    $x3	$node04	$node11	$A_PZ	$E	$G	$S_la	$Ipz	$Ipz	$VerTransfTag";
	RunLog "element elasticBeamColumn    $x4	$node11	$node05	$A_PZ	$E	$G	$S_la	$Ipz	$Ipz	$VerTransfTag";
	RunLog "element elasticBeamColumn    $x5	$node06	$node12	$A_PZ	$E	$G	$S_la	$Ipz	$Ipz	$HorTransfTag";
	RunLog "element elasticBeamColumn    $x6	$node12	$node07	$A_PZ	$E	$G	$S_la	$Ipz	$Ipz	$HorTransfTag";
	RunLog "element elasticBeamColumn    $x7	$node08	$node09	$A_PZ	$E	$G	$S_la	$Ipz	$Ipz	$VerTransfTag";
	RunLog "element elasticBeamColumn    $x8	$node09	$node01	$A_PZ	$E	$G	$S_la	$Ipz	$Ipz	$VerTransfTag";
}

##############################################################################################################################
#          	  								 Write RigidDiaphragm Command								    				 #
##############################################################################################################################

proc RigidDiaphragmCommand { level ColPier perpDirn} {
	set Commands [list rigidDiaphragm $perpDirn];
	set MasterNodeID [format %s%s%s $level 0 02];
	lappend Commands $MasterNodeID
	foreach iColPier $ColPier {
		set Y $level;
		set X [lindex $iColPier 0];
		set Z [lindex $iColPier 1];
		lappend Commands [format %s%s%s%s%s $Y $X $Z 1 09];
		lappend Commands [format %s%s%s%s%s $Y $X $Z 2 09];
		lappend Commands [format %s%s%s%s%s $Y $X $Z 1 11];
		lappend Commands [format %s%s%s%s%s $Y $X $Z 2 11];
	}
	return $Commands
	# set MassNodeID [format %s%s%s $level 0 00];
	# lappend Commands $MassNodeID
}

##############################################################################################################################
#          	  							 Write RigidDiaphragm Command for no-panelzone model			    				 #
##############################################################################################################################

proc RigidDiaphragmCommand1 { level ColPier perpDirn} {
	set Commands [list rigidDiaphragm $perpDirn];
	set MasterNodeID [format %s%s%s $level 0 02];
	lappend Commands $MasterNodeID
	foreach iColPier $ColPier {
		set Y $level;
		set X [lindex $iColPier 0];
		set Z [lindex $iColPier 1];
		lappend Commands [format %s%s%s%s%s $Y $X $Z 0 19];
		# lappend Commands [format %s%s%s%s%s $Y $X $Z 1 09];
		# lappend Commands [format %s%s%s%s%s $Y $X $Z 2 09];
		# lappend Commands [format %s%s%s%s%s $Y $X $Z 1 11];
		# lappend Commands [format %s%s%s%s%s $Y $X $Z 2 11];
	}
	return $Commands
	# set MassNodeID [format %s%s%s $level 0 00];
	# lappend Commands $MassNodeID
}
		
##############################################################################################################################
#          	  						 Write Beam Data Input for Matlab Processing						    				 #
##############################################################################################################################

proc BeamData { NLevel XPier ZPier LGrid BeamSecs SectionLevel E Fy } {		
	global Longspan;	#longspan means the times of interior long span to short span.
	global baseDir;
	set XBeamData ""
	set ZBeamData ""
	set MatProp [list $E $Fy];
	for {set level 2} {$level <= $NLevel} {incr level} {
		# write Xbeam data
		for {set zline 1} {$zline <= $ZPier} {incr zline} {
			set bname [BeamSectionName $level $zline $BeamSecs $SectionLevel $ZPier 1];
			set SecProp [WFProp $bname];
			if {$zline == 1 || $zline == $ZPier} {
				for {set xbay 1} {$xbay <= [expr $XPier - 1]} {incr xbay 1} {
					set LocSecName [list $level $zline $xbay $LGrid $LGrid];
					set iXBeamData [concat $LocSecName $SecProp $MatProp]; 
					lappend XBeamData $iXBeamData;
				}
			} else {
			for {set xbay 1} {$xbay <= [expr ($XPier - 1)/$Longspan]} {incr xbay 1} {
				set LocSecName [list $level $zline $xbay [expr $Longspan*$LGrid] [expr $Longspan*$LGrid]];
				set iXBeamData [concat $LocSecName $SecProp $MatProp]; 
				lappend XBeamData $iXBeamData;
				}
			}
		}
		# write Zbeam data
		for {set xline 1} {$xline <= $XPier} {incr xline $Longspan} {
			set bname [BeamSectionName $level $xline $BeamSecs $SectionLevel $XPier 2];
			set SecProp [WFProp $bname];
			if {$xline == 1 || $xline == $XPier} {
				for {set zbay 1} {$zbay <= [expr $ZPier - 1]} {incr zbay 1} {
					set LocSecName [list $level $xline $zbay $LGrid $LGrid];
					set iZBeamData [concat $LocSecName $SecProp $MatProp]; 
					lappend ZBeamData $iZBeamData;
				}
			} else {
			for {set zbay 1} {$zbay <= [expr $ZPier - 1]} {incr zbay 1} {
				set LocSecName [list $level $xline $zbay $LGrid $LGrid];
				set iZBeamData [concat $LocSecName $SecProp $MatProp]; 
				lappend ZBeamData $iZBeamData;
				}
			}
		}
	}
	
	cd ../DataFile
	set AddPath [pwd];
	set AddFile $AddPath/BeamData.txt

	if {[catch {set File_BeamData [open $AddFile w+]} err_msg]} {
		puts "Failed to open the file for editing: $err_msg"
		return
	}
	puts $File_BeamData "#XBeamData"
	foreach iline $XBeamData {
		puts $File_BeamData $iline;
	}
	puts $File_BeamData "#ZBeamData"
	foreach iline $ZBeamData {
		puts $File_BeamData $iline;
	} 
	close  $File_BeamData
	
	cd $baseDir
	# return $ZBeamData
}

##############################################################################################################################
#          	  						 Write Building Data Input for Matlab Processing						   				 #
##############################################################################################################################

proc BuildingData {} {	

	global NStory
	global NLobby
	global NBase
	global ZBay
	global XBay
	global NLevel
	global SpliceStory
	# global ColPier
	global StoryHeight
	global SectionLevel
	global LoadLevel
	global YCor
	global XCor
	global ZCor
	global Longspan
	# global E
	# global Ps
	# global G
	# global BeamFy
	# global ColumnFy
	# global RoSteel
	

	# set NoNStory 1
	# set NoNLobby 2
	# set NoNBase	3
	# set NoZBay 4
	# set NoXBay 5
	# set NoNLevel 6
	# set NoSpliceStory 7
	# set NoColPier 8
	# set NoStoryHeight 9
	# set NoSectionLevel 10
	# set NoLoadLevel 11
	# set NoYCor 12
	# set NoXCor 13
	# set NoZCor 14 
	# # set NoLongspan 15
	# # set NoE	16
	# # set NoPs 17
	# # set NoG 18
	# # set NoBeamFy 19
	# # set NoColumnFy 20 
	# # set NoRoSteel 21
	
	global baseDir;
	
	cd ../DataFile
	set AddPath [pwd];
	set AddFile $AddPath/BuildingData.txt
	if {[catch {set File_BuildingData [open $AddFile w+]} err_msg]} {
		puts "Failed to open the file for editing: $err_msg"
		return
	}
	set conts [format %s%s%s "NStorey:" "\t" $NStory]
	puts $File_BuildingData $conts
	set conts [format %s%s%s "NLobby:" "\t" $NLobby]
	puts $File_BuildingData $conts
	set conts [format %s%s%s "NBase:" "\t" $NBase]
	puts $File_BuildingData $conts
	set conts [format %s%s%s "ZBay:" "\t" $ZBay]
	puts $File_BuildingData $conts
	set conts [format %s%s%s "XBay:" "\t" $XBay]
	puts $File_BuildingData $conts
	set conts [format %s%s%s "NLevel:" "\t" $NLevel]
	puts $File_BuildingData $conts	
	set conts [format %s%s%s "Longspan:" "\t" $Longspan]  
	puts $File_BuildingData $conts
	set conts [format %s%s%s "SpliceStory:" "\t" $SpliceStory]
	puts $File_BuildingData $conts
	# set conts [format %s%s%s "ColPier:" "\t" $ColPier]
	# puts $File_BuildingData $conts
	set conts [format %s%s%s "StoryHeight:" "\t" $StoryHeight]
	puts $File_BuildingData $conts
	set conts [format %s%s%s "SectionLevel:" "\t" $SectionLevel]
	puts $File_BuildingData $conts
	set conts [format %s%s%s "LoadLevel:" "\t" $LoadLevel]
	puts $File_BuildingData $conts
	set conts [format %s%s%s "XCor:" "\t" $XCor]
	puts $File_BuildingData $conts
	set conts [format %s%s%s "YCor:" "\t" $YCor]
	puts $File_BuildingData $conts	
	set conts [format %s%s%s "ZCor:" "\t" $ZCor]
	puts $File_BuildingData $conts		
	close  $File_BuildingData
	
	cd $baseDir	
	
	
	# [open dd.txt w+]
	# set File_BuildingData [open dd.txt w+]
	
	# set ColumnData ""
	# set MatProp [list $E $Fy];
	# for {set level 2} {$level <= $NLevel} {incr level} {
		# set h [lindex $StoryHeight [expr $level - 2]];
		# foreach iColPier $ColPier {
			# set x [lindex $iColPier 0];
			# set z [lindex $iColPier 1];
			# set cname [ColumnSectionName $level $iColPier $ColumnSecs $SectionLevel $XPier $ZPier];
			# set SecProp [BoxProp $cname];
			# set LocSecName [list $level $x $z $h $h];
			# set iColumnData [concat $LocSecName $SecProp $MatProp]; 
			# lappend ColumnData $iColumnData;
		# }			
	# }
	

	# puts $File_ColumnData "#ColumnData"
	# foreach iline $ColumnData {
		# puts $File_ColumnData $iline;
	# }
}

##############################################################################################################################
#          	  						 Write Column Data Input for Matlab Processing						    				 #
##############################################################################################################################

proc ColumnData { NLevel XPier ZPier ColPier StoryHeight ColumnSecs SectionLevel E Fy} {		
	global Longspan;	#longspan means the times of interior long span to short span.
	global baseDir;
	set ColumnData ""
	set MatProp [list $E $Fy];
	for {set storey 1} {$storey <= [expr $NLevel - 1]} {incr storey} {
		set h [lindex $StoryHeight [expr $storey - 1]];
		foreach iColPier $ColPier {
			set x [lindex $iColPier 0];
			set z [lindex $iColPier 1];
			set cname [ColumnSectionName [expr $storey + 1] $iColPier $ColumnSecs $SectionLevel $XPier $ZPier];
			set SecProp [BoxProp $cname];
			set LocSecName [list $storey $x $z $h $h];
			set iColumnData [concat $LocSecName $SecProp $MatProp]; 
			lappend ColumnData $iColumnData;
		}			
	}
	
	cd ../DataFile
	set AddPath [pwd];
	set AddFile $AddPath/ColumnData.txt
	
	if {[catch {set File_ColumnData [open $AddFile w+]} err_msg]} {
		puts "Failed to open the file for editing: $err_msg"
		return
	}
	puts $File_ColumnData "#ColumnData"
	foreach iline $ColumnData {
		puts $File_ColumnData $iline;
	}
	close  $File_ColumnData
	
	cd $baseDir	
}

##############################################################################################################################
#          	  									 identify the ColPositionID								    				 #
##############################################################################################################################

proc ColPositionID {iCol XPier ZPier} {
	# ###################################################################
	# ColPositionID  $iCol $XPier $ZPier
	# ###################################################################
	# identify the ColPositionID
	# iCol = a list of column coordinates 
	# XPier = number of piers in X direction
	# ZPier = number of piers in Z direction  
	# ColPositionID = 0, means corner column
	# ColPositionID = 1, means perimeter column in X direction
	# ColPositionID = 2, means perimeter column in Z direction
	# ColPositionID = 3, means inner column
	
	set ColPositionID "Input is wrong!"
	set X [lindex $iCol 0];
	set Z [lindex $iCol 1];
	if {($X == 1||$X == $XPier)&&($Z == 1||$Z == $ZPier)} {
		set ColPositionID 0
	} elseif {$Z == 1||$Z == $ZPier} {
		set ColPositionID 1
	} elseif {$X == 1||$X == $XPier} {
		set ColPositionID 2
	} else {
		set ColPositionID 3
	}
			
	return $ColPositionID
}

##############################################################################################################################
#          	  											 Max Drift Tester 								    				 #
##############################################################################################################################

proc MaxDriftTesterBiDirection {numStories DriftLimit FloorNodes StoreyHeight} {

# Procedure that checks if the drift is maximum for Collapse
# Calls the floor displacements of the structure and checks if they exceed the drift
# Collapse limit
#
# Developed by Dimitrios G. Lignos, Ph.D
# Reedited by Xiaolei
# First Created: 04/20/2010
# Last Modified: 10/03/2017
#
# #######################################################################################

# global DriftCautionFlag
set DriftCautionFlag "NO"

# Initializing Drift list
set Drift ""
set MAXDrift $DriftLimit

# Checking X-Direction Drifts 
for {set i 0} { $i<=$numStories-1} {incr i} {
	if { $i == 0 } {
	    set Node [lindex $FloorNodes $i]
		set NodeDisplI [nodeDisp $Node 1]
		set iSHeight [lindex $StoreyHeight $i]
		set SDR [expr $NodeDisplI/$iSHeight]
		lappend Drift [list $SDR]

   } elseif { $i > 0 } {
	    set NodeI [lindex $FloorNodes $i]
		set NodeDisplI [nodeDisp $NodeI 1]
		set NodeJ [lindex $FloorNodes [expr $i-1]]
		set NodeDisplJ [nodeDisp $NodeJ 1]
		set iSHeight [lindex $StoreyHeight $i]
		set SDR [expr ($NodeDisplI - $NodeDisplJ)/$iSHeight]
		lappend Drift [list  $SDR]

	}
} 

# set MaxValue 0;

for { set h 0 } { $h <= $numStories-1} {incr h} {
	set TDrift [lindex $Drift [expr $h]]
	set TDrift [expr abs( $TDrift )]
	# if { $TDrift > $MaxValue } {
		# set MaxValue $TDrift;
	# }
	if { $TDrift > $MAXDrift } {
		set DriftCautionFlag "YES"
		# puts "Collapse in Direction X"
	}
}

if  {$DriftCautionFlag == "NO"} {

	 # Initializing Drift list
	set Drift ""
 
	 # Checking Z-Direction Drifts 
	 for {set i 0} { $i<=$numStories-1} {incr i} {
		if { $i == 0 } {
			set Node [lindex $FloorNodes $i]
			set NodeDisplI [nodeDisp $Node 3]
			set iSHeight [lindex $StoreyHeight $i]
			set SDR [expr $NodeDisplI/$iSHeight]
			lappend Drift [list $SDR]

		} elseif { $i > 0 } {
			set NodeI [lindex $FloorNodes $i]
			set NodeDisplI [nodeDisp $NodeI 3]
			set NodeJ [lindex $FloorNodes [expr $i-1]]
			set NodeDisplJ [nodeDisp $NodeJ 3]
			set iSHeight [lindex $StoreyHeight $i]
			set SDR [expr ($NodeDisplI - $NodeDisplJ)/$iSHeight]
			lappend Drift [list  $SDR]

		}
	 } 
	

	for { set h 0 } { $h <= $numStories-1} {incr h} {
		set TDrift [ lindex $Drift [expr $h] ]
		set TDrift [expr abs( $TDrift )]
		# if { $TDrift > $MaxValue } {
			# set MaxValue $TDrift;
		# }
		if { $TDrift > $MAXDrift } {
			set DriftCautionFlag "YES"
			# puts "Collapse in Direction Z"
		}
	}
}

return $DriftCautionFlag
}


##############################################################################################################################
#          	  											 Max Drift  Calculator							    				 #
##############################################################################################################################

proc MaxDrift {numStories FloorNodes StoreyHeight} {

# Procedure that checks if the drift is maximum for Collapse
# Calls the floor displacements of the structure and checks if they exceed the drift
# Collapse limit
#
# Developed by Dimitrios G. Lignos, Ph.D
# Reedited by Xiaolei
# First Created: 04/20/2010
# Last Modified: 10/03/2017
#
# #######################################################################################

# global DriftCautionFlag
# set DriftCautionFlag "NO"

# Initializing Drift list
set Drift ""
set MaxValue 0;
# set MAXDrift $DriftLimit

# Checking X-Direction Drifts 
for {set i 0} { $i<=$numStories-1} {incr i} {
	if { $i == 0 } {
	    set Node [lindex $FloorNodes $i]
		set NodeDisplI [nodeDisp $Node 1]
		set iSHeight [lindex $StoreyHeight $i]
		set SDR [expr $NodeDisplI/$iSHeight]
		lappend Drift [list $SDR]

   } elseif { $i > 0 } {
	    set NodeI [lindex $FloorNodes $i]
		set NodeDisplI [nodeDisp $NodeI 1]
		set NodeJ [lindex $FloorNodes [expr $i-1]]
		set NodeDisplJ [nodeDisp $NodeJ 1]
		set iSHeight [lindex $StoreyHeight $i]
		set SDR [expr ($NodeDisplI - $NodeDisplJ)/$iSHeight]
		lappend Drift [list  $SDR]

	}
} 



for { set h 0 } { $h <= $numStories-1} {incr h} {
	set TDrift [lindex $Drift [expr $h]]
	set TDrift [expr abs( $TDrift )]
	if { $TDrift > $MaxValue } {
		set MaxValue $TDrift;
		set Dir X;
	}	
}

set Drift ""
# Checking Z-Direction Drifts 
for {set i 0} { $i<=$numStories-1} {incr i} {
	if { $i == 0 } {
		set Node [lindex $FloorNodes $i]
		set NodeDisplI [nodeDisp $Node 3]
		set iSHeight [lindex $StoreyHeight $i]
		set SDR [expr $NodeDisplI/$iSHeight]
		lappend Drift [list $SDR]
	
	} elseif { $i > 0 } {
		set NodeI [lindex $FloorNodes $i]
		set NodeDisplI [nodeDisp $NodeI 3]
		set NodeJ [lindex $FloorNodes [expr $i-1]]
		set NodeDisplJ [nodeDisp $NodeJ 3]
		set iSHeight [lindex $StoreyHeight $i]
		set SDR [expr ($NodeDisplI - $NodeDisplJ)/$iSHeight]
		lappend Drift [list  $SDR]
	
	}
}
	
for { set h 0 } { $h <= $numStories-1} {incr h} {
	set TDrift [lindex $Drift [expr $h]]
	set TDrift [expr abs( $TDrift )]
	if { $TDrift > $MaxValue } {
		set MaxValue $TDrift;
		set Dir Z;
	}	
}

set DriftData [list $MaxValue $Dir];

return $DriftData
}

#还没有修改好
##############################################################################################################################
#          	  							 Extract BiDirectional Max Drift								    				 #
##############################################################################################################################

proc ExtractBiDirectionalMaxDrift3DModel {numStories pathToOutputFile} {

# Procedure that extracts the maximum story drift
#
# Developed by Henry Burton
#
# First Created: 09/22/2013
# 
#
# #######################################################################################
 
 global maximumXStoryDrift
 global maximumZStoryDrift
 set maximumXStoryDrift 0.0
 set maximumZStoryDrift 0.0
 cd $pathToOutputFile/StoreyDrifts
 
# Maximum X-Story Drift
for {set story 1} { $story<=$numStories} {incr story} {
	if {$y<10} {
		set FileName [format %s%s%s NodeX_ColumnDrifts_Storey0 $y .out];
	} else {
		set FileName [format %s%s%s NodeX_ColumnDrifts_Storey $y .out];
	}
	set maxDriftOutputFile [open $FileName r];
	# 数据提取须重新设置读取格式
	while {[gets $maxDriftOutputFile line] >= 0} {
		set drift [lindex $line 1];
		if {[expr abs($drift)]  > $maximumXStoryDrift} {
			set maximumXStoryDrift [expr abs($drift)];
		}
	}
	close $maxDriftOutputFile
}

# Maximum Z-Story Drift
for {set story 1} { $story<=$numStories} {incr story} {
	if {$y<10} {
		set FileName [format %s%s%s NodeZ_ColumnDrifts_Storey0 $y .out];
	} else {
		set FileName [format %s%s%s NodeZ_ColumnDrifts_Storey $y .out];
	}
	set maxDriftOutputFile [open $FileName r];			
	while {[gets $maxDriftOutputFile line] >= 0} {
		set drift [lindex $line 1];
		if {[expr abs($drift)]  > $maximumZStoryDrift} {
			set maximumZStoryDrift [expr abs($drift)];
		}
	}
	close $maxDriftOutputFile
}
}

##############################################################################################################################
#          	  						 		Run IDA for Collapse Point	(Not used)						    				 #
##############################################################################################################################

# Procedure that run IDA for collapse point
#
# Developed by Xiaolei Xiong
#
# First Created: 08/6/2017
#  
# initialGroundMotionScaleIncrement 初始GM比例,也是首次比例递增的增幅
#
# IncrementScaleTimes 比例变化时，本次比例与上次比例的比值
#
# Iteration 迭代次数，即比例缩小的次数,1次代表比例恒定不缩小
#
# currentGrounMotionScaleIncrement 当前比例增量
#
# BfreducedGroundMotionScaleIncrement 缩减前GM使用比例
#
# reducedGroundMotionScaleIncrement 缩减后GM使用比例
#
# scale 当前计算GM使用比例
#
# #######################################################################################
proc RunIDAforCollapsePoint {collapseDriftLimit initialGroundMotionScaleIncrement IncrementScaleTimes Iteration } {
	# Run IDA until collapse response parameter limit is exceeded
	global GM_dt dtAn GMtime NStories DriftLimit RigidDiaphNodeItem StoryHeight firstTimeCheck
	for {set i 1} {$i <= $Iteration} {incr i} { 
		if {$i == 1} {
			set reducedGroundMotionScaleIncrement $initialGroundMotionScaleIncrement;
			set currentGrounMotionScale $initialGroundMotionScaleIncrement;
		} else {
			set reducedGroundMotionScaleIncrement [expr  $initialGroundMotionScaleIncrement*$IncrementScaleTimes**($i - 1)];
			# Reduce ground motion scale to obtain refined estimate of collapse scale
			# set currentGrounMotionScale [expr $currentGrounMotionScale - 2*$BfreducedGroundMotionScaleIncrement + $reducedGroundMotionScaleIncrement];
			set currentGrounMotionScale [expr $currentGrounMotionScale - 1*$BfreducedGroundMotionScaleIncrement + $reducedGroundMotionScaleIncrement];
		}
		
		set currentGrounMotionScaleIncrement $reducedGroundMotionScaleIncrement;
		
		# Initialize response parameters used to check for collapse
		set maximumXStoryDrift 0.0;	
		set maximumZStoryDrift 0.0;
		
		while {$maximumZStoryDrift <  $collapseDriftLimit && $maximumXStoryDrift <  $collapseDriftLimit} {
			# Define current scale to run	
			set scale $currentGrounMotionScale;
			# Sourcing model to run	
			puts "********************************************************************************"
			puts "         Ground Motion Pairs $runNumber(Scale:$scale) starts to run             "
			puts "********************************************************************************"
			source D4_BuildDynamicAnalysisModel.tcl
			source E4_PerformDynamicAnalysisBiDirectionCollapseSolver.tcl
			# input Motion  simul. step  duration NStories Drift Limit    List Nodes    StoryH 1   StoryH Typical    Analysis Start Time
			E4_PerformDynamicAnalysisBiDirectionCollapseSolver $GM_dt $dtAn $GMtime $NStories $DriftLimit $RigidDiaphNodeItem $StoryHeight $firstTimeCheck
			puts "********************************************************************************"
			puts "          Ground Motion Pairs $runNumber(Scale:$scale) finished                 "
			puts "********************************************************************************"
			# wipe;
			# Defining path to output data for current model
			set pathToOutputFile $baseDir/$dataDir/EQ_$eqNumber/Scale_[format "%i" $scale]
							
			# Extracting global EDPs
			# Extracting maximum story drift
			ExtractBiDirectionalMaxDrift3DModel $NStories $numColumnsPerStory $pathToOutputFile	
			
			# Updating vectors used to store relevant response parameters
			if {$maximumZStoryDrift <  $collapseDriftLimit && $maximumXStoryDrift <  $collapseDriftLimit} {
				lappend listOfScalesRun $scale;	
				lappend listOfMaximumXStoryDrifts $maximumXStoryDrift;
				lappend listOfMaximumZStoryDrifts $maximumZStoryDrift;			
			}
			set currentGrounMotionScale [expr $currentGrounMotionScale + $currentGrounMotionScaleIncrement];
		}
		
		set BfreducedGroundMotionScaleIncrement $currentGrounMotionScaleIncrement;
	}
}

##############################################################################################################################
#          	  						 		Algorithm and Test (Not used)								    				 #
##############################################################################################################################

proc AlgorithmSwift { step } {
	algorithm Newton 
	set ok [analyze 1 ];
	if {$ok == 0} { 
		puts [format "Step %s is done, Algorithm (Newton without Initial Tangent) succeed .." $step];
		return $ok
	} 
	
	algorithm 
	set ok [analyze 1 ];
	if {$ok == 0} { 
		puts [format "Step %s is done, Algorithm () succeed .." $step];
		return $ok
	} 
	
	algorithm Newton -initial
	set ok [analyze 1 ];
	if {$ok == 0} { 
		puts [format "Step %s is done, Algorithm (Newton with Initial Tangent) succeed .." $step];
		return $ok
	} 
	
	algorithm NewtonLineSearch .8
	set ok [analyze 1 ];
	if {$ok == 0} { 
		puts [format "Step %s is done, Algorithm (NewtonLineSearch .8) succeed .." $step];
		return $ok
	} 
	
	algorithm NewtonLineSearch .75
	set ok [analyze 1 ];
	if {$ok == 0} { 
		puts [format "Step %s is done, Algorithm (NewtonLineSearch .75) succeed .." $step];
		return $ok
	} 
	
	algorithm NewtonLineSearch .5
	set ok [analyze 1 ];
	if {$ok == 0} { 
		puts [format "Step %s is done, Algorithm (NewtonLineSearch .5) succeed .." $step];
		return $ok
	} 
	
	algorithm KrylovNewton
	set ok [analyze 1 ];
	if {$ok == 0} { 
		puts [format "Step %s is done, Algorithm (KrylovNewton 3) succeed .." $step];
		return $ok
	} 
	
	algorithm KrylovNewton -maxDim 5
	set ok [analyze 1 ];
	if {$ok == 0} { 
		puts [format "Step %s is done, Algorithm (KrylovNewton -maxDim 5) succeed .." $step];
		return $ok
	} 
	
	algorithm Broyden 5
	set ok [analyze 1 ];
	if {$ok == 0} { 
		puts [format "Step %s is done, Algorithm (Broyden 5) succeed .." $step];
		return $ok
	} 
	
	algorithm Broyden 10
	set ok [analyze 1 ];
	if {$ok == 0} { 
		puts [format "Step %s is done, Algorithm (Broyden 10) succeed .." $step];
		return $ok
	} 
	
	algorithm SecantNewton 
	set ok [analyze 1 ];
	if {$ok == 0} { 
		puts [format "Step %s is done, Algorithm (SecantNewton) succeed .." $step];
		return $ok
	} 
	
	algorithm SecantNewton -maxDim 5
	set ok [analyze 1 ];
	if {$ok == 0} { 
		puts [format "Step %s is done, Algorithm (SecantNewton -maxDim 5) succeed .." $step];
		return $ok
	} 
	
	algorithm BFGS
	set ok [analyze 1 ];
	if {$ok == 0} { 
		puts [format "Step %s is done, Algorithm (BFGS) succeed .." $step];
		return $ok
	} 
	
	
	puts "All algorithms fail .."
	return $ok
}

##############################################################################################################################
#          	  				 		Run 5 steps	Algorithm and Test(system SparseSYM)					    				 #
##############################################################################################################################

proc AlgorithmSwitch { ModeNumSteps remainTime CuAn_dt intl_Tol incrFactor_Tol intl_MaxNumIter incr_MaxNumIter changingtimes } {
	
	# global DriftCautionFlag
	# global CollapseFlag
	# global ok
	
	set changingCount 1;
	
	while {$changingCount <= $changingtimes} {
	
		set CCuAn_dt [expr $CuAn_dt/pow(2,$changingCount)];
		set Tol [expr $intl_Tol*$incrFactor_Tol**$changingCount];
		set MaxNumIter [expr $intl_MaxNumIter+$incr_MaxNumIter*$changingCount];
		set TestType NormDispIncr
		test $TestType $Tol $MaxNumIter 0;
		set NewRemainSteps [expr round(($remainTime)/($CCuAn_dt))];
		if {$NewRemainSteps < 1} {
			set NewRemainSteps 1;}
		set CCuRunStep [expr min($NewRemainSteps,$ModeNumSteps)];
		
		
		algorithm Newton 
		set ok [analyze $CCuRunStep $CCuAn_dt];
		if {$ok == 0} { 
			set controlTime [getTime]
			puts "**********************************\n** Algorithm = Newton\n** Time Step = [format {%0.2e} $CCuAn_dt]\n** Steps to run = [format {%0.0f} $CCuRunStep]\n** Tolerance = [format {%0.1e} $Tol]\n** Ok = $ok\n** ControlTime = $controlTime\n**********************************\n"
			return $ok
		} 
		
		
		algorithm Newton -initial
		set ok [analyze $CCuRunStep $CCuAn_dt];
		if {$ok == 0} { 
			set controlTime [getTime]
			puts "**********************************\n** Algorithm = Newton -initial\n** Time Step = [format {%0.2e} $CCuAn_dt]\n** Steps to run = [format {%0.0f} $CCuRunStep]\n** Tolerance = [format {%0.1e} $Tol]\n** Ok = $ok\n** ControlTime = $controlTime\n**********************************\n"
			return $ok
		} 
		
		algorithm NewtonLineSearch .8
		set ok [analyze $CCuRunStep $CCuAn_dt];
		if {$ok == 0} { 
			set controlTime [getTime]
			puts "**********************************\n** Algorithm = NewtonLineSearch .75\n** Time Step = [format {%0.2e} $CCuAn_dt]\n** Steps to run = [format {%0.0f} $CCuRunStep]\n** Tolerance = [format {%0.1e} $Tol]\n** Ok = $ok\n** ControlTime = $controlTime\n**********************************\n"
			return $ok
		}
		
		algorithm NewtonLineSearch .5
		set ok [analyze $CCuRunStep $CCuAn_dt];
		if {$ok == 0} { 
			set controlTime [getTime]
			puts "**********************************\n** Algorithm = NewtonLineSearch .5\n** Time Step = [format {%0.2e} $CCuAn_dt]\n** Steps to run = [format {%0.0f} $CCuRunStep]\n** Tolerance = [format {%0.1e} $Tol]\n** Ok = $ok\n** ControlTime = $controlTime\n**********************************\n"
			return $ok
		}
		
		algorithm KrylovNewton
		set ok [analyze $CCuRunStep $CCuAn_dt];
		if {$ok == 0} { 
			set controlTime [getTime]
			puts "**********************************\n** Algorithm = KrylovNewton\n** Time Step = [format {%0.2e} $CCuAn_dt]\n** Steps to run = [format {%0.0f} $CCuRunStep]\n** Tolerance = [format {%0.1e} $Tol]\n** Ok = $ok\n** ControlTime = $controlTime\n**********************************\n"
			return $ok
		}
		
		algorithm KrylovNewton -maxDim 5
		set ok [analyze $CCuRunStep $CCuAn_dt];
		if {$ok == 0} { 
			set controlTime [getTime]
			puts "**********************************\n** Algorithm = KrylovNewton -maxDim 5\n** Time Step = [format {%0.2e} $CCuAn_dt]\n** Steps to run = [format {%0.0f} $CCuRunStep]\n** Tolerance = [format {%0.1e} $Tol]\n** Ok = $ok\n** ControlTime = $controlTime\n**********************************\n"
			return $ok
		}
		
		algorithm Broyden 5
		set ok [analyze $CCuRunStep $CCuAn_dt];
		if {$ok == 0} { 
			set controlTime [getTime]
			puts "**********************************\n** Algorithm = Broyden 5\n** Time Step = [format {%0.2e} $CCuAn_dt]\n** Steps to run = [format {%0.0f} $CCuRunStep]\n** Tolerance = [format {%0.1e} $Tol]\n** Ok = $ok\n** ControlTime = $controlTime\n**********************************\n"
			return $ok
		}

		algorithm Broyden 10
		set ok [analyze $CCuRunStep $CCuAn_dt];
		if {$ok == 0} { 
			set controlTime [getTime]
			puts "**********************************\n** Algorithm = Broyden 10\n** Time Step = [format {%0.2e} $CCuAn_dt]\n** Steps to run = [format {%0.0f} $CCuRunStep]\n** Tolerance = [format {%0.1e} $Tol]\n** Ok = $ok\n** ControlTime = $controlTime\n**********************************\n"
			return $ok
		}
		
		algorithm SecantNewton 
		set ok [analyze $CCuRunStep $CCuAn_dt];
		if {$ok == 0} { 
			set controlTime [getTime]
			puts "**********************************\n** Algorithm = SecantNewton\n** Time Step = [format {%0.2e} $CCuAn_dt]\n** Steps to run = [format {%0.0f} $CCuRunStep]\n** Tolerance = [format {%0.1e} $Tol]\n** Ok = $ok\n** ControlTime = $controlTime\n**********************************\n"
			return $ok
		} 
		
		algorithm SecantNewton -maxDim 5
		set ok [analyze $CCuRunStep $CCuAn_dt];
		if {$ok == 0} { 
			set controlTime [getTime]
			puts "**********************************\n** Algorithm = SecantNewton -maxDim 5\n** Time Step = [format {%0.2e} $CCuAn_dt]\n** Steps to run = [format {%0.0f} $CCuRunStep]\n** Tolerance = [format {%0.1e} $Tol]\n** Ok = $ok\n** ControlTime = $controlTime\n**********************************\n"
			return $ok
		} 
		
		algorithm BFGS
		set ok [analyze $CCuRunStep $CCuAn_dt];
		if {$ok == 0} { 
			set controlTime [getTime]
			puts "**********************************\n** Algorithm = BFGS\n** Time Step = [format {%0.2e} $CCuAn_dt]\n** Steps to run = [format {%0.0f} $CCuRunStep]\n** Tolerance = [format {%0.1e} $Tol]\n** Ok = $ok\n** ControlTime = $controlTime\n**********************************\n"
			return $ok
		}
		
		integrator HHTHSIncrReduct 0.5 0.95
		algorithm NewtonLineSearch 0.75
		set ok [analyze $CCuRunStep $CCuAn_dt];
		if {$ok == 0} { 
			set controlTime [getTime]
			puts "**********************************\n** Integrator = HHTHSIncrReduct\n** Algorithm = NewtonLineSearch 0.75\n** Time Step = [format {%0.2e} $CCuAn_dt]\n** Steps to run = [format {%0.0f} $CCuRunStep]\n** Tolerance = [format {%0.1e} $Tol]\n** Ok = $ok\n** ControlTime = $controlTime\n**********************************\n"
			return $ok
		}
		
		integrator HHTHSIncrReduct 0.5 0.95
		algorithm KrylovNewton
		set ok [analyze $CCuRunStep $CCuAn_dt];
		if {$ok == 0} { 
			set controlTime [getTime]
			puts "**********************************\n** Integrator = HHTHSIncrReduct\n** Algorithm = KrylovNewton\n** Time Step = [format {%0.2e} $CCuAn_dt]\n** Steps to run = [format {%0.0f} $CCuRunStep]\n** Tolerance = [format {%0.1e} $Tol]\n** Ok = $ok\n** ControlTime = $controlTime\n**********************************\n"
			return $ok
		}
		
		integrator HHTHSIncrReduct 0.5 0.95
		algorithm KrylovNewton -initial
		set ok [analyze $CCuRunStep $CCuAn_dt];
		if {$ok == 0} { 
			set controlTime [getTime]
			puts "**********************************\n** Integrator = HHTHSIncrReduct\n** Algorithm = KrylovNewton -initial\n** Time Step = [format {%0.2e} $CCuAn_dt]\n** Steps to run = [format {%0.0f} $CCuRunStep]\n** Tolerance = [format {%0.1e} $Tol]\n** Ok = $ok\n** ControlTime = $controlTime\n**********************************\n"
			return $ok
		}
		
		integrator HHTHSIncrReduct 0.5 0.95
		algorithm BFGS
		set ok [analyze $CCuRunStep $CCuAn_dt];
		if {$ok == 0} { 
			set controlTime [getTime]
			puts "**********************************\n** Integrator = HHTHSIncrReduct\n** Algorithm = BFGS\n** Time Step = [format {%0.2e} $CCuAn_dt]\n** Steps to run = [format {%0.0f} $CCuRunStep]\n** Tolerance = [format {%0.1e} $Tol]\n** Ok = $ok\n** ControlTime = $controlTime\n**********************************\n"
			return $ok
		}

		set changingCount [expr $changingCount+1];

	}
	# set DriftCautionFlag [MaxDriftTesterBiDirection $NStories $ModeCheckDrift $RigidDiaphNodeItem $StoryHeight];
	# set CollapseFlag [MaxDriftTesterBiDirection $NStories $DriftLimit $RigidDiaphNodeItem $StoryHeight];
	return $ok	
	
}

##############################################################################################################################
#          	  				 				Algorithm switch for static analysis						    				 #
##############################################################################################################################

proc POAlgorithmSwitch { RunStep {Atype 0} } {
	
	# global DriftCautionFlag
	# global CollapseFlag
	# global ok
	if {$Atype != 0 } {
		switch $Atype {
			1	{algorithm Newton} 
			2	{algorithm Newton -initial}
			3	{algorithm NewtonLineSearch .75}
			4	{algorithm NewtonLineSearch .5}
			5	{algorithm KrylovNewton}
			6	{algorithm KrylovNewton -maxDim 5}
			7	{algorithm Broyden 5}
			8	{algorithm Broyden 10}
			9	{algorithm SecantNewton}
			10	{algorithm SecantNewton -maxDim 5}
			11	{algorithm BFGS}
		}
		analysis Static		
		set ok [analyze $RunStep];
		if {$ok == 0} {
			switch $Atype {
				1	{puts "**********************************\n** Algorithm = Newton\n** Analysis succeed!\n** Ok = $ok\n***********************************\n"} 
				2	{puts "**********************************\n** Algorithm = Newton -initial\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"}
				3	{puts "**********************************\n** Algorithm = NewtonLineSearch .75\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"}
				4	{puts "**********************************\n** Algorithm = NewtonLineSearch .5\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"}
				5	{puts "**********************************\n** Algorithm = KrylovNewton\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"}
				6	{puts "**********************************\n** Algorithm = KrylovNewton -maxDim 5\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"}
				7	{puts "**********************************\n** Algorithm = Broyden 5\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"}
				8	{puts "**********************************\n** Algorithm = Broyden 10\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"}
				9	{puts "**********************************\n** Algorithm = SecantNewton\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"}
				10	{puts "**********************************\n** Algorithm = SecantNewton -maxDim 5\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"}
				11	{puts "**********************************\n** Algorithm = BFGS\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"}
			}
			set AtypeOk [list $ok $Atype];
			return $AtypeOk
		} else {
			switch $Atype {
				1	{puts "**********************************\n** Algorithm = Newton\n** Analysis fail!\n** Ok = $ok\n***********************************\n"} 
				2	{puts "**********************************\n** Algorithm = Newton -initial\n** Analysis fail! \n** Ok = $ok\n***********************************\n"}
				3	{puts "**********************************\n** Algorithm = NewtonLineSearch .75\n** Analysis fail! \n** Ok = $ok\n***********************************\n"}
				4	{puts "**********************************\n** Algorithm = NewtonLineSearch .5\n** Analysis fail! \n** Ok = $ok\n***********************************\n"}
				5	{puts "**********************************\n** Algorithm = KrylovNewton\n** Analysis fail! \n** Ok = $ok\n***********************************\n"}
				6	{puts "**********************************\n** Algorithm = KrylovNewton -maxDim 5\n** Analysis fail! \n** Ok = $ok\n***********************************\n"}
				7	{puts "**********************************\n** Algorithm = Broyden 5\n** Analysis fail! \n** Ok = $ok\n***********************************\n"}
				8	{puts "**********************************\n** Algorithm = Broyden 10\n** Analysis fail! \n** Ok = $ok\n***********************************\n"}
				9	{puts "**********************************\n** Algorithm = SecantNewton\n** Analysis fail! \n** Ok = $ok\n***********************************\n"}
				10	{puts "**********************************\n** Algorithm = SecantNewton -maxDim 5\n** Analysis fail! \n** Ok = $ok\n***********************************\n"}
				11	{puts "**********************************\n** Algorithm = BFGS\n** Analysis fail! \n** Ok = $ok\n***********************************\n"}
			}
			set AtypeOk [list $ok $Atype];
			return $AtypeOk
		}
		
	}

	
	algorithm Newton
	analysis Static		
	set ok [analyze $RunStep];
	if {$ok == 0} { 
		set Atype 1;
		puts "**********************************\n** Algorithm = Newton\n** Analysis succeed!\n** Ok = $ok\n***********************************\n"
		set AtypeOk [list $ok $Atype];
		return $AtypeOk
	} else {puts "**********************************\n** Algorithm = Newton\n** Analysis fail!\n** Ok = $ok\n***********************************\n"}
	
	
	algorithm Newton -initial
	analysis Static	
	set ok [analyze $RunStep];
	if {$ok == 0} { 
		set Atype 2;
		puts "**********************************\n** Algorithm = Newton -initial\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"
		set AtypeOk [list $ok $Atype];
		return $AtypeOk
	} else {puts "**********************************\n** Algorithm = Newton -initial\n** Analysis fail!\n** Ok = $ok\n***********************************\n"}
	
	algorithm NewtonLineSearch .75
	analysis Static
	set ok [analyze $RunStep];
	if {$ok == 0} { 
		set Atype 3;
		puts "**********************************\n** Algorithm = NewtonLineSearch .75\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"
		set AtypeOk [list $ok $Atype];
		return $AtypeOk
	} else {puts "**********************************\n** Algorithm = NewtonLineSearch .75\n** Analysis fail!\n** Ok = $ok\n***********************************\n"}
	
	algorithm NewtonLineSearch .5
	analysis Static
	set ok [analyze $RunStep];
	if {$ok == 0} { 
		set Atype 4;
		puts "**********************************\n** Algorithm = NewtonLineSearch .5\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"
		set AtypeOk [list $ok $Atype];
		return $AtypeOk
	} else {puts "**********************************\n** Algorithm = NewtonLineSearch .5\n** Analysis fail!\n** Ok = $ok\n***********************************\n"}
	
	algorithm KrylovNewton
	analysis Static
	set ok [analyze $RunStep];
	if {$ok == 0} { 
		set Atype 5;
		puts "**********************************\n** Algorithm = KrylovNewton\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"
		set AtypeOk [list $ok $Atype];
		return $AtypeOk
	} else {puts "**********************************\n** Algorithm = KrylovNewton\n** Analysis fail!\n** Ok = $ok\n***********************************\n"}
	
	algorithm KrylovNewton -maxDim 5
	analysis Static
	set ok [analyze $RunStep];
	if {$ok == 0} { 
		set Atype 6;
		puts "**********************************\n** Algorithm = KrylovNewton -maxDim 5\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"
		set AtypeOk [list $ok $Atype];
		return $AtypeOk
	} else {puts "**********************************\n** Algorithm = KrylovNewton -maxDim 5\n** Analysis fail!\n** Ok = $ok\n***********************************\n"}
	
	algorithm Broyden 5
	analysis Static
	set ok [analyze $RunStep];
	if {$ok == 0} { 
		set Atype 7;
		puts "**********************************\n** Algorithm = Broyden 5\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"
		set AtypeOk [list $ok $Atype];
		return $AtypeOk
	} else {puts "**********************************\n** Algorithm = Broyden 5\n** Analysis fail!\n** Ok = $ok\n***********************************\n"}

	algorithm Broyden 10
	analysis Static
	set ok [analyze $RunStep];
	if {$ok == 0} { 
		set Atype 8;
		puts "**********************************\n** Algorithm = Broyden 10\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"
		set AtypeOk [list $ok $Atype];
		return $AtypeOk
	} else {puts "**********************************\n** Algorithm = Broyden 10\n** Analysis fail!\n** Ok = $ok\n***********************************\n"}
	
	algorithm SecantNewton 
	analysis Static
	set ok [analyze $RunStep];
	if {$ok == 0} { 
		set Atype 9;
		puts "**********************************\n** Algorithm = SecantNewton\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"
		set AtypeOk [list $ok $Atype];
		return $AtypeOk
	} else {puts "**********************************\n** Algorithm = SecantNewton\n** Analysis fail!\n** Ok = $ok\n***********************************\n"}
	
	algorithm SecantNewton -maxDim 5
	analysis Static
	set ok [analyze $RunStep];
	if {$ok == 0} { 
		set Atype 10;
		puts "**********************************\n** Algorithm = SecantNewton -maxDim 5\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"
		set AtypeOk [list $ok $Atype];
		return $AtypeOk
	} else {puts "**********************************\n** Algorithm = SecantNewton -maxDim 5\n** Analysis fail!\n** Ok = $ok\n***********************************\n"}
	
	algorithm BFGS
	analysis Static
	set ok [analyze $RunStep];
	if {$ok == 0} { 
		set Atype 11;
		puts "**********************************\n** Algorithm = BFGS\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"
		set AtypeOk [list $ok $Atype];
		return $AtypeOk
	} else {puts "**********************************\n** Algorithm = BFGS\n** Analysis fail!\n** Ok = $ok\n***********************************\n"}
	
	
	
	set AtypeOk [list $ok 0];
	return $AtypeOk
	
	
}


##############################################################################################################################
#          	  				 				Algorithm switch for dynamic analysis						    				 #
##############################################################################################################################

proc DYAlgorithmSwitch { RunStep CuAn_dt {Atype 0} } {
	
	# global DriftCautionFlag
	# global CollapseFlag
	# global ok
	
	
	if {$Atype != 0 } {
		switch $Atype {
			1	{algorithm Newton} 
			2	{algorithm Newton -initial}
			3	{algorithm NewtonLineSearch 0.75}
			4	{algorithm NewtonLineSearch 0.5}
			5	{algorithm KrylovNewton}
			6	{algorithm KrylovNewton -maxDim 5}
			7	{algorithm Broyden 5}
			8	{algorithm Broyden 10}
			9	{algorithm SecantNewton}
			10	{algorithm SecantNewton -maxDim 5}
			11	{algorithm BFGS}
			12	{algorithm ModifiedNewton}
			13	{algorithm ModifiedNewton -initial}
		}
		analysis Transient;		
		set ok [analyze $RunStep $CuAn_dt];
		# if {$ok == 0} {
			# switch $Atype {
				# 1	{puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n** Algorithm = Newton\n** Analysis succeed!\n** Ok = $ok\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"} 
				# 2	{puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n** Algorithm = Newton -initial\n** Analysis succeed! \n** Ok = $ok\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"}
				# 3	{puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n** Algorithm = NewtonLineSearch 0.75\n** Analysis succeed! \n** Ok = $ok\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"}
				# 4	{puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n** Algorithm = NewtonLineSearch 0.5\n** Analysis succeed! \n** Ok = $ok\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"}
				# 5	{puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n** Algorithm = KrylovNewton\n** Analysis succeed! \n** Ok = $ok\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"}
				# 6	{puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n** Algorithm = KrylovNewton -maxDim 5\n** Analysis succeed! \n** Ok = $ok\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"}
				# 7	{puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n** Algorithm = Broyden 5\n** Analysis succeed! \n** Ok = $ok\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"}
				# 8	{puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n** Algorithm = Broyden 10\n** Analysis succeed! \n** Ok = $ok\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"}
				# 9	{puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n** Algorithm = SecantNewton\n** Analysis succeed! \n** Ok = $ok\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"}
				# 10	{puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n** Algorithm = SecantNewton -maxDim 5\n** Analysis succeed! \n** Ok = $ok\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"}
				# 11	{puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n** Algorithm = BFGS\n** Analysis succeed! \n** Ok = $ok\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"}
				# 12	{puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n** Algorithm = ModifiedNewton\n** Analysis succeed! \n** Ok = $ok\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"}
				# 13	{puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n** Algorithm = ModifiedNewton -initial\n** Analysis succeed! \n** Ok = $ok\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"}
			# }
		# } else {
			# switch $Atype {
				# 1	{puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n** Algorithm = Newton\n** Analysis fail!\n** Ok = $ok\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"} 
				# 2	{puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n** Algorithm = Newton -initial\n** Analysis fail! \n** Ok = $ok\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"}
				# 3	{puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n** Algorithm = NewtonLineSearch 0.75\n** Analysis fail! \n** Ok = $ok\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"}
				# 4	{puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n** Algorithm = NewtonLineSearch 0.5\n** Analysis fail! \n** Ok = $ok\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"}
				# 5	{puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n** Algorithm = KrylovNewton\n** Analysis fail! \n** Ok = $ok\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"}
				# 6	{puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n** Algorithm = KrylovNewton -maxDim 5\n** Analysis fail! \n** Ok = $ok\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"}
				# 7	{puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n** Algorithm = Broyden 5\n** Analysis fail! \n** Ok = $ok\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"}
				# 8	{puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n** Algorithm = Broyden 10\n** Analysis fail! \n** Ok = $ok\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"}
				# 9	{puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n** Algorithm = SecantNewton\n** Analysis fail! \n** Ok = $ok\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"}
				# 10	{puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n** Algorithm = SecantNewton -maxDim 5\n** Analysis fail! \n** Ok = $ok\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"}
				# 11	{puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n** Algorithm = BFGS\n** Analysis fail! \n** Ok = $ok\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"}
				# 12	{puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n** Algorithm = ModifiedNewton\n** Analysis fail! \n** Ok = $ok\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"}
				# 13	{puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n** Algorithm = ModifiedNewton -initial\n** Analysis fail! \n** Ok = $ok\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"}
			# }
		# }
		set AtypeOk [list $ok $Atype];
		return $AtypeOk	
	}

	
	algorithm Newton
	analysis Transient;	
	set ok [analyze $RunStep $CuAn_dt];
	if {$ok == 0} { 
		set Atype 1;
		puts "**********************************\n** Algorithm = Newton\n** Analysis succeed!\n** Ok = $ok\n***********************************\n"
		set AtypeOk [list $ok $Atype];
		return $AtypeOk
	} else {puts "**********************************\n** Algorithm = Newton\n** Analysis fail!\n** Ok = $ok\n***********************************\n"}
	
	
	algorithm Newton -initial
	analysis Transient;
	set ok [analyze $RunStep $CuAn_dt];
	if {$ok == 0} { 
		set Atype 2;
		puts "**********************************\n** Algorithm = Newton -initial\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"
		set AtypeOk [list $ok $Atype];
		return $AtypeOk
	} else {puts "**********************************\n** Algorithm = Newton -initial\n** Analysis fail!\n** Ok = $ok\n***********************************\n"}
	
	algorithm NewtonLineSearch .75
	analysis Transient;
	set ok [analyze $RunStep $CuAn_dt];
	if {$ok == 0} { 
		set Atype 3;
		puts "**********************************\n** Algorithm = NewtonLineSearch .75\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"
		set AtypeOk [list $ok $Atype];
		return $AtypeOk
	} else {puts "**********************************\n** Algorithm = NewtonLineSearch .75\n** Analysis fail!\n** Ok = $ok\n***********************************\n"}
	
	algorithm NewtonLineSearch .5
	analysis Transient;
	set ok [analyze $RunStep $CuAn_dt];
	if {$ok == 0} { 
		set Atype 4;
		puts "**********************************\n** Algorithm = NewtonLineSearch .5\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"
		set AtypeOk [list $ok $Atype];
		return $AtypeOk
	} else {puts "**********************************\n** Algorithm = NewtonLineSearch .5\n** Analysis fail!\n** Ok = $ok\n***********************************\n"}
	
	algorithm KrylovNewton
	analysis Transient;
	set ok [analyze $RunStep $CuAn_dt];
	if {$ok == 0} { 
		set Atype 5;
		puts "**********************************\n** Algorithm = KrylovNewton\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"
		set AtypeOk [list $ok $Atype];
		return $AtypeOk
	} else {puts "**********************************\n** Algorithm = KrylovNewton\n** Analysis fail!\n** Ok = $ok\n***********************************\n"}
	
	algorithm KrylovNewton -maxDim 5
	analysis Transient;
	set ok [analyze $RunStep $CuAn_dt];
	if {$ok == 0} { 
		set Atype 6;
		puts "**********************************\n** Algorithm = KrylovNewton -maxDim 5\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"
		set AtypeOk [list $ok $Atype];
		return $AtypeOk
	} else {puts "**********************************\n** Algorithm = KrylovNewton -maxDim 5\n** Analysis fail!\n** Ok = $ok\n***********************************\n"}
	
	algorithm Broyden 5
	analysis Transient;
	set ok [analyze $RunStep $CuAn_dt];
	if {$ok == 0} { 
		set Atype 7;
		puts "**********************************\n** Algorithm = Broyden 5\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"
		set AtypeOk [list $ok $Atype];
		return $AtypeOk
	} else {puts "**********************************\n** Algorithm = Broyden 5\n** Analysis fail!\n** Ok = $ok\n***********************************\n"}

	algorithm Broyden 10
	analysis Transient;
	set ok [analyze $RunStep $CuAn_dt];
	if {$ok == 0} { 
		set Atype 8;
		puts "**********************************\n** Algorithm = Broyden 10\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"
		set AtypeOk [list $ok $Atype];
		return $AtypeOk
	} else {puts "**********************************\n** Algorithm = Broyden 10\n** Analysis fail!\n** Ok = $ok\n***********************************\n"}
	
	algorithm SecantNewton 
	analysis Transient;
	set ok [analyze $RunStep $CuAn_dt];
	if {$ok == 0} { 
		set Atype 9;
		puts "**********************************\n** Algorithm = SecantNewton\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"
		set AtypeOk [list $ok $Atype];
		return $AtypeOk
	} else {puts "**********************************\n** Algorithm = SecantNewton\n** Analysis fail!\n** Ok = $ok\n***********************************\n"}
	
	algorithm SecantNewton -maxDim 5
	analysis Transient;
	set ok [analyze $RunStep $CuAn_dt];
	if {$ok == 0} { 
		set Atype 10;
		puts "**********************************\n** Algorithm = SecantNewton -maxDim 5\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"
		set AtypeOk [list $ok $Atype];
		return $AtypeOk
	} else {puts "**********************************\n** Algorithm = SecantNewton -maxDim 5\n** Analysis fail!\n** Ok = $ok\n***********************************\n"}
	
	algorithm BFGS
	analysis Transient;
	set ok [analyze $RunStep $CuAn_dt];
	if {$ok == 0} { 
		set Atype 11;
		puts "**********************************\n** Algorithm = BFGS\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"
		set AtypeOk [list $ok $Atype];
		return $AtypeOk
	} else {puts "**********************************\n** Algorithm = BFGS\n** Analysis fail!\n** Ok = $ok\n***********************************\n"}
	
	algorithm ModifiedNewton
	analysis Transient;
	set ok [analyze $RunStep $CuAn_dt];
	if {$ok == 0} { 
		set Atype 12;
		puts "**********************************\n** Algorithm = ModifiedNewton\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"
		set AtypeOk [list $ok $Atype];
		return $AtypeOk
	} else {puts "**********************************\n** Algorithm = ModifiedNewton\n** Analysis fail!\n** Ok = $ok\n***********************************\n"}
	
	algorithm ModifiedNewton -initial
	analysis Transient;
	set ok [analyze $RunStep $CuAn_dt];
	if {$ok == 0} { 
		set Atype 12;
		puts "**********************************\n** Algorithm = ModifiedNewton -initial\n** Analysis succeed! \n** Ok = $ok\n***********************************\n"
		set AtypeOk [list $ok $Atype];
		return $AtypeOk
	} else {puts "**********************************\n** Algorithm = ModifiedNewton -initial\n** Analysis fail!\n** Ok = $ok\n***********************************\n"}
	
	set AtypeOk [list $ok 0];
	return $AtypeOk
	
	
}

##############################################################################################################################
#          	  				 				Parameter switch for static analysis						    				 #
##############################################################################################################################

proc POParameterSwitch { IDctrlNode IDctrlDOF Dmax Dincr intl_Tol incrFactor_Tol intl_MaxNumIter incr_MaxNumIter changingtimes RunLog } {
	
	# global DriftCautionFlag
	# global CollapseFlag
	# global ok
	
	
	set PmLevel 1;
	set ok -3;
	
	while {$ok != 0 || $remainDisp > 0 } {
		RunAndLog $RunLog "********************************************************************\n** Parameter Level = $PmLevel\n*********************************************************************\n" 
		wipeAnalysis;
		constraints Transformation;
		numberer RCM
		system SparseSYM;
		# set UmfPackLvalueFact 40
		# system UmfPack -lvalueFact $UmfPackLvalueFact
		
		set CuDincr [expr $Dincr/pow(5,$PmLevel)];
		# set ModeNumSteps [expr 10 * pow(10,$PmLevel)];	
		# set ModeNumSteps [expr 10 * 10];	
		set ModeNumSteps [expr max(1,[expr round(200/pow(2,$PmLevel))])];	
		set Tol [expr $intl_Tol+$incrFactor_Tol*$PmLevel];
		set MaxNumIter [expr $intl_MaxNumIter+$incr_MaxNumIter*$PmLevel];
		set TestType NormDispIncr
		# test $TestType $Tol $MaxNumIter 2;
		test $TestType $Tol $MaxNumIter 0;
		set controlDisp [nodeDisp $IDctrlNode $IDctrlDOF];
		set remainDisp [expr $Dmax - $controlDisp];
		
		RunAndLog $RunLog "**********************************\n** Disp Incre = [format {%0.4e} $CuDincr]\n** Steps to run = [format {%0.0f} $ModeNumSteps]\n** Tolerance = [format {%0.1e} $Tol]\n** Max Number for Iteration = [format {%0.1e} $MaxNumIter]\n** There are $remainDisp more inches to push.\n***********************************\n" 
		
		set NewRemainSteps [expr round(($remainDisp)/($CuDincr))];
		
		if {$NewRemainSteps < 1} {
			set NewRemainSteps 1;}
		set RunStep [expr min($NewRemainSteps,$ModeNumSteps)];
		
		integrator DisplacementControl  $IDctrlNode   $IDctrlDOF $CuDincr
		
		####################################################
		
		set AtypeOktry [POAlgorithmSwitch $RunStep 3];		
		set oktry [lindex $AtypeOktry 0];
		RunAndLog $RunLog "**********************************\n** oktry = $oktry\n***********************************\n" 
		set ok $oktry;
		
		# if {$oktry == 0} {
			# set Atypetry [lindex $AtypeOktry 1];
			# RunAndLog $RunLog "**********************************\n** Atypetry = $Atypetry\n***********************************\n"
			# set AtypeOk [POAlgorithmSwitch  $RunStep $Atypetry];
			# set ok [lindex $AtypeOk 0];
			# RunAndLog $RunLog "**********************************\n** ok after atypetry = $ok\n***********************************\n"
		# } else {set ok $oktry;}
		
		
		# set Atype [lindex $AtypeOk 1];	
		####################################################
		set controlDisp [nodeDisp $IDctrlNode $IDctrlDOF];
		set remainDisp [expr $Dmax - $controlDisp];		
		RunAndLog $RunLog "**********************************\n** Analysis stop at Parameter Level $PmLevel\n** There are $remainDisp more inches to push.\n***********************************\n"
		
		
		
		if {$ok == 0 && $PmLevel == 1 } {
			# RunAndLog $RunLog "********************************************************************\n** Analysis go well at PmLevel 1. Parameters switch back to default settings.\n*********************************************************************\n"
			RunAndLog $RunLog "********************************************************************\n** Analysis go well at PmLevel 1. Parameters level stays at PmLevel 1.\n*********************************************************************\n"
			# break;
			continue;
		} elseif {$ok == 0 && $PmLevel > 1 && $PmLevel <= $changingtimes} {
			set PmLevel [expr $PmLevel - 1];
			RunAndLog $RunLog "********************************************************************\n** Analysis go well at PmLevel [expr $PmLevel +1]. Parameters switch down to PmLevel [expr $PmLevel].\n*********************************************************************\n"
			continue;	
		} elseif {$ok != 0 && $PmLevel >= 1 && $PmLevel < $changingtimes} {
			set PmLevel [expr $PmLevel + 1];
			RunAndLog $RunLog "********************************************************************\n** Analysis fail at PmLevel [expr $PmLevel -1]. Parameters switch up to PmLevel [expr $PmLevel].\n*********************************************************************\n"
			continue;
		} else {
			RunAndLog $RunLog "********************************************************************\n** Analysis fail through PmLevel 1 to PmLevel $changingtimes.\n*********************************************************************\n" 
			break;
		}


	}; # End of While
	# set DriftCautionFlag [MaxDriftTesterBiDirection $NStories $ModeCheckDrift $RigidDiaphNodeItem $StoryHeight];
	# set CollapseFlag [MaxDriftTesterBiDirection $NStories $DriftLimit $RigidDiaphNodeItem $StoryHeight];
	return $ok	
	
}


##############################################################################################################################
#          	  				 			X	Parameter switch for static analysis		X				    				 #
##############################################################################################################################

proc POParameterSwitchX { RunLog IDctrlNode IDctrlDOF Dmax Dincr intl_Tol incrFactor_Tol intl_MaxNumIter incr_MaxNumIter changingtimes RunLog } {
	
	# global DriftCautionFlag
	# global CollapseFlag
	# global ok
	
	
	set PmLevel 1;
	set ok -3;
	
	while {$ok != 0 || $remainDisp > 0 } {
		RunAndLog $RunLog "********************************************************************\n** Parameter Level = $PmLevel\n*********************************************************************\n"
		wipeAnalysis;
		constraints Transformation;
		numberer RCM
		system SparseSYM;
		# set UmfPackLvalueFact 40
		# system UmfPack -lvalueFact $UmfPackLvalueFact
		
		set CuDincr [expr $Dincr/pow(5,$PmLevel)];
		# set ModeNumSteps [expr 10 * pow(10,$PmLevel)];	
		# set ModeNumSteps [expr 10 * 10];	
		set ModeNumSteps [expr max(1,[expr round(200/pow(2,$PmLevel))])];	
		set Tol [expr $intl_Tol+$incrFactor_Tol*$PmLevel];
		set MaxNumIter [expr $intl_MaxNumIter+$incr_MaxNumIter*$PmLevel];
		set TestType NormDispIncr
		# test $TestType $Tol $MaxNumIter 2;
		test $TestType $Tol $MaxNumIter 0;
		set controlDisp [nodeDisp $IDctrlNode $IDctrlDOF];
		set remainDisp [expr $Dmax - $controlDisp];
		
		RunAndLog $RunLog "**********************************\n** Disp Incre = [format {%0.4e} $CuDincr]\n** Steps to run = [format {%0.0f} $ModeNumSteps]\n** Tolerance = [format {%0.1e} $Tol]\n** Max Number for Iteration = [format {%0.1e} $MaxNumIter]\n** There are $remainDisp more inches to push.\n***********************************\n"
		
		set NewRemainSteps [expr round(($remainDisp)/($CuDincr))];
		
		if {$NewRemainSteps < 1} {
			set NewRemainSteps 1;}
		set RunStep [expr min($NewRemainSteps,$ModeNumSteps)];
		
		integrator DisplacementControl  $IDctrlNode   $IDctrlDOF $CuDincr
		
		####################################################
		
		set AtypeOktry [POAlgorithmSwitch $RunStep 3];		
		set oktry [lindex $AtypeOktry 0];
		RunAndLog $RunLog "**********************************\n** oktry = $oktry\n***********************************\n"
		set ok $oktry;
		
		# if {$oktry == 0} {
			# set Atypetry [lindex $AtypeOktry 1];
			# RunAndLog $RunLog "**********************************\n** Atypetry = $Atypetry\n***********************************\n"
			# set AtypeOk [POAlgorithmSwitch  $RunStep $Atypetry];
			# set ok [lindex $AtypeOk 0];
			# RunAndLog $RunLog "**********************************\n** ok after atypetry = $ok\n***********************************\n"
		# } else {set ok $oktry;}
		
		
		# set Atype [lindex $AtypeOk 1];	
		####################################################
		set controlDisp [nodeDisp $IDctrlNode $IDctrlDOF];
		set remainDisp [expr $Dmax - $controlDisp];		
		RunAndLog $RunLog "**********************************\n** Analysis stop at Parameter Level $PmLevel\n** There are $remainDisp more inches to push.\n***********************************\n"
		
		
		
		if {$ok == 0 && $PmLevel == 1 } {
			# RunAndLog $RunLog "********************************************************************\n** Analysis go well at PmLevel 1. Parameters switch back to default settings.\n*********************************************************************\n"
			RunAndLog $RunLog "********************************************************************\n** Analysis go well at PmLevel 1. Parameters level stays at PmLevel 1.\n*********************************************************************\n"
			# break;
			continue;
		} elseif {$ok == 0 && $PmLevel > 1 && $PmLevel <= $changingtimes} {
			set PmLevel [expr $PmLevel - 1];
			RunAndLog $RunLog "********************************************************************\n** Analysis go well at PmLevel [expr $PmLevel +1]. Parameters switch down to PmLevel [expr $PmLevel].\n*********************************************************************\n"
			continue;	
		} elseif {$ok != 0 && $PmLevel >= 1 && $PmLevel < $changingtimes} {
			set PmLevel [expr $PmLevel + 1];
			RunAndLog $RunLog "********************************************************************\n** Analysis fail at PmLevel [expr $PmLevel -1]. Parameters switch up to PmLevel [expr $PmLevel].\n*********************************************************************\n"
			continue;
		} else {
			RunAndLog $RunLog "********************************************************************\n** Analysis fail through PmLevel 1 to PmLevel $changingtimes.\n*********************************************************************\n"
			break;
		}


	}; # End of While
	# set DriftCautionFlag [MaxDriftTesterBiDirection $NStories $ModeCheckDrift $RigidDiaphNodeItem $StoryHeight];
	# set CollapseFlag [MaxDriftTesterBiDirection $NStories $DriftLimit $RigidDiaphNodeItem $StoryHeight];
	return $ok	
	
}

##############################################################################################################################
#          	  				 						Look up algorithm name								    				 #
##############################################################################################################################
proc LookUpAlgorithmName { Atype } {
	switch $Atype {
			1	{set Aname Newton} 
			2	{set Aname [list Newton -initial]}
			3	{set Aname [list NewtonLineSearch 0.75]}
			4	{set Aname [list NewtonLineSearch 0.5]}
			5	{set Aname KrylovNewton}
			6	{set Aname [list KrylovNewton -maxDim 5]}
			7	{set Aname [list Broyden 5]}
			8	{set Aname [list Broyden 10]}
			9	{set Aname SecantNewton}
			10	{set Aname [list SecantNewton -maxDim 5]}
			11	{set Aname BFGS}   
			12	{set Aname ModifiedNewton}
			13	{set Aname [list ModifiedNewton -initial]}
		}
	return $Aname
}

# Broyden 这个方法是不好的，不要使用

##############################################################################################################################
#          	  				 		Integrator and system switch for dynamic analysis					    				 #
##############################################################################################################################
proc DYIntSymSwitch {RunStep CuAn_dt Atype TestType Tol MaxNumIter GM_time {Integratortype 0} {Systemtype 0}} {
	wipeAnalysis;
	constraints Transformation;
	numberer RCM
	if {$Systemtype != 0} {
		system Mumps -ICNTL14 60;
		# puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n**Using Mumps system to run dynamic analysis."
	} else {
		# system UmfPack -lvalueFact 60;
		system SparseSYM;
		# puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n**Using SparseSYM system to run dynamic analysis. "
	}
	# test $TestType $Tol $MaxNumIter 2;
	test $TestType $Tol $MaxNumIter 0;
		
			
	if {$Integratortype == 0} {
		integrator Newmark 0.55 0.2765625;
		# puts "**Using Newmark integrator to run dynamic analysis. \n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"
	} else {
		integrator HHTHSIncrReduct 0.5 0.95;
		# puts "**Using HHTHSIncrReduct integrator to run dynamic analysis. \n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"
	}
	set AtypeOk [DYAlgorithmSwitch $RunStep $CuAn_dt $Atype];
	
	return $AtypeOk
}
	
	
	
	
##############################################################################################################################
#          	  				 				Parameter switch for dynamic analysis						    				 #
##############################################################################################################################

proc DYParameterSwitch {RunLog ModeCount RunGM_time GM_time An_dt MaxModeNumStep intl_Tol Max_Tol intl_MaxNumIter incr_MaxNumIter NStories DriftLimit FloorNodes StoryHeight changingtimes MaxCheckDrift LoadCaseStartT} {
	
	# global DriftCautionFlag
	# global CollapseFlag
	# global ok  
	
	
	# set DriftOKOut $changingtimes;
	if {$ModeCount == 1} {
		set DriftOKOuttime 10;
	} elseif {$ModeCount == 2} {
		set DriftOKOuttime 20;
	}
	
	
	set DriftOKtime 0;
	set DriftOKOutjump 0;
	set ParameterSwitchtime 1;
	set PmLevel 1;
	set ok -3;
	set DriftFlag "NO"
	set controlTimeStart [getTime];
	set remainTimeStop [expr $GM_time-$controlTimeStart-$RunGM_time]; # 本轮计算剩余时间
	if {$remainTimeStop < 0 } {
		set remainTimeStop 0;}
	# set MaxCheckDrift 0;
	
	RunAndLog $RunLog "********************************************************************************\n********************************************************************************\n** Enter into DYParameterSwitch from the solver! \n********************************************************************************\n********************************************************************************\n"
	
	 # while $DriftOKOut > $DriftOKtime && $DriftFlag == "NO" && ($ok != 0 || $remainTimeE > 0)  这里采取穷尽式的计算有问题，会造成检查Drift超限的次数过少
	 # $DriftFlag == "NO" && ($ok != 0 || $remainTimeE > 0)
	 # $DriftFlag == "NO" && ($ok != 0 || $remainTimeE > $remainTimeStop)
	while {  $DriftFlag == "NO" && $DriftOKOutjump != 1 && ($ok != 0 || $remainTimeE > $remainTimeStop) } {
		RunAndLog $RunLog "********************************************************************************\n** Mode Level = $ModeCount \n** Parameter Level = $PmLevel \n********************************************************************************\n"

		set CuAn_dt [expr $An_dt*4.0/pow(2,$PmLevel)];
		RunAndLog $RunLog "****$An_dt";
		RunAndLog $RunLog "*$CuAn_dt";
		
		# set ModeNumSteps [expr 10 * pow(10,$PmLevel)];	
		# set ModeNumSteps [expr 10 * 10];	
		# set ModeNumSteps [expr max(1,[expr round($MaxModeNumStep*2/pow(2,$PmLevel))])];	
		# set ModeNumSteps [expr max(1,[expr round($MaxModeNumStep/pow(2,$PmLevel))])];	
		set ModeNumSteps [expr max(1,[expr round($MaxModeNumStep*0.5/pow(2,$PmLevel))])];	
		
		set Tol [expr $intl_Tol+($Max_Tol - $intl_Tol)/($changingtimes - 1) * ($PmLevel - 1)];
		set MaxNumIter [expr $intl_MaxNumIter+$incr_MaxNumIter*$PmLevel];
		set TestType NormDispIncr		
		set controlTimeS [getTime];
		set remainTimeS [expr $GM_time-$controlTimeS];
		
		RunAndLog $RunLog "********************************************************************************\n** MaxCheckedDrift = [format {%0.5f} $MaxCheckDrift] \n** Time Incre = [format {%0.4e} $CuAn_dt]\n** Steps to run = [format {%0.0f} $ModeNumSteps]\n** Tolerance = [format {%0.1e} $Tol]\n** Max Number for Iteration = [format {%0.0f} $MaxNumIter]\n** There are [format {%0.3f} $remainTimeS] more seconds to run.\n** Analysis finished [format {%0.3f} $controlTimeS] seconds\n********************************************************************************\n"
		RunTimeCheck $RunLog $LoadCaseStartT
		set NewRemainSteps [expr round(($remainTimeS)/($CuAn_dt))];		
		if {$NewRemainSteps < 1} {
			set NewRemainSteps 1;}
		set RunStep [expr min($NewRemainSteps,$ModeNumSteps)];
				
		####################################################
		# 选择使用的算法类型
		set AtypeList [list 2 3 12 13 5 6]; #should be editted.
		# 试算各种选择的算法类型
		foreach Atypetry $AtypeList {			
			set AtypeOktry [DYIntSymSwitch 1 $CuAn_dt $Atypetry $TestType $Tol $MaxNumIter $GM_time];		
			# set AtypeOktry [DYAlgorithmSwitch 1 $CuAn_dt $Atypetry];		
			set oktry [lindex $AtypeOktry 0];
			set Atype [lindex $AtypeOktry 1];
			
			set Aname [LookUpAlgorithmName $Atype];
			
			RunAndLog $RunLog "********************************************************************************\n** trying algorithm: $Aname (IntegratorType: Newmark)."			
			if {$oktry == 0} {
				set Atype $Atypetry;
				set Aname [LookUpAlgorithmName $Atype]
				RunAndLog $RunLog "** Analysis complete one try step successfully, by using algorithm: $Aname (IntegratorType: Newmark).\n********************************************************************************\n"
				set IntegratorType 0;
				break;
			} else {
				RunAndLog $RunLog "** Analysis try step failed, by using algorithm: $Aname (IntegratorType: Newmark).\n********************************************************************************\n"
			}
			
			RunAndLog $RunLog "********************************************************************************\n** trying algorithm: $Aname (IntegratorType: HHTHSIncrReduct)."
			set AtypeOktry [DYIntSymSwitch 1 $CuAn_dt $Atypetry $TestType $Tol $MaxNumIter $GM_time 1];		
			# set AtypeOktry [DYAlgorithmSwitch 1 $CuAn_dt $Atypetry];		
			set oktry [lindex $AtypeOktry 0];
			if {$oktry == 0} {
				set Atype $Atypetry;
				set Aname [LookUpAlgorithmName $Atype]
				RunAndLog $RunLog "** Analysis complete one try step successfully, by using algorithm: $Aname (IntegratorType: HHTHSIncrReduct).\n********************************************************************************\n"
				set IntegratorType 1;
				break;
			} else {
				RunAndLog $RunLog "** Analysis try step failed, by using algorithm: $Aname (IntegratorType: HHTHSIncrReduct).\n********************************************************************************\n"
			}
				
		}
		# 如果试算全部失败，提升参数使用级别，同时检查变形
		if {$oktry != 0 && $PmLevel >= 1 && $PmLevel < $changingtimes} {
			set PmLevel [expr $PmLevel + 1];
			RunAndLog $RunLog "********************************************************************************\n** Analysis fail at try step at PmLevel [expr $PmLevel -1]. Parameters switch up to PmLevel [expr $PmLevel].\n********************************************************************************\n"
			set DriftFlag [MaxDriftTesterBiDirection $NStories $DriftLimit $FloorNodes $StoryHeight];
			RunAndLog $RunLog "********************************************************************************\n** DriftRatio exceeds the setting limit ([format {%0.3f} $DriftLimit]), doesn't it? $DriftFlag. \n********************************************************************************\n"
			RunAndLog $RunLog "********************************************************************************\n** Analysis parameters switch $ParameterSwitchtime times! \n********************************************************************************\n"
			RunTimeCheck $RunLog $LoadCaseStartT
			# set ParameterSwitchtime [expr $ParameterSwitchtime + 1 ];
			continue;
		} elseif {$oktry != 0 && $PmLevel == $changingtimes} {
			RunAndLog $RunLog "********************************************************************************\n** Analysis fail at try step through PmLevel 1 to PmLevel $changingtimes.\n********************************************************************************\n"
			set DriftFlag [MaxDriftTesterBiDirection $NStories $DriftLimit $FloorNodes $StoryHeight];
			RunAndLog $RunLog "********************************************************************************\n** DriftRatio exceeds the setting limit ([format {%0.3f} $DriftLimit]), doesn't it? $DriftFlag. \n********************************************************************************\n"
			RunAndLog $RunLog "********************************************************************************\n** Analysis parameters switch $ParameterSwitchtime times! \n********************************************************************************\n"
			RunTimeCheck $RunLog $LoadCaseStartT
			# set ParameterSwitchtime [expr $ParameterSwitchtime + 1 ];
			break;
		}
		# 如果试算成功，完成指定步数计算
		set AtypeOk [DYIntSymSwitch $RunStep $CuAn_dt $Atype $TestType $Tol $MaxNumIter $GM_time $IntegratorType 1];	
		# set AtypeOk [DYIntSymSwitch $RunStep $CuAn_dt $Atype $TestType $Tol $MaxNumIter $GM_time $IntegratorType];	
		# 给出计算结果完成信息
		set controlTimeE [getTime];
		set remainTimeE [expr $GM_time-$controlTimeE];
		set completeTime [expr $controlTimeE - $controlTimeS];	
		set completeStep [expr $completeTime/$CuAn_dt];
		set ok [lindex $AtypeOk 0];
		RunAndLog $RunLog "********************************************************************************\n** Analysis finished at Parameter Level $PmLevel.\n** Analysis complete [format {%0.0f} $completeStep] steps.\n** ok = $ok\n** There are [format {%0.3f} $remainTimeE] more seconds to run.\n********************************************************************************\n"
		RunTimeCheck $RunLog $LoadCaseStartT	
		# 采集倒塌信息
		####################################################
		set DriftFlag [MaxDriftTesterBiDirection $NStories $DriftLimit $FloorNodes $StoryHeight];	
		set maxDriftData [MaxDrift $NStories $FloorNodes $StoryHeight];
		set maxDrift [lindex $maxDriftData 0];
		# set maxDriftDir [lindex $maxDriftData 1];
		RunAndLog $RunLog "@maxDrift : $maxDrift "
		if {$MaxCheckDrift < $maxDrift} {
			set MaxCheckDrift $maxDrift;
		}
		RunAndLog $RunLog "@MaxCheckedDrift : $MaxCheckDrift "	
		####################################################
		
		if {$DriftFlag == "NO"} {			
			set DriftOKtime [expr $DriftOKtime + 1 ];
			RunAndLog $RunLog "********************************************************************************\n**DriftOKtime :  $DriftOKtime => maxDrift : [format {%0.5f} $maxDrift]";
			
		}		
		if { $ModeCount != 0 && $DriftOKOuttime < $DriftOKtime } {
			set DriftOKOutjump 1;
		} 
			
		# 根据计算结果信息判断是否改变计算参数
		if {$ok == 0 && $PmLevel == 1 } {
			# RunAndLog $RunLog "********************************************************************\n** Analysis go well at PmLevel 1. Parameters switch back to default settings.\n*********************************************************************\n"
			RunAndLog $RunLog "********************************************************************************\n** Analysis go well at PmLevel 1. Parameters level stays at PmLevel 1."
			RunAndLog $RunLog "** DriftRatio exceeds the setting limit ([format {%0.3f} $DriftLimit]), doesn't it? $DriftFlag (MaxDrift : [format {%0.3f} $maxDrift])."
			RunAndLog $RunLog "** Analysis parameters switched $ParameterSwitchtime times! \n********************************************************************************\n"
			# set ParameterSwitchtime [expr $ParameterSwitchtime + 1 ];
			RunTimeCheck $RunLog $LoadCaseStartT
			continue;
		} elseif {$ok == 0 && $PmLevel > 1 && $PmLevel <= $changingtimes} {
			set PmLevel [expr $PmLevel - 1];
			RunAndLog $RunLog "********************************************************************************\n** Analysis go well at PmLevel [expr $PmLevel +1]. Parameters switch down to PmLevel [expr $PmLevel]."
			RunAndLog $RunLog "** DriftRatio exceeds the setting limit ([format {%0.3f} $DriftLimit]), doesn't it? $DriftFlag (MaxDrift : [format {%0.3f} $maxDrift]). "
			RunAndLog $RunLog "** Analysis parameters switched $ParameterSwitchtime times! \n********************************************************************************\n"
			set ParameterSwitchtime [expr $ParameterSwitchtime + 1 ];
			RunTimeCheck $RunLog $LoadCaseStartT
			continue;	
		} elseif {$ok != 0 && $PmLevel >= 1 && $PmLevel < $changingtimes} {
			set PmLevel [expr $PmLevel + 1];
			RunAndLog $RunLog "********************************************************************************\n** Analysis fail at PmLevel [expr $PmLevel -1]. Parameters switch up to PmLevel [expr $PmLevel]."
			RunAndLog $RunLog "** DriftRatio exceeds the setting limit ([format {%0.3f} $DriftLimit]), doesn't it? $DriftFlag (MaxDrift : [format {%0.3f} $maxDrift]). "
			RunAndLog $RunLog "** Analysis parameters switched $ParameterSwitchtime times! \n********************************************************************************\n"
			set ParameterSwitchtime [expr $ParameterSwitchtime + 1 ];
			RunTimeCheck $RunLog $LoadCaseStartT
			continue;
		} else {
			RunAndLog $RunLog "********************************************************************************\n** Analysis fail through PmLevel 1 to PmLevel $changingtimes."
			RunAndLog $RunLog "** DriftRatio exceeds the setting limit ([format {%0.3f} $DriftLimit]), doesn't it? $DriftFlag (MaxDrift : [format {%0.3f} $maxDrift]). "
			RunAndLog $RunLog "** Analysis parameters switched $ParameterSwitchtime times! \n********************************************************************************\n"
			# set ParameterSwitchtime [expr $ParameterSwitchtime + 1 ];
			RunTimeCheck $RunLog $LoadCaseStartT
			break;
		}
		

	}; # End of While
	# set DriftCautionFlag [MaxDriftTesterBiDirection $NStories $ModeCheckDrift $RigidDiaphNodeItem $StoryHeight];
	# set CollapseFlag [MaxDriftTesterBiDirection $NStories $DriftLimit $RigidDiaphNodeItem $StoryHeight];
	RunAndLog $RunLog "********************************************************************************\n********************************************************************************\n** Go to the solver! \n********************************************************************************\n********************************************************************************\n"
		
	set DriftAndOk [list $ok $DriftFlag $MaxCheckDrift $DriftOKOutjump];
	return $DriftAndOk
		
}

##############################################################################################################################
#          	  				 				Parameter switch for dynamic analysis	(test)				    				 #
##############################################################################################################################

proc DYParameterSwitch1 {RunLog ModeCount RunGM_time GM_time An_dt MaxModeNumStep intl_Tol Max_Tol intl_MaxNumIter incr_MaxNumIter NStories DriftLimit FloorNodes StoryHeight changingtimes MaxCheckDrift LoadCaseStartT} {
	
	# global DriftCautionFlag
	# global CollapseFlag
	# global ok  
	
	
	# set DriftOKOut $changingtimes;
	if {$ModeCount == 1} {
		set DriftOKOuttime 10;
	} elseif {$ModeCount == 2} {
		set DriftOKOuttime 20;
	}
	
	set RunTrigger 1;
	
	set DriftOKtime 0;
	set DriftOKOutjump 0;
	set ParameterSwitchtime 1;
	set PmLevel 1;
	set ok -3;
	set DriftFlag "NO"
	set controlTimeStart [getTime];
	set remainTimeStop [expr $GM_time-$controlTimeStart-$RunGM_time]; # 本轮计算剩余时间
	if {$remainTimeStop < 0 } {
		set remainTimeStop 0;}
	# set MaxCheckDrift 0;
	
	RunAndLog $RunLog "********************************************************************************\n********************************************************************************\n** Enter into DYParameterSwitch from the solver! \n********************************************************************************\n********************************************************************************\n"
	
	 # while $DriftOKOut > $DriftOKtime && $DriftFlag == "NO" && ($ok != 0 || $remainTimeE > 0)  这里采取穷尽式的计算有问题，会造成检查Drift超限的次数过少
	 # $DriftFlag == "NO" && ($ok != 0 || $remainTimeE > 0)
	 # $DriftFlag == "NO" && ($ok != 0 || $remainTimeE > $remainTimeStop)
	while { $RunTrigger } {
		RunAndLog $RunLog "********************************************************************************\n** Mode Level = $ModeCount \n** Parameter Level = $PmLevel \n********************************************************************************\n"

		set CuAn_dt [expr $An_dt*4.0/pow(2,$PmLevel)];
		RunAndLog $RunLog "****$An_dt";
		RunAndLog $RunLog "*$CuAn_dt";
		
		# set ModeNumSteps [expr 10 * pow(10,$PmLevel)];	
		# set ModeNumSteps [expr 10 * 10];	
		# set ModeNumSteps [expr max(1,[expr round($MaxModeNumStep*2/pow(2,$PmLevel))])];	
		# set ModeNumSteps [expr max(1,[expr round($MaxModeNumStep/pow(2,$PmLevel))])];	
		set ModeNumSteps [expr max(1,[expr round($MaxModeNumStep*0.5/pow(2,$PmLevel))])];	
		
		set Tol [expr $intl_Tol+($Max_Tol - $intl_Tol)/($changingtimes - 1) * ($PmLevel - 1)];
		# set Tol [expr $intl_Tol+($Max_Tol - $intl_Tol)/(sqrt($changingtimes) - 1) * (sqrt($PmLevel) - 1)];
		set MaxNumIter [expr $intl_MaxNumIter+$incr_MaxNumIter*$PmLevel];
		set TestType NormDispIncr		
		set controlTimeS [getTime];
		set remainTimeS [expr $GM_time-$controlTimeS];
		
		RunAndLog $RunLog "********************************************************************************\n** MaxCheckedDrift = [format {%0.5f} $MaxCheckDrift] \n** Time Incre = [format {%0.4e} $CuAn_dt]\n** Steps to run = [format {%0.0f} $ModeNumSteps]\n** Tolerance = [format {%0.1e} $Tol]\n** Max Number for Iteration = [format {%0.0f} $MaxNumIter]\n** There are [format {%0.3f} $remainTimeS] more seconds to run.\n** Analysis finished [format {%0.3f} $controlTimeS] seconds\n********************************************************************************\n"
		RunTimeCheck $RunLog $LoadCaseStartT
		set NewRemainSteps [expr round(($remainTimeS)/($CuAn_dt))];		
		if {$NewRemainSteps < 1} {
			set NewRemainSteps 1;}
		set RunStep [expr min($NewRemainSteps,$ModeNumSteps)];
				
		####################################################
		# 选择使用的算法类型
		set AtypeList [list 2 3 12 13 5 6]; #should be editted.
		# 试算各种选择的算法类型
		foreach Atypetry $AtypeList {			
			set AtypeOktry [DYIntSymSwitch 1 $CuAn_dt $Atypetry $TestType $Tol $MaxNumIter $GM_time];		
			# set AtypeOktry [DYAlgorithmSwitch 1 $CuAn_dt $Atypetry];		
			set oktry [lindex $AtypeOktry 0];
			set Atype [lindex $AtypeOktry 1];
			
			set Aname [LookUpAlgorithmName $Atype];
			
			RunAndLog $RunLog "********************************************************************************\n** trying algorithm: $Aname (IntegratorType: Newmark)."			
			if {$oktry == 0} {
				set Atype $Atypetry;
				set Aname [LookUpAlgorithmName $Atype]
				RunAndLog $RunLog "** Analysis complete one try step successfully, by using algorithm: $Aname (IntegratorType: Newmark).\n********************************************************************************\n"
				set IntegratorType 0;
				break;
			} else {
				RunAndLog $RunLog "** Analysis try step failed, by using algorithm: $Aname (IntegratorType: Newmark).\n********************************************************************************\n"
			}
			
			RunAndLog $RunLog "********************************************************************************\n** trying algorithm: $Aname (IntegratorType: HHTHSIncrReduct)."
			set AtypeOktry [DYIntSymSwitch 1 $CuAn_dt $Atypetry $TestType $Tol $MaxNumIter $GM_time 1];		
			# set AtypeOktry [DYAlgorithmSwitch 1 $CuAn_dt $Atypetry];		
			set oktry [lindex $AtypeOktry 0];
			if {$oktry == 0} {
				set Atype $Atypetry;
				set Aname [LookUpAlgorithmName $Atype]
				RunAndLog $RunLog "** Analysis complete one try step successfully, by using algorithm: $Aname (IntegratorType: HHTHSIncrReduct).\n********************************************************************************\n"
				set IntegratorType 1;
				break;
			} else {
				RunAndLog $RunLog "** Analysis try step failed, by using algorithm: $Aname (IntegratorType: HHTHSIncrReduct).\n********************************************************************************\n"
			}
				
		}
		# 如果试算全部失败，提升参数使用级别，同时检查变形
		if {$oktry != 0 && $PmLevel >= 1 && $PmLevel < $changingtimes} {
			set PmLevel [expr $PmLevel + 1];
			RunAndLog $RunLog "********************************************************************************\n** Analysis fail at try step at PmLevel [expr $PmLevel -1]. Parameters switch up to PmLevel [expr $PmLevel].\n********************************************************************************\n"
			set DriftFlag [MaxDriftTesterBiDirection $NStories $DriftLimit $FloorNodes $StoryHeight];
			RunAndLog $RunLog "********************************************************************************\n** DriftRatio exceeds the setting limit ([format {%0.3f} $DriftLimit]), doesn't it? $DriftFlag. \n********************************************************************************\n"
			RunAndLog $RunLog "********************************************************************************\n** Analysis parameters switch $ParameterSwitchtime times! \n********************************************************************************\n"
			RunTimeCheck $RunLog $LoadCaseStartT
			# set ParameterSwitchtime [expr $ParameterSwitchtime + 1 ];
			continue;
		} elseif {$oktry != 0 && $PmLevel == $changingtimes} {
			RunAndLog $RunLog "********************************************************************************\n** Analysis fail at try step through PmLevel 1 to PmLevel $changingtimes.\n********************************************************************************\n"
			set DriftFlag [MaxDriftTesterBiDirection $NStories $DriftLimit $FloorNodes $StoryHeight];
			RunAndLog $RunLog "********************************************************************************\n** DriftRatio exceeds the setting limit ([format {%0.3f} $DriftLimit]), doesn't it? $DriftFlag. \n********************************************************************************\n"
			RunAndLog $RunLog "********************************************************************************\n** Analysis parameters switch $ParameterSwitchtime times! \n********************************************************************************\n"
			RunTimeCheck $RunLog $LoadCaseStartT
			# set ParameterSwitchtime [expr $ParameterSwitchtime + 1 ];
			break;
		}
		# 如果试算成功，完成指定步数计算
		set AtypeOk [DYIntSymSwitch $RunStep $CuAn_dt $Atype $TestType $Tol $MaxNumIter $GM_time $IntegratorType 1];	
		# set AtypeOk [DYIntSymSwitch $RunStep $CuAn_dt $Atype $TestType $Tol $MaxNumIter $GM_time $IntegratorType];	
		# 给出计算结果完成信息
		set controlTimeE [getTime];
		set remainTimeE [expr $GM_time-$controlTimeE];
		set completeTime [expr $controlTimeE - $controlTimeS];	
		set completeStep [expr $completeTime/$CuAn_dt];
		set ok [lindex $AtypeOk 0];
		RunAndLog $RunLog "********************************************************************************\n** Analysis finished at Parameter Level $PmLevel.\n** Analysis complete [format {%0.0f} $completeStep] steps.\n** ok = $ok\n** There are [format {%0.3f} $remainTimeE] more seconds to run.\n********************************************************************************\n"
		RunTimeCheck $RunLog $LoadCaseStartT	
		# 采集倒塌信息
		####################################################
		set DriftFlag [MaxDriftTesterBiDirection $NStories $DriftLimit $FloorNodes $StoryHeight];	
		set maxDriftData [MaxDrift $NStories $FloorNodes $StoryHeight];
		set maxDrift [lindex $maxDriftData 0];
		# set maxDriftDir [lindex $maxDriftData 1];
		RunAndLog $RunLog "@maxDrift : $maxDrift "
		if {$MaxCheckDrift < $maxDrift} {
			set MaxCheckDrift $maxDrift;
		}
		RunAndLog $RunLog "@MaxCheckedDrift : $MaxCheckDrift "	
		####################################################
		
		if {$DriftFlag == "NO"} {			
			set DriftOKtime [expr $DriftOKtime + 1 ];
			RunAndLog $RunLog "********************************************************************************\n**DriftOKtime :  $DriftOKtime => maxDrift : [format {%0.5f} $maxDrift]";
			
		}		
		if { $ModeCount != 0 && $DriftOKOuttime < $DriftOKtime } {
			set DriftOKOutjump 1;
		} 
		
		if { $ModeCount == 0 && $PmLevel == 1 && $controlTimeE > [expr 0.66*$GM_time] } {
			set RunTrigger [expr ($DriftFlag == "NO" && $DriftOKOutjump != 1 && ($ok != 0 || $remainTimeE > 0))];
		} else {
			set RunTrigger [expr ($DriftFlag == "NO" && $DriftOKOutjump != 1 && ($ok != 0 || $remainTimeE > $remainTimeStop))];
		}
		# 根据计算结果信息判断是否改变计算参数
		if {$ok == 0 && $PmLevel == 1 } {
			# RunAndLog $RunLog "********************************************************************\n** Analysis go well at PmLevel 1. Parameters switch back to default settings.\n*********************************************************************\n"
			RunAndLog $RunLog "********************************************************************************\n** Analysis go well at PmLevel 1. Parameters level stays at PmLevel 1."
			RunAndLog $RunLog "** DriftRatio exceeds the setting limit ([format {%0.3f} $DriftLimit]), doesn't it? $DriftFlag (MaxDrift : [format {%0.3f} $maxDrift])."
			RunAndLog $RunLog "** Analysis parameters switched $ParameterSwitchtime times! \n********************************************************************************\n"
			# set ParameterSwitchtime [expr $ParameterSwitchtime + 1 ];
			RunTimeCheck $RunLog $LoadCaseStartT
			continue;
		} elseif {$ok == 0 && $PmLevel > 1 && $PmLevel <= $changingtimes} {
			set PmLevel [expr $PmLevel - 1];
			RunAndLog $RunLog "********************************************************************************\n** Analysis go well at PmLevel [expr $PmLevel +1]. Parameters switch down to PmLevel [expr $PmLevel]."
			RunAndLog $RunLog "** DriftRatio exceeds the setting limit ([format {%0.3f} $DriftLimit]), doesn't it? $DriftFlag (MaxDrift : [format {%0.3f} $maxDrift]). "
			RunAndLog $RunLog "** Analysis parameters switched $ParameterSwitchtime times! \n********************************************************************************\n"
			set ParameterSwitchtime [expr $ParameterSwitchtime + 1 ];
			RunTimeCheck $RunLog $LoadCaseStartT
			continue;	
		} elseif {$ok != 0 && $PmLevel >= 1 && $PmLevel < $changingtimes} {
			set PmLevel [expr $PmLevel + 1];
			RunAndLog $RunLog "********************************************************************************\n** Analysis fail at PmLevel [expr $PmLevel -1]. Parameters switch up to PmLevel [expr $PmLevel]."
			RunAndLog $RunLog "** DriftRatio exceeds the setting limit ([format {%0.3f} $DriftLimit]), doesn't it? $DriftFlag (MaxDrift : [format {%0.3f} $maxDrift]). "
			RunAndLog $RunLog "** Analysis parameters switched $ParameterSwitchtime times! \n********************************************************************************\n"
			set ParameterSwitchtime [expr $ParameterSwitchtime + 1 ];
			RunTimeCheck $RunLog $LoadCaseStartT
			continue;
		} else {
			RunAndLog $RunLog "********************************************************************************\n** Analysis fail through PmLevel 1 to PmLevel $changingtimes."
			RunAndLog $RunLog "** DriftRatio exceeds the setting limit ([format {%0.3f} $DriftLimit]), doesn't it? $DriftFlag (MaxDrift : [format {%0.3f} $maxDrift]). "
			RunAndLog $RunLog "** Analysis parameters switched $ParameterSwitchtime times! \n********************************************************************************\n"
			# set ParameterSwitchtime [expr $ParameterSwitchtime + 1 ];
			RunTimeCheck $RunLog $LoadCaseStartT
			break;
		}
		

	}; # End of While
	# set DriftCautionFlag [MaxDriftTesterBiDirection $NStories $ModeCheckDrift $RigidDiaphNodeItem $StoryHeight];
	# set CollapseFlag [MaxDriftTesterBiDirection $NStories $DriftLimit $RigidDiaphNodeItem $StoryHeight];
	RunAndLog $RunLog "********************************************************************************\n********************************************************************************\n** Go to the solver! \n********************************************************************************\n********************************************************************************\n"
		
	set DriftAndOk [list $ok $DriftFlag $MaxCheckDrift $DriftOKOutjump];
	return $DriftAndOk
		
}

##############################################################################################################################
#          	  				 			Extract Bi direction max drift from recorder files				    				 #
##############################################################################################################################

proc ExtractBiDirectionalMaxDrift3DModel {pathToOutputFile} {

 global maximumXStoryDrift
 global maximumZStoryDrift
 set maximumXStoryDrift 0.0
 set maximumZStoryDrift 0.0
 
# Maximum X-Story Drift
set maxDriftOutputFile [open $pathToOutputFile/StoreyDrifts/StoreyXDrifts.txt r];
set Drifts_data_list_X {};
set Drifts_data_list_X [read $maxDriftOutputFile];
close $maxDriftOutputFile;

set AbsDrifts_data_list_X {};
foreach DriftsData $Drifts_data_list_X {
   lappend AbsDrifts_data_list_X [expr abs($DriftsData)];
}
set maximumXStoryDrift [lindex [lsort -real $AbsDrifts_data_list_X] end];

# Maximum Z-Story Drift
set maxDriftOutputFile [open $pathToOutputFile/StoreyDrifts/StoreyZDrifts.txt r];
set Drifts_data_list_Z {};
set Drifts_data_list_Z [read $maxDriftOutputFile];
close $maxDriftOutputFile;

set AbsDrifts_data_list_Z {};
foreach DriftsData $Drifts_data_list_Z {
   lappend AbsDrifts_data_list_Z [expr abs($DriftsData)];
}
set maximumZStoryDrift [lindex [lsort -real $AbsDrifts_data_list_Z] end];
 
}