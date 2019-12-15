## Define Beam Section Properties and Element
# These number can be modified regarding convergence issues]
uniaxialMaterial Elastic	99999	1e-8;
uniaxialMaterial Elastic	199999	1e8;

# Define Material Properties
set	Es	29000.0; #steel Young modulus
set	G	11500.0; # steel shear modulus
set	n	10.0; # stiffness multiplier for rotational spring

## Define Moment Frame Damping Parameters
set omegaI [expr (2.0 * $pi) / $periodForRayleighDamping_1];
set omegaJ [expr (2.0 * $pi) / ($periodForRayleighDamping_2)];
set alpha1Coeff [expr (2.0 * $omegaI * $omegaJ) / ($omegaI + $omegaJ)];
set alpha2Coeff [expr (2.0) / ($omegaI + $omegaJ)];
set alpha1  [expr $alpha1Coeff*0.02];
set alpha2  [expr $alpha2Coeff*0.02];
set alpha2ToUse [expr 1.1 * $alpha2];  # 1.1 factor is becuase we apply to only LE elements

#Define Geometric Transformations
set XBeamLinearTransf 4;
geomTransf Linear $XBeamLinearTransf	0	0	1;

set ZBeamLinearTransf 3;
geomTransf Linear $ZBeamLinearTransf	1	0	0;

#Joint Nodes 
node	9111	60.0000	0.0000	360.0000;
node	9121	240.0000	0.0000	360.0000;
node	9112	60.0000	111.0000	360.0000;
node	9122	240.0000	111.0000	360.0000;

#Beam Hinge Nodes 
node	8112	60.0000	111.0000	360.0000;
node	8122	240.0000	111.0000	360.0000;

#Column Hinge Nodes 
node	7111	60.0000	0.0000	360.0000;
node	7121	240.0000	0.0000	360.0000;
node	7112	60.0000	111.0000	360.0000;
node	7122	240.0000	111.0000	360.0000;

#Frame Fixities
fix	9111	1	1	1	1	1	1;
fix	9121	1	1	1	1	1	1;

#Joint Nodes Rigid Diaphragm
#Seeting rigid floor diaphragm constraint on
set RigidDiaphragm ON;
set perpDirn	2;
rigidDiaphragm	$perpDirn	2000	9112;
rigidDiaphragm	$perpDirn	2000	9122;

#Define Moment Frame Beam Section Properties and Element
set Abm	2.9600; # cross-section area 
set Ibm	30.8000; # momment of inertia 
set Ibm_mod	[expr $Ibm*($n + 1.0/$n)]; # modified moment of inertia for beam 
set Jbm	1000000.0; # inertia of tortion for beam, just assign a small number 
set WBay	180.0000; # bay length 
set Ks_bm	[expr $n*6.0*$Es*$Ibm_mod/$WBay]; # rotational stiffness of beam springs 

#define rotational spring properties and create spring elements using "rotSpring3DModIKModel" procedure
#rotSpring3DModIKModel creates a uniaxial material spring with a bilinear response based on Modified Ibarra Krawinkler Deterioration Model

#define beam hinges
set My_bm	470.1100; #yield moment
set McMy_bm	1.1100; 
set LS_bm	135.0947; 
set LK_bm	135.0947; 
set LA_bm	1000.0000; 
set LD_bm	135.0947; 
set cS_bm	1.00; 
set cK_bm	1.00; 
set cA_bm	1.00; 
set cD_bm	1.00; 
set theta_pP_bm	0.0513; 
set theta_pN_bm	0.0513; 
set theta_pcP_bm	0.1097; 
set theta_pcN_bm	0.1097; 
set ResP_bm	0.4000; 
set ResN_bm	0.4000; 
set theta_uP_bm	0.4000; 
set theta_uN_bm	0.4000; 
set DP_bm	1.00; 
set DN_bm	1.00; 
set a_bm	[expr ($n+1.0)*($My_bm*($McMy_bm-1.0)) / ($Ks_bm*$theta_pP_bm)];
set b_bm	[expr ($a_bm)/(1.0+$n*(1.0-$a_bm))];

