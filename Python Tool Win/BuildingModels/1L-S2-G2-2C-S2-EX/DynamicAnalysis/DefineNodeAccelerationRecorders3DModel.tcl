# Define node acceleration recorders 

cd $pathToResults/EQ_$folderNumber/NodeAccelerations 

# Record accelerations at leaning column nodes  
recorder	EnvelopeNode	-file	LeaningColumnNodeXAbsoAccLevel2.out	-timeSeries	11	-time	-node	2400	-dof	1	accel
recorder	EnvelopeNode	-file	LeaningColumnNodeZAbsoAccLevel2.out	-timeSeries	12	-time	-node	2400	-dof	3	accel
recorder	EnvelopeNode	-file	LeaningColumnNodeXAbsoAccLevel3.out	-timeSeries	11	-time	-node	3400	-dof	1	accel
recorder	EnvelopeNode	-file	LeaningColumnNodeZAbsoAccLevel3.out	-timeSeries	12	-time	-node	3400	-dof	3	accel
