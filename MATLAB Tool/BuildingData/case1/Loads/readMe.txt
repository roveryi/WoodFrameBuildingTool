liveLoad.txt: Floor live load in kips per square inch at each suspended floor level i.e. 2nd floor live load in 1st row, 3rd floor live load in 2nd row etc.
floorWeights: total weight of each suspended floor level in kips i.e. 2nd floor weight in 1st row, 3rd floor weight in 2nd row etc.

## Added by GUAN XINGQUAN ##
floorWeights: unit should be kips

## Added by Zhengxiang Yi ##
floorWeights: wall dead load should be included, assume only consider peripheral 
wall dead load calculation : (60ft (x dimension) + 30ft (z dimension))*2*9.25ft (floor height)*16psf(Table 2.3 SEAOSC) = 26.64kips

roof will take half-height of peripheral wall self weight 
typical floor will take full-height of peripheral wall self weight