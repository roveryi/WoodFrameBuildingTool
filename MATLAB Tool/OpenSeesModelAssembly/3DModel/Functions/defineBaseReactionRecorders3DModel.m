
function defineBaseReactionRecorders3DModel(buildingGeometry,...
    XDirectionWoodPanelNodes,ZDirectionWoodPanelNodes,...
    leaningColumnNodes,BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Generating Tcl File with Defined Base Reaction Recorders            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(BuildingModelDirectory);
cd OpenSees3DModels
cd(AnalysisType);
fid = fopen('DefineBaseReactionRecorders3DModel.tcl','wt');

% Writing file description into tcl file
fprintf(fid,'%s\n','# Define base node reaction recorders');
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','');

% Define base node reaction recorders
% Changing directory to output location
fprintf(fid,'%s\t','cd');
if strcmp(AnalysisType,'PushoverAnalysis') == 1
    fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/BaseReactions'));
    fprintf(fid,'%s\n','');
else
    fprintf(fid,'%s\n',strcat('$pathToResults/EQ_$folderNumber/BaseReactions'));
    fprintf(fid,'%s\n','');
end

% Define vertical reactions for base nodes of X-Direction Wood Panels
fprintf(fid,'%s\n',...
    '# X-Direction Wood Panels Base Node Vertical Reactions');
fprintf(fid,'%s\t','recorder Node -file');
fprintf(fid,'%s\t','XPanelBaseNodesVerticalReactions.out');
fprintf(fid,'%s\t','-time -node');
% Loop over the number of X-Direction wood panels
for j = 1:buildingGeometry.numberOfXDirectionWoodPanels(1,1)
    fprintf(fid,'%s\t',XDirectionWoodPanelNodes{1,j}(1,1).openSeesTag);
end
fprintf(fid,'%s\n','-dof 2 reaction');

% Define vertical reactions for base nodes of Z-Direction Wood Panels
fprintf(fid,'%s\n',...
    '# Z-Direction Wood Panels Base Node Vertical Reactions');
fprintf(fid,'%s\t','recorder Node -file');
fprintf(fid,'%s\t','ZPanelBaseNodesVerticalReactions.out');
fprintf(fid,'%s\t','-time -node');
% Loop over the number of Z-Direction wood panels
for j = 1:buildingGeometry.numberOfZDirectionWoodPanels(1,1)
    fprintf(fid,'%s\t',ZDirectionWoodPanelNodes{1,j}(1,1).openSeesTag);
end
fprintf(fid,'%s\n','-dof 2 reaction');
fprintf(fid,'%s\n','');

% Define vertical reaction at leaning column base node
fprintf(fid,'%s\n','# Leaning Column Base Node Vertical Reactions');
fprintf(fid,'%s\t','recorder Node -file');
fprintf(fid,'%s\t','LeaningColumnBaseNodeVerticalReactions.out');
fprintf(fid,'%s\t','-time -node');
fprintf(fid,'%s\t',num2str(leaningColumnNodes{1}(4)),num2str(leaningColumnNodes{3}(4)),num2str(leaningColumnNodes{5}(4)),...
    num2str(leaningColumnNodes{7}(4)),num2str(leaningColumnNodes{9}(4)),num2str(leaningColumnNodes{11}(4)),...
    num2str(leaningColumnNodes{13}(4)),num2str(leaningColumnNodes{15}(4)),num2str(leaningColumnNodes{17}(4)));
fprintf(fid,'%s\n','-dof 2 reaction');
fprintf(fid,'%s\n','');

% Define X-horizontal reactions for X-Direction Wood Panels
fprintf(fid,'%s\n',...
    '# X-Direction Wood Panels Base Node Horizontal Reactions');
fprintf(fid,'%s\t','recorder Node -file');
fprintf(fid,'%s\t','XPanelBaseNodesHorizontalReactions.out');
fprintf(fid,'%s\t','-time -node');
% Loop over the number of X-Direction wood panels
for j = 1:buildingGeometry.numberOfXDirectionWoodPanels(1,1)
    fprintf(fid,'%s\t',XDirectionWoodPanelNodes{1,j}(1,1).openSeesTag);
end
fprintf(fid,'%s\n','-dof 1 reaction');

% Define Z-horizontal reactions for base nodes of Z-Direction Wood Panels
fprintf(fid,'%s\n',...
    '# Z-Direction Wood Panels Base Node Horizontal Reactions');
fprintf(fid,'%s\t','recorder Node -file');
fprintf(fid,'%s\t','ZPanelBaseNodesHorizontalReactions.out');
fprintf(fid,'%s\t','-time -node');
% Loop over the number of Z-Direction wood panels
for j = 1:buildingGeometry.numberOfZDirectionWoodPanels(1,1)
    fprintf(fid,'%s\t',ZDirectionWoodPanelNodes{1,j}(1,1).openSeesTag);
end
fprintf(fid,'%s\n','-dof 3 reaction');
fprintf(fid,'%s\n','');

% Define horizontal X-Direction reaction at leaning column base node
fprintf(fid,'%s\n',...
    '# Leaning Column Base Node X-Direction Horizontal Reactions');
fprintf(fid,'%s\t','recorder Node -file');
fprintf(fid,'%s\t','LeaningColumnBaseNodeXHorizontalReactions.out');
fprintf(fid,'%s\t','-time -node');
fprintf(fid,'%s\t',num2str(leaningColumnNodes{1}(4)),num2str(leaningColumnNodes{3}(4)),num2str(leaningColumnNodes{5}(4)),...
    num2str(leaningColumnNodes{7}(4)),num2str(leaningColumnNodes{9}(4)),num2str(leaningColumnNodes{11}(4)),...
    num2str(leaningColumnNodes{13}(4)),num2str(leaningColumnNodes{15}(4)),num2str(leaningColumnNodes{17}(4)));
fprintf(fid,'%s\n','-dof 1 reaction');

% Define horizontal Z-Direction reaction at leaning column base node
fprintf(fid,'%s\n',...
    '# Leaning Column Base Node Z-Direction Horizontal Reactions');
fprintf(fid,'%s\t','recorder Node -file');
fprintf(fid,'%s\t','LeaningColumnBaseNodeZHorizontalReactions.out');
fprintf(fid,'%s\t','-time -node');
fprintf(fid,'%s\t',num2str(leaningColumnNodes{1}(4)),num2str(leaningColumnNodes{3}(4)),num2str(leaningColumnNodes{5}(4)),...
    num2str(leaningColumnNodes{7}(4)),num2str(leaningColumnNodes{9}(4)),num2str(leaningColumnNodes{11}(4)),...
    num2str(leaningColumnNodes{13}(4)),num2str(leaningColumnNodes{15}(4)),num2str(leaningColumnNodes{17}(4)));
fprintf(fid,'%s\n','-dof 3 reaction');
fprintf(fid,'%s\n','');

% Closing and saving tcl file
fclose(fid);

end

