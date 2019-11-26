##############################################################################################################################
# DefineVariables                                                                                                            #
#   This file will be used to define all variables that will be used in the analysis                                         #
#                                                                                                                            #
# Created by: Henry Burton, Stanford University, 2010                                                                        #
# Edited by: Xiaolei Xiong, Tongji University, 2017                                                                          #
# Units: kips, inches, seconds                                                                                               #
##############################################################################################################################
 


##############################################################################################################################
#                                                       Miscellaneous                                                        #
##############################################################################################################################

# Define Hinge Type
set HingeType Fiber; # HingeType can be "Fiber" or "Bilin"

# Define Geometric Transformations
set PDeltaTransf 1;
set LinearTransf 2;
set ZBeamLinearTransf 3;
set XBeamLinearTransf 4;
# set XBraceCorotTransf 5;
# set ZBraceCorotTransf 6;
    
# set up geometric transformations of element
geomTransf PDelta $PDeltaTransf 0 0 1;                          # PDelta transformation
geomTransf Linear $ZBeamLinearTransf -1 0 0;
geomTransf Linear $XBeamLinearTransf 0 0 1;
# geomTransf Corotational $ZBraceCorotTransf 1 0 0;
# geomTransf Corotational $XBraceCorotTransf 0 0 -1;
#   geomTransf Linear $XInfillTransf 0 0 -1
#   geomTransf Linear $ZInfillTransf -1 0 0

# Define Young's Modulus for Steel  
set E [expr 29000000*$psi];
# set E 29000000;

# Define Poisson's ratio for Steel  
set Ps 0.3;

# Define Shear Modulus for Steel    
# set G [expr $E/2.0/(1 + $Ps)];
set G [expr 11.5*1000000*$psi];

# Define Yield Strength for Beam and Column 
set BeamFy [expr 36*$ksi];
set ColumnFy [expr 50*$ksi];

# Define Density for Steel  
# set RoSteel [expr 78*$kN/$meter/$meter/$meter];
# set RoConcretes [expr 25*$kN/$meter/$meter/$meter];
set RoSteel [expr 490*$pcf];
set RoConcrete [expr 62.4*$pcf];
# set RoConcrete [expr 146.28*$pcf];
# set RoConcrete [expr 150*$pcf];

# Residual strength ratio for beam-column flexure (concrete)
set resStrRatioBeamColumnFlexure 0.01

# Residual strength ratio for column shear (concrete)
set resStrRatioColumnShear 0.01

# Define stiffness factors for plastic hinges and elastic elements
set stiffFactor0 20.0;    # Ks=$stiffFactor0 * Kbc
# set stiffFactor0 10.0;    # Ks=$stiffFactor0 * Kbc
set stiffFactor1 11.0;
set stiffFactor2 1.0;

#Define residual strength ratio for Clough Beam-Column Elements
# set resStrRatioBeamColumn 0.01;

# # UDamping ratio used for Rayleigh Damping !!! set in B0a_DefineDampingParameters.tcl
# set dampRat     0.050;      # Damping Ratio
# set dampRatF    1.0;        # Factor on the damping ratio.

# Define the periods to use for the Rayleigh damping calculations
# set periodForRayleighDamping_1 5.869662645627329;	# Mode 1 period - NEEDS to be UPDATED
set periodForRayleighDamping_1 0.04385044154047379;	# Mode 1 period - NEEDS to be UPDATED
# set periodForRayleighDamping_2 2.8757773830782978;	# Mode 3 period - NEEDS to be UPDATED
set periodForRayleighDamping_2 0.032101876839331904;	# Mode 3 period - NEEDS to be UPDATED
    

# define p-delta columns and rigid links
set TrussMatID 60000;       # define a material ID
    
# Define P-Delta Rigid Link Material
uniaxialMaterial Elastic $TrussMatID 1.0;       # define truss material
    
set Arigid 200000000.0;     # define area of truss section (make much larger than A of frame elements)
set Irigid 9000000000.0;   # moment of inertia for p-delta columns  (make much larger than I of frame elements)

