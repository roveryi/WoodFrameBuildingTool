% This function is used to setup root tcl files for running dynamic
% analysis
function setupDynamicAnalysis(BuildingModelDirectory,buildingGeometry,...
    dynamicAnalysisParameters,dynamicPropertiesObject)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              Define Root Tcl File for Running Single Scale Dynamic      %
%                   Analysis with Bi-Directional Loading                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define directory where OpenSees model tcl files are stored
AnalysisModelDirectory = strcat(BuildingModelDirectory,...
    '/OpenSees3DModels/DynamicAnalysis');

% Go to directory where tcl files are located
cd(AnalysisModelDirectory)

% Tcl file to be updated
original_OpenSees_file = ('RunSingleScale3DModel.tcl');

%Tcl file with updated parameters
updated_OpenSees_file = ('RunSingleScale3DModelFinal.tcl');

% Open tcl file to be updated
fileID = fopen(original_OpenSees_file);

% Read original file data into vector
fileData = fread(fileID);

% Update ground motion parameters
fileData = strrep(fileData,'*NumberOfGroundMotions*',...
    num2str(dynamicAnalysisParameters.NumberOfGroundMotions));
fileData = strrep(fileData,'*SingleScaleToRun*',...
    num2str(dynamicAnalysisParameters.SingleScaleToRun));

% Model dynamic properties
fileData = strrep(fileData,'*firstModePeriod*',...
    num2str(dynamicPropertiesObject.modalPeriods3DModel(1)));
fileData = strrep(fileData,'*thirdModePeriod*',...
    num2str(dynamicPropertiesObject.modalPeriods3DModel(3)));

% Open tcl file to write updated parameters
updatedDataFile = fopen(updated_OpenSees_file,'w');

% Write file with updated parameters
fprintf(updatedDataFile,'%c',fileData);

% Close all files
fclose('all');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            Define Root Tcl File for Running Incremental Dynamic         %
%                   Analysis with Bi-Directional Loading                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Tcl file to be updated
original_OpenSees_file = ('RunIDA3DModel.tcl');

%Tcl file with updated parameters
updated_OpenSees_file = ('RunIDA3DModelFinal.tcl');

% Open tcl file to be updated
fileID = fopen(original_OpenSees_file);

% Read original file data into vector
fileData = fread(fileID);

% Update ground motion parameters
fileData = strrep(fileData,'*NumberOfGroundMotions*',...
    num2str(dynamicAnalysisParameters.NumberOfGroundMotions));
fileData = strrep(fileData,'*AllScales*',...
    num2str((dynamicAnalysisParameters.scalesForIDA)'));

% Model dynamic properties
fileData = strrep(fileData,'*firstModePeriod*',...
    num2str(dynamicPropertiesObject.modalPeriods3DModel(1)));
fileData = strrep(fileData,'*thirdModePeriod*',...
    num2str(dynamicPropertiesObject.modalPeriods3DModel(3)));

% Open tcl file to write updated parameters
updatedDataFile = fopen(updated_OpenSees_file,'w');

% Write file with updated parameters
fprintf(updatedDataFile,'%c',fileData);

% Close all files
fclose('all');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            Define Root Tcl File for Running Incremental Dynamic         %
%              Analysis to Collapse with Bi-Directional Loading           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Tcl file to be updated
original_OpenSees_file = ('RunIDAToCollapse3DModel.tcl');

%Tcl file with updated parameters
updated_OpenSees_file = ('RunIDAToCollapse3DModelFinal.tcl');

% Open tcl file to be updated
fileID = fopen(original_OpenSees_file);

% Read original file data into vector
fileData = fread(fileID);

% Update ground motion parameters
fileData = strrep(fileData,'*NumberOfGroundMotions*',...
    num2str(dynamicAnalysisParameters.NumberOfGroundMotions));
%fileData = strrep(fileData,...
%        '*InitialGroundMotionIncrementScaleForCollapse*',...
%        num2str(dynamicAnalysisParameters. ...
%        InitialGroundMotionIncrementScaleForCollapse));
%fileData = strrep(fileData,...
%        '*ReducedGroundMotionIncrementScaleForCollapse*',...
%        num2str(dynamicAnalysisParameters. ...
%        ReducedGroundMotionIncrementScaleForCollapse));

% Model dynamic properties
fileData = strrep(fileData,'*firstModePeriod*',...
    num2str(dynamicPropertiesObject.modalPeriods3DModel(1)));
fileData = strrep(fileData,'*thirdModePeriod*',...
    num2str(dynamicPropertiesObject.modalPeriods3DModel(3)));

% % Collapse criteria
% fileData = strrep(fileData,'*CollapseDriftLimit*',...
%     num2str(dynamicAnalysisParameters.CollapseDriftLimit));

% Update geometry parameters
fileData = strrep(fileData,'*nStories*',...
    num2str(buildingGeometry.numberOfStories));

% Open tcl file to write updated parameters
updatedDataFile = fopen(updated_OpenSees_file,'w');

% Write file with updated parameters
fprintf(updatedDataFile,'%c',fileData);

% Close all files
fclose('all');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            Define Root Tcl File for Running Incremental Dynamic         %
%              Analysis to Collapse with Bi-Directional Loading           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tcl file to be updated
original_OpenSees_file = ('DefineVariables.tcl');

%Tcl file with updated parameters
updated_OpenSees_file = ('DefineVariables.tcl');

% Open tcl file to be updated
fileID = fopen(original_OpenSees_file);

% Read original file data into vector
fileData = fread(fileID);

% Model dynamic properties
fileData = strrep(fileData,'*firstModePeriod*',...
    num2str(dynamicPropertiesObject.modalPeriods3DModel(1)));
fileData = strrep(fileData,'*thirdModePeriod*',...
    num2str(dynamicPropertiesObject.modalPeriods3DModel(3)));

% % Collapse criteria
% fileData = strrep(fileData,'*CollapseDriftLimit*',...
%     num2str(dynamicAnalysisParameters.CollapseDriftLimit));

% Update geometry parameters
fileData = strrep(fileData,'*nStories*',...
    num2str(buildingGeometry.numberOfStories));

% Open tcl file to write updated parameters
updatedDataFile = fopen(updated_OpenSees_file,'w');

% Write file with updated parameters
fprintf(updatedDataFile,'%c',fileData);

% Close all files
fclose('all');

end