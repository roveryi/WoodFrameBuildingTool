
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         Relevant Publications                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                User Defined Model Folder and Directory Paths            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear all; close all;

% Define path to where SPA-WOOD base directory
BaseDirectory = strcat('/Users/rover/Desktop/WoodFrameBuilding/MATLAB Tool');
cd (BaseDirectory);
cd 'RootModule';
BuildingNameFile = importdata('BuildingName.txt');
% HazardLevelFile = importdata('HazardLevel.txt');
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
    
    % Define location where the assembled data structures with building
    % modeling information will be stored
    BuildingModelDataDirectory = strcat(BaseDirectory,'/BuildingData/',...
        BuildingID,'/BuildingModelData');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %      Building Data Assembly (BDA) Functions and Classes Directories     %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Define path to building data assembly functions
    BDAFunctionsDirectory = strcat(BaseDirectory,'/BuildingDataAssembly/Functions');
    
    % Define path to building data assembly classes
    BDAClassesDirectory = strcat(BaseDirectory,'/BuildingDataAssembly/','Classes');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                      Defining Building Geometry                         %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Define path to folder where building geometry data is stored
    GeometryParametersLocation = strcat(BuildingDataDirectory,'/Geometry');
    
    % Call function used to generate a struct containing building
    % geometry data
    cd(BDAFunctionsDirectory);
    buildingGeometry = defineBuildingGeometry(GeometryParametersLocation);
    
    % Save building geometry data
    cd(BuildingModelDataDirectory);
    save('buildingGeometry.mat','buildingGeometry','-mat');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                           Defining Building Loads                       %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Define path to folder where building load data is stored
    LoadParametersLocation = strcat(BuildingDataDirectory,'/Loads');
    
    % Call function used to generate a struct containing building loads
    cd(BDAFunctionsDirectory);
    buildingLoads = defineBuildingLoads(LoadParametersLocation);
    
    % Save building loads data
    cd(BuildingModelDataDirectory);
    save('buildingLoads.mat','buildingLoads','-mat');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                        Defining Dynamic GM Histories                    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     DynamicParameters(HazardLevelFile{ii},BuildingDataDirectory);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                         Defining Seismic Parameters                     %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Define string with path to folder where building seismic parameters are
    % stored
    SeismicParametersLocation = strcat(BuildingDataDirectory,...
        '/SeismicDesignParameters');
    
    % Create seismic parameters object
    cd(BDAClassesDirectory);
    seismicParametersObject = seismicParameters(SeismicParametersLocation,...
        buildingGeometry,buildingLoads);
    
    % Save seismic parameters object
    cd(BuildingModelDataDirectory);
    seismicParametersObject = saveToStruct(seismicParametersObject);
    save('seismicParametersObject.mat','seismicParametersObject','-mat');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                         Defining Dynamic Properties                     %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Define string with path to folder where building dynamic properties are
    % stored
    DynamicPropertiesLocation = strcat(BuildingDataDirectory,...
        '/DynamicProperties');
    
    % Create dynamic properties object
    cd(BDAClassesDirectory);
    dynamicPropertiesObject = dynamicProperties(DynamicPropertiesLocation,...
        buildingLoads);
    
    % Save dynamic properties object
    cd(BuildingModelDataDirectory);
    dynamicPropertiesObject = saveToStruct(dynamicPropertiesObject);
    save('dynamicPropertiesObject.mat','dynamicPropertiesObject','-mat');
    

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                    Defining Pushover Analysis Parameters                %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Define string with path to folder where pushover analysis parameters are
    % stored
    PushoverAnalysisParametersLocation = strcat(BuildingDataDirectory,...
        '/AnalysisParameters/StaticAnalysis');
    
    % Call function used to generate a struct containing pushover analysis
    % parameters
    cd(BDAFunctionsDirectory);
    pushoverAnalysisParameters = definePushoverAnalysisParameters(...
        PushoverAnalysisParametersLocation);
    
    % Save pushover analysis parameters
    cd(BuildingModelDataDirectory);
    save('pushoverAnalysisParameters.mat','pushoverAnalysisParameters','-mat');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                     Defining Dynamic Analysis Parameters                %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Define string with path to folder where dynamic analysis parameters are
    % stored
    DynamicAnalysisParametersLocation = strcat(BuildingDataDirectory,...
        '/AnalysisParameters/DynamicAnalysis');
    
    % Call function used to generate a struct containing dynamic analysis
    % parameters
    cd(BDAFunctionsDirectory);
    dynamicAnalysisParameters = defineDynamicAnalysisParameters(...
        DynamicAnalysisParametersLocation);
    
    % Save dynamic analysis parameters
    cd(BuildingModelDataDirectory);
    save('dynamicAnalysisParameters.mat','dynamicAnalysisParameters','-mat');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %               Defining Wood Panel and Leaning Column Nodes              %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Call function used to generate an array of wood panel node objects where
    % panel nodes are the nodes that located at the top and bottom of a wood
    % panel at the midpoint in plan
    cd(BDAFunctionsDirectory);
    [XDirectionWoodPanelNodes, ZDirectionWoodPanelNodes] = ...
        defineWoodPanelNodes(buildingGeometry,BDAClassesDirectory);
    cd(BDAFunctionsDirectory);
    leaningColumnNodes = defineLeaningColumnNodes(buildingGeometry);
    
    % Save joint and leaning column node objects
    cd(BuildingModelDataDirectory);
    save('XDirectionWoodPanelNodes.mat','XDirectionWoodPanelNodes','-mat');
    save('ZDirectionWoodPanelNodes.mat','ZDirectionWoodPanelNodes','-mat');
    save('leaningColumnNodes.mat','leaningColumnNodes','-mat');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                 Defining Pinching4 Material Parameters                  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Define path to folder where the SAWS material parameters for x-direction
    % wood panels are stored
    XPanelPinching4MaterialParametersLocation = strcat(BuildingDataDirectory,...
        '/StructuralProperties/XWoodPanelPinching4Materials');
    
    % Define path to folder where the SAWS material parameters for z-direction
    % wood panels are stored
    ZPanelPinching4MaterialParametersLocation = strcat(BuildingDataDirectory,...
        '/StructuralProperties/ZWoodPanelPinching4Materials');
    
    % Call function used to generate a struct containing the SAWS parameters
    % for each unique type of material
    cd(BDAFunctionsDirectory);
    [XWoodPanelPinching4Materials, ZWoodPanelPinching4Materials] = definePinching4Materials(...
        XPanelPinching4MaterialParametersLocation,...
        ZPanelPinching4MaterialParametersLocation);
    
    % Save SAWS parameters
    cd(BuildingModelDataDirectory);
    save('XWoodPanelPinching4Materials.mat','XWoodPanelPinching4Materials','-mat');
    save('ZWoodPanelPinching4Materials.mat','ZWoodPanelPinching4Materials','-mat');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                           Defining Wood Panels                          %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Define string with path to folder where building x-direction wood panel
    % structural properties are stored
    XDirectionWoodPanelsPropertiesLocation = strcat(BuildingDataDirectory,...
        '/StructuralProperties/XWoodPanels');
    
    % Define string with path to folder where building z-direction wood panel
    % structural properties are stored
    ZDirectionWoodPanelsPropertiesLocation = strcat(BuildingDataDirectory,...
        '/StructuralProperties/ZWoodPanels');
    
    % Call function used to generate an array of wood panel objects
    cd(BDAFunctionsDirectory)
    [xDirectionWoodPanelObjects, zDirectionWoodPanelObjects] = ...
        defineWoodPanels(buildingGeometry,BDAClassesDirectory,...
        XDirectionWoodPanelNodes,ZDirectionWoodPanelNodes,...
        XDirectionWoodPanelsPropertiesLocation,...
        ZDirectionWoodPanelsPropertiesLocation);
    
    % Save wood panel objects
    cd(BuildingModelDataDirectory);
    save('xDirectionWoodPanelObjects.mat','xDirectionWoodPanelObjects','-mat');
    save('zDirectionWoodPanelObjects.mat','zDirectionWoodPanelObjects','-mat');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                    Defining Moment Frame Retrofit                       %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Define string to path where an the moment frame retrofit indicator is
    % stored
    MomentFrameIndicatorLocation = strcat(BuildingDataDirectory,...
        '/FrameRetrofit');
    
    % Call function used to generate a struct containing moment frame retrofit
    % indicator
    cd(BDAFunctionsDirectory)
    momentFrameRetrofitIndicator = defineMomentFrameRetrofitIndicator(...
        MomentFrameIndicatorLocation);
    
    % Save moment frame retrofit indicator
    cd(BuildingModelDataDirectory)
    save('momentFrameRetrofitIndicator.mat',...
        'momentFrameRetrofitIndicator','-mat')
    
    % Define string with path to folder where information related to the
    % x-direction moment frames are stored
    XMomentFramesInformationLocation = strcat(BuildingDataDirectory,...
        '/FrameRetrofit/XMomentFrames');
    
    % Define string with path to folder where information related to the
    % z-direction moment frames are stored
    ZMomentFramesInformationLocation = strcat(BuildingDataDirectory,...
        '/FrameRetrofit/ZMomentFrames');
    
    % Call function used to generate objects related to retrofit moment frames
    cd(BDAFunctionsDirectory)
    [xDirectionMomentFrameObjects zDirectionMomentFrameObjects] = ...
        defineRetrofitMomentFrames(XMomentFramesInformationLocation,...
        ZMomentFramesInformationLocation);
    
    % Save infill objects
    cd(BuildingModelDataDirectory)
    save('xDirectionMomentFrameObjects.mat',...
        'xDirectionMomentFrameObjects','-mat')
    save('zDirectionMomentFrameObjects.mat',...
        'zDirectionMomentFrameObjects','-mat')
end