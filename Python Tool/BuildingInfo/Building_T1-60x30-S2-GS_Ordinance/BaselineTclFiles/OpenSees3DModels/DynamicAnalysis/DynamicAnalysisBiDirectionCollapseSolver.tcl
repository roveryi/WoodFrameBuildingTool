# DynamicAnalysisCollapseSolver ########################################################
# Developed by Yu Zhang
# Date: 03-29-16
# Email: y.zhang@ucla.edu
# Acknowledgement: developed basd on Dimitrios G. Lignos's original solver
# Uses:
# 1. dt            : Ground Motion step
# 2. dt_anal_Step  : Analysis time step
# 3. GMtime        : Ground Motion Total Time
# 4. numStories    : DriftLimit

# Sequence of Algorithms #################################################
# (a) Newton with LineSearch; (b) Krylov Newton; (c) BFGS; (d) Krylov Newton initial;
# 1. Try (a)-(d) algorithms @ dt, Tol, TestType, keep using until finish or 64 steps
# 2. Try (a)-(d) algorithms @ dt/2, Tol, TestType, use for 32 steps
# 3. Try (a)-(d) algorithms @ dt/4, Tol, TestType, use for 16 steps
# 4. Try (a)-(d) algorithms @ dt/8, Tol, TestType, use for 16 step
# 5. Try (a)-(d) algorithms @ dt/16, Tol, TestType, use for 16 step
# 6. Try (a)-(d) algorithms @ dt/32, Tol, TestType, use for 8 step
# 7. Try (a)-(d) algorithms @ dt/32, Tol, BackUpTestType, HTTP Inegrator, use for 8 step
###########################################################################
proc DynamicAnalysisBiDirectionCollapseSolver {dt dt_anal_Step GMtime numStories DriftLimit FloorNodes h1 htyp startTime} {

 ###########################################################################
 ### Tune the parameters here for your own model for better performance  ###
 ###########################################################################
 set maxRunTime 3600; # 1 hours
 set initialTol 1.0e-8; # reasonable value interval [1.0e-2, 1.0e-4]
 #set incrTol 0.0e-3; # reasonable value interval [1.0e-3, 5.0e-3]
 set incrTolFactor 10.0; # reasonable value interval [1.0e-3, 5.0e-3]
 set initialMaxNumIter 500; # reasonable value interval [25, 100]
 set incrMaxNumIter 100; # reasonable value interval [10, 100]
 ###########################################################################
 ###########################################################################

 # Set up basic parameters ################################################
 global CollapseFlag;                                        # global variable to monitor collapse
 global ok;
 source MaxDriftTesterBiDirection.tcl;                       # For Collapse Studies
 set CollapseFlag "NO";
 set Tol $initialTol;
 set MaxNumIter $initialMaxNumIter;
 set TestType EnergyIncr; 
 set BackUpTestType NormDispIncr; 
 set printFlag 0;
 set AdditionalTime 0.0;
 set UmfPackLvalueFact 30;
 #set ICNTL14ValueFact 50;
 wipeAnalysis;
 ###########################################################################
 
 # Start Initial Dynamic Analysis ##########################################
 constraints Transformation;
 numberer RCM;
 system UmfPack -lvalueFact $UmfPackLvalueFact;
 test $TestType $Tol $MaxNumIter $printFlag;		
 algorithm NewtonLineSearch 0.75;     
 integrator Newmark 0.50 0.25; 	
 analysis Transient;
 
 set DtAnalysis $dt_anal_Step; # timestep of analysis
 set TimeStepCount 0;
 set NumSteps [expr round(($GMtime+$AdditionalTime)/$DtAnalysis)]; # number of steps in analysis
 set startT [clock seconds];
 set controlTime [getTime];
 set ok 0;
 
 while {$controlTime < [expr 0.996*$GMtime] && $ok == 0 } {
 	
 	set DtCurrent [expr $DtAnalysis/pow(2,$TimeStepCount)];
  
  ###########################################################################
 	puts "Using $TestType test as default ..."
 	
 	set controlTime [getTime];
 	set remainTime [expr $GMtime-$controlTime];
  set NewRemainSteps [expr round(($remainTime)/($DtCurrent))];		
  puts "**********************************\n** Algorithm = NewtonLineSearch\n** Time Step = [format {%0.2e} $DtCurrent]\n** Remaining Time = [format {%0.3f} $remainTime]\n** Tolerance = [format {%0.1e} $Tol]\n** MaxNumIter = [format {%d} $MaxNumIter]\n**********************************"
 	system UmfPack -lvalueFact $UmfPackLvalueFact;
 	test $TestType $Tol $MaxNumIter $printFlag;
 	algorithm NewtonLineSearch 0.75;
  if {$TimeStepCount == 0} {
  	set ok [analyze [expr min([expr $NewRemainSteps-1],64)] $DtCurrent]; 
  } elseif {$TimeStepCount == 1} {
  	set ok [analyze 32 $DtCurrent]; 
  } elseif {$TimeStepCount == 2} {
  	set ok [analyze 32 $DtCurrent]; 
  } elseif {$TimeStepCount == 3} {
  	set ok [analyze 16 $DtCurrent]; 
  } elseif {$TimeStepCount == 4} {
  	set ok [analyze 16 $DtCurrent]; 
  } elseif {$TimeStepCount == 5} {
  	set ok [analyze 8 $DtCurrent]; 
  } 
  
 	if {$ok != 0} {
 		set controlTime [getTime];
 		set remainTime [expr $GMtime-$controlTime];
   	set NewRemainSteps [expr round(($remainTime)/($DtCurrent))];
    puts "**********************************\n** Algorithm = KrylovNewton\n** Time Step = [format {%0.2e} $DtCurrent]\n** Remaining Time = [format {%0.3f} $remainTime]\n** Tolerance = [format {%0.1e} $Tol]\n** MaxNumIter = [format {%d} $MaxNumIter]\n**********************************"
 		system UmfPack -lvalueFact $UmfPackLvalueFact;
 		test $TestType $Tol $MaxNumIter $printFlag;
 		algorithm KrylovNewton;
 		if {$TimeStepCount == 0} {
    	set ok [analyze [expr min([expr $NewRemainSteps-1],64)] $DtCurrent]; 
    } elseif {$TimeStepCount == 1} {
    	set ok [analyze 32 $DtCurrent]; 
    } elseif {$TimeStepCount == 2} {
    	set ok [analyze 32 $DtCurrent]; 
    } elseif {$TimeStepCount == 3} {
    	set ok [analyze 16 $DtCurrent]; 
    } elseif {$TimeStepCount == 4} {
    	set ok [analyze 16 $DtCurrent]; 
    } elseif {$TimeStepCount == 5} {
    	set ok [analyze 8 $DtCurrent]; 
    } 
 	}
 	
 	if {$ok != 0} {
 		set controlTime [getTime];
 		set remainTime [expr $GMtime-$controlTime];
   	set NewRemainSteps [expr round(($remainTime)/($DtCurrent))];
   	puts "**********************************\n** Algorithm = KrylovNewtonInitial\n** Time Step = [format {%0.2e} $DtCurrent]\n** Remaining Time = [format {%0.3f} $remainTime]\n** Tolerance = [format {%0.1e} $Tol]\n** MaxNumIter = [format {%d} $MaxNumIter]\n**********************************"
 		system UmfPack -lvalueFact $UmfPackLvalueFact;
 		test $TestType $Tol $MaxNumIter $printFlag;
 		algorithm KrylovNewton -initial;
 		if {$TimeStepCount == 0} {
    	set ok [analyze [expr min([expr $NewRemainSteps-1],64)] $DtCurrent]; 
    } elseif {$TimeStepCount == 1} {
    	set ok [analyze 32 $DtCurrent]; 
    } elseif {$TimeStepCount == 2} {
    	set ok [analyze 32 $DtCurrent]; 
    } elseif {$TimeStepCount == 3} {
    	set ok [analyze 16 $DtCurrent]; 
    } elseif {$TimeStepCount == 4} {
    	set ok [analyze 16 $DtCurrent]; 
    } elseif {$TimeStepCount == 5} {
    	set ok [analyze 8 $DtCurrent]; 
    } 
 	}
 	
 	if {$ok != 0} {
 		set controlTime [getTime];
 		set remainTime [expr $GMtime-$controlTime];
   	set NewRemainSteps [expr round(($remainTime)/($DtCurrent))];
    puts "**********************************\n** Algorithm = BFGS\n** Time Step = [format {%0.2e} $DtCurrent]\n** Remaining Time = [format {%0.3f} $remainTime]\n** Tolerance = [format {%0.1e} $Tol]\n** MaxNumIter = [format {%d} $MaxNumIter]\n**********************************"
 		system UmfPack -lvalueFact $UmfPackLvalueFact;
 		test $TestType $Tol [expr int(floor($MaxNumIter/2))] $printFlag;
 		algorithm BFGS;
 		if {$TimeStepCount == 0} {
    	set ok [analyze [expr min([expr $NewRemainSteps-1],64)] $DtCurrent]; 
    } elseif {$TimeStepCount == 1} {
    	set ok [analyze 32 $DtCurrent]; 
    } elseif {$TimeStepCount == 2} {
    	set ok [analyze 32 $DtCurrent]; 
    } elseif {$TimeStepCount == 3} {
    	set ok [analyze 16 $DtCurrent]; 
    } elseif {$TimeStepCount == 4} {
    	set ok [analyze 16 $DtCurrent]; 
    } elseif {$TimeStepCount == 5} {
    	set ok [analyze 8 $DtCurrent]; 
    } 
 	}
 	
  # Check Max Drifts for Collapse by Monitoring the CollapseFlag Variable
  MaxDriftTesterBiDirection $numStories $DriftLimit $FloorNodes $h1 $htyp
  if  {$CollapseFlag == "YES"} {
  	set ok 0; 
  	break;
  }
  
  # Check run time to see if it is in excess of maximum allotted time
  set currentT [clock seconds];
  set runTime [expr $currentT - $startT];
  if  {$runTime > $maxRunTime} {
  	break;
  }	
  ###############################################################################
  
  ###############################################################################
  # Dt/32 #######################################################################
  if {$ok != 0 && $TimeStepCount == 5} {  
   puts "Using $BackUpTestType test and HTTP Inegrator for convergence ..."
   system UmfPack -lvalueFact $UmfPackLvalueFact;
 	 test $BackUpTestType $Tol $MaxNumIter $printFlag;
 	 integrator HHTHSIncrReduct 0.5 0.95
  }
   
 	if {$ok != 0 && $TimeStepCount == 5} { 
 		puts "**********************************\n** Algorithm = NewtonLineSearch\n** Time Step = [format {%0.2e} $DtCurrent]\n** Remaining Time = [format {%0.3f} $remainTime]\n** Tolerance = [format {%0.1e} $Tol]\n** MaxNumIter = [format {%d} $MaxNumIter]\n**********************************"
 		system UmfPack -lvalueFact $UmfPackLvalueFact;
 		algorithm NewtonLineSearch 0.75;
 		set ok [analyze 4 $DtCurrent];
 	}
 	
 	if {$ok != 0 && $TimeStepCount == 5} { 
 		puts "**********************************\n** Algorithm = KrylovNewton\n** Time Step = [format {%0.2e} $DtCurrent]\n** Remaining Time = [format {%0.3f} $remainTime]\n** Tolerance = [format {%0.1e} $Tol]\n** MaxNumIter = [format {%d} $MaxNumIter]\n**********************************"
 		system UmfPack -lvalueFact $UmfPackLvalueFact;
 		algorithm KrylovNewton;
 		set ok [analyze 4 $DtCurrent];
 	}
 	
 	if {$ok != 0 && $TimeStepCount == 5} { 
 		puts "**********************************\n** Algorithm = KrylovNewtonInitial\n** Time Step = [format {%0.2e} $DtCurrent]\n** Remaining Time = [format {%0.3f} $remainTime]\n** Tolerance = [format {%0.1e} $Tol]\n** MaxNumIter = [format {%d} $MaxNumIter]\n**********************************"
 		system UmfPack -lvalueFact $UmfPackLvalueFact;
 		algorithm KrylovNewton -initial;
 		set ok [analyze 4 $DtCurrent];
 	}
 	
 	if {$ok != 0 && $TimeStepCount == 5} { 
 		puts "**********************************\n** Algorithm = BFGS\n** Time Step = [format {%0.2e} $DtCurrent]\n** Remaining Time = [format {%0.3f} $remainTime]\n** Tolerance = [format {%0.1e} $Tol]\n** MaxNumIter = [format {%d} $MaxNumIter]\n**********************************"
 		system UmfPack -lvalueFact $UmfPackLvalueFact;
 		algorithm BFGS;
 		set ok [analyze 4 $DtCurrent];
 	}
 	
 	# Check Max Drifts for Collapse by Monitoring the CollapseFlag Variable
  MaxDriftTesterBiDirection $numStories $DriftLimit $FloorNodes $h1 $htyp
  if  {$CollapseFlag == "YES"} {
  	set ok 0; 
  	break;
  }
  
  # Check run time to see if it is in excess of maximum allotted time
  set currentT [clock seconds];
  set runTime [expr $currentT - $startT];
  if  {$runTime > $maxRunTime} {
  	break;
  }	
  
  ###########################################################################
  
  ###############################################################################
  # Dt/32 #######################################################################
  if {$ok != 0 && $TimeStepCount == 5} {  
   puts "Using $BackUpTestType test and HTTP Inegrator for convergence for the last time..."
   system UmfPack -lvalueFact $UmfPackLvalueFact;
 	 test $BackUpTestType $Tol $MaxNumIter $printFlag;
 	 integrator HHTHSIncrReduct 0.5 0.95
  }
   
 	if {$ok != 0 && $TimeStepCount == 5} { 
 		puts "**********************************\n** Algorithm = NewtonLineSearch\n** Time Step = [format {%0.2e} $DtCurrent]\n** Remaining Time = [format {%0.3f} $remainTime]\n** Tolerance = [format {%0.1e} $Tol]\n** MaxNumIter = [format {%d} $MaxNumIter]\n**********************************"
 		algorithm NewtonLineSearch 0.75;
 		set ok [analyze 1 $DtCurrent];
 	}
 	
 	if {$ok != 0 && $TimeStepCount == 5} { 
 		puts "**********************************\n** Algorithm = KrylovNewton\n** Time Step = [format {%0.2e} $DtCurrent]\n** Remaining Time = [format {%0.3f} $remainTime]\n** Tolerance = [format {%0.1e} $Tol]\n** MaxNumIter = [format {%d} $MaxNumIter]\n**********************************"
 		algorithm KrylovNewton;
 		set ok [analyze 1 $DtCurrent];
 	}
 	
 	if {$ok != 0 && $TimeStepCount == 5} { 
 		puts "**********************************\n** Algorithm = KrylovNewtonInitial\n** Time Step = [format {%0.2e} $DtCurrent]\n** Remaining Time = [format {%0.3f} $remainTime]\n** Tolerance = [format {%0.1e} $Tol]\n** MaxNumIter = [format {%d} $MaxNumIter]\n**********************************"
 		algorithm KrylovNewton -initial;
 		set ok [analyze 1 $DtCurrent];
 	}
 	
 	if {$ok != 0 && $TimeStepCount == 5} { 
 		puts "**********************************\n** Algorithm = BFGS\n** Time Step = [format {%0.2e} $DtCurrent]\n** Remaining Time = [format {%0.3f} $remainTime]\n** Tolerance = [format {%0.1e} $Tol]\n** MaxNumIter = [format {%d} $MaxNumIter]\n**********************************"
 		algorithm BFGS;
 		set ok [analyze 1 $DtCurrent];
 	}
 	
 	# Check Max Drifts for Collapse by Monitoring the CollapseFlag Variable
  MaxDriftTesterBiDirection $numStories $DriftLimit $FloorNodes $h1 $htyp
  if  {$CollapseFlag == "YES"} {
  	set ok 0; 
  	break;
  }
  
  # Check run time to see if it is in excess of maximum allotted time
  set currentT [clock seconds];
  set runTime [expr $currentT - $startT];
  if  {$runTime > $maxRunTime} {
  	break;
  }	
  
  ###########################################################################
  
  ###########################################################################
  # Dynamicly changing TimeStepCount, Tol and MaxNumIter per difficulty of convergence ##########
  if {$ok == 0 && $TimeStepCount >= 1 && $TimeStepCount <= 5} {
 		set TimeStepCount [expr $TimeStepCount-1];
 		set Tol [expr $Tol/$incrTolFactor];
 		set MaxNumIter [expr $MaxNumIter-$incrMaxNumIter];
  }
  
 	if {$ok != 0 && $TimeStepCount >= 0 && $TimeStepCount <= 4} {
 		set TimeStepCount [expr $TimeStepCount+1];
 		set Tol [expr $Tol*$incrTolFactor];
 		set MaxNumIter [expr $MaxNumIter+$incrMaxNumIter];
  	set ok 0;
  	continue;
  }
 	###########################################################################
 			
 }; # End of While
 
  if {$ok == 0} {
  	set controlTime [getTime];
    puts "Dynamic analysis ACCOMPLISHED with time [format {%0.3f} $controlTime]/[format {%0.3f} $GMtime] ...";
 	} else {
 		set controlTime [getTime];
 		puts "Dynamic analysis FAILED with time [format {%0.3f} $controlTime]/[format {%0.3f} $GMtime] ...";
 	}
 	
}
