% This function is used to generate a 3D OpenSees model.

function generate3DOpenSeesModel(...
    BuildingDataDirectory, BuildingModelDirectory, OMA3DFunctionsDirectory,...
    buildingGeometry, buildingLoads, dynamicPropertiesObject,...
    XDirectionWoodPanelNodes, ZDirectionWoodPanelNodes,...
    XWoodPanelSAWSMaterials, ZWoodPanelSAWSMaterials,...
    xDirectionMomentFrameObjects, zDirectionMomentFrameObjects,...
    leaningColumnNodes,...
    xDirectionWoodPanelObjects, zDirectionWoodPanelObjects,...
    seismicParametersObject, pushoverAnalysisParameters,...
    dynamicAnalysisParameters, momentFrameRetrofitIndicator,...
    BuildingModelDataDirectory)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        Create Model Folders                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Go to directory with baseline tcl files
cd(BuildingModelDirectory);
mkdir OpenSees3DModels
cd(BuildingDataDirectory);
cd BaselineTclFiles

% Copy/create folders for new model
NewModelLocation = strcat(BuildingModelDirectory,'/OpenSees3DModels');
copyfile('OpenSees3DModels',NewModelLocation);

% Copy MCE scale factors to Ground Motion Info Folder
% OriginFolder = strcat(BuildingDataDirectory,'/AnalysisParameters/',...
%     'DynamicAnalysis');
% DestinationFolder = strcat(BuildingModelDirectory,'/OpenSees3DModels',...
%     '/DynamicAnalysis/GroundMotionInfo');
% cd(OriginFolder)
% copyfile('BiDirectionMCEScaleFactors.txt',DestinationFolder)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Generate Tcl Files Needed to Define Model Nodes                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create tcl files with nodes defined
cd(OMA3DFunctionsDirectory);
defineNodes3DModel(BuildingModelDirectory,buildingGeometry,...
    XDirectionWoodPanelNodes,ZDirectionWoodPanelNodes,...
    leaningColumnNodes,'PushoverAnalysis');
cd(OMA3DFunctionsDirectory);
defineNodes3DModel(BuildingModelDirectory,buildingGeometry,...
    XDirectionWoodPanelNodes,ZDirectionWoodPanelNodes,...
    leaningColumnNodes,'DynamicAnalysis');
cd(OMA3DFunctionsDirectory);
defineNodes3DModel(BuildingModelDirectory,buildingGeometry,...
    XDirectionWoodPanelNodes,ZDirectionWoodPanelNodes,...
    leaningColumnNodes,'EigenValueAnalysis');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Generate Tcl Files Needed to Define Rigid Floor Diaphragm           %
%     Constraints                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generates Tcl file where rigid diaphragm constraints
% are defined
cd(OMA3DFunctionsDirectory);
defineRigidFloorDiaphragm3DModel(buildingGeometry,...
    XDirectionWoodPanelNodes,ZDirectionWoodPanelNodes,...
    leaningColumnNodes,BuildingModelDirectory,'PushoverAnalysis');
cd(OMA3DFunctionsDirectory);
defineRigidFloorDiaphragm3DModel(buildingGeometry,...
    XDirectionWoodPanelNodes,ZDirectionWoodPanelNodes,...
    leaningColumnNodes,BuildingModelDirectory,'DynamicAnalysis');
cd(OMA3DFunctionsDirectory);
defineRigidFloorDiaphragm3DModel(buildingGeometry,...
    XDirectionWoodPanelNodes,ZDirectionWoodPanelNodes,...
    leaningColumnNodes,BuildingModelDirectory,'EigenValueAnalysis');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Generate Tcl Files Needed to Define Fixities                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Call function that generates Tcl file where node fixities are assigned
cd(OMA3DFunctionsDirectory);
defineFixities3DModel(buildingGeometry,XDirectionWoodPanelNodes,...
    ZDirectionWoodPanelNodes,leaningColumnNodes,BuildingModelDirectory,...
    'PushoverAnalysis');
cd(OMA3DFunctionsDirectory);
defineFixities3DModel(buildingGeometry,XDirectionWoodPanelNodes,...
    ZDirectionWoodPanelNodes,leaningColumnNodes,BuildingModelDirectory,...
    'DynamicAnalysis');
