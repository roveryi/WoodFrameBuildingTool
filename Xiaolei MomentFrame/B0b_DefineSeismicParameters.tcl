# Define seismic parameters
#Input# Mapped MCE spectral acceleration at 1s period, USGS seismic design map ,zip code 94102, San Fransisco Downtown
set S1 0.638;
#Input# Mapped MCE spectral acceleration at short period, USGS seismic design map ,zip code 94102, San Fransisco Downtown
set Ss 1.5; #0.5
#Input# Site coefficients, Site Class D defalt, Page 66, ASCE 7-10
set Fa 1.0;
set Fv 1.5;
# MCE spectral acceleration at short period
set SMS [expr $Ss*$Fa];
# MCE spectral acceleration at 1s period
set SM1 [expr $S1*$Fv];
# DBE spectral acceleration at short period
set SDS [expr $SMS*2/3];
# DBE spectral acceleration at 1s period
set SD1 [expr $SM1*2/3];
#Input# Coefficient for upper limit on code period, Page 90, ASCE 7-10, SD1= S1*Fv*2/3
set Cu 1.4;
# Code period coefficient, Page 90, ASCE 7-10
set Ct 0.028;
# code period coefficient x, Page 90, ASCE 7-10
set DPx 0.8;
# R factor, Page 75, ASCE 7-10
set R 8.0;
# Redundancy factor
set rho 1.0;
#Input# Long period transition, Page 224, ASCE 7-10
set TL 12.0;
# Hazard curve. N x 2 array where N is the number of points used to
# define hazard curve. The first column contains the spectral
# intensity ordinates and the 2nd column contains the mean annual
# frequency of exceedance
# set hazardCurve [];
# Code period

#Input# shuould be set according to geometry parameters 
set BuildingHeight 537.5; #in ft
#BuildingHeight should be in ft
set Tcode [expr $Ct*($BuildingHeight)**$DPx];
# Code period with upper limit factor 
set CuTcode [expr $Tcode*$Cu];
# Response spectra transition periods
set T0 [expr 0.2*$SD1/$SDS];
set TS [expr $SD1/$SDS];
# MCE Spectral acceleration
if {$CuTcode <= $T0} {
	set SaMCE [expr $SMS*(0.4 + 0.6*$CuTcode/$T0)];
} elseif {$CuTcode <= $TS} {
	set SaMCE [expr $SMS*1.0];
} elseif {$CuTcode <= $TL} {
	set SaMCE [expr $SM1/$CuTcode];
} else {
	set SaMCE [expr $SM1*$TL/$CuTcode**2];
}

# unit in g， see ASCE 7-10 Page 66
# DBE Spectral acceleration
set SaDBE [expr $SaMCE*2/3.0];