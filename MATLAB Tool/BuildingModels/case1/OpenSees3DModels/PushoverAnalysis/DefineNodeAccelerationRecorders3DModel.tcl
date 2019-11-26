# Define node acceleration recorders


cd	$baseDir/$dataDir/NodeAccelerations

# Record accelerations for x-direction wood panel nodes
# recorder Node -file	XWoodPanelNodeAccLevel1.out	-time -timeSeries 4 -node	11012	11022	11032	11042	11052	11062	-dof 1 2 3 accel
# recorder Node -file	XWoodPanelNodeAccLevel2.out	-time -timeSeries 4 -node	21012	21022	21032	21042	21052	-dof 1 2 3 accel

# Record accelerations for z-direction wood panel nodes
# recorder Node -file	ZWoodPanelNodeAccLevel1.out	-time -timeSeries 4 -node	13012	13022	13032	13042	13052	13062	-dof 1 2 3 accel
# recorder Node -file	ZWoodPanelNodeAccLevel2.out	-time -timeSeries 4 -node	23012	23022	23032	23042	23052	-dof 1 2 3 accel

# Record accelerations for leaning column nodes
#recorder Node -file	LeaningColumnNodeAccLevel2.out	-time -node	2000	-dof 1 2 3 accel
recorder Node -file	LeaningColumnNodeXAbsoAccLevel2.out	-timeSeries 11 -time -node	2000	-dof 1 accel
recorder Node -file	LeaningColumnNodeZAbsoAccLevel2.out	-timeSeries 12 -time -node	2000	-dof 3 accel
#recorder Node -file	LeaningColumnNodeAccLevel3.out	-time -node	3000	-dof 1 2 3 accel
recorder Node -file	LeaningColumnNodeXAbsoAccLevel3.out	-timeSeries 11 -time -node	3000	-dof 1 accel
recorder Node -file	LeaningColumnNodeZAbsoAccLevel3.out	-timeSeries 12 -time -node	3000	-dof 3 accel