cd(OMA3DFunctionsDirectory);
defineFixities3DModel(buildingGeometry,XDirectionWoodPanelNodes,...
    ZDirectionWoodPanelNodes,leaningColumnNodes,BuildingModelDirectory,...
    'EigenValueAnalysis');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Generate Tcl Files Needed to Define Wood Panel Materials         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function used to generate tcl files that define wood panel materials
cd(OMA3DFunctionsDirectory);
defineWoodPanelMaterials3DModel(buildingGeometry,...
    XWoodPanelSAWSMaterials,ZWoodPanelSAWSMaterials,...
    xDirectionWoodPanelObjects,zDirectionWoodPanelObjects,...
    BuildingModelDirectory,'PushoverAnalysis');
cd(OMA3DFunctionsDirectory);
defineWoodPanelMaterials3DModel(buildingGeometry,...
    XWoodPanelSAWSMaterials,ZWoodPanelSAWSMaterials,...
    xDirectionWoodPanelObjects,zDirectionWoodPanelObjects,...
    BuildingModelDirectory,'DynamicAnalysis');
cd(OMA3DFunctionsDirectory);
defineWoodPanelMaterials3DModel(buildingGeometry,...
    XWoodPanelSAWSMaterials,ZWoodPanelSAWSMaterials,...
    xDirectionWoodPanelObjects,zDirectionWoodPanelObjects,...
    BuildingModelDirectory,'EigenValueAnalysis');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Generate Tcl Files Needed to Define Wood Panels             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function used to generate tcl files that define wood panels
cd(OMA3DFunctionsDirectory);
defineWoodPanels3DModel(buildingGeometry,xDirectionWoodPanelObjects,...
    zDirectionWoodPanelObjects,BuildingModelDirectory,'PushoverAnalysis');
cd(OMA3DFunctionsDirectory);
defineWoodPanels3DModel(buildingGeometry,xDirectionWoodPanelObjects,...
    zDirectionWoodPanelObjects,BuildingModelDirectory,'DynamicAnalysis');
cd(OMA3DFunctionsDirectory);
defineWoodPanels3DModel(buildingGeometry,xDirectionWoodPanelObjects,...
    zDirectionWoodPanelObjects,BuildingModelDirectory,'EigenValueAnalysis');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Generate Tcl Files Needed to Retrofit Moment Frames           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function used to generate tcl files that define retrofit moment
% frames (where present)
if momentFrameRetrofitIndicator.XFrame == 1
    cd(OMA3DFunctionsDirectory)
    defineXMomentFrames3DModel(buildingGeometry,...
        xDirectionMomentFrameObjects,BuildingModelDirectory,...
        'EigenValueAnalysis')
    cd(OMA3DFunctionsDirectory)
    defineXMomentFrames3DModel(buildingGeometry,...
        xDirectionMomentFrameObjects,BuildingModelDirectory,...
        'PushoverAnalysis')
    cd(OMA3DFunctionsDirectory)
    defineXMomentFrames3DModel(buildingGeometry,...
        xDirectionMomentFrameObjects,BuildingModelDirectory,...
        'DynamicAnalysis')
end

if momentFrameRetrofitIndicator.ZFrame == 1
    cd(OMA3DFunctionsDirectory)
    defineZMomentFrames3DModel(buildingGeometry,...
        zDirectionMomentFrameObjects,BuildingModelDirectory,...
        'EigenValueAnalysis')
    cd(OMA3DFunctionsDirectory)
    defineZMomentFrames3DModel(buildingGeometry,...
        zDirectionMomentFrameObjects,BuildingModelDirectory,...
        'PushoverAnalysis')
    cd(OMA3DFunctionsDirectory)
    defineZMomentFrames3DModel(buildingGeometry,...
        zDirectionMomentFrameObjects,BuildingModelDirectory,...
        'DynamicAnalysis')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          Generate Tcl Files Needed to Define Leaning Columns            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function used to generate tcl files that define leaning columns
cd(OMA3DFunctionsDirectory);
defineLeaningColumn3DModel(buildingGeometry,leaningColumnNodes,...
    BuildingModelDirectory,'PushoverAnalysis');
cd(OMA3DFunctionsDirectory);
defineLeaningColumn3DModel(buildingGeometry,leaningColumnNodes,...
    BuildingModelDirectory,'DynamicAnalysis');
cd(OMA3DFunctionsDirectory);
defineLeaningColumn3DModel(buildingGeometry,leaningColumnNodes,...
    BuildingModelDirectory,'EigenValueAnalysis');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Generate Tcl Files Needed to Define Flexible              %
