JointNodeNumbers.txt: Used to define beam-column joint node numbers. Each row entry corresponds to a single node. Use the following numbering scheme: "ABCD" where A = 9, B = 1 for X-Frame and 2 for Z-Frame, C = Column Line Number and D = Floor Level

JointNodeCoordinates.txt: Used to define coordinates for beam-column joint nodes. The row entry for the node numbers and coordinates should match. For example, a node whose number is entered in row i of JointNodeNumbers.txt should have the coordinate entered in row i of JointNodeCoordinates. The first, second and third entries in row i correspond to the X, Y and Z coordinates of that node respectively

BeamEnd1HingeNodeNumbers.txt: Used to define node numbers for hinge at left end of beams. Each row entry corresponds to a single node/hinge/beam. The number of rows corresponds to he number of beams in a single frame. Use the following numbering scheme: "ABCD" where A = 8, B = 1 for X-Frame and 2 for Z-Frame, C = Column Line Number and D = Floor Level

BeamEnd1HingeNodeCoordinates.txt: Used to define coordinates for hinge node at the left end of beams. As with "BeamEnd1HingeNodeNumbers.txt", each row entry corresponds to a single node/hinge/beam located at the left end of the beam and consists of the X, Y and Z coordinates defined from left to right in that order. 

BeamEnd2HingeNodeNumbers.txt: Used to define node numbers for hinge at right end of beam.

BeamEnd2HingeNodeCoordinates.txt: Used to define coordinates for hinge node at right end of beam

ColumnEnd1HingeNodeNumbers.txt: Used to define node numbers for hinge at bottom end of column. Each row entry corresponds to a single node/hinge/column. The number of rows corresponds to he number of columns in a single frame. Use the following numbering scheme: "ABCD" where A = 7, B = 1 for X-Frame and 2 for Z-Frame, C = Column Line Number and D = Floor Level

ColumnEnd1HingeNodeCoordinates.txt: Used to define coordinates for hinge node at the bottom end of columns. As with "ColumnEnd1HingeNodeNumbers.txt", each row entry corresponds to a single node/hinge/column located at the bottom end of the column and consists of the X, Y and Z coordinates defined from left to right in that order. 

ColumnEnd2HingeNodeNumbers.txt: Used to define node numbers for hinge at top end of column.

ColumnEnd2HingeNodeCoordinates.txt: Used to define coordinates for hinge node at top end of column.