#define beam springs
#Spring ID: "8xya", where 8 = beam spring, x = Direction, y = Column Line, a = Floor, "x" convention: 5 = x Frame, 6 = z Frame
rotSpring3DRotZModIKModel	8512	9112	8112	$Ks_bm $b_bm $b_bm $My_bm [expr -$My_bm]	$LS_bm $LK_bm $LA_bm $LD_bm $cS_bm $cK_bm $cA_bm $cD_bm	$theta_pP_bm $theta_pN_bm $theta_pcP_bm $theta_pcN_bm	$ResP_bm $ResN_bm $theta_uP_bm $theta_uN_bm $DP_bm $DN_bm;
rotSpring3DRotZModIKModel	8522	9122	8122	$Ks_bm $b_bm $b_bm $My_bm [expr -$My_bm]	$LS_bm $LK_bm $LA_bm $LD_bm $cS_bm $cK_bm $cA_bm $cD_bm	$theta_pP_bm $theta_pN_bm $theta_pcP_bm $theta_pcN_bm	$ResP_bm $ResN_bm $theta_uP_bm $theta_uN_bm $DP_bm $DN_bm;
#Define beams
element elasticBeamColumn	81128122	8112	8122	 $Abm	$Es	$G	$Jbm	$Ibm	$Ibm	$XBeamLinearTransf;

set Acol	4.4100; # cross-section area 
set Icol	68.9000; # momment of inertia 
set Icol_mod	[expr $Icol*($n + 1.0/$n)]; # modified moment of inertia for beam 
set Jcol	1000000.0; # inertia of tortion for beam, just assign a small number 
set HStory	180.0000; # column length 
set Ks_col	[expr $n*6.0*$Es*$Icol_mod/$HStory]; # rotational stiffness of beam springs 

#define rotational spring properties and create spring elements using "rotSpring3DModIKModel" procedure
#rotSpring3DModIKModel creates a uniaxial material spring with a bilinear response based on Modified Ibarra Krawinkler Deterioration Model

set My_col	848.0000; #yield moment
set McMy_col	1.1100; 
set LS_col	201.6033; 
set LK_col	201.6033; 
set LA_col	1000.0000; 
set LD_col	201.6033; 
set cS_col	1.00; 
set cK_col	1.00; 
set cA_col	1.00; 
set cD_col	1.00; 
set theta_pP_col	0.0435; 
set theta_pN_col	0.0435; 
set theta_pcP_col	0.1417; 
set theta_pcN_col	0.1417; 
set ResP_col	0.4000; 
set ResN_col	0.4000; 
set theta_uP_col	0.4000; 
set theta_uN_col	0.4000; 
set DP_col	1.00; 
set DN_col	1.00; 
set a_col	[expr ($n+1.0)*($My_col*($McMy_col-1.0)) / ($Ks_col*$theta_pP_col)];
set b_col	[expr ($a_col)/(1.0+$n*(1.0-$a_col))];

#define column springs
#Spring ID: "7xya", where 7 = column spring, x = Direction, y = Column Line, a = Floor, "x" convention: 5 = x Frame, 6 = z Frame
rotSpring3DRotZModIKModel	7511	9111	7111	$Ks_col $b_col $b_col $My_col [expr -$My_col]	$LS_col $LK_col $LA_col $LD_col $cS_col $cK_col $cA_col $cD_col	$theta_pP_col $theta_pN_col $theta_pcP_col $theta_pcN_col	$ResP_col $ResN_col $theta_uP_col $theta_uN_col $DP_col $DN_col;
rotSpring3DRotZModIKModel	7521	9121	7121	$Ks_col $b_col $b_col $My_col [expr -$My_col]	$LS_col $LK_col $LA_col $LD_col $cS_col $cK_col $cA_col $cD_col	$theta_pP_col $theta_pN_col $theta_pcP_col $theta_pcN_col	$ResP_col $ResN_col $theta_uP_col $theta_uN_col $DP_col $DN_col;
#Define columns
element elasticBeamColumn	71117112	7111	7112	 $Abm	$Es	$G	$Jbm	$Ibm	$Ibm	$PDeltaTransf;

