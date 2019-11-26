The text files in this folder are used to describe the material parameters for the Pinching4 model. 
Each file has a different material parameter. 
A column vector is used to define each parameter such that each row entry corresponds to the parameter value for each material. 
The number of rows corresponds to the number of unique materials used.
Each  material is assigned a unique number, which is stored in the materialNumber.txt file. 
The materialDescription.txt file contains description of the material type associated with each material number 
e.g. 1: WSP with 10d nailing at 2" O.C. 


Author: Zhengxiang Yi
Date: 01/06/2018
Email: roveryi@g.ucla.edu
Unit: kips, in
All the Pinching4 parameters are derived from SAWS model. 
Each row corresponding to a material and each colum is a parameter in Pinching4 model.
The model material property corresponding to per foot length wood panel, then has to be scaled by the length of wall.

Author: Zhengxiang Yi
Date: 05/16/2018
Email: roveryi@g.ucla.edu
Unit: kips, in
All the Pinching4 parameters are based on the test from PEER CEA Project.

Author: Zhengxiang Yi
Date: 05/16/2018
Email: roveryi@g.ucla.edu
Unit: kips, in
Dual spring model, each material is model by 2 springs with different material properties, then combine them parallel.