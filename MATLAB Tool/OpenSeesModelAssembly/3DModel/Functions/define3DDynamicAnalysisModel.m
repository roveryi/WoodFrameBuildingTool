% This function is used to generate the tcl file that sources all
% tcl files needed to run a 3D Model in OpenSees
function define3DDynamicAnalysisModel(...
    BuildingModelDirectory,AnalysisType,momentFrameRetrofitIndicator)

% Go to model data direction
cd(BuildingModelDirectory)

% Make folder used to store OpenSees models
cd OpenSees3DModels
cd(AnalysisType)

% Opening and defining Tcl file
fid = fopen(strcat('Model','.tcl'),'wt');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Defining Model Builder and Sourcing Appropriate Procedures      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Clear memory
fprintf(fid,'%s\n','wipe all;');
fprintf(fid,'%s\n','');

% Defining model builder
fprintf(fid,'%s\n','model BasicBuilder -ndm 3 -ndf 6;');
fprintf(fid,'%s\n','');

% Source appropriate procedures
fprintf(fid,'%s\n','source DefineUnitsAndConstants.tcl');
fprintf(fid,'%s\n','source DefineVariables.tcl');
fprintf(fid,'%s\n','source DefineFunctionsAndProcedures.tcl');
fprintf(fid,'%s\n','# source Define_GM_Record_Info.tcl');
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
%                           Define Gravity Loads                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define gravity loads
fprintf(fid,'%s\n','# Define gravity loads');
fprintf(fid,'%s\n','source DefineGravityLoads3DModel.tcl');
fprintf(fid,'%s\n','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Defining Recorders                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define recorders
fprintf(fid,'%s\n','# Defining recorders');
fprintf(fid,'%s\n','# source DefineAllRecorders3DModel.tcl');
fprintf(fid,'%s\n','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         Perform Gravity Analysis                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Perform Gravity Analysis
fprintf(fid,'%s\n','# Perform gravity analysis');
fprintf(fid,'%s\n','source PerformGravityAnalysis.tcl');
fprintf(fid,'%s\n','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Defining Masses                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define masses
fprintf(fid,'%s\n','# Defining masses');
fprintf(fid,'%s\n','source DefineMasses3DModel.tcl');
fprintf(fid,'%s\n','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Defining Damping                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define damping
fprintf(fid,'%s\n','# Defining damping');
fprintf(fid,'%s\n','source DefineDamping3DModel.tcl');
fprintf(fid,'%s\n','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    Define Ground Motion Scale Factor                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Run Time History
fprintf(fid,'%s\n','# Define ground motion scale factor');
fprintf(fid,'%s\n',strcat('set scalefactor [expr $g*100/100*$MCE_SF];'));
fprintf(fid,'%s\n','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Run Time History                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Run Time History
fprintf(fid,'%s\n','# Run Time History');
fprintf(fid,'%s\n','source DefineBiDirectionalTimeHistory.tcl');
fprintf(fid,'%s\n','');

fprintf(fid,'%s\n','puts "Analysis Completed"');

% Closing and saving tcl file
fclose(fid);

end