set Acol	4.4100; # cross-section area 
set Icol	68.9000; # momment of inertia 
set Icol_mod	[expr $Icol*($n + 1.0/$n)]; # modified moment of inertia for beam 
set Jcol	1000000.0; # inertia of tortion for beam, just assign a small number 
set HStory	180.0000; # column length 
set Ks_col	[expr $n*6.0*$Es*$Icol_mod/$HStory]; # rotational stiffness of beam springs 

#define rotational spring properties and create spring elements using "rotSpring3DModIKModel" procedure
#rotSpring3DModIKModel creates a uniaxial material spring with a bilinear response based on Modified Ibarra Krawinkler Deterioration Model

set My_col	848.0000; #yield moment
set McMy_col	1.1100; 
set LS_col	201.6033; 
set LK_col	201.6033; 
set LA_col	1000.0000; 
set LD_col	201.6033; 
set cS_col	1.00; 
set cK_col	1.00; 
set cA_col	1.00; 
set cD_col	1.00; 
set theta_pP_col	0.0435; 
set theta_pN_col	0.0435; 
set theta_pcP_col	0.1417; 
set theta_pcN_col	0.1417; 
set ResP_col	0.4000; 
set ResN_col	0.4000; 
set theta_uP_col	0.4000; 
set theta_uN_col	0.4000; 
set DP_col	1.00; 
set DN_col	1.00; 
set a_col	[expr ($n+1.0)*($My_col*($McMy_col-1.0)) / ($Ks_col*$theta_pP_col)];
set b_col	[expr ($a_col)/(1.0+$n*(1.0-$a_col))];

#define column springs
#Spring ID: "7xya", where 7 = column spring, x = Direction, y = Column Line, a = Floor, "x" convention: 5 = x Frame, 6 = z Frame
rotSpring3DRotZModIKModel	7512	9112	7112	$Ks_col $b_col $b_col $My_col [expr -$My_col]	$LS_col $LK_col $LA_col $LD_col $cS_col $cK_col $cA_col $cD_col	$theta_pP_col $theta_pN_col $theta_pcP_col $theta_pcN_col	$ResP_col $ResN_col $theta_uP_col $theta_uN_col $DP_col $DN_col;
rotSpring3DRotZModIKModel	7522	9122	7122	$Ks_col $b_col $b_col $My_col [expr -$My_col]	$LS_col $LK_col $LA_col $LD_col $cS_col $cK_col $cA_col $cD_col	$theta_pP_col $theta_pN_col $theta_pcP_col $theta_pcN_col	$ResP_col $ResN_col $theta_uP_col $theta_uN_col $DP_col $DN_col;
#Define columns
element elasticBeamColumn	71217122	7121	7122	 $Abm	$Es	$G	$Jbm	$Ibm	$Ibm	$PDeltaTransf;

region	10	-node	9111	9121	9112	9122	-rayleigh	$alpha1	0	$alpha2ToUse	0;
region	20	-ele	81128122	71117112	71217122	-rayleigh	$alpha1	0	$alpha2ToUse	0;
#Joint Nodes 
node	9131	60.0000	0.0000	0.0000;
node	9141	240.0000	0.0000	0.0000;
node	9132	60.0000	111.0000	0.0000;
node	9142	240.0000	111.0000	0.0000;

#Beam Hinge Nodes 
node	8132	60.0000	111.0000	360.0000;
node	8142	240.0000	111.0000	360.0000;

