# This file will be used to define the rigid floor diaphram properties


# Setting rigid floor diaphragm constraint on
set RigidDiaphragm ON;

# Define Rigid Diaphram, dof 2 is normal to floor
set perpDirn 2;

rigidDiaphragm	$perpDirn	2000	2100	2200	2300	2400	2500	2600	2700	2800	11012	11022	11032	11042	11052	11062	21011	21021	21031	21041	21051	13012	13022	13032	13042	13052	13062	23011	23021	23031	23041	23051	
rigidDiaphragm	$perpDirn	3000	3100	3200	3300	3400	3500	3600	3700	3800	21012	21022	21032	21042	21052	23012	23022	23032	23042	23052	

puts "rigid diaphragm constraints defined"

