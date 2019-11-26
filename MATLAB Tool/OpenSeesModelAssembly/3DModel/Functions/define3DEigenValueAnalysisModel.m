
function define3DEigenValueAnalysisModel...
    (BuildingModelDirectory,AnalysisType,momentFrameRetrofitIndicator)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                Generating Tcl File with Defined Nodes                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(BuildingModelDirectory);
cd OpenSees3DModels
cd(AnalysisType);
fid = fopen('Model.tcl','wt');

% Clear the memory
fprintf(fid,'%s\n','# Clear the memory');
fprintf(fid,'%s\n','wipe all');
fprintf(fid,'%s\n','');

% Defining model builder
fprintf(fid,'%s\n','# Define model builder');
fprintf(fid,'%s\n','model BasicBuilder -ndm 3 -ndf 6');
fprintf(fid,'%s\n','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Define Miscellaneous Functions and Procedures             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Defining Nodes, Rigid Floor Diaphragm Constraints and Fixities     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Defining nodes
fprintf(fid,'%s\n','# Defining nodes');
fprintf(fid,'%s\n','source DefineNodes3DModel.tcl');
fprintf(fid,'%s\n','');

% Defining rigid floor diaphragm constraints
fprintf(fid,'%s\n','# Defining rigid floor diaphragm constraints');
fprintf(fid,'%s\n','source DefineRigidFloorDiaphragm3DModel.tcl');
fprintf(fid,'%s\n','');

% Defining node fixities
fprintf(fid,'%s\n','# Defining node fixities');
fprintf(fid,'%s\n','source DefineFixities3DModel.tcl');
fprintf(fid,'%s\n','');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Defining Wood Panel Material Models                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Wood panel material models
fprintf(fid,'%s\n','# Defining wood panel material models');
fprintf(fid,'%s\n','source DefineWoodPanelMaterials3DModel.tcl');
fprintf(fid,'%s\n','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     Defining Wood Panel Elements                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define wood panel elements
fprintf(fid,'%s\n','# Defining wood panel elements');
fprintf(fid,'%s\n','source DefineWoodPanels3DModel.tcl');
fprintf(fid,'%s\n','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        Defining Leaning Column                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define leaning column
fprintf(fid,'%s\n','# Defining leaning column');
fprintf(fid,'%s\n','source DefineLeaningColumn3DModel.tcl');
fprintf(fid,'%s\n','');

% Define leaning column fleuxral springs
fprintf(fid,'%s\n','# Defining leaning column flexural springs');
fprintf(fid,'%s\n','source DefineLeaningColumnFlexuralSprings3DModel.tcl');
fprintf(fid,'%s\n','');

fprintf(fid,'%s\n','# Defining Moment Frames');
if momentFrameRetrofitIndicator.XFrame == 1
    fprintf(fid,'%s\n','source DefineXMomentFrames3DModel.tcl');
end

if momentFrameRetrofitIndicator.ZFrame == 1
    fprintf(fid,'%s\n','source DefineZMomentFrames3DModel.tcl');
end
fprintf(fid,'%s\n','');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Defining Masses                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define masses
fprintf(fid,'%s\n','# Defining masses');
fprintf(fid,'%s\n','source DefineMasses3DModel.tcl');
fprintf(fid,'%s\n','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Define Gravity Loads                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define gravity loads
fprintf(fid,'%s\n','# Define gravity loads');
fprintf(fid,'%s\n','source DefineGravityLoads3DModel.tcl');
fprintf(fid,'%s\n','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          Perform Gravity Analysis                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Perform gravity analysis
fprintf(fid,'%s\n','# Perform gravity analysis');
fprintf(fid,'%s\n','source PerformGravityAnalysis.tcl');
fprintf(fid,'%s\n','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Perform Eigen Value Analysis                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Perform Eigen Value Analysis
fprintf(fid,'%s\n','# Perform eigen value analysis');
fprintf(fid,'%s\n','source EigenValueAnalysis.tcl');
fprintf(fid,'%s\n','');

% Closing and saving tcl file
fclose(fid);

end