#Column Hinge Nodes 
node	7131	60.0000	0.0000	360.0000;
node	7141	240.0000	0.0000	360.0000;
node	7132	60.0000	111.0000	360.0000;
node	7142	240.0000	111.0000	360.0000;

#Frame Fixities
fix	9131	1	1	1	1	1	1;
fix	9141	1	1	1	1	1	1;

#Joint Nodes Rigid Diaphragm
#Seeting rigid floor diaphragm constraint on
set RigidDiaphragm ON;
set perpDirn	2;
rigidDiaphragm	$perpDirn	2000	9132;
rigidDiaphragm	$perpDirn	2000	9142;

#Define Moment Frame Beam Section Properties and Element
set Abm	2.9600; # cross-section area 
set Ibm	30.8000; # momment of inertia 
set Ibm_mod	[expr $Ibm*($n + 1.0/$n)]; # modified moment of inertia for beam 
set Jbm	1000000.0; # inertia of tortion for beam, just assign a small number 
set WBay	180.0000; # bay length 
set Ks_bm	[expr $n*6.0*$Es*$Ibm_mod/$WBay]; # rotational stiffness of beam springs 

#define rotational spring properties and create spring elements using "rotSpring3DModIKModel" procedure
#rotSpring3DModIKModel creates a uniaxial material spring with a bilinear response based on Modified Ibarra Krawinkler Deterioration Model

#define beam hinges
set My_bm	470.1100; #yield moment
set McMy_bm	1.1100; 
set LS_bm	135.0947; 
set LK_bm	135.0947; 
set LA_bm	1000.0000; 
set LD_bm	135.0947; 
set cS_bm	1.00; 
set cK_bm	1.00; 
set cA_bm	1.00; 
set cD_bm	1.00; 
set theta_pP_bm	0.0513; 
set theta_pN_bm	0.0513; 
set theta_pcP_bm	0.1097; 
set theta_pcN_bm	0.1097; 
set ResP_bm	0.4000; 
set ResN_bm	0.4000; 
set theta_uP_bm	0.4000; 
set theta_uN_bm	0.4000; 
set DP_bm	1.00; 
set DN_bm	1.00; 
set a_bm	[expr ($n+1.0)*($My_bm*($McMy_bm-1.0)) / ($Ks_bm*$theta_pP_bm)];
set b_bm	[expr ($a_bm)/(1.0+$n*(1.0-$a_bm))];

#define beam springs
#Spring ID: "8xya", where 8 = beam spring, x = Direction, y = Column Line, a = Floor, "x" convention: 5 = x Frame, 6 = z Frame
rotSpring3DRotZModIKModel	8532	9132	8132	$Ks_bm $b_bm $b_bm $My_bm [expr -$My_bm]	$LS_bm $LK_bm $LA_bm $LD_bm $cS_bm $cK_bm $cA_bm $cD_bm	$theta_pP_bm $theta_pN_bm $theta_pcP_bm $theta_pcN_bm	$ResP_bm $ResN_bm $theta_uP_bm $theta_uN_bm $DP_bm $DN_bm;
rotSpring3DRotZModIKModel	8542	9142	8142	$Ks_bm $b_bm $b_bm $My_bm [expr -$My_bm]	$LS_bm $LK_bm $LA_bm $LD_bm $cS_bm $cK_bm $cA_bm $cD_bm	$theta_pP_bm $theta_pN_bm $theta_pcP_bm $theta_pcN_bm	$ResP_bm $ResN_bm $theta_uP_bm $theta_uN_bm $DP_bm $DN_bm;
#Define beams
element elasticBeamColumn	81328142	8132	8142	 $Abm	$Es	$G	$Jbm	$Ibm	$Ibm	$XBeamLinearTransf;