%                  Flexural Springs at Leaning Columns                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function used to generate tcl files that define leaning columns
cd(OMA3DFunctionsDirectory);
defineLeaningColumnFlexuralSprings3DModel(buildingGeometry,...
    leaningColumnNodes,BuildingModelDirectory,'PushoverAnalysis');
cd(OMA3DFunctionsDirectory);
defineLeaningColumnFlexuralSprings3DModel(buildingGeometry,...
    leaningColumnNodes,BuildingModelDirectory,'DynamicAnalysis');
cd(OMA3DFunctionsDirectory);
defineLeaningColumnFlexuralSprings3DModel(buildingGeometry,...
    leaningColumnNodes,BuildingModelDirectory,'EigenValueAnalysis');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Generate Tcl File Needed to Define Damping                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where damping defined
cd(OMA3DFunctionsDirectory);
defineDamping3DModel(buildingGeometry,dynamicPropertiesObject,...
    BuildingModelDirectory,leaningColumnNodes,'DynamicAnalysis');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Generate Tcl File Needed to Define Base Node Reaction Recorders     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where base node reaction recorders
% are defined
cd(OMA3DFunctionsDirectory);
defineBaseReactionRecorders3DModel(buildingGeometry,...
    XDirectionWoodPanelNodes,ZDirectionWoodPanelNodes,...
    leaningColumnNodes,BuildingModelDirectory,'PushoverAnalysis');
cd(OMA3DFunctionsDirectory);
defineBaseReactionRecorders3DModel(buildingGeometry,...
    XDirectionWoodPanelNodes,ZDirectionWoodPanelNodes,...
    leaningColumnNodes,BuildingModelDirectory,'DynamicAnalysis');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Generate Tcl File Needed to Define Wood Panel Recorders          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where wood panel recorders are
% defined
cd(OMA3DFunctionsDirectory);
defineWoodPanelRecorders3DModel(buildingGeometry,...
    BuildingModelDirectory,'PushoverAnalysis');
cd(OMA3DFunctionsDirectory);
defineWoodPanelRecorders3DModel(buildingGeometry,...
    BuildingModelDirectory,'DynamicAnalysis');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Generate Tcl File Needed to Define Node Displacement Recorders      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where node damping force recorders
% are defined
cd(OMA3DFunctionsDirectory);
defineNodeAccelerationRecorders3DModel(buildingGeometry,...
    XDirectionWoodPanelNodes,ZDirectionWoodPanelNodes,...
    leaningColumnNodes,BuildingModelDirectory,'PushoverAnalysis');
cd(OMA3DFunctionsDirectory);
defineNodeAccelerationRecorders3DModel(buildingGeometry,...
    XDirectionWoodPanelNodes,ZDirectionWoodPanelNodes,...
    leaningColumnNodes,BuildingModelDirectory,'DynamicAnalysis');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Generate Tcl File Needed to Define Node Displacement Recorders      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where node displacement recorders
% are defined
cd(OMA3DFunctionsDirectory);
defineNodeDisplacementRecorders3DModel(buildingGeometry,...
    XDirectionWoodPanelNodes,ZDirectionWoodPanelNodes,...
    leaningColumnNodes,BuildingModelDirectory,'PushoverAnalysis');
cd(OMA3DFunctionsDirectory);
defineNodeDisplacementRecorders3DModel(buildingGeometry,...
    XDirectionWoodPanelNodes,ZDirectionWoodPanelNodes,...
    leaningColumnNodes,BuildingModelDirectory,'DynamicAnalysis');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Generate Tcl File Needed to Define Node Damping Force Recorders     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where node acceleration recorders
% are defined
cd(OMA3DFunctionsDirectory);
defineNodeDampingForceRecorders3DModel(buildingGeometry,...
    XDirectionWoodPanelNodes,ZDirectionWoodPanelNodes,...
    leaningColumnNodes,BuildingModelDirectory,'DynamicAnalysis');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Generate Tcl File Needed to Define Story Drift Recorders        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where story drift recorders
% are defined
cd(OMA3DFunctionsDirectory);
defineStoryDriftRecorders3DModel(buildingGeometry,leaningColumnNodes,...
    BuildingModelDirectory,'PushoverAnalysis');
