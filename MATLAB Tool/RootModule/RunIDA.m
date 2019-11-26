
clc;clear all;close all;
tic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                User Defined Model Folder and Directory Paths            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define path to where SPA-WOOD base directory
BaseDirectory = strcat('C:/Users/Zhengxiang Yi/Desktop/5%Tangent');
cd (BaseDirectory);
cd 'RootModule';
BuildingNameFile = importdata('BuildingName.txt');
cd ..

for ii = length(BuildingNameFile)
    % for ii = 4:length(BuildingNameFile)
    % String used to identify the name of the folder in which the relevant data
    % for the current building being modeled is stored. The generated OpenSees
    % models will also be stored in this folder.
    BuildingID = char(BuildingNameFile(ii,1));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                    Model Folder and Directory Paths                     %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Define path to directory where all data related to a current building
    % is located
    BuildingDataDirectory = strcat(BaseDirectory,'\BuildingData\',BuildingID);
    
    % Define location where the assembled data structures with building
    % modeling information will be stored
    BuildingModelDataDirectory = strcat(BaseDirectory,'\BuildingData\',...
        BuildingID,'\BuildingModelData');
    
    % Define path to directory where the generated OpenSees models will be
    % placed
    BuildingModelDirectory = strcat(BaseDirectory,'\BuildingModels\',BuildingID);
    
    % Define location where ground motion information for current building
    % model is stored
    GroundMotionDataDirectory = strcat(BuildingModelDirectory,...
        '\OpenSees3DModels\DynamicAnalysis\GroundMotionInfo');
    cd(GroundMotionDataDirectory)
    NumEQ = length(load('BiDirectionMCEScaleFactors.txt'));
    
    % Define directory where OpenSees model tcl files are stored
    AnalysisModelDirectory = strcat(BuildingModelDirectory,...
        '\OpenSees3DModels\DynamicAnalysis');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %              Generate Analysis Plots (GAP) Functions Directory          %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Define path to functions used to generate pushover and collapse fragility
    % curves
    GAPFunctionsDirectory = strcat(BaseDirectory,'\Post-Processing');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                Load Relevant Building Model Data Structures             %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Go to location where building model information data structures are
    % stored
    cd(BuildingModelDataDirectory)
    
    % Misc building information
    load buildingGeometry
    % Analysis options and parameters
    load dynamicAnalysisParameters
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %              Define Root Tcl File for Running Single Scale Dynamic      %
    %                   Analysis with Bi-Directional Loading                  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1:5%51:2*NumEQ
        
        % Go to directory where tcl files are located
        cd(AnalysisModelDirectory)
        
        % Tcl file to be updated
        original_OpenSees_file = ('RunIDAToCollapse3DModelFinal.tcl');
        
        %Tcl file with updated parameters
        updated_OpenSees_file = ('RunIDAToCollapse3DModelFinal2.tcl');
        
        % Open tcl file to be updated
        fileID = fopen(original_OpenSees_file);
        
        % Read original file data into vector
        fileData = fread(fileID);
        
        if i <= NumEQ
            PairingID = 1;
            % Update ground motion parameters
            fileData = strrep(fileData,'*ID*',num2str(i));
            fileData = strrep(fileData,'*PairingID*',num2str(PairingID));
        elseif i <= 2*NumEQ
            PairingID = 2;
            % Update ground motion parameters
            fileData = strrep(fileData,'*ID*',num2str(i-NumEQ));
            fileData = strrep(fileData,'*PairingID*',num2str(PairingID));
        end
        
        % Open tcl file to write updated parameters
        updatedDataFile = fopen(updated_OpenSees_file,'w');
        
        % Write file with updated parameters
        fprintf(updatedDataFile,'%c',fileData);
        
        % Close all files
        fclose('all');
        
        Scale = 0.0000;
        reduceindicator = 0;
        
        ScaleList = [];
        MaxXStoryList = [];
        MaxZStoryList = [];
        
        k = 0;
        ScaleList(1,1) = 0;
        MaxXStoryList(1,1) = 0;
        MaxZStoryList(1,1) = 0;
        
        MaxXStoryDrift = 0;
        MaxZStoryDrift = 0;
        MaxStoryDrift = max(MaxXStoryDrift,MaxZStoryDrift);
        
        while MaxStoryDrift <= dynamicAnalysisParameters.CollapseDriftLimit
            
            % Go to directory where tcl files are located
            cd(AnalysisModelDirectory)
            
            % Tcl file to be updated
            original_OpenSees_file = ('RunIDAToCollapse3DModelFinal2.tcl');
            
            %Tcl file with updated parameters
            updated_OpenSees_file = ('RunIDAToCollapse3DModelFinal3.tcl');
            
            % Open tcl file to be updated
            fileID = fopen(original_OpenSees_file);
            
            % Read original file data into vector
            fileData = fread(fileID);
            
            % Update ground motion parameters
            fileData = strrep(fileData,'*ScaleID*',num2str(Scale,'%.4f'));
            
            % Open tcl file to write updated parameters
            updatedDataFile = fopen(updated_OpenSees_file,'w');
            
            % Write file with updated parameters
            fprintf(updatedDataFile,'%c',fileData);
            
            % Close all files
            fclose('all');
            
            cd(AnalysisModelDirectory);
            
            !OpenSees RunIDAToCollapse3DModelFinal3.tcl
            
            cd(GAPFunctionsDirectory)
            [MaxXStoryDrift, MaxZStoryDrift] = extract3DStoryDriftsMax...
                (BuildingModelDirectory, buildingGeometry, i, Scale);
            MaxStoryDrift = max(max(MaxXStoryDrift(:,1),MaxZStoryDrift(:,1)));
            
            if MaxStoryDrift <= dynamicAnalysisParameters.CollapseDriftLimit
                ScaleList(k+1,1) = Scale;
                MaxXStoryList(k+1,1) = max(MaxXStoryDrift);
                MaxZStoryList(k+1,1) = max(MaxZStoryDrift);
                Scale = Scale + ...
                    dynamicAnalysisParameters.InitialGroundMotionIncrementScaleForCollapse;
                k = k + 1;
            elseif (MaxStoryDrift > dynamicAnalysisParameters.CollapseDriftLimit)
                ScaleList(k+1,1) = Scale;
                MaxXStoryList(k+1,1) = max(MaxXStoryDrift);
                MaxZStoryList(k+1,1) = max(MaxZStoryDrift);
            end
            
        end
        
        AnalysisOutputDataLocation = strcat(BuildingModelDirectory,...
            '\OpenSees3DModels\DynamicAnalysis\ModelBiDirectionalIDAToCollapseOutput');
        cd(AnalysisOutputDataLocation)
        mkdir IDACollapsedStories
        mkdir IDACollapseDirections
        
        IDAGMScalesLocation = strcat(AnalysisOutputDataLocation,'\IDAGMScales');
        IDAMaxXDriftsLocation = strcat(AnalysisOutputDataLocation,'\IDAMaxXDrifts');
        IDAMaxZDriftsLocation = strcat(AnalysisOutputDataLocation,'\IDAMaxZDrifts');
        
        IDACollapsedStoriesLocation = ...
            strcat(AnalysisOutputDataLocation,'\IDACollapsedStories');
        IDACollapseDirectionsLocation = ...
            strcat(AnalysisOutputDataLocation,'\IDACollapseDirections');
        
        GMFolder = sprintf('EQ_%d',i);
        
        cd(IDAGMScalesLocation)
        IDAGMScalesFile = strcat(GMFolder,'.txt');
        save (strcat(IDAGMScalesFile), 'ScaleList', '-ascii');
        
        cd(IDAMaxXDriftsLocation)
        IDAMaxXDriftsFile = strcat(GMFolder,'.txt');
        save (strcat(IDAMaxXDriftsFile), 'MaxXStoryList', '-ascii');
        
        cd(IDAMaxZDriftsLocation)
        IDAMaxZDriftsFile = strcat(GMFolder,'.txt');
        save (strcat(IDAMaxZDriftsFile), 'MaxZStoryList', '-ascii');
        
        if (MaxXStoryList(end,1) > dynamicAnalysisParameters.CollapseDriftLimit) ...
                && (MaxZStoryList(end,1) > dynamicAnalysisParameters.CollapseDriftLimit)
            collapseDirection = 4;
        elseif MaxXStoryList(end,1) > dynamicAnalysisParameters.CollapseDriftLimit
            collapseDirection = 1;
        elseif MaxZStoryList(end,1) > dynamicAnalysisParameters.CollapseDriftLimit
            collapseDirection = 3;
        end
        
        cd(IDACollapseDirectionsLocation)
        IDACollapseDirectionsFile = strcat(GMFolder,'.txt');
        save (strcat(IDACollapseDirectionsFile), 'collapseDirection', '-ascii');
        
        if (MaxXStoryList(end,1) > dynamicAnalysisParameters.CollapseDriftLimit) ...
                [~,CollapsedStories] = max(MaxXStoryDrift);
        elseif MaxZStoryList(end,1) > dynamicAnalysisParameters.CollapseDriftLimit
            [~,CollapsedStories] = max(MaxZStoryDrift);
        end
        
        cd(IDACollapsedStoriesLocation)
        IDACollapsedStoriesFile = strcat(GMFolder,'.txt');
        save (strcat(IDACollapsedStoriesFile), 'CollapsedStories', '-ascii');
        
        
        
    end
end

toc