set LargeStiff [expr 1e12 * $ksi];
set LargeNumber 1e8;
# Define material for gap element at rocking spine
set SpineBaseMatID 70000;
set SpineBaseMatID2 80000;
set SpineBaseVerticalCompressionStiff $LargeStiff; # Assuming 4ft square footing and 200 pci subgrade modulus
set SpineBaseLateralStiff $LargeStiff; # Assuming 4ft square footing and 200 pci subgrade modulus
set Negligible [expr 1e-12 * $ksi];

# Define material ID for columns and beam shear springs
set ColumnShearSpringMatID 90000;
    
# Define very stiff uniaxial material
set StiffMat 1200
    
# Define very stiff uniaxial material   
set SoftMat 1300
    
uniaxialMaterial Elastic $StiffMat $LargeStiff;     # define truss material
uniaxialMaterial Elastic $SoftMat $Negligible;      # define truss material 
# Define compression only material  
set CompressionOnlyMat 700000;
uniaxialMaterial ENT $CompressionOnlyMat $LargeStiff;       
    
# Define variable used to reference file with element removal data
set fileremoval "Dispwall1-cg.tcl"; 

##############################################################################################################################
#                                                  frame configuration                                                       #
##############################################################################################################################

# ----------------------------------------------------------------
set NStory 0;           # number of stories above ground level in Y direction (including the number of lobby stories), default=40
# ----------------------------------------------------------------
set NLobby 0;           # number of lobby stories above ground level in Y direction, default=1
# ----------------------------------------------------------------
set NBase 1;           # number of basements under ground level in Y direction, default=3
# ----------------------------------------------------------------
set ZBay 1;             # number of Bays in Z direction, default=4
# ----------------------------------------------------------------
set XBay 1;         # number of Bays in X direction, default=6
# ----------------------------------------------------------------
puts "Number of Stories in Y: $NStory"
puts "Number of Basements in Y: $NBase"
puts "Number of Bays in X: $XBay"
puts "Number of Bays in Z: $ZBay"
set XPier [expr $XBay + 1]; 
set ZPier [expr $ZBay + 1]; 
set NLevel [expr max($NLobby,$NStory) + $NBase + 1]; # number of levels
set NStories [expr max($NLobby,$NStory) + $NBase]; # number of Stories
set firstsplice 53;      # the first level above which column splice occurs (including basement), default=3or4, cann't be 1
set spliceincr 3;       # number of incremental level at each splice place
set iSplice $firstsplice;
set SpliceStory "";     
while {$iSplice < $NLevel} {
    lappend SpliceStory $iSplice;
    incr iSplice $spliceincr;
}
set spliceabove [expr 4*$ft]; #the height of splice node above the level

# set SpliceLevel "";       # the level right !!!below!!! which column splice occurs
# foreach iSpliceStory $SpliceStory {
    # set iSpliceLevel [expr $iSpliceStory + 1]
    # lappend SpliceLevel $iSpliceLevel;
# } 

# Column Piers data
set Longspan 2; #longspan means the times of interior long span to short span, default=2.
set iZbeam 1;
set ZBeamline ""
while {$iZbeam <= $XPier} {
	lappend ZBeamline $iZbeam
	set iZbeam [expr $iZbeam + $Longspan]
}
	
set ColPier ""
for {set z 1} {$z<=$ZPier} {incr z} {
    if {$z == 1 || $z == $ZPier} {
        for {set x 1} {$x<=$XPier} {incr x 1} {
            set iColPier [list $x $z] 
            lappend ColPier $iColPier
        }
    } else {
    for {set x 1} {$x<=$XPier} {incr x $Longspan} {
        set iColPier [list $x $z] 
        lappend ColPier $iColPier
        }
    }
}

# Define GEOMETRY -------------------------------------------------------------
# Define Structure Geometry Paramters
set LColS   [expr 12.5*$ft];        # superstructure column height (parallel to Z axis)
set LColL   [expr 20.0*$ft];        # lobby column height (parallel to Z axis)
set LColB   [expr 9.25*$ft];        # basement column height (parallel to Z axis)
set LGrid   [expr 15.0*$ft];        # grid length 
set Aera    [expr $XBay*$LGrid*$ZBay*$LGrid];       # plan area
set Perimeter [expr $XBay*$LGrid*2.0 + $ZBay*$LGrid*2.0];       # plan perimeter

