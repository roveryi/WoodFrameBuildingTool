# This file will be used to define damping


# Defining damping parameters
set omegaI [expr (2.0 * $pi) / ($periodForRayleighDamping_1)]
set omegaJ [expr (2.0 * $pi) / ($periodForRayleighDamping_2)]
set alpha1Coeff [expr (2.0 * $omegaI * $omegaJ) / ($omegaI + $omegaJ)]
set alpha2Coeff [expr (2.0) / ($omegaI + $omegaJ)]
set alpha1  [expr $alpha1Coeff*0.05]
set alpha2  [expr $alpha2Coeff*0.05]

# Assign damping to wood panel elements
region 1 -eleRange	700000	700021	-rayleigh 0  0 $alpha2 0;
# Assign damping to nodes
region 2 -node	2000	1100	3100	2200	1300	3300	2400	1500	3500	3000	2100	1200	3200	2300	1400	3400	2500	1600	-rayleigh $alpha1 0 0 0;

# Define the periods to use for the Rayleigh damping calculations
set periodForRayleighDamping_1	