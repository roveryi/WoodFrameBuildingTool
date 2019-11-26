# Define base node reaction recorders


cd	$StoreDir/BaseReactions

# get the group of the node at base.
# set NodeNums ""
# foreach iColPier $ColPier {
	# set X [lindex $iColPier 0];
	# set Z [lindex $iColPier 1];
	# set iNodeNums [format %s%s%s%s%s 1 $X $Z 0 17];
	# lappend NodeNums $iNodeNums;
# }

# Vertical Reactions
# RunLog "recorder Node -file VerticalReactions.txt -time -node $NodeNums -dof 2 reaction";

# X-Direction Reactions
# RunLog "recorder Node -file XReactions.txt -time -node $NodeNums -dof 1 reaction";

# Z-Direction Reactions
# RunLog "recorder Node -file ZReactions.txt -time -node $NodeNums -dof 3 reaction";

recorder Node -file VerticalReactions.txt -time -node 111017 121017  -dof 2 reaction
recorder Node -file XReactions.txt -time -node 111017 121017 -dof 1 reaction
recorder Node -file ZReactions.txt -time -node 111017 121017  -dof 3 reaction