set StoryHeight ""
for {set y 1} {$y<=$NBase} {incr y} {
    lappend StoryHeight $LColB
}
for {set y 1} {$y<=$NLobby} {incr y} {
    lappend StoryHeight $LColL
}
for {set y 1} {$y<=[expr $NStory - $NLobby]} {incr y} {
    lappend StoryHeight $LColS
}

set ZCor ""
for {set z 1} {$z<=$ZPier} {incr z} {
    set iZCor [expr ($z - 1)*$LGrid]; 
    lappend ZCor $iZCor
}
set XCor ""
for {set x 1} {$x<=$XPier} {incr x} {
    set iXCor [expr ($x - 1)*$LGrid]; 
    lappend XCor $iXCor
}
set YCor "0"
for {set y 1} {$y<=$NBase} {incr y} {
    set iYCor [expr $y*$LColB]; 
    lappend YCor $iYCor
}
set aYCor $iYCor
for {set y 1} {$y<=$NLobby} {incr y} {
    set iYCor [expr $aYCor + $y*$LColL]; 
    lappend YCor $iYCor
}
set aYCor $iYCor
for {set y 1} {$y<=[expr $NStory - $NLobby]} {incr y} {
    set iYCor [expr $aYCor + $y*$LColS]; 
    lappend YCor $iYCor
}

set BuildingHeight $iYCor;

set SectionStory [list 10 20 30 40]; # Must be input in ascending consequence, and only can be four members list
set SectionLevel ""
foreach iSectionStory $SectionStory {
    set iSectionLevel [expr $iSectionStory + $NBase + 1]
    lappend SectionLevel $iSectionLevel
} 
# set SecLevelNo [llength $SectionLevel]; #Number of total section levels

set BeamSecExt [list W8X10 W33X169 W33X118 W24X62];
set BeamSecIntS [list W8X10 W36X194 W33X169 W27X84];
set BeamSecIntL [list W8X10 W27X84 W27X84 W24X76];
set BeamSecs [list $BeamSecExt $BeamSecIntS $BeamSecIntL]; #the sequence in list cannot be changed

set ColumnSecInt [list B10X1.0 B20X2.0 B18X1.0 B18X0.75];
set ColumnSecExtS [list B10X1.0 B26X2.5 B24X1.5 B24X1.0];
set ColumnSecExtL [list B10X1.0 B20X2.0 B18X1.0 B18X0.75];
set ColumnSecs [list $ColumnSecInt $ColumnSecExtS $ColumnSecExtL]; #the sequence in list cannot be changed

set LoadStory [list -1 0 19 20 38 39 40]; # Must be input in ascending consequence
set LoadLevel ""
foreach iLoadStory $LoadStory {
    set iLoadLevel [expr $iLoadStory + $NBase + 1]
    lappend LoadLevel $iLoadLevel
} 

set DLSlab      [expr 3*$RoConcrete];
# set DLSlab    [expr 40.0*$psf];
set DLFacade    [expr 41.5*$psf];

set DLParking   [expr 15*$psf + $DLSlab];
set DLLobby     [expr 90*$psf + $DLSlab];
set DLOffice    [expr 40*$psf + $DLSlab];
set DLMech      [expr 135*$psf + $DLSlab];
set DLRoof 		[expr 85*$psf + $DLSlab];

set LLParking   [expr 52*$psf];
set LLLobby     [expr 100*$psf];
set LLOffice    [expr 56*$psf];
set LLMech      [expr 56*$psf];
set LLRoof		[expr 32*$psf];

set ELParking   [expr 1.0*$DLParking + 0.25*$LLParking];
set ELLobby     [expr 1.0*$DLLobby + 0.25*$LLLobby];
set ELOffice    [expr 1.0*$DLOffice + 0.25*$LLOffice];
set ELMech      [expr 1.0*$DLMech + 0.25*$LLMech];
set ELRoof		[expr 1.0*$DLRoof + 0.25*$LLRoof];

