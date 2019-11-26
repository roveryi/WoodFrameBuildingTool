# model BasicBuilder -ndm 3 -ndf 6
# Defining model builder
# Defining seismic parameters
# Defining geometry and model variables
# Defining nodes
node 111017 0.0 0.0 0.0;
node 111018 0.0 0.0 0.0;
node 121017 180.0 0.0 0.0;
node 121018 180.0 0.0 0.0;

node 211015 0.0 111.0 0.0;
node 211016 0.0 111.0 0.0;
node 211019 0.0 111.0 0.0;

node 221015 180.0 111.0 0.0;
node 221016 180.0 111.0 0.0;
node 221019 180.0 111.0 0.0;

# Defining rigid floor diaphragm constraints
# fix	2002 0 1 0 1 0 1
# rigidDiaphragm 2 2002 211019 221019 212019 222019
# Rigid diaphragm constraints defined
# Defining node fixities
fix	111017	1	1	1	1	1	1
fix	121017	1	1	1	1	1	1

equalDOF 221019 211019 1 3 5;
# All column base fixities have been defined
# Defining beam hinge material models
set iXBeamProp [WFProp W10X33];
# set iXBeamProp [WFProp W36X256];
# set Prop [list $name $d $A $bf $tw $tf $Ix $Iy $Zx $Zy $ry $J];
set c1 25.4;
set c2 6.895;
set XBeamHingeA [lindex $iXBeamProp 2];
set XBeamHinged [lindex $iXBeamProp 1];
set XBeamHingebf [lindex $iXBeamProp 3];
set XBeamHingetw [lindex $iXBeamProp 4];
set XBeamHingetf [lindex $iXBeamProp 5];
set XBeamHingeIx [lindex $iXBeamProp 6];
set XBeamHingeIy [lindex $iXBeamProp 7];
set XBeamHingeZx [lindex $iXBeamProp 8];
set XBeamHingery [lindex $iXBeamProp 10];
set XBeamHingeJ [lindex $iXBeamProp 11];
set XBeamHingeh [expr $XBeamHinged-2*$XBeamHingetf];
set XBeamHingeL $LGrid;
# set XBeamHingeL 240;

set XBeamHingeMatTag 700000001;
# set XBeamHingeK0   1.704267;
set XBeamHingeK0   [expr 6*$E*$XBeamHingeIx/$XBeamHingeL];
# set XBeamHingeMy   1.757690;
set XBeamHingeMy   [expr $XBeamHingeZx*$BeamFy];
set XBeamHingeThetaY  [expr $XBeamHingeMy/$XBeamHingeK0];
# set XBeamHingeLambda 169.788058;
set XBeamHingeLambda [expr 536*($XBeamHingeh/$XBeamHingetw)**(-1.26)*($XBeamHingebf/2.0/$XBeamHingetf)**(-0.525)*($BeamFy*$c2/355.0)**(-0.291)*($XBeamHingeL/$XBeamHingery)**(-0.130)];
# set XBeamHingeThetaP   0.307255;
set XBeamHingeThetaP   [expr 0.318*($XBeamHingeh/$XBeamHingetw)**(-0.55)*($XBeamHingebf/2.0/$XBeamHingetf)**(-0.345)*($BeamFy*$c2/355.0)**(-0.130)*($XBeamHinged*$c1/533.0)**(-0.330)*($XBeamHingeL/$XBeamHinged)**(0.090)*($XBeamHingeL/$XBeamHingery)**(-0.0230)];
# set XBeamHingeThetaPc   3.403249;
set XBeamHingeThetaPc   [expr 7.50*($XBeamHingeh/$XBeamHingetw)**(-0.61)*($XBeamHingebf/2.0/$XBeamHingetf)**(-0.71)*($BeamFy*$c2/355.0)**(-0.320)*($XBeamHinged*$c1/533.0)**(-0.161)*($XBeamHingeL/$XBeamHingery)**(-0.110)];
# set XBeamHingeas   0.369232;
set XBeamHingeas   [expr $XBeamHingeMy*0.11/$XBeamHingeK0/$XBeamHingeThetaP];
set XBeamHingeMrR   0.250000;
set XBeamHingeThetaAll  [expr $XBeamHingeThetaY+$XBeamHingeThetaP*$XBeamHingeThetaPc];
set XBeamHingeThetaU  [expr min(0.060000,$XBeamHingeThetaAll)];
CreateBilinMaterial $XBeamHingeMatTag $XBeamHingeK0 $stiffFactor0 $XBeamHingeas $XBeamHingeMy $XBeamHingeLambda $XBeamHingeThetaP $XBeamHingeThetaPc $XBeamHingeMrR $XBeamHingeThetaU;	

# Beam hinge materials defined
# Defining beam hinges	
rotXBeamSpring3DModIKModel 21107 211019 211015 $XBeamHingeMatTag $StiffMat;
rotXBeamSpring3DModIKModel 22107 221015 221019 $XBeamHingeMatTag $StiffMat;