set Acol	4.4100; # cross-section area 
set Icol	68.9000; # momment of inertia 
set Icol_mod	[expr $Icol*($n + 1.0/$n)]; # modified moment of inertia for beam 
set Jcol	1000000.0; # inertia of tortion for beam, just assign a small number 
set HStory	180.0000; # column length 
set Ks_col	[expr $n*6.0*$Es*$Icol_mod/$HStory]; # rotational stiffness of beam springs 

#define rotational spring properties and create spring elements using "rotSpring3DModIKModel" procedure
#rotSpring3DModIKModel creates a uniaxial material spring with a bilinear response based on Modified Ibarra Krawinkler Deterioration Model

set My_col	848.0000; #yield moment
set McMy_col	1.1100; 
set LS_col	201.6033; 
set LK_col	201.6033; 
set LA_col	1000.0000; 
set LD_col	201.6033; 
set cS_col	1.00; 
set cK_col	1.00; 
set cA_col	1.00; 
set cD_col	1.00; 
set theta_pP_col	0.0435; 
set theta_pN_col	0.0435; 
set theta_pcP_col	0.1417; 
set theta_pcN_col	0.1417; 
set ResP_col	0.4000; 
set ResN_col	0.4000; 
set theta_uP_col	0.4000; 
set theta_uN_col	0.4000; 
set DP_col	1.00; 
set DN_col	1.00; 
set a_col	[expr ($n+1.0)*($My_col*($McMy_col-1.0)) / ($Ks_col*$theta_pP_col)];
set b_col	[expr ($a_col)/(1.0+$n*(1.0-$a_col))];

#define column springs
#Spring ID: "7xya", where 7 = column spring, x = Direction, y = Column Line, a = Floor, "x" convention: 5 = x Frame, 6 = z Frame
rotSpring3DRotZModIKModel	7531	9131	7131	$Ks_col $b_col $b_col $My_col [expr -$My_col]	$LS_col $LK_col $LA_col $LD_col $cS_col $cK_col $cA_col $cD_col	$theta_pP_col $theta_pN_col $theta_pcP_col $theta_pcN_col	$ResP_col $ResN_col $theta_uP_col $theta_uN_col $DP_col $DN_col;
rotSpring3DRotZModIKModel	7541	9141	7141	$Ks_col $b_col $b_col $My_col [expr -$My_col]	$LS_col $LK_col $LA_col $LD_col $cS_col $cK_col $cA_col $cD_col	$theta_pP_col $theta_pN_col $theta_pcP_col $theta_pcN_col	$ResP_col $ResN_col $theta_uP_col $theta_uN_col $DP_col $DN_col;
#Define columns
element elasticBeamColumn	71317132	7131	7132	 $Abm	$Es	$G	$Jbm	$Ibm	$Ibm	$PDeltaTransf;

set Acol	4.4100; # cross-section area 
set Icol	68.9000; # momment of inertia 
set Icol_mod	[expr $Icol*($n + 1.0/$n)]; # modified moment of inertia for beam 
set Jcol	1000000.0; # inertia of tortion for beam, just assign a small number 
set HStory	180.0000; # column length 
set Ks_col	[expr $n*6.0*$Es*$Icol_mod/$HStory]; # rotational stiffness of beam springs 

#define rotational spring properties and create spring elements using "rotSpring3DModIKModel" procedure
#rotSpring3DModIKModel creates a uniaxial material spring with a bilinear response based on Modified Ibarra Krawinkler Deterioration Model

set My_col	848.0000; #yield moment
set McMy_col	1.1100; 
set LS_col	201.6033; 
set LK_col	201.6033; 
set LA_col	1000.0000; 
set LD_col	201.6033; 
set cS_col	1.00; 
set cK_col	1.00; 
set cA_col	1.00; 
set cD_col	1.00; 
set theta_pP_col	0.0435; 
set theta_pN_col	0.0435; 
set theta_pcP_col	0.1417; 
set theta_pcN_col	0.1417; 
set ResP_col	0.4000; 
set ResN_col	0.4000; 
set theta_uP_col	0.4000; 
set theta_uN_col	0.4000; 
set DP_col	1.00; 
set DN_col	1.00; 
set a_col	[expr ($n+1.0)*($My_col*($McMy_col-1.0)) / ($Ks_col*$theta_pP_col)];
set b_col	[expr ($a_col)/(1.0+$n*(1.0-$a_col))];