set E2LParking   [expr 1.05*$DLParking + 0.25*$LLParking];
set E2LLobby     [expr 1.05*$DLLobby + 0.25*$LLLobby];
set E2LOffice    [expr 1.05*$DLOffice + 0.25*$LLOffice];
set E2LMech      [expr 1.05*$DLMech + 0.25*$LLMech];
set E2LRoof  	[expr 1.05*$DLRoof + 0.25*$LLRoof];

set LoadValueList [list $ELParking $ELLobby $ELOffice $ELMech $ELOffice $ELMech $ELRoof];
set LoadValueList2 [list $E2LParking $E2LLobby $E2LOffice $E2LMech $E2LOffice $E2LMech $E2LRoof];


set FloorWeight "";
for {set y 2} {$y <= $NLevel} {incr y} {
	set iFLoad [FloorLoad $y $LoadValueList $LoadLevel];
	if {$y < $NLevel} {
		set UstoreyHeight [lindex $StoryHeight [expr $y - 1]];
		set UiFacadeSelfGravity [expr $DLFacade*$Perimeter*$UstoreyHeight/2.0];
	} else {
		set UstoreyHeight 0.0;
		set UiFacadeSelfGravity 0.0;
	}
	set DstoreyHeight [lindex $StoryHeight [expr $y - 2]];
	set DiFacadeSelfGravity [expr $DLFacade*$Perimeter*$DstoreyHeight/2.0];
	set iColumnWeight 0.0; # the weight of columns in one storey
	set iFacadeWeight 0.0; # the weight of facade in one storey
	# sum column weight above and below the level
	foreach iCor $ColPier { 
		set x [lindex $iCor 0];
		set z [lindex $iCor 1];
		# column weight from the column above the level
		if {$y < $NLevel} {
			set UiColumnSecName [ColumnSectionName [expr $y + 1] $iCor $ColumnSecs $SectionLevel $XPier $ZPier];
			set UiColumnProp [BoxProp $UiColumnSecName];
			set UiA [lindex $UiColumnProp 3];
			set UicolumnSelfGravity [expr $UiA*$RoSteel*$UstoreyHeight/2.0];
		} else {
			set UicolumnSelfGravity 0.0;
		}
		# column weight from the column below the level
		set DiColumnSecName [ColumnSectionName $y $iCor $ColumnSecs $SectionLevel $XPier $ZPier];
		set DiColumnProp [BoxProp $DiColumnSecName];
		set DiA [lindex $DiColumnProp 3];
		set DicolumnSelfGravity [expr $DiA*$RoSteel*$DstoreyHeight/2.0];
		
		set iColumnWeight [expr $iColumnWeight + $UicolumnSelfGravity + $DicolumnSelfGravity];
	}
	set iFacadeWeight [expr $UiFacadeSelfGravity + $DiFacadeSelfGravity];
	set iFloorWeight [expr $iFLoad*$Aera + $iColumnWeight + $iFacadeWeight];
	lappend FloorWeight $iFloorWeight;
}

set CornerColAA [expr $LGrid**2/4.0];
set EdgeColAA [expr $LGrid**2/2.0];
set InnerColAA [expr $LGrid**2*2.5];

set ColAAList [list $CornerColAA $EdgeColAA $EdgeColAA $InnerColAA];

set RotMassGC [expr ($XBay*$LGrid*$XBay*$LGrid + $ZBay*$LGrid*$ZBay*$LGrid)/12.0];
# Region tag information
# set PZRDNodeReg 01; # Group Tag for Panel Zone Rigid Diaphgram Node
# set BColNodeReg 02; # Group Tag for Column Node at Bottom
# set XBeamReg 03;
# set ZBeamReg 04;
# set ColReg 05;
# set STColReg 06;
# set SBColReg 07;
# set XBeamHingeReg 08;
# set ZBeamHingeReg 09;
# set TColHingeReg 10;
# set BColHingeReg 11;
# set SColHingeReg 12;
# set XPanelZoneHingeReg 13;
# set ZPanelZoneHingeReg 14;