# Beam hinges defined
# Defining beam elements
# Beam section name is W8X10
element	elasticBeamColumn	101	211015	221015	$XBeamHingeA	29000.0	11500.0	$XBeamHingeJ	$XBeamHingeIy $XBeamHingeIx	4

# XBeams defined

# Defining column hinge material models
set iColumnProp [BoxProp B5X0.13];
# set iColumnProp [BoxProp B26X3.0];
# set Prop [list $shape $b $t $A $Ix $Zx $ry];
# set c1 25.4;
# set c2 6.895;
set ColumnHingeb 8.02;
set ColumnHinget 0.35;
set ColumnHingebA 17;
set ColumnHingeIx 475;
set ColumnHingeZx 86.4;
set ColumnHingery 2.51;
set ColumnHingeJ 1.00E+06;

# set ColumnHingeL $LGrid;
set ColumnHingeL $LColB;
set ColumnHingeL 111;

set ColHingeMatTag 800000001;

set ColHingeNoverNy 0.2;
set ColHingeK0 [expr 6*$E*$ColumnHingeIx/$ColumnHingeL];
set ColHingeMy 5750;
set ColHingeThetaY  [expr $ColHingeMy/$ColHingeK0];
set ColHingeLambda 1.659;
set ColHingeThetaP 0.046		;
set ColHingeThetaPc 0.183		;
set ColHingeas [expr $ColHingeMy*0.06/$ColHingeK0/$ColHingeThetaP];
set ColHingeRes 2.500000e-01;
set ColHingeThetaU 0.4;
CreateBilinMaterial $ColHingeMatTag $ColHingeK0 $stiffFactor0 $ColHingeas $ColHingeMy $ColHingeLambda $ColHingeThetaP $ColHingeThetaPc $ColHingeRes $ColHingeThetaU;

# Defining column hinges
rotColSpring3DModIKModel 111012 111017 111018 $StiffMat $StiffMat $StiffMat $ColHingeMatTag $StiffMat $ColHingeMatTag
rotColSpring3DModIKModel 211011 211016 211019 $StiffMat $StiffMat $StiffMat $ColHingeMatTag $StiffMat $ColHingeMatTag

rotColSpring3DModIKModel 121012 121017 121018 $StiffMat $StiffMat $StiffMat $ColHingeMatTag $StiffMat $ColHingeMatTag
rotColSpring3DModIKModel 221011 221016 221019 $StiffMat $StiffMat $StiffMat $ColHingeMatTag $StiffMat $ColHingeMatTag

# Column hinge defined
# Defining column elements
element	elasticBeamColumn	201	111018	211016	$ColumnHingebA	29000.0	11500.0	$ColumnHingeJ	$ColumnHingeIx	$ColumnHingeIx	1
element	elasticBeamColumn	202	121018	221016	$ColumnHingebA	29000.0	11500.0	$ColumnHingeJ	$ColumnHingeIx	$ColumnHingeIx	1

# Columns defined
# Defining masses
# mass	211019	0.020494841849526532	0.020494841849526532	0.020494841849526532	1e-12	1e-12	1e-12;
# mass	221019	0.020494841849526532	0.020494841849526532	0.020494841849526532	1e-12	1e-12	1e-12;
# mass	212019	0.020494841849526532	0.020494841849526532	0.020494841849526532	1e-12	1e-12	1e-12;
# mass	222019	0.020494841849526532	0.020494841849526532	0.020494841849526532	1e-12	1e-12	1e-12;
# Nodal masses defined
# Defining gravity loads
# pattern Plain 101 Constant {
# eleLoad -ele	21101	-type -beamUniform -0.0008813194444444443 0.000
# eleLoad -ele	21201	-type -beamUniform -0.0008813194444444443 0.000
# eleLoad -ele	21102 -type -beamUniform	-0.0008813194444444443 0.000
# eleLoad -ele	11103 -type -beamUniform 0.000 0.000 -0.010718749999999999
# eleLoad -ele	12103 -type -beamUniform 0.000 0.000 -0.010718749999999999
# eleLoad -ele	11203 -type -beamUniform 0.000 0.000 -0.010718749999999999
# eleLoad -ele	12203 -type -beamUniform 0.000 0.000 -0.010718749999999999
# load	211019	0	-7.643249999999999	0	0	0	0
# load	221019	0	-7.643249999999999	0	0	0	0
# load	212019	0	-7.643249999999999	0	0	0	0
# load	222019	0	-7.643249999999999	0	0	0	0
# }
# Gravity loads defined
# Defining all recorders
# recorder Node -file VerticalReactions.txt -time -node 111017 121017  -dof 2 reaction
# recorder Node -file XReactions.txt -time -node 111017 121017 -dof 1 reaction
# recorder Node -file ZReactions.txt -time -node 111017 121017  -dof 3 reaction
# recorder Element -file GlobalColumnForcesStorey01.txt -ele 201 202 globalForce
# All Recorders Defined
