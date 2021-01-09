# Define story drift recorders 

cd $pathToResults/EQ_$folderNumber/StoryDrifts 
# Define x-direction story drift recorders 
recorder	EnvelopeDrift	-file	$pathToResults/EQ_$folderNumber/StoryDrifts/MidLeaningColumnXDrift.out	-time	-iNode	1100	1400	1700	2100	2400	2700	1100	1400	1700	-jNode	2100	2400	2700	3100	3400	3700	3100	3400	3700	-dof	1	-perpDirn	2
recorder	EnvelopeDrift	-file	$pathToResults/EQ_$folderNumber/StoryDrifts/CornerLeaningColumnXDrift.out	-time	-iNode	1000	1200	1600	1800	2000	2200	2600	2800	1000	1200	1600	1800	-jNode	2000	2200	2600	2800	3000	3200	3600	3800	3000	3200	3600	3800	-dof	1	-perpDirn	2
# Define z-direction story drift recorders 
recorder	EnvelopeDrift	-file	$pathToResults/EQ_$folderNumber/StoryDrifts/MidLeaningColumnZDrift.out	-time	-iNode	1300	1400	1500	2300	2400	2500	1300	1400	1500	-jNode	2300	2400	2500	3300	3400	3500	3300	3400	3500	-dof	3	-perpDirn	2
recorder	EnvelopeDrift	-file	$pathToResults/EQ_$folderNumber/StoryDrifts/CornerLeaningColumnZDrift.out	-time	-iNode	1000	1200	1600	1800	2000	2200	2600	2800	1000	1200	1600	1800	-jNode	2000	2200	2600	2800	3000	3200	3600	3800	3000	3200	3600	3800	-dof	3	-perpDirn	2