#define column springs
#Spring ID: "7xya", where 7 = column spring, x = Direction, y = Column Line, a = Floor, "x" convention: 5 = x Frame, 6 = z Frame
rotSpring3DRotZModIKModel	7532	9132	7132	$Ks_col $b_col $b_col $My_col [expr -$My_col]	$LS_col $LK_col $LA_col $LD_col $cS_col $cK_col $cA_col $cD_col	$theta_pP_col $theta_pN_col $theta_pcP_col $theta_pcN_col	$ResP_col $ResN_col $theta_uP_col $theta_uN_col $DP_col $DN_col;
rotSpring3DRotZModIKModel	7542	9142	7142	$Ks_col $b_col $b_col $My_col [expr -$My_col]	$LS_col $LK_col $LA_col $LD_col $cS_col $cK_col $cA_col $cD_col	$theta_pP_col $theta_pN_col $theta_pcP_col $theta_pcN_col	$ResP_col $ResN_col $theta_uP_col $theta_uN_col $DP_col $DN_col;
#Define columns
element elasticBeamColumn	71417142	7141	7142	 $Abm	$Es	$G	$Jbm	$Ibm	$Ibm	$PDeltaTransf;

region	10	-node	9131	9141	9132	9142	-rayleigh	$alpha1	0	$alpha2ToUse	0;
region	20	-ele	81328142	71317132	71417142	-rayleigh	$alpha1	0	$alpha2ToUse	0;
#Joint Nodes 
node	9211	0.0000	0.0000	90.0000;
node	9221	0.0000	0.0000	270.0000;
node	9212	0.0000	111.0000	90.0000;
node	9222	0.0000	111.0000	270.0000;

#Beam Hinge Nodes 
node	8212	60.0000	111.0000	360.0000;
node	8222	240.0000	111.0000	360.0000;

#Column Hinge Nodes 
node	7211	60.0000	0.0000	360.0000;
node	7221	240.0000	0.0000	360.0000;
node	7212	60.0000	111.0000	360.0000;
node	7222	240.0000	111.0000	360.0000;

#Frame Fixities
fix	9211	1	1	1	1	1	1;
fix	9221	1	1	1	1	1	1;

#Joint Nodes Rigid Diaphragm
#Seeting rigid floor diaphragm constraint on
set RigidDiaphragm ON;
set perpDirn	2;
rigidDiaphragm	$perpDirn	2000	9212;
rigidDiaphragm	$perpDirn	2000	9222;

#Define Moment Frame Beam Section Properties and Element
set Abm	2.9600; # cross-section area 
set Ibm	30.8000; # momment of inertia 
set Ibm_mod	[expr $Ibm*($n + 1.0/$n)]; # modified moment of inertia for beam 
set Jbm	1000000.0; # inertia of tortion for beam, just assign a small number 
set WBay	180.0000; # bay length 
set Ks_bm	[expr $n*6.0*$Es*$Ibm_mod/$WBay]; # rotational stiffness of beam springs 

#define rotational spring properties and create spring elements using "rotSpring3DModIKModel" procedure
#rotSpring3DModIKModel creates a uniaxial material spring with a bilinear response based on Modified Ibarra Krawinkler Deterioration Model

