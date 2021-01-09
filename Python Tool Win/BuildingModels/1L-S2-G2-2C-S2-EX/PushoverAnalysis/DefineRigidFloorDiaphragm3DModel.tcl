# This file will be used to define the rigid floor diaphragm properties 

 # Setting rigid floor diaphragm constraint con
set RigidDiaphragm ON; 

 # Define Rigid Diaphragm,dof 2 is normal to floor
set perpDirn 2; 

rigidDiaphragm $perpDirn	 2400	 2000	 2100	 2200	 2300	 2500	 2600	 2700	 2800	 11012	 11022	 11032	 11042	 11052	 11062	 13012	 13022	 13032	 13042	 13052	 13062	 21011	 21021	 21031	 21041	 21051	 21061	 21071	 21081	 21091	 21101	 23011	 23021	 23031	 23041	 23051	 23061	 23071	 23081	 23091
rigidDiaphragm $perpDirn	 3400	 3000	 3100	 3200	 3300	 3500	 3600	 3700	 3800	 21012	 21022	 21032	 21042	 21052	 21062	 21072	 21082	 21092	 21102	 23012	 23022	 23032	 23042	 23052	 23062	 23072	 23082	 23092

puts "rigid diaphragm constraints defined"