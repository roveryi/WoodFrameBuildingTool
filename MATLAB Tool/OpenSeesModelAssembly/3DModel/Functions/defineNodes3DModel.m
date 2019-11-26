
function defineNodes3DModel(BuildingModelDirectory,buildingGeometry,...
    XDirectionWoodPanelNodes,ZDirectionWoodPanelNodes,...
    leaningColumnNodes,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                Generating Tcl File with Defined Nodes                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(BuildingModelDirectory);
cd OpenSees3DModels
cd(AnalysisType);
fid = fopen('DefineNodes3DModel.tcl','wt');

% Writing file description into tcl file
fprintf(fid,'%s\n','# This file will be used to define all nodes');
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','');

fprintf(fid,'%s\n','# Define x-direction wood panel nodes');

% Looping over number of stories
for i = 1:buildingGeometry.numberOfStories
    fprintf(fid,'%s\n',strcat('# Story', num2str(i)));
    
    % Loop over the number of X-Direction wood panels
    for j = 1:buildingGeometry.numberOfXDirectionWoodPanels(i,1)
        
        % Bottom node
        fprintf(fid,'%s\t','node');
        fprintf(fid,'%s\t',...
            XDirectionWoodPanelNodes{i,j}(1,1).openSeesTag);
        fprintf(fid,'%10.3f\t',...
            XDirectionWoodPanelNodes{i,j}(1,1).xCoordinate);
        fprintf(fid,'%10.3f\t',...
            XDirectionWoodPanelNodes{i,j}(1,1).yCoordinate);
        fprintf(fid,'%10.3f',...
            XDirectionWoodPanelNodes{i,j}(1,1).zCoordinate);
        fprintf(fid,'%s\n',';');
        
        % Top node
        fprintf(fid,'%s\t','node');
        fprintf(fid,'%s\t',...
            XDirectionWoodPanelNodes{i,j}(2,1).openSeesTag);
        fprintf(fid,'%10.3f\t',...
            XDirectionWoodPanelNodes{i,j}(2,1).xCoordinate);
        fprintf(fid,'%10.3f\t',...
            XDirectionWoodPanelNodes{i,j}(2,1).yCoordinate);
        fprintf(fid,'%10.3f',...
            XDirectionWoodPanelNodes{i,j}(2,1).zCoordinate);
        fprintf(fid,'%s\n',';');
        
    end
    fprintf(fid,'%s\n','');
    
end
fprintf(fid,'%s\n','puts "x-direction wood panel nodes defined"');
fprintf(fid,'%s\n','');

fprintf(fid,'%s\n','# Define z-direction wood panel nodes');

% Looping over number of stories
for i = 1:buildingGeometry.numberOfStories
    fprintf(fid,'%s\n',strcat('# Story', num2str(i)));
    
    % Loop over the number of Z-Direction wood panels
    for j = 1:buildingGeometry.numberOfZDirectionWoodPanels(i,1)
        
        % Bottom node
        fprintf(fid,'%s\t','node');
        fprintf(fid,'%s\t',...
            ZDirectionWoodPanelNodes{i,j}(1,1).openSeesTag);
        fprintf(fid,'%10.3f\t',...
            ZDirectionWoodPanelNodes{i,j}(1,1).xCoordinate);
        fprintf(fid,'%10.3f\t',...
            ZDirectionWoodPanelNodes{i,j}(1,1).yCoordinate);
        fprintf(fid,'%10.3f',...
            ZDirectionWoodPanelNodes{i,j}(1,1).zCoordinate);
        fprintf(fid,'%s\n',';');
        
        % Top node
        fprintf(fid,'%s\t','node');
        fprintf(fid,'%s\t',...
            ZDirectionWoodPanelNodes{i,j}(2,1).openSeesTag);
        fprintf(fid,'%10.3f\t',...
            ZDirectionWoodPanelNodes{i,j}(2,1).xCoordinate);
        fprintf(fid,'%10.3f\t',...
            ZDirectionWoodPanelNodes{i,j}(2,1).yCoordinate);
        fprintf(fid,'%10.3f',...
            ZDirectionWoodPanelNodes{i,j}(2,1).zCoordinate);
        fprintf(fid,'%s\n',';');
        
    end
    fprintf(fid,'%s\n','');
    
end
fprintf(fid,'%s\n','puts "z-direction wood panel nodes defined"');
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','');

fprintf(fid,'%s\n','# Define main leaning column nodes');

% Looping over all leaning columns 
for j = 1:9
    % Looping over number of floor levels
    for i = 1:buildingGeometry.numberOfStories + 1

        fprintf(fid,'%s\t','node');
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,j}(4)));
        fprintf(fid,'%10.3f\t',leaningColumnNodes{i,j}(1));
        fprintf(fid,'%10.3f\t',leaningColumnNodes{i,j}(3));
        fprintf(fid,'%10.3f',leaningColumnNodes{i,j}(2));
        fprintf(fid,'%s\n',';');

    end
    fprintf(fid,'%s\n','');
end
fprintf(fid,'%s\n','puts "main leaning column nodes defined"');
fprintf(fid,'%s\n','');

% Schematic figure for leaning column (eg. 2-story building)
%
%           O         -> Mass center on roof
%                     -> Spring allows rotation about x and z axis
%           O         -> Bottom node of spring
%           |
%           |         -> Column element
%           |
%           O         -> Top node of spring
%                     -> Spring allows rotations about x, y, and z axis
%           O         -> Mass center on 2nd floor
%                     -> Spring allows rotation about x and z axis
%           O         -> Bottom node of spring
%           |
%           |         -> Column element
%           |
%           O         -> Top node of spring
%                     -> Spring allows rotations about x, y, and z axis
%           O         -> Mass center on ground floor(1st floor)

% Defining top nodes of zero length springs
% (bottom node for leaning column)
fprintf(fid,'%s\n',...
    '# Define leaning column top nodes for zero length springs');
for j = 1:9
% Looping over number of floor levels
    for i = 1:buildingGeometry.numberOfStories
        fprintf(fid,'%s\t','node');
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,j}(4) + 1));
        fprintf(fid,'%10.3f\t',leaningColumnNodes{i,j}(1));
        fprintf(fid,'%10.3f\t',leaningColumnNodes{i,j}(3));
        fprintf(fid,'%10.3f',leaningColumnNodes{i,j}(2));
        fprintf(fid,'%s\n',';');
    end
    fprintf(fid,'%s\n','');
end

% Defining bottom nodes of zero length springs
% (top node for leaning column)
    fprintf(fid,'%s\n',...
        '# Define leaning column bottom nodes for zero length springs');
for j = 1:9
    % Looping over number of floor levels
    for i = 2:buildingGeometry.numberOfStories + 1
        fprintf(fid,'%s\t','node');
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,j}(4) + 2));
        fprintf(fid,'%10.3f\t',leaningColumnNodes{i,j}(1));
        fprintf(fid,'%10.3f\t',leaningColumnNodes{i,j}(3));
        fprintf(fid,'%10.3f',leaningColumnNodes{i,j}(2));
        fprintf(fid,'%s\n',';');
    end

    fprintf(fid,'%s\n','');
end
    fprintf(fid,'%s\n','puts "Leaning column nodes for zero length spring defined"');
% Closing and saving tcl file
fclose(fid);

end

