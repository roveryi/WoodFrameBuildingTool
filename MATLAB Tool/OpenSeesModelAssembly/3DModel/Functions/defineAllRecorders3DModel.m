
function defineAllRecorders3DModel(BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Generating Tcl File with All Recorders Defined                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(BuildingModelDirectory);
cd OpenSees3DModels
cd(AnalysisType);
fid = fopen('DefineAllRecorders3DModel.tcl','wt');

% Writing file description into tcl file
fprintf(fid,'%s\n','# This file will be used to define all recorders');
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','');

% Setting up folders
fprintf(fid,'%s\n','# Setting up folders');
fprintf(fid,'%s\n','# set baseDir [pwd];');

if strcmp(AnalysisType,'DynamicAnalysis') == 1

    fprintf(fid,'%s\t','cd');
    fprintf(fid,'%s\n','$pathToResults/');
    fprintf(fid,'%s\n','');

    fprintf(fid,'%s\n','if {$Pairing == 1} {');
    fprintf(fid,'%s\n','    set folderNumber $eqNumber');
    fprintf(fid,'%s\n','} else {');
    fprintf(fid,'%s\n','    set folderNumber [expr $eqNumber + $numberOfGroundMotionXIDs]');
    fprintf(fid,'%s\n','}');


    fprintf(fid,'%s\n','file mkdir EQ_$folderNumber');
    fprintf(fid,'%s\t','cd');
    fprintf(fid,'%s\n',strcat('$pathToResults/EQ_$folderNumber'));
    fprintf(fid,'%s\n','# file mkdir Scale_$scale');
    fprintf(fid,'%s\t','# cd');
    fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/EQ_$folderNumber/',...
        'Scale_$scale'));
    
else 
    fprintf(fid,'%s\n','set baseDir [pwd];');
    fprintf(fid,'%s\t','cd');
    fprintf(fid,'%s\n','$baseDir/$dataDir/');
    fprintf(fid,'%s\n','');
end
fprintf(fid,'%s\n','');

% Create output folders
fprintf(fid,'%s\n','#file mkdir BaseReactions');
fprintf(fid,'%s\n','#file mkdir WoodPanelShearForces');
fprintf(fid,'%s\n','#file mkdir WoodPanelDeformations');
fprintf(fid,'%s\n','#file mkdir NodeDisplacements');
fprintf(fid,'%s\n','file mkdir NodeAccelerations');
fprintf(fid,'%s\n','file mkdir StoryDrifts');
fprintf(fid,'%s\n','#file mkdir NodeDampingForces');
fprintf(fid,'%s\n','');

% Source recorder files
fprintf(fid,'%s\n','#cd $baseDir');
fprintf(fid,'%s\n','#source DefineBaseReactionRecorders3DModel.tcl');
fprintf(fid,'%s\n','#cd $baseDir');
fprintf(fid,'%s\n','#source DefineWoodPanelRecorders3DModel.tcl');
fprintf(fid,'%s\n','#cd $baseDir');
fprintf(fid,'%s\n','#source DefineNodeDisplacementRecorders3DModel.tcl');
fprintf(fid,'%s\n','cd $pathToModel');
fprintf(fid,'%s\n','source DefineStoryDriftRecorders3DModel.tcl');
fprintf(fid,'%s\n','cd $pathToModel');
if strcmp(AnalysisType,'DynamicAnalysis') == 1
    fprintf(fid,'%s\n','source DefineNodeAccelerationRecorders3DModel.tcl');
    fprintf(fid,'%s\n','cd $pathToModel');
    fprintf(fid,'%s\n','#source DefineNodeDampingForceRecorders3DModel.tcl');
    fprintf(fid,'%s\n','#cd $baseDir');
end
fprintf(fid,'%s\n','');

% Closing and saving tcl file
fclose(fid);


end