#define beam hinges
set My_bm	470.1100; #yield moment
set McMy_bm	1.1100; 
set LS_bm	135.0947; 
set LK_bm	135.0947; 
set LA_bm	1000.0000; 
set LD_bm	135.0947; 
set cS_bm	1.00; 
set cK_bm	1.00; 
set cA_bm	1.00; 
set cD_bm	1.00; 
set theta_pP_bm	0.0513; 
set theta_pN_bm	0.0513; 
set theta_pcP_bm	0.1097; 
set theta_pcN_bm	0.1097; 
set ResP_bm	0.4000; 
set ResN_bm	0.4000; 
set theta_uP_bm	0.4000; 
set theta_uN_bm	0.4000; 
set DP_bm	1.00; 
set DN_bm	1.00; 
set a_bm	[expr ($n+1.0)*($My_bm*($McMy_bm-1.0)) / ($Ks_bm*$theta_pP_bm)];
set b_bm	[expr ($a_bm)/(1.0+$n*(1.0-$a_bm))];

#define beam springs
#Spring ID: "8xya", where 8 = beam spring, x = Direction, y = Column Line, a = Floor, "x" convention: 5 = x Frame, 6 = z Frame
rotSpring3DRotZModIKModel	8612	9212	8212	$Ks_bm $b_bm $b_bm $My_bm [expr -$My_bm]	$LS_bm $LK_bm $LA_bm $LD_bm $cS_bm $cK_bm $cA_bm $cD_bm	$theta_pP_bm $theta_pN_bm $theta_pcP_bm $theta_pcN_bm	$ResP_bm $ResN_bm $theta_uP_bm $theta_uN_bm $DP_bm $DN_bm;
rotSpring3DRotZModIKModel	8622	9222	8222	$Ks_bm $b_bm $b_bm $My_bm [expr -$My_bm]	$LS_bm $LK_bm $LA_bm $LD_bm $cS_bm $cK_bm $cA_bm $cD_bm	$theta_pP_bm $theta_pN_bm $theta_pcP_bm $theta_pcN_bm	$ResP_bm $ResN_bm $theta_uP_bm $theta_uN_bm $DP_bm $DN_bm;
#Define beams
element elasticBeamColumn	82128222	8212	8222	 $Abm	$Es	$G	$Jbm	$Ibm	$Ibm	$ZBeamLinearTransf;

set Acol	4.4100; # cross-section area 
set Icol	68.9000; # momment of inertia 
set Icol_mod	[expr $Icol*($n + 1.0/$n)]; # modified moment of inertia for beam 
set Jcol	1000000.0; # inertia of tortion for beam, just assign a small number 
set HStory	180.0000; # column length 
set Ks_col	[expr $n*6.0*$Es*$Icol_mod/$HStory]; # rotational stiffness of beam springs 

#define rotational spring properties and create spring elements using "rotSpring3DModIKModel" procedure
#rotSpring3DModIKModel creates a uniaxial material spring with a bilinear response based on Modified Ibarra Krawinkler Deterioration Model

set My_col	848.0000; #yield moment
set McMy_col	1.1100; 
set LS_col	201.6033; 
set LK_col	201.6033; 
set LA_col	1000.0000; 
set LD_col	201.6033; 
set cS_col	1.00; 
set cK_col	1.00; 
set cA_col	1.00; 
set cD_col	1.00; 
set theta_pP_col	0.0435; 
set theta_pN_col	0.0435; 
set theta_pcP_col	0.1417; 
set theta_pcN_col	0.1417; 
set ResP_col	0.4000; 
set ResN_col	0.4000; 
set theta_uP_col	0.4000; 
set theta_uN_col	0.4000; 
set DP_col	1.00; 
set DN_col	1.00; 
set a_col	[expr ($n+1.0)*($My_col*($McMy_col-1.0)) / ($Ks_col*$theta_pP_col)];
set b_col	[expr ($a_col)/(1.0+$n*(1.0-$a_col))];

