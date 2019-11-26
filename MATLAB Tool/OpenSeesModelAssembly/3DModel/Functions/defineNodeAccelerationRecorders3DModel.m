
function defineNodeAccelerationRecorders3DModel(buildingGeometry,...
    XDirectionWoodPanelNodes,ZDirectionWoodPanelNodes,...
    leaningColumnNodes,BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Generating Tcl File with Defined Node Acceleration Recorders       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(BuildingModelDirectory);
cd OpenSees3DModels
cd(AnalysisType);
fid = fopen('DefineNodeAccelerationRecorders3DModel.tcl','wt');

% Writing file description into tcl file
fprintf(fid,'%s\n','# Define node acceleration recorders');
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','');

% Changing directory to output location
fprintf(fid,'%s\t','cd');
if strcmp(AnalysisType,'PushoverAnalysis') == 1
    fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/NodeAccelerations'));
else
    fprintf(fid,'%s\n',strcat('$pathToResults/EQ_$folderNumber/',...
        'NodeAccelerations'));
end
fprintf(fid,'%s\n','');

% Defining recorders for X-Direction Wood Panel Node Accelerations
fprintf(fid,'%s\n',...
    '# Record accelerations for x-direction wood panel nodes');
% Looping over number of stories
for i = 1:buildingGeometry.numberOfStories
    fprintf(fid,'%s\t','# recorder Node -file');
    fprintf(fid,'%s\t',strcat('XWoodPanelNodeAccLevel',num2str(i),'.out'));
    fprintf(fid,'%s\t','-time -timeSeries 4 -node');
    % Loop over the number of X-Direction wood panels
    for j = 1:buildingGeometry.numberOfXDirectionWoodPanels(i,1)
        fprintf(fid,'%s\t',...
            XDirectionWoodPanelNodes{i,j}(2,1).openSeesTag);
    end
    fprintf(fid,'%s\n','-dof 1 2 3 accel');
end
fprintf(fid,'%s\n','');

% Defining recorders for Z-Direction Wood Panel Node Accelerations
fprintf(fid,'%s\n',...
    '# Record accelerations for z-direction wood panel nodes');
% Looping over number of stories
for i = 1:buildingGeometry.numberOfStories
    fprintf(fid,'%s\t','# recorder Node -file');
    fprintf(fid,'%s\t',strcat('ZWoodPanelNodeAccLevel',num2str(i),'.out'));
    fprintf(fid,'%s\t','-time -timeSeries 4 -node');
    % Loop over the number of Z-Direction wood panels
    for j = 1:buildingGeometry.numberOfZDirectionWoodPanels(i,1)
        fprintf(fid,'%s\t',...
            ZDirectionWoodPanelNodes{i,j}(2,1).openSeesTag);
    end
    fprintf(fid,'%s\n','-dof 1 2 3 accel');
end
fprintf(fid,'%s\n','');

% Defining recorders for Leaning Column Node Accelerations
fprintf(fid,'%s\n','# Record accelerations for leaning column nodes');
% Looping over number of stories
for i = 2:buildingGeometry.numberOfStories + 1
    fprintf(fid,'%s\t','#recorder Node -file');
    fprintf(fid,'%s\t',strcat('LeaningColumnNodeAccLevel',num2str(i),'.out'));
    fprintf(fid,'%s\t','-time -node');
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{i}(4)));
    fprintf(fid,'%s\n','-dof 1 2 3 accel');
    
    fprintf(fid,'%s\t','recorder Node -file');
    fprintf(fid,'%s\t',strcat('LeaningColumnNodeXAbsoAccLevel',num2str(i),'.out'));
    fprintf(fid,'%s\t','-timeSeries 11 -time -node');
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{i}(4)));
    fprintf(fid,'%s\n','-dof 1 accel');
    
    fprintf(fid,'%s\t','recorder Node -file');
    fprintf(fid,'%s\t',strcat('LeaningColumnNodeZAbsoAccLevel',num2str(i),'.out'));
    fprintf(fid,'%s\t','-timeSeries 12 -time -node');
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{i}(4)));
    fprintf(fid,'%s\n','-dof 3 accel');
end
fprintf(fid,'%s\n','');

% Closing and saving tcl file
fclose(fid);

end

