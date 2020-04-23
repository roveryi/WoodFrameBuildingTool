# This file will be used to define damping 

# Define the periods to use for damping parameter calculation 
set periodForRayleighDamping_1 0.357; 
set periodForRayleighDamping_2 0.229; 
# Define damping parameters 
set omegaI [expr (2.0 * $pi) / ($periodForRayleighDamping_1)] 
set omegaJ [expr (2.0 * $pi) / ($periodForRayleighDamping_2)] 
set alpha1Coeff [expr (2.0 * $omegaI * $omegaJ) / ($omegaI + $omegaJ)] 
set alpha2Coeff [expr (2.0) / ($omegaI + $omegaJ)] 
set alpha1 [expr $alpha1Coeff*0.050] 
set alpha2 [expr $alpha2Coeff*0.050] 
# Assign damping to wood panel elements 
region 1 -eleRange	700000	700077	-rayleigh	0	$alpha2	0	0; 
# Assign damping to nodes 
region 2 -node	2000	2100	2200	2300	2400	2500	2600	2700	2800	3000	3100	3200	3300	3400	3500	3600	3700	3800	-rayleigh	$alpha1	0	0	0; 