#define column springs
#Spring ID: "7xya", where 7 = column spring, x = Direction, y = Column Line, a = Floor, "x" convention: 5 = x Frame, 6 = z Frame
rotSpring3DRotZModIKModel	7511	9211	7211	$Ks_col $b_col $b_col $My_col [expr -$My_col]	$LS_col $LK_col $LA_col $LD_col $cS_col $cK_col $cA_col $cD_col	$theta_pP_col $theta_pN_col $theta_pcP_col $theta_pcN_col	$ResP_col $ResN_col $theta_uP_col $theta_uN_col $DP_col $DN_col;
rotSpring3DRotZModIKModel	7521	9221	7221	$Ks_col $b_col $b_col $My_col [expr -$My_col]	$LS_col $LK_col $LA_col $LD_col $cS_col $cK_col $cA_col $cD_col	$theta_pP_col $theta_pN_col $theta_pcP_col $theta_pcN_col	$ResP_col $ResN_col $theta_uP_col $theta_uN_col $DP_col $DN_col;
#Define columns
element elasticBeamColumn	72117212	7211	7212	 $Abm	$Es	$G	$Jbm	$Ibm	$Ibm	$PDeltaTransf;

set Acol	4.4100; # cross-section area 
set Icol	68.9000; # momment of inertia 
set Icol_mod	[expr $Icol*($n + 1.0/$n)]; # modified moment of inertia for beam 
set Jcol	1000000.0; # inertia of tortion for beam, just assign a small number 
set HStory	180.0000; # column length 
set Ks_col	[expr $n*6.0*$Es*$Icol_mod/$HStory]; # rotational stiffness of beam springs 

#define rotational spring properties and create spring elements using "rotSpring3DModIKModel" procedure
#rotSpring3DModIKModel creates a uniaxial material spring with a bilinear response based on Modified Ibarra Krawinkler Deterioration Model

set My_col	848.0000; #yield moment
set McMy_col	1.1100; 
set LS_col	201.6033; 
set LK_col	201.6033; 
set LA_col	1000.0000; 
set LD_col	201.6033; 
set cS_col	1.00; 
set cK_col	1.00; 
set cA_col	1.00; 
set cD_col	1.00; 
set theta_pP_col	0.0435; 
set theta_pN_col	0.0435; 
set theta_pcP_col	0.1417; 
set theta_pcN_col	0.1417; 
set ResP_col	0.4000; 
set ResN_col	0.4000; 
set theta_uP_col	0.4000; 
set theta_uN_col	0.4000; 
set DP_col	1.00; 
set DN_col	1.00; 
set a_col	[expr ($n+1.0)*($My_col*($McMy_col-1.0)) / ($Ks_col*$theta_pP_col)];
set b_col	[expr ($a_col)/(1.0+$n*(1.0-$a_col))];

#define column springs
#Spring ID: "7xya", where 7 = column spring, x = Direction, y = Column Line, a = Floor, "x" convention: 5 = x Frame, 6 = z Frame
rotSpring3DRotZModIKModel	7512	9212	7212	$Ks_col $b_col $b_col $My_col [expr -$My_col]	$LS_col $LK_col $LA_col $LD_col $cS_col $cK_col $cA_col $cD_col	$theta_pP_col $theta_pN_col $theta_pcP_col $theta_pcN_col	$ResP_col $ResN_col $theta_uP_col $theta_uN_col $DP_col $DN_col;
rotSpring3DRotZModIKModel	7522	9222	7222	$Ks_col $b_col $b_col $My_col [expr -$My_col]	$LS_col $LK_col $LA_col $LD_col $cS_col $cK_col $cA_col $cD_col	$theta_pP_col $theta_pN_col $theta_pcP_col $theta_pcN_col	$ResP_col $ResN_col $theta_uP_col $theta_uN_col $DP_col $DN_col;
#Define columns
element elasticBeamColumn	72217222	7221	7222	 $Abm	$Es	$G	$Jbm	$Ibm	$Ibm	$PDeltaTransf;

region	10	-node	9211	9221	9212	9222	-rayleigh	$alpha1	0	$alpha2ToUse	0;
region	20	-ele	82128222	72117212	72217222	-rayleigh	$alpha1	0	$alpha2ToUse	0;
