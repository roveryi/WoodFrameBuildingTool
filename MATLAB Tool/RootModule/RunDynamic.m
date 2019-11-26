
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                User Defined Model Folder and Directory Paths            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define path to where SPA-WOOD base directory
BaseDirectory = strcat('C:/Users/Zhengxiang Yi/Desktop/1%Initial');
cd (BaseDirectory);
cd 'RootModule';
BuildingNameFile = importdata('BuildingName.txt');
cd ..

for ii =1: length(BuildingNameFile)
    % for ii = 1:length(BuildingNameFile)
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
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %              Define Root Tcl File for Running Single Scale Dynamic      %
    %                   Analysis with Bi-Directional Loading                  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1:2*NumEQ
        
        % Define directory where OpenSees model tcl files are stored
        AnalysisModelDirectory = strcat(BuildingModelDirectory,...
            '\OpenSees3DModels\DynamicAnalysis');
        
        % Go to directory where tcl files are located
        cd(AnalysisModelDirectory)
        
        % Tcl file to be updated
        original_OpenSees_file = ('RunSingleScale3DModelFinal.tcl');
        
        %Tcl file with updated parameters
        updated_OpenSees_file = ('RunSingleScale3DModelFinal2.tcl');
        
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
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                       Run Dynamic Value Analysis                        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Define directory where OpenSees model tcl files are stored
        AnalysisModelDirectory = strcat(BuildingModelDirectory,...
            '\OpenSees3DModels\DynamicAnalysis');
        
        cd(AnalysisModelDirectory);
        
        % RunSingleScale3DModelFinal.tcl
        % ! ÓÃÀ´run OpenSees file Model.tcl
        !OpenSees RunSingleScale3DModelFinal2.tcl
    end
end

