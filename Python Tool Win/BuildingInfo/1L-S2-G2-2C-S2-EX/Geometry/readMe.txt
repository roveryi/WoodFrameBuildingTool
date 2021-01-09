floorAreas.txt: Each row defines the floor area (in square feet) at each level including the ground floor i.e. area of 1st floor in 1st row, area of 2nd floor in 2nd row etc.
numberOfStories.txt: scalar entry of the number of stories in a building
storyHeights.txt: column vector of story heights (in inches). The row number corresponds to the story number
XDirectionWoodPanelsXCoordinates.txt: Each row defines the x-coordinates (in inches) of the center (in plan view) of the wood panels aligned in the X-Direction on a particular story. The row number corresponds to the story number of the panels.
XDirectionWoodPanelsZCoordinates.txt: Each row defines the z-coordinates (in inches) of the center (in plan view) of the wood panels aligned in the X-Direction.
ZDirectionWoodPanelsXCoordinates.txt: Each row defines the x-coordinates (in inches) of the center (in plan view) of the wood panels aligned in the X-Direction on a particular story. The row number corresponds to the story number of the panels.
ZDirectionWoodPanelsZCoordinates.txt: Each row defines the z-coordinates (in inches) of the center (in plan view) of the wood panels aligned in the X-Direction.
leaningColumnNodesXCoordinates.txt:column vector of x-coordinates (in inches) of nodes used to define leaning columns. The row number corresponds to the floor level i.e. row 1, floor level 1, row 2, floor level 2 etc.
leaningColumnNodesZCoordinates.txt:column vector of z-coordinates (in inches) of nodes used to define leaning columns.
leaningColumnNodesOpenSeesTags.txt: column vector of OpenSees Tags for nodes used to define leaning columns. The row number corresponds to the floor level i.e. row 1, floor level 1, row 2, floor level 2 etc.


## Add by GUAN XINGQUAN ##
floorMaximumXDimension: maximum length along X direction of building, required by the computation of rotational mass; unit: inch
floorMaximumZDimension: maximum length along Y direction of building, required by the computation of rotational mss; unit: inch
numberOfXDirectionWoodPanels: A column vector, each row represents one story. Enter the number of wood panels along X direction
numberOfZDirectionWoodPanels: A column vector, each row represents one story. Enter the number of wood panels along Z direction