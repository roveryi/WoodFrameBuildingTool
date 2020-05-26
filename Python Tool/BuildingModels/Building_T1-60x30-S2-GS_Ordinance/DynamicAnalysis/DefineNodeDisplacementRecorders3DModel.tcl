# Define node displacement recorders 

cd	$baseDir/$dataDir/NodeDisplacements

# Record displacements for x-direction wood panel nodes
recorder	Node	-file	XWoodPanelNodeDispLevel1.out	-time	-node	11012	11022	11032	11042	11052	11062	11072	11082	11092	11102	11112	11122	11132	11142	11152	11162	-dof	1	disp
recorder	Node	-file	XWoodPanelNodeDispLevel2.out	-time	-node	21012	21022	21032	21042	21052	21062	21072	21082	21092	21102	21112	21122	21132	21142	21152	21162	21172	21182	21192	21202	21212	21222	21232	21242	21252	21262	21272	21282	21292	-dof	1	disp

# Record displacements for z-direction wood panel nodes
recorder	Node	-file	ZWoodPanelNodeDispLevel1.out	-time	-node	13012	13022	13032	13042	13052	13062	13072	13082	13092	-dof	3	disp
recorder	Node	-file	ZWoodPanelNodeDispLevel2.out	-time	-node	23012	23022	23032	23042	23052	23062	23072	23082	23092	23102	23112	23122	23132	23142	23152	23162	23172	23182	23192	23202	23212	23222	23232	23242	-dof	3	disp

# Record displacements for leaning column nodes 
recorder	Node	-file	LeaningColumnNodeDispLevel1.out	-time	-node	2000	-dof	1	2	3	disp
recorder	Node	-file	LeaningColumnNodeDispLevel2.out	-time	-node	3000	-dof	1	2	3	disp
