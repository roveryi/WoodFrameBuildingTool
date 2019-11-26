
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                User Defined Model Folder and Directory Paths            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all;

% Define path to where SPA-WOOD base directory
BaseDirectory = strcat('/Users/rover/Desktop/WoodFrameBuilding/MATLAB Tool');
cd (BaseDirectory); 
cd 'RootModule';
BuildingNameFile = importdata('BuildingName.txt');
cd ..

for ii = 1:length(BuildingNameFile)
    % for ii = 1:length(BuildingNameFile)
    % String used to identify the name of the folder in which the relevant data
    % for the current building being modeled is stored. The generated OpenSees
    % models will also be stored in this folder.
    BuildingID = char(BuildingNameFile(ii,1));
    
    % Define path to directory where all data related to a currenr building
    % is located
    BuildingDataDirectory = strcat(BaseDirectory,'/BuildingData/',BuildingID);
    
    % Define path to directory where the generated OpenSees models will be
    % placed
    BuildingModelDirectory = strcat(BaseDirectory,'/BuildingModels/',...
        BuildingID);
    
    % Define location where the assembled data structures with building
    % modeling information will be stored
    BuildingModelDataDirectory = strcat(BaseDirectory,'/BuildingData/',...
        BuildingID,'/BuildingModelData');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %            OpenSees Model Assembly (OMA) Functions Directory            %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Define path to OpenSees analysis model assembly (OMA) functions
    % 3D Models
    OMA3DFunctionsDirectory = strcat(BaseDirectory,...
        '/OpenSeesModelAssembly/3DModel/Functions');
    % Define path to OpenSees analysis model assembly (OMA) functions
    % 2DX Models
    OMA2DXFunctionsDirectory = strcat(BaseDirectory,...
        '/OpenSeesModelAssembly/2DModel');
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                Load Relevant Building Model Data Structures             %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Go to location where building model information data structures are
    % stored
    cd(BuildingModelDataDirectory);
    
    % Misc building information
    load buildingGeometry
    load buildingLoads
    load dynamicPropertiesObject
    
    % Nodes
    load XDirectionWoodPanelNodes
    load ZDirectionWoodPanelNodes
    load leaningColumnNodes
    
    % Wood panels
    load xDirectionWoodPanelObjects
    load zDirectionWoodPanelObjects
    
    % Analysis parameters
    load pushoverAnalysisParameters
    load dynamicAnalysisParameters
    load seismicParametersObject
    
    % Materials
    % load Pinching4Materials
    load XWoodPanelPinching4Materials
    load ZWoodPanelPinching4Materials
    
    % Moment frames
    load momentFrameRetrofitIndicator
    load xDirectionMomentFrameObjects
    load zDirectionMomentFrameObjects
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                             3D Analysis Model                           %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Calling root function used to generate tcl files for 3D OpenSees analysis
    % model
    cd(OMA3DFunctionsDirectory);
    generate3DOpenSeesModel(...
        BuildingDataDirectory, BuildingModelDirectory, OMA3DFunctionsDirectory, ...
        buildingGeometry, buildingLoads, dynamicPropertiesObject, ...
        XDirectionWoodPanelNodes, ZDirectionWoodPanelNodes, ...
        XWoodPanelPinching4Materials, ZWoodPanelPinching4Materials, ...
        xDirectionMomentFrameObjects, zDirectionMomentFrameObjects,...
        leaningColumnNodes,...
        xDirectionWoodPanelObjects, zDirectionWoodPanelObjects,...
        seismicParametersObject, pushoverAnalysisParameters,...
        dynamicAnalysisParameters, momentFrameRetrofitIndicator,...
        BuildingModelDataDirectory);
    
    % cd(OMA2DXFunctionsDirectory);
    % generate_XWoodModels(BuildingDataDirectory,...
    %     BuildingModelDirectory, OMA2DXFunctionsDirectory,...
    %     buildingGeometry, buildingLoads, dynamicPropertiesObject,...
    %     XDirectionWoodPanelNodes, XWoodPanelSAWSMaterials,...
    %     xDirectionMomentFrameObjects, leaningColumnNodes,...
    %     xDirectionWoodPanelObjects,...
    %     seismicParametersObject, pushoverAnalysisParameters,...
    %     dynamicAnalysisParameters, momentFrameRetrofitIndicator,...
    %     BuildingModelDataDirectory);
    
end