# Element tag information
# set XBeamId 01;
# set ZBeamId 02;
# set ColId 03;
# set TColId 04;
# set BColId 05;
# # set LColId 06;
# set XBeamLHingeId 07;
# set XBeamRHingeId 08;
# set ZBeamLHingeId 09;
# set ZBeamRHingeId 10;
# set TColHingeId 11;
# set BColHingeId 12;
# set SColHingeId 13;
# # set LColHingeId 14;
# set XPZId 21;
# set ZPZId 31;
# set XPZHingeId 41;
# set ZPZHingeId 51;

set RigidDiaphNodeItem ""
for {set y 2} {$y <= $NLevel} {incr y} {	
	lappend RigidDiaphNodeItem [format %s%s%s $y 0 02];	
}

set RigidDiaphragm ON;
##############################################################################################################################
#                                               Analysis configuration                                                       #
##############################################################################################################################

# Define pushover analysis parameters
# set IDctrlNode	[format %s%s%s $NLevel 0 02];
set IDctrlNode	211019;
# set IDctrlDOF	3
set Dincr	1.0e-4;
set PushDriftPercent 10;
set Dmax	[expr $PushDriftPercent*$BuildingHeight/100];


# Vertical distribution factor for equivalent lateral loads,DPk is the k in Code.
if {$CuTcode <= 0.5} {
	set DPk 1;
} elseif {$CuTcode <= 2.5} {
	set DPk [expr 1 + ($CuTcode - 0.5)/2];
} else {
	set DPk 2;
}
set sumWeightHeight 0;
for {set y 1} {$y <= [expr $NLevel - 1]} {incr y} {
	set sumWeightHeight [expr $sumWeightHeight + [lindex $FloorWeight [expr $y - 1]]*[expr [lindex $YCor $y]/12]**$DPk];
}
for {set y 1} {$y <= [expr $NLevel - 1]} {incr y} {
	set iWeightHeight [expr [lindex $FloorWeight [expr $y - 1]]*[expr [lindex $YCor $y]/12]**$DPk];
	set Cvx(Storey$y) [expr $iWeightHeight/$sumWeightHeight];
}

# Scale factor needed to anchor median spectra of ground motion set
# to MCE level
# set MCEScaleFactor 1.0, not sure.

# Damping parameters presetting, dynamic analysis will set in damping parameters tcl file.
set alphaM 0.0;
set betaKcurr 0.0;
set betaKinit 0.0;
set betaKcomm 0.0;
# set alpha1 0.0;
# set alpha2ToUse 0.0;
if { [info exists TimeHistoryAnalysisType] == 1 } {
	set xDamp 0.02;					# damping ratio 
	set MpropSwitch 1.0;
	set KcurrSwitch 0.0;
	set KcommSwitch 0.0;
	set KinitSwitch 1.0;
	set omegaI [expr (2.0 * $pi) / $periodForRayleighDamping_1];
	set omegaJ [expr (2.0 * $pi) / ($periodForRayleighDamping_2)];
	set alphaM [expr $MpropSwitch*$xDamp*(2.*$omegaI*$omegaJ)/($omegaI+$omegaJ)];	# M-prop. damping; D = alphaM*M
	set betaKcurr [expr ($stiffFactor0+1.0)/$stiffFactor0*$KcurrSwitch*2.*$xDamp/($omegaI+$omegaJ)];         		# current-K;      +beatKcurr*KCurrent
	set betaKcomm [expr ($stiffFactor0+1.0)/$stiffFactor0*$KcommSwitch*2.*$xDamp/($omegaI+$omegaJ)];   		# last-committed K;   +betaKcomm*KlastCommitt
	set betaKinit [expr ($stiffFactor0+1.0)/$stiffFactor0*$KinitSwitch*2.*$xDamp/($omegaI+$omegaJ)];         			# initial-K;     +beatKinit*Kini	
}
puts "Variables Defined"