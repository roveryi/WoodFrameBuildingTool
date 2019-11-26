# Define base node reaction recorders


cd	$pathToResults/EQ_$folderNumber/BaseReactions

# X-Direction Wood Panels Base Node Vertical Reactions
recorder Node -file	XPanelBaseNodesVerticalReactions.out	-time -node	11011	11021	11031	11041	11051	11061	-dof 2 reaction
# Z-Direction Wood Panels Base Node Vertical Reactions
recorder Node -file	ZPanelBaseNodesVerticalReactions.out	-time -node	13011	13021	13031	13041	13051	13061	-dof 2 reaction

# Leaning Column Base Node Vertical Reactions
recorder Node -file	LeaningColumnBaseNodeVerticalReactions.out	-time -node	1000	3000	2100	1200	3200	2300	1400	3400	2500	-dof 2 reaction

# X-Direction Wood Panels Base Node Horizontal Reactions
recorder Node -file	XPanelBaseNodesHorizontalReactions.out	-time -node	11011	11021	11031	11041	11051	11061	-dof 1 reaction
# Z-Direction Wood Panels Base Node Horizontal Reactions
recorder Node -file	ZPanelBaseNodesHorizontalReactions.out	-time -node	13011	13021	13031	13041	13051	13061	-dof 3 reaction

# Leaning Column Base Node X-Direction Horizontal Reactions
recorder Node -file	LeaningColumnBaseNodeXHorizontalReactions.out	-time -node	1000	3000	2100	1200	3200	2300	1400	3400	2500	-dof 1 reaction
# Leaning Column Base Node Z-Direction Horizontal Reactions
recorder Node -file	LeaningColumnBaseNodeZHorizontalReactions.out	-time -node	1000	3000	2100	1200	3200	2300	1400	3400	2500	-dof 3 reaction

