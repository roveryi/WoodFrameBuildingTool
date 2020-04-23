# Define node acceleration recorders 

cd $pathToResults/EQ_$folderNumber/NodeAccelerations 

# Record accelerations at leaning column nodes  
recorder	Node	-file	LeaningColumnNodeXAbsoAccLevel2.out	-timeSeries	11	-time	-node	2000	-dof	1	accel
recorder	Node	-file	LeaningColumnNodeZAbsoAccLevel2.out	-timeSeries	12	-time	-node	2000	-dof	3	accel
recorder	Node	-file	LeaningColumnNodeXAbsoAccLevel3.out	-timeSeries	11	-time	-node	3000	-dof	1	accel
recorder	Node	-file	LeaningColumnNodeZAbsoAccLevel3.out	-timeSeries	12	-time	-node	3000	-dof	3	accel
