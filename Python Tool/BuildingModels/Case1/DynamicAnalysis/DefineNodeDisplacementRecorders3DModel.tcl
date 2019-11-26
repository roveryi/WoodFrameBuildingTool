# Define node displacement recorders 

cd	$baseDir/$dataDir/NodeDisplacements

# Record displacements for x-direction wood panel nodes
recorder	Node	-file	XWoodPanelNodeDispLevel1.out	-time	-node	11012	11022	11032	11042	11052	11062	-dof	1	disp
recorder	Node	-file	XWoodPanelNodeDispLevel2.out	-time	-node	21012	21022	21032	21042	21052	-dof	1	disp

# Record displacements for z-direction wood panel nodes
recorder	Node	-file	ZWoodPanelNodeDispLevel1.out	-time	-node	13012	13022	13032	13042	13052	13062	-dof	3	disp
recorder	Node	-file	ZWoodPanelNodeDispLevel2.out	-time	-node	23012	23022	23032	23042	23052	-dof	3	disp

# Record displacements for leaning column nodes 
recorder	Node	-file	LeaningColumnNodeDispLevel1.out	-time	-node	2000	-dof	1	2	3	disp
recorder	Node	-file	LeaningColumnNodeDispLevel2.out	-time	-node	3000	-dof	1	2	3	disp
