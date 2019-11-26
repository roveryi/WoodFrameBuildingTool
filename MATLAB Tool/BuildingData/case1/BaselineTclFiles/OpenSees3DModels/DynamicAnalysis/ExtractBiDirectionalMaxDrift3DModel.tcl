# ExtractBiDirectionalMaxDrift3DModel ##################################################
#
# Procedure that extracts the maximum story drift
#
# Developed by Henry Burton
#
# First Created: 09/22/2013
# 
#
# #######################################################################################

proc ExtractBiDirectionalMaxDrift3DModel {numStories pathToOutputFile} {

 global maximumXStoryDrift
 global maximumZStoryDrift
 set maximumXStoryDrift 0.0
 set maximumZStoryDrift 0.0
 
# Maximum X-Story Drift
for {set story 1} { $story<=$numStories} {incr story} {
	set maxDriftOutputFile [open $pathToOutputFile/StoryDrifts/StoryX$story.out r];
	while {[gets $maxDriftOutputFile line] >= 0} {
		set drift [lindex $line 1];
		if {[expr abs($drift)]  > $maximumXStoryDrift} {
			set maximumXStoryDrift [expr abs($drift)];
		}
	}
	close $maxDriftOutputFile
}

# Maximum Z-Story Drift
for {set story 1} { $story<=$numStories} {incr story} {
	set maxDriftOutputFile [open $pathToOutputFile/StoryDrifts/StoryZ$story.out r];			
	while {[gets $maxDriftOutputFile line] >= 0} {
		set drift [lindex $line 1];
		if {[expr abs($drift)]  > $maximumZStoryDrift} {
			set maximumZStoryDrift [expr abs($drift)];
		}
	}
	close $maxDriftOutputFile
}
}
