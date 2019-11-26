% This MATLAB script is used for generating MaxStoryX.out, MaxStoryZ.out,
% ResStoryX.out, ResStoryZ.out for IDA story drift fragility curve
% Author: Zhengxiang Yi
% Email: roveryi@g.ucla.edu
% Date: 05/09/2018

clc; clear all; close all;
tic;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                User Defined Model Folder and Directory Paths            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
% Define path to where SPA-WOOD base directory
BaseDirectory = strcat('/Users/rover/Desktop/Cost_Benefit/20190701UpdateDesignForSeismicParameters/Updated Building Performance');
FunctionDirectory = strcat('/Users/rover/Desktop/WoodFrameBuilding/PostProcessing/Generate SP3 Input');

NumEQ = 44;
NumDir = 2; 
NumScale = 15; 
for ii = 1:96
    % for ii = 1:length(BuildingNameFile)
    % String used to identify the name of the folder in which the relevant data
    % for the current building being modeled is stored. The generated OpenSees
    % models will also be stored in this folder.


    % Define path to directory where the generated OpenSees models will be
    % placed
    BuildingModelDirectory = strcat(BaseDirectory,'\BuildingModels\',BuildingID);

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


    % Go to directory where analysis output is stored
    AnalysisOutputDataLocation = strcat(BuildingModelDirectory,...
        '\OpenSees3DModels\DynamicAnalysis\ModelIDAOutputBiDirection');
    cd(AnalysisOutputDataLocation);

    SDR_Matrix_Ori = zeros(NumEQ*NumDir*NumScale,3+buildingGeometry.numberOfStories);
    RDR_Matrix_Ori = zeros(NumEQ*NumDir*NumScale,1);
    PFA_Matrix_Ori = zeros(NumEQ*NumDir*NumScale,3+1+buildingGeometry.numberOfStories);

    EQ = [1:NumEQ]';
    Dir = repelem([1:NumDir]',NumEQ);
    Scale = [1:NumScale]';

    SDR_Matrix_Ori(:,1) = repelem(Scale,NumDir*NumEQ);
    RDR_Matrix_Ori(:,1) = repelem(Scale,NumDir*NumEQ);
    PFA_Matrix_Ori(:,1) = repelem(Scale,NumDir*NumEQ);

    SDR_Matrix_Ori(:,2) = repmat(Dir,NumScale,1);
    RDR_Matrix_Ori(:,2) = repmat(Dir,NumScale,1);
    PFA_Matrix_Ori(:,2) = repmat(Dir,NumScale,1);

    SDR_Matrix_Ori(:,3) = repmat(EQ,NumDir*NumScale,1);
    RDR_Matrix_Ori(:,3) = repmat(EQ,NumDir*NumScale,1);
    PFA_Matrix_Ori(:,3) = repmat(EQ,NumDir*NumScale,1);

% Load raw data and write into matrix       
    for i = 1:NumEQ
        GMFileName = sprintf('EQ_%d.txt',i);

        cd(strcat(AnalysisOutputDataLocation,'\SP3Info\SDR'))
        SDR_info = load(GMFileName);

        cd(strcat(AnalysisOutputDataLocation,'\SP3Info\RDR'))
        RDR_info = load(GMFileName);

        cd(strcat(AnalysisOutputDataLocation,'\SP3Info\PFA'))
        PFA_info = load(GMFileName);

        for j = 1:NumScale 

            SDR_Matrix_Ori((j-1)*(NumDir*NumEQ)+i,4:end) = SDR_info(j,:);
            SDR_Matrix_Ori((j-1)*(NumDir*NumEQ)+i+NumEQ,4:end ) = SDR_info(j+NumScale,:);

            PFA_Matrix_Ori((j-1)*(NumDir*NumEQ)+i,5:end ) = PFA_info(j,:);
            PFA_Matrix_Ori((j-1)*(NumDir*NumEQ)+i+NumEQ,5:end ) = PFA_info(j+NumScale,:);

            RDR_Matrix_Ori((j-1)*(NumDir*NumEQ)+i,4 ) = RDR_info(j);
            RDR_Matrix_Ori((j-1)*(NumDir*NumEQ)+i+NumEQ,4 ) = RDR_info(j+NumScale);
        end
    end

% Ground floor PFA
GMInfoDirectory = strcat(BaseDirectory,'\BuildingData\',...
        BuildingID,'\BaselineTclFiles\OpenSees3DModels\DynamicAnalysis\GroundMotionInfo');
cd (GMInfoDirectory)
GMName = load('GMFileNames.txt');

GMHistoryDirectory = strcat(BaseDirectory,'\BuildingData\',...
        BuildingID,'\BaselineTclFiles\OpenSees3DModels\DynamicAnalysis\histories');
cd (GMHistoryDirectory)
PGA = zeros(length(GMName),1);

for i = 1:length(GMName) 
    temp(i,1) = max(abs(load(strcat(num2str(GMName(i)),'.txt'))));        
end 
for i = 1:NumEQ/NumDir
    PGA(i,1) = temp(2*i-1,1)*SF(i,1);
    PGA(i+NumEQ/NumDir) = temp(2*i,1)*SF(i,1);
end

PGA = [PGA(1:NumEQ/NumDir);PGA(NumEQ/NumDir+1:end);PGA(NumEQ/NumDir+1:end);PGA(1:NumEQ/NumDir)];


for j = 1:NumScale           
    PFA_Matrix_Ori((j-1)*(NumDir*NumEQ)+1:j*(NumDir*NumEQ),4 ) = PGA*Scale(j,1)/10;       
end

% Generate data for missing data, based on lognormal distribution 
    for i = 1:NumDir:NumDir*NumScale
        SDR_Matrix_Ori( (i-1)*NumEQ+1:i*NumEQ,:) = generatemissingdata(SDR_Matrix_Ori( (i-1)*NumEQ+1:i*NumEQ,:), NumEQ, 'SDR');
        SDR_Matrix_Ori( i*NumEQ+1:(i+1)*NumEQ,:) = generatemissingdata(SDR_Matrix_Ori( i*NumEQ+1:(i+1)*NumEQ,:), NumEQ, 'SDR');

        RDR_Matrix_Ori( (i-1)*NumEQ+1:i*NumEQ,:) = generatemissingdata(RDR_Matrix_Ori( (i-1)*NumEQ+1:i*NumEQ,:), NumEQ, 'RDR');
        RDR_Matrix_Ori( i*NumEQ+1:(i+1)*NumEQ,:) = generatemissingdata(RDR_Matrix_Ori( i*NumEQ+1:(i+1)*NumEQ,:), NumEQ, 'RDR');

        PFA_Matrix_Ori( (i-1)*NumEQ+1:i*NumEQ,:) = generatemissingdata(PFA_Matrix_Ori( (i-1)*NumEQ+1:i*NumEQ,:), NumEQ, 'PFA');
        PFA_Matrix_Ori( i*NumEQ+1:(i+1)*NumEQ,:) = generatemissingdata(PFA_Matrix_Ori( i*NumEQ+1:(i+1)*NumEQ,:), NumEQ, 'PFA');

    end




% Write the results into csv files
cd ('C:\Users\Zhengxiang Yi\Desktop\SP3Input');
mkdir(BuildingID)
cd(BuildingID)
csvwrite ('SDR.csv',SDR_Matrix_Ori);
csvwrite ('RDR.csv',RDR_Matrix_Ori);
csvwrite ('PFA.csv',PFA_Matrix_Ori);
end
