# Define story drift recorders


cd	$pathToResults/EQ_$folderNumber/StoryDrifts

# X-Direction Story Drifts
recorder Drift -file	$pathToResults/EQ_$folderNumber/StoryDrifts/MidLeaningColumnXDrift.out	-time -iNode	1400	1100	1700	2400	2100	2700	1400	1100	1700	-jNode	2400	2100	2700	3400	3100	3700	3400	3100	3700	-dof 1 -perpDirn 2
recorder Drift -file	$pathToResults/EQ_$folderNumber/StoryDrifts/CornerLeaningColumnXDrift.out	-time -iNode	1000	1200	1600	1800	2000	2200	2600	2800	1000	1200	1600	1800	-jNode	2000	2200	2600	2800	3000	3200	3600	3800	3000	3200	3600	3800	-dof 1 -perpDirn 2
# Z-Direction Story Drifts
recorder Drift -file	$pathToResults/EQ_$folderNumber/StoryDrifts/MidLeaningColumnZDrift.out	-time -iNode	1400	1500	1300	2400	2500	2300	1400	1500	1300	-jNode	2400	2500	2300	3400	3500	3300	3400	3500	3300	-dof 3 -perpDirn 2
recorder Drift -file	$pathToResults/EQ_$folderNumber/StoryDrifts/CornerLeaningColumnZDrift.out	-time -iNode	1000	1200	1600	1800	2000	2200	2600	2800	1000	1200	1600	1800	-jNode	2000	2200	2600	2800	3000	3200	3600	3800	3000	3200	3600	3800	-dof 3 -perpDirn 2
