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
for p = 1:4
    
    % Define path to where SPA-WOOD base directory
%     BaseDirectory = strcat('D:\Google Drive\Research\SWOF Project\SWOF Project Models\WoodIEBC',num2str(p));
    BaseDirectory = strcat('F:\SWOF Project Models\WoodIEBC',num2str(p));
    cd (BaseDirectory)
    cd 'RootModule';
    BuildingNameFile = importdata('BuildingName.txt');
    cd ..
    NumEQ = 44;
    NumDir = 2; 
    NumScale = 15; 
    for ii = 1:length(BuildingNameFile)
        % for ii = 1:length(BuildingNameFile)
        % String used to identify the name of the folder in which the relevant data
        % for the current building being modeled is stored. The generated OpenSees
        % models will also be stored in this folder.

        BuildingID = char(BuildingNameFile(ii,1));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                    Model Folder and Directory Paths                     %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        % Define location where the assembled data structures with building
        % modeling information will be stored
        BuildingModelDataDirectory = strcat(BaseDirectory,'\BuildingData\',...
            BuildingID,'\BuildingModelData');

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
        mkdir SP3Info
        cd SP3Info
        mkdir SDR
        mkdir RDR
        mkdir PFA
        
        for i = 1:NumEQ
            
            GMFolderName = sprintf('EQ_%d',i);
            xAcc = zeros(NumScale,buildingGeometry.numberOfStories);
            zAcc = zeros(NumScale,buildingGeometry.numberOfStories);
            xSDR = zeros(NumScale,buildingGeometry.numberOfStories);
            zSDR = zeros(NumScale,buildingGeometry.numberOfStories);
            xRDR = zeros(NumScale,1);
            zRDR = zeros(NumScale,1);
            
            for j = 1:NumScale  
                
                ScaleFolderName = sprintf('Scale_%d',j*10);                
                SDFolder = strcat(AnalysisOutputDataLocation,'\',GMFolderName,'\',ScaleFolderName,'\StoryDrifts');
                SAFolder = strcat(AnalysisOutputDataLocation,'\',GMFolderName,'\',ScaleFolderName,'\NodeAccelerations');
                
                cd(SDFolder)     
                
                for k = 1:buildingGeometry.numberOfStories
                    
                    XCOMSDR = load(sprintf('COMStoryX%d.out',k));
                    XNorSDR = load(sprintf('NorthStoryX%d.out',k));
                    XSouSDR = load(sprintf('SouthStoryX%d.out',k));
                    XSDR = max(max([abs(XCOMSDR(:,2)),abs(XNorSDR(:,2)),abs(XSouSDR(:,2))]));

                    ZCOMSDR = load(sprintf('COMStoryZ%d.out',k));
                    ZEastSDR = load(sprintf('EastStoryZ%d.out',k));
                    ZWestSDR = load(sprintf('WestStoryZ%d.out',k));
                    ZSDR = max(max([abs(ZCOMSDR(:,2)),abs(ZEastSDR(:,2)),abs(ZWestSDR(:,2))]));

                    xSDR(j,k) = XSDR;
                    zSDR(j,k) = ZSDR;                
                end
                
                if max(max(xSDR(j,:)),max(zSDR(j,:))) > 0.1
                    xSDR(j,:) = zeros(1,buildingGeometry.numberOfStories);
                    zSDR(j,:) = zeros(1,buildingGeometry.numberOfStories);
                    break 
                    
                else    
                            COMRDRFile = load('COMRoofX.out');
                            NorthRDRFile = load('NorthRoofX.out');
                            SouthRDRFIle = load('SouthRoofX.out');
                            
                            xRDR(j,1) = max(max([abs(COMRDRFile(:,2)),abs(NorthRDRFile(:,2)),abs(SouthRDRFIle(:,2))]));
                            
                            COMRDRFile = load('COMRoofZ.out');
                            EastRDRFile = load('EastRoofZ.out');
                            WestRDRFIle = load('WestRoofZ.out');
                            
                            zRDR(j,1) = max(max([abs(COMRDRFile(:,2)),abs(EastRDRFile(:,2)),abs(WestRDRFIle(:,2))]));
                            
                        for k = 1:buildingGeometry.numberOfStories

                            cd(SAFolder)
                            XAccFile = load(sprintf('LeaningColumnNodeXAbsoAccLevel%d.out',k+1));
                            ZAccFile = load(sprintf('LeaningColumnNodeZAbsoAccLevel%d.out',k+1));

                            xAcc(j,k) = max(abs(XAccFile(:,2)))/32.174/12;
                            zAcc(j,k) = max(abs(ZAccFile(:,2)))/32.174/12;
                        end
                end
                
                
                
                
                
            end
            GMName = sprintf('EQ_%d.txt',i);
            cd(strcat(AnalysisOutputDataLocation,'\SP3Info\SDR'))
            dlmwrite(GMName,[xSDR;zSDR],'delimiter','\t');
            
            cd(strcat(AnalysisOutputDataLocation,'\SP3Info\RDR'))
            dlmwrite(GMName,[xRDR;zRDR],'delimiter','\t');
            
            cd(strcat(AnalysisOutputDataLocation,'\SP3Info\PFA'))
            dlmwrite(GMName,[xAcc;zAcc],'delimiter','\t');
        end
    end
end