%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This script is used for generating ground motion folders for large number%
%of ground motion records for different hazard levels and parallel        %
%computing                                                                %
%Author: Zhengxiang Yi                                                    %
%Date: 06/18/2018                                                         %
%Email: roveryi@g.ucla.edu                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

GMDirectory = strcat('D:\Google Drive\Research\PEER CEA Project\Ground Motion\GM Files\ModelGMFiles');
TotalAnalysisNum = 20; % 10MSA + 10IDA 
% Specify site condition for analysis
SiteInfo = strcat('180329_GroundMotions_PEER-CEA 03 SanFrancisco');
ReturnPeriod = [15,25,50,75,100,150,250,500,1000,2500];

TargetDirectory = strcat('C:\Users\Zhengxiang Yi\Desktop\Sensitivity Study Model\Sensitivity Study OpenSees\BuildingModels');
cd(TargetDirectory)
mkdir GM_Info
TargetDirectory = strcat(TargetDirectory,'\GM_Info');

for i = 1:length(ReturnPeriod)
    EQDirectory = strcat(GMDirectory,'\',SiteInfo,'\',SiteInfo,' Vs30=270 RP=',num2str(ReturnPeriod(i)),'yr');
    GMNameFile = strcat(EQDirectory,'\GroundMotionInfo\GMFileNames.txt');
    GMNumPointsFile = strcat(EQDirectory,'\GroundMotionInfo\GMNumPoints.txt');
    GMTimeStepFile = strcat(EQDirectory,'\GroundMotionInfo\GMTimeSteps.txt');
    DefineGMRecordFile = strcat(EQDirectory,'\GroundMotionInfo\Define_GM_Record_Info.tcl');
    MCESFFile = strcat(EQDirectory,'\AnalysisParameters\BiDirectionMCEScaleFactors.txt');
    HistoryFolder = strcat(EQDirectory,'\Histories');
    
    cd(TargetDirectory)
    mkdir(num2str(i))
    cd(num2str(i))
    mkdir GroundMotionInfo
    mkdir histories
    InfoTargetFolder = strcat(TargetDirectory,'\',num2str(i),'\GroundMotionInfo');
    historyTargetFolder = strcat(TargetDirectory,'\',num2str(i),'\histories');
    
    copyfile(GMNameFile,InfoTargetFolder)
    copyfile(GMNumPointsFile,InfoTargetFolder)
    copyfile(GMTimeStepFile,InfoTargetFolder)
    copyfile(DefineGMRecordFile,InfoTargetFolder)
    copyfile(MCESFFile,InfoTargetFolder)
    copyfile(HistoryFolder,historyTargetFolder)
end
 MCEScale = importdata(MCESFFile);
for i = 11:20
    cd(TargetDirectory)
    mkdir(num2str(i))
    cd(num2str(i))
    mkdir GroundMotionInfo
    mkdir histories
    
%    
    NewMCE = MCEScale*i/10;
    InfoTargetFolder = strcat(TargetDirectory,'\',num2str(i),'\GroundMotionInfo');
    historyTargetFolder = strcat(TargetDirectory,'\',num2str(i),'\histories');
    
    cd(InfoTargetFolder)
    dlmwrite('BiDirectionMCEScaleFactors.txt',NewMCE);
    copyfile(GMNameFile,InfoTargetFolder)
    copyfile(GMNumPointsFile,InfoTargetFolder)
    copyfile(GMTimeStepFile,InfoTargetFolder)
    copyfile(DefineGMRecordFile,InfoTargetFolder)
    copyfile(HistoryFolder,historyTargetFolder)
    
end