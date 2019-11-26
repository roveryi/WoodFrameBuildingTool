
function defineDynamicAnalysisParameters3DModel(buildingGeometry,...
    leaningColumnNodes,BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                Generating Tcl File with Defined Nodes                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(BuildingModelDirectory);
cd OpenSees3DModels
cd(AnalysisType);
fid = fopen('DefineDynamicAnalysisParameters3DModel.tcl','wt');

% Writing file description into tcl file
fprintf(fid,'%s\t','# This file will be used to define');
fprintf(fid,'%s\n',...
    'the parameters needed for the collapse analysis solver');
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','');

% Number of building stories
fprintf(fid,'%s\t','set NStories');
fprintf(fid,'%s\n',strcat(num2str(buildingGeometry.numberOfStories),';'));

% Height of typical story
fprintf(fid,'%s\t','set HTypicalStory');
if buildingGeometry.numberOfStories == 1
    fprintf(fid,'%s\n',strcat(num2str(buildingGeometry.storyHeights(1)),';'));
else fprintf(fid,'%s\n',strcat(num2str(buildingGeometry.storyHeights(2)),';'));
end

% Height of first story
fprintf(fid,'%s\t','set HFirstStory');
fprintf(fid,'%s\n',strcat(num2str(buildingGeometry.storyHeights(1)),';'));

% Defining floor nodes for drift monitoring
fprintf(fid,'%s\t','set FloorNodes [list');
for i = 1:(buildingGeometry.numberOfStories + 1)
    if i == buildingGeometry.numberOfStories + 1
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i}(4)),'];');
    else
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i}(4)));
    end
end
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','');

% Closing and saving tcl file
fclose(fid);
end

