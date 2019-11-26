
function defineFixities3DModel(buildingGeometry,...
    XDirectionWoodPanelNodes,ZDirectionWoodPanelNodes,...
    leaningColumnNodes,BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Generating Tcl File with Fixity at all Column Bases Defined       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(BuildingModelDirectory);
cd OpenSees3DModels
cd(AnalysisType);
fid = fopen('DefineFixities3DModel.tcl','wt');

% Writing file description into tcl file
fprintf(fid,'%s\n','# This file will be used to define all fixities');
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','');

% Defining fixity at x-direction wood panel nodes
fprintf(fid,'%s\n','# Defining fixity at x-direction wood panel nodes');

% Looping over number of stories
for i = 1:buildingGeometry.numberOfStories
    fprintf(fid,'%s\n',strcat('# Story', num2str(i)));
    
    % Loop over the number of X-Direction wood panels
    for j = 1:buildingGeometry.numberOfXDirectionWoodPanels(i,1)
        
        % Bottom node
        fprintf(fid,'%s\t','fix');
        fprintf(fid,'%s\t',...
            XDirectionWoodPanelNodes{i,j}(1,1).openSeesTag);
        % base node(fixed)
        if XDirectionWoodPanelNodes{i,j}(1,1).yCoordinate == 0
            fprintf(fid,'%u\t',1);
            fprintf(fid,'%u\t',1);
            fprintf(fid,'%u\t',1);
            fprintf(fid,'%u\t',1);
            fprintf(fid,'%u\t',1);
            fprintf(fid,'%u',1);
            fprintf(fid,'%s\n',';');
        else % non-base node(plane stress)
            fprintf(fid,'%u\t',0);
            fprintf(fid,'%u\t',1);
            fprintf(fid,'%u\t',0);
            fprintf(fid,'%u\t',1);
            fprintf(fid,'%u\t',0);
            fprintf(fid,'%u',1);
            fprintf(fid,'%s\n',';');
        end
        
        % Top node
        fprintf(fid,'%s\t','fix');
        fprintf(fid,'%s\t',...
            XDirectionWoodPanelNodes{i,j}(2,1).openSeesTag);
        fprintf(fid,'%u\t',0);
        fprintf(fid,'%u\t',1);
        fprintf(fid,'%u\t',0);
        fprintf(fid,'%u\t',1);
        fprintf(fid,'%u\t',0);
        fprintf(fid,'%u',1);
        fprintf(fid,'%s\n',';');
        
    end
    fprintf(fid,'%s\n','');
    
end

fprintf(fid,'%s\n',...
    'puts "fixities at x-direction wood panel nodes defined"');
fprintf(fid,'%s\n','');
% Defining fixity at z-direction wood panel nodes
fprintf(fid,'%s\n','# Defining fixity at z-direction wood panel nodes');

% Looping over number of stories
for i = 1:buildingGeometry.numberOfStories
    fprintf(fid,'%s\n',strcat('# Story', num2str(i)));
    
    % Loop over the number of Z-Direction wood panels
    for j = 1:buildingGeometry.numberOfZDirectionWoodPanels(i,1)
        
        % Bottom node
        fprintf(fid,'%s\t','fix');
        fprintf(fid,'%s\t',...
            ZDirectionWoodPanelNodes{i,j}(1,1).openSeesTag);
        % base node(fixed)
        if ZDirectionWoodPanelNodes{i,j}(1,1).yCoordinate == 0
            fprintf(fid,'%u\t',1);
            fprintf(fid,'%u\t',1);
            fprintf(fid,'%u\t',1);
            fprintf(fid,'%u\t',1);
            fprintf(fid,'%u\t',1);
            fprintf(fid,'%u',1);
            fprintf(fid,'%s\n',';');
        else % non-base node(plane stress)
            fprintf(fid,'%u\t',0);
            fprintf(fid,'%u\t',1);
            fprintf(fid,'%u\t',0);
            fprintf(fid,'%u\t',1);
            fprintf(fid,'%u\t',0);
            fprintf(fid,'%u',1);
            fprintf(fid,'%s\n',';');
        end
        
        % Top node
        fprintf(fid,'%s\t','fix');
        fprintf(fid,'%s\t',...
            ZDirectionWoodPanelNodes{i,j}(2,1).openSeesTag);
        fprintf(fid,'%u\t',0);
        fprintf(fid,'%u\t',1);
        fprintf(fid,'%u\t',0);
        fprintf(fid,'%u\t',1);
        fprintf(fid,'%u\t',0);
        fprintf(fid,'%u',1);
        fprintf(fid,'%s\n',';');
        
    end
    fprintf(fid,'%s\n','');
    
end
fprintf(fid,'%s\n',...
    'puts "fixities at z-direction wood panel nodes defined"');
fprintf(fid,'%s\n','');

% Defining fixity in leaning column nodes
fprintf(fid,'%s\n','# Define fixities at leaning column nodes');

% Looping over number of floor levels
for j = 1:9
    for i = 1:buildingGeometry.numberOfStories + 1

        fprintf(fid,'%s\t','fix');
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,j}(4)));
        % base node(fixed)
        if leaningColumnNodes{i,j}(3) == 0
            fprintf(fid,'%u\t',1);
            fprintf(fid,'%u\t',1);
            fprintf(fid,'%u\t',1);
            fprintf(fid,'%u\t',1);
            fprintf(fid,'%u\t',1);
            fprintf(fid,'%u',1);
            fprintf(fid,'%s\n',';');
        else % non-base node(plane stress + leanging column)
            fprintf(fid,'%u\t',0);
            fprintf(fid,'%u\t',0);
            fprintf(fid,'%u\t',0);
            fprintf(fid,'%u\t',1);
            fprintf(fid,'%u\t',0);
            fprintf(fid,'%u',1);
            fprintf(fid,'%s\n',';');
        end

    end
    fprintf(fid,'%s\n','');
end
fprintf(fid,'%s\n','');

fprintf(fid,'%s\n','puts "leaning column nodes defined"');
fprintf(fid,'%s\n','');

% Closing and saving tcl file
fclose(fid);
end

