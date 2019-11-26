# Define node damping forces recorders


cd	$pathToResults/EQ_$folderNumber/NodeDampingForces

# Record displacements for x-direction wood panel nodes
recorder Node -file	XWoodPanelNodeDampingForceLevel1.out	-time -node	11012	11022	11032	11042	11052	11062	-dof 1 2 3 rayleighForces
recorder Node -file	XWoodPanelNodeDampingForceLevel2.out	-time -node	21012	21022	21032	21042	21052	-dof 1 2 3 rayleighForces

# Record displacements for z-direction wood panel nodes
recorder Node -file	ZWoodPanelNodeDampingForceLevel1.out	-time -node	13012	13022	13032	13042	13052	13062	-dof 1 2 3 rayleighForces
recorder Node -file	ZWoodPanelNodeDampingForceLevel2.out	-time -node	23012	23022	23032	23042	23052	-dof 1 2 3 rayleighForces

# Record displacements for leaning column nodes
recorder Node -file	LeaningColumnNodeDampingForceLevel2.out	-time -node	2000	1100	3100	2200	1300	3300	2400	1500	3500	-dof 1 2 3 rayleighForces
recorder Node -file	LeaningColumnNodeDampingForceLevel3.out	-time -node	2000	1100	3100	2200	1300	3300	2400	1500	3500	-dof 1 2 3 rayleighForces