cd(OMA3DFunctionsDirectory);
defineStoryDriftRecorders3DModel(buildingGeometry,leaningColumnNodes,...
    BuildingModelDirectory,'DynamicAnalysis');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Generate Tcl File Needed to Source All Recorders            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where all recorders are sourced
cd(OMA3DFunctionsDirectory);
defineAllRecorders3DModel(BuildingModelDirectory,'PushoverAnalysis');
cd(OMA3DFunctionsDirectory);
defineAllRecorders3DModel(BuildingModelDirectory,'DynamicAnalysis');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Generate Tcl File Needed to Define Gravity Loading            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where gravity loading defined
cd(OMA3DFunctionsDirectory);
defineGravityLoads3DModel(buildingGeometry,buildingLoads,...
    leaningColumnNodes,BuildingModelDirectory,'PushoverAnalysis');
cd(OMA3DFunctionsDirectory);
defineGravityLoads3DModel(buildingGeometry,buildingLoads,...
    leaningColumnNodes,BuildingModelDirectory,'DynamicAnalysis');
cd(OMA3DFunctionsDirectory);
defineGravityLoads3DModel(buildingGeometry,buildingLoads,...
    leaningColumnNodes,BuildingModelDirectory,'EigenValueAnalysis');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Generate Tcl File Needed to Define Masses                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where masses are defined
cd(OMA3DFunctionsDirectory);
defineMasses3DModel(buildingGeometry,buildingLoads,leaningColumnNodes,...
    BuildingModelDirectory,'PushoverAnalysis');
cd(OMA3DFunctionsDirectory);
defineMasses3DModel(buildingGeometry,buildingLoads,leaningColumnNodes,...
    BuildingModelDirectory,'DynamicAnalysis');
cd(OMA3DFunctionsDirectory);
defineMasses3DModel(buildingGeometry,buildingLoads,leaningColumnNodes,...
    BuildingModelDirectory,'EigenValueAnalysis');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Generating Tcl File Defining Parameters Needed for Collapse Solver   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generates file used to define collapse solver
% parameters
cd(OMA3DFunctionsDirectory);
defineDynamicAnalysisParameters3DModel(buildingGeometry,...
    leaningColumnNodes,BuildingModelDirectory,'DynamicAnalysis');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Generate Tcl File Needed to Define Pushover Loading           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generates tcl file used to define pushover loading
% pattern
cd(OMA3DFunctionsDirectory);
definePushoverLoading3DModel(buildingGeometry,seismicParametersObject,...
    leaningColumnNodes,BuildingModelDirectory,'PushoverAnalysis');
cd(OMA3DFunctionsDirectory);
definePushoverLoading3DModel(buildingGeometry,seismicParametersObject,...
    leaningColumnNodes,BuildingModelDirectory,'EigenValueAnalysis');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Define, Setup and Run Eigen Value Analysis Model            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set up tcl files for eigen value analysis
cd(OMA3DFunctionsDirectory);
define3DEigenValueAnalysisModel(BuildingModelDirectory,...
    'EigenValueAnalysis',momentFrameRetrofitIndicator);

%Run eigen value analysis
cd(OMA3DFunctionsDirectory);
run3DEigenValueAnalysis(BuildingModelDirectory,...
    BuildingModelDataDirectory,dynamicPropertiesObject);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  Define and Setup Pushover Analysis Model               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generates main tcl file used to define pushover
% analysis model
cd(OMA3DFunctionsDirectory);
define3DPushoverAnalysisModel(BuildingModelDirectory,'PushoverAnalysis',...
    momentFrameRetrofitIndicator);

% Call function that is used to setup root tcl files for running pushover
% analysis
cd(OMA3DFunctionsDirectory);
setupPushoverAnalysis(BuildingModelDirectory,buildingGeometry,...
    leaningColumnNodes,pushoverAnalysisParameters);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  Define and Setup Dynamic Analysis Model               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generates main tcl file used to define dynamic
% analysis model
cd(OMA3DFunctionsDirectory)
define3DDynamicAnalysisModel(BuildingModelDirectory,...
    'DynamicAnalysis',momentFrameRetrofitIndicator)

% Call function that is used to setup root tcl files for running dynamic
% analysis
cd(BuildingModelDataDirectory)
load dynamicPropertiesObject
cd(OMA3DFunctionsDirectory)
setupDynamicAnalysis(BuildingModelDirectory,buildingGeometry,...
    dynamicAnalysisParameters,dynamicPropertiesObject)







