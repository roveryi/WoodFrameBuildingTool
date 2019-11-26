function [ output_args ] = DynamicParameters( HazardLevelFile,BuildingDataDirectory )
% This function is used for generate dynamic analysis parameters and ground
% motion information. 
% Author : Zhengxiang Yi
% Date: 04/30/2018
%% Copy analysis parameters files into baseline directory 
    temp = strsplit(HazardLevelFile);
    FolderName = strcat(temp{1},{' '},temp{2},{' '},temp{3});
    TargetDirectory = strcat('D:\Google Drive\Research\PEER CEA Project\Ground Motion\GM Files\ModelGMFiles\',FolderName,'\',HazardLevelFile);
    TargetParametersFullName = strcat(TargetDirectory,'\AnalysisParameters');
    TargetSF = strcat(TargetParametersFullName,'\BiDirectionMCEScaleFactors.txt');
    TargetNumEQ = strcat(TargetParametersFullName,'\NumberOfGroundMotions.txt');
    
    ParametersBaseline = strcat(BuildingDataDirectory,'\AnalysisParameters\DynamicAnalysis');
    SF = strcat(ParametersBaseline,'\BiDirectionMCEScaleFactors.txt');
    NumEQ = strcat(ParametersBaseline,'\NumberOfGroundMotions.txt');
    
    copyfile(TargetSF{1},SF);
    copyfile(TargetNumEQ{1},NumEQ);
%% Copy ground motion histories and GM info into Baseline directory 

    TargetHistoryFullName = strcat(TargetDirectory,'\Histories');
    TargetGMInfoFullName = strcat(TargetDirectory,'\GroundMotionInfo');
    DefineGMRecordFullName = strcat(TargetDirectory,'\GroundMotionInfo\Define_GM_Record_Info.tcl');

    BaselineDirectory = strcat(BuildingDataDirectory,'\BaselineTclFiles\OpenSees3DModels\DynamicAnalysis');
    HistoryBaseline = strcat(BaselineDirectory,'\histories');
    GMInfoBaseline = strcat(BaselineDirectory,'\GroundMotionInfo');
    DefineGMRecordBaseline = strcat(BaselineDirectory,'\Define_GM_Record_Info.tcl');
    
    copyfile(TargetHistoryFullName{1},HistoryBaseline);
    copyfile(TargetGMInfoFullName{1},GMInfoBaseline);
    copyfile(DefineGMRecordFullName{1},DefineGMRecordBaseline);

    %% Copy dyanamic analysis parameter txt file
    TargetFactorsFileName = strcat(TargetDirectory,'\AnalysisParameters\BiDirectionMCEScaleFactors.txt');
    TargetNumEQFileName = strcat(TargetDirectory,'\AnalysisParameters\NumberOfGroundMotions.txt');
    
    AnalysisFactorsFileName = strcat(BuildingDataDirectory,'\AnalysisParameters\DynamicAnalysis\BiDirectionMCEScaleFactors.txt');
    AnalysisNumEQFileName = strcat(BuildingDataDirectory,'\AnalysisParameters\DynamicAnalysis\NumberOfGroundMotions.txt');
    
    copyfile (TargetFactorsFileName{1},AnalysisFactorsFileName);
    copyfile (TargetNumEQFileName{1},AnalysisNumEQFileName);
    
end

