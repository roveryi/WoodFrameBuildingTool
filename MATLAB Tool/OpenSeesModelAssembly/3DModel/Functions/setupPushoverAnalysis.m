% This function is used to setup the root tcl file for running the pushover
% analysis
function setupPushoverAnalysis(BuildingModelDirectory,buildingGeometry,...
    leaningColumnNodes,pushoverAnalysisParameters)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Define Root Tcl File for Running X-Direction Pushover Analysis     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Go to model data direction
cd(BuildingModelDirectory)

% Make folder used to store OpenSees models
cd OpenSees3DModels/PushoverAnalysis

% Opening and defining Tcl file
fid = fopen(strcat('RunXPushoverAnalysis','.tcl'),'wt');

% Clear the memory
fprintf(fid,'%s\n','# Clear the memory');
fprintf(fid,'%s\n','wipe all');
fprintf(fid,'%s\n','');

% Defining model builder
fprintf(fid,'%s\n','# Define model builder');
fprintf(fid,'%s\n','model BasicBuilder -ndm 3 -ndf 6');
fprintf(fid,'%s\n','');

% Defining pushover analysis parameters
fprintf(fid,'%s\n','# Define pushover analysis parameters');
% Control node
fprintf(fid,'%s\t','set IDctrlNode');
fprintf(fid,'%s\n',num2str(leaningColumnNodes{...
    buildingGeometry.numberOfStories + 1}(4)));

% Control degree of freedom
fprintf(fid,'%s\t','set IDctrlDOF');
fprintf(fid,'%s\n',num2str(1));

% Control increment size
fprintf(fid,'%s\t','set Dincr');
fprintf(fid,'%s\n',num2str(pushoverAnalysisParameters. ...
    PushoverIncrementSize));

% Maximum displacement
PushoverRoofDisplacement = pushoverAnalysisParameters. ...
    PushoverXDrift*sum(buildingGeometry.floorHeights(...
    buildingGeometry.numberOfStories+1))/100;
fprintf(fid,'%s\t','set Dmax');
fprintf(fid,'%s\n',num2str(PushoverRoofDisplacement));
fprintf(fid,'%s\n','');

% Setting up output directory
fprintf(fid,'%s\n','# Set up output directory');
fprintf(fid,'%s\n','set dataDir Static-Pushover-Output-Model3D-XPushoverDirection');
fprintf(fid,'%s\n','file mkdir $dataDir');
fprintf(fid,'%s\n','set baseDir [pwd]');
fprintf(fid,'%s\n','');

% Define variables
fprintf(fid,'%s\n','# Defining variables');
fprintf(fid,'%s\n','source DefineVariables.tcl');
fprintf(fid,'%s\n','');

% Define units and constants
fprintf(fid,'%s\n','# Defining units and constants');
fprintf(fid,'%s\n','source DefineUnitsAndConstants.tcl');
fprintf(fid,'%s\n','');

% Define functions and procedures
fprintf(fid,'%s\n','# Defining functions and procedures');
fprintf(fid,'%s\n','source DefineFunctionsAndProcedures.tcl');
fprintf(fid,'%s\n','');

% Source display procedures
fprintf(fid,'%s\n','# Source display procedures');
fprintf(fid,'%s\n','source DisplayModel3D.tcl');
fprintf(fid,'%s\n','source DisplayPlane.tcl');
fprintf(fid,'%s\n','');

% Source building model
fprintf(fid,'%s\n','# Source building model');
fprintf(fid,'%s\n','source Model.tcl');
fprintf(fid,'%s\n','');

% Defining pushover loading
fprintf(fid,'%s\n','# Define pushover loading');
fprintf(fid,'%s\n','source DefinePushoverXLoading3DModel.tcl');
fprintf(fid,'%s\n','');

% Defining model run time parameters
fprintf(fid,'%s\n','# Define model run time parameters');
fprintf(fid,'%s\n','set startT [clock seconds]');
fprintf(fid,'%s\n','');

% Run pushover analysis
fprintf(fid,'%s\n','# Run pushover analysis');
fprintf(fid,'%s\n','source RunStaticPushover.tcl');
fprintf(fid,'%s\n','');

% Defining model run time parameters
fprintf(fid,'%s\n','# Define model run time parameters');
fprintf(fid,'%s\n','set endT [clock seconds]');
fprintf(fid,'%s\n','set RunTime [expr ($endT - $endT)]');
fprintf(fid,'%s\n','puts "Run Time = $RunTime Seconds"');
fprintf(fid,'%s\n','');

% Closing and saving tcl file
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Define Root Tcl File for Running Z-Direction Pushover Analysis     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Go to model data direction
cd(BuildingModelDirectory)

% Make folder used to store OpenSees models
cd OpenSees3DModels/PushoverAnalysis

% Opening and defining Tcl file
fid = fopen(strcat('RunZPushoverAnalysis','.tcl'),'wt');

% Clear the memory
fprintf(fid,'%s\n','# Clear the memory');
fprintf(fid,'%s\n','wipe all');
fprintf(fid,'%s\n','');

% Defining model builder
fprintf(fid,'%s\n','# Define model builder');
fprintf(fid,'%s\n','model BasicBuilder -ndm 3 -ndf 6');
fprintf(fid,'%s\n','');

% Defining pushover analysis parameters
fprintf(fid,'%s\n','# Define pushover analysis parameters');
% Control node
fprintf(fid,'%s\t','set IDctrlNode');
fprintf(fid,'%s\n',num2str(leaningColumnNodes{...
    buildingGeometry.numberOfStories + 1}(4)));

% Control degree of freedom
fprintf(fid,'%s\t','set IDctrlDOF');
fprintf(fid,'%s\n',num2str(3));

% Control increment size
fprintf(fid,'%s\t','set Dincr');
fprintf(fid,'%s\n',num2str(pushoverAnalysisParameters. ...
    PushoverIncrementSize));

% Maximum displacement
PushoverRoofDisplacement = pushoverAnalysisParameters. ...
    PushoverXDrift*sum(buildingGeometry.floorHeights(...
    buildingGeometry.numberOfStories+1))/100;
fprintf(fid,'%s\t','set Dmax');
fprintf(fid,'%s\n',num2str(PushoverRoofDisplacement));
fprintf(fid,'%s\n','');

% Setting up output directory
fprintf(fid,'%s\n','# Set up output directory');
fprintf(fid,'%s\n','set dataDir Static-Pushover-Output-Model3D-ZPushoverDirection');
fprintf(fid,'%s\n','file mkdir $dataDir');
fprintf(fid,'%s\n','set baseDir [pwd]');
fprintf(fid,'%s\n','');

% Define variables
fprintf(fid,'%s\n','# Defining variables');
fprintf(fid,'%s\n','source DefineVariables.tcl');
fprintf(fid,'%s\n','');

% Define units and constants
fprintf(fid,'%s\n','# Defining units and constants');
fprintf(fid,'%s\n','source DefineUnitsAndConstants.tcl');
fprintf(fid,'%s\n','');

% Define functions and procedures
fprintf(fid,'%s\n','# Defining functions and procedures');
fprintf(fid,'%s\n','source DefineFunctionsAndProcedures.tcl');
fprintf(fid,'%s\n','');

% Source display procedures
fprintf(fid,'%s\n','# Source display procedures');
fprintf(fid,'%s\n','source DisplayModel3D.tcl');
fprintf(fid,'%s\n','source DisplayPlane.tcl');
fprintf(fid,'%s\n','');

% Source building model
fprintf(fid,'%s\n','# Source building model');
fprintf(fid,'%s\n','source Model.tcl');
fprintf(fid,'%s\n','');

% Defining pushover loading
fprintf(fid,'%s\n','# Define pushover loading');
fprintf(fid,'%s\n','source DefinePushoverZLoading3DModel.tcl');
fprintf(fid,'%s\n','');

% Defining model run time parameters
fprintf(fid,'%s\n','# Define model run time parameters');
fprintf(fid,'%s\n','set startT [clock seconds]');
fprintf(fid,'%s\n','');

% Run pushover analysis
fprintf(fid,'%s\n','# Run pushover analysis');
fprintf(fid,'%s\n','source RunStaticPushover.tcl');
fprintf(fid,'%s\n','');

% Defining model run time parameters
fprintf(fid,'%s\n','# Define model run time parameters');
fprintf(fid,'%s\n','set endT [clock seconds]');
fprintf(fid,'%s\n','set RunTime [expr ($endT - $endT)]');
fprintf(fid,'%s\n','puts "Run Time = $RunTime Seconds"');
fprintf(fid,'%s\n','');

% Closing and saving tcl file
fclose(fid);
end