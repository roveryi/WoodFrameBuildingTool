
function defineWoodPanels3DModel(buildingGeometry,...
    xDirectionWoodPanelObjects,zDirectionWoodPanelObjects,...
    BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                Generating Tcl File with Wood Panels Defined             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(BuildingModelDirectory);
cd OpenSees3DModels
cd(AnalysisType);
fid = fopen('DefineWoodPanels3DModel.tcl','wt');

% Writing file description into tcl file
fprintf(fid,'%s\n',...
    '# This file will be used to define wood panel elements');
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','');

% Initialize integer used as wood panel material tag
WoodPanelMaterialTag = 600000;

% Initialize integer used as wood panel element tag
WoodPanelElementTag = 700000;

fprintf(fid,'%s\n','# Define x-direction wood panels');

% Looping over number of stories
for i = 1:buildingGeometry.numberOfStories
    fprintf(fid,'%s\n',strcat('# Story', num2str(i)));
    
    % Loop over the number of X-Direction wood panels
    for j = 1:buildingGeometry.numberOfXDirectionWoodPanels(i,1)
        % Display (commented) panel identifier
        fprintf(fid,'%s\n',strcat('# X-Direction Story',num2str(i),...
            '/Panel',num2str(j)));
        
        % Define element as twoNodeLink
        fprintf(fid,'%s\t','element twoNodeLink');
        % Define panel tag
        fprintf(fid,'%u\t',WoodPanelElementTag);
        WoodPanelElementTag = WoodPanelElementTag + 1;
        % Define start (bottom) node
        fprintf(fid,'%s\t',xDirectionWoodPanelObjects{i,j}. ...
            panelBottomNodeOpenSeesTag);
        % Define end (top) node
        fprintf(fid,'%s\t',xDirectionWoodPanelObjects{i,j}. ...
            panelTopNodeOpenSeesTag);
        % Define material linked to element
        fprintf(fid,'%s\t','-mat');
        fprintf(fid,'%u\t',WoodPanelMaterialTag);
        WoodPanelMaterialTag = WoodPanelMaterialTag + 1;
        % Define material direction
        fprintf(fid,'%s\t','-dir');
        fprintf(fid,'%u\t',2);
        % Define matreial direction
        fprintf(fid,'%s\t','-orient');
        fprintf(fid,'%u\t',1);
        fprintf(fid,'%u\t',0);
        fprintf(fid,'%u\t',0);
        fprintf(fid,'-doRayleigh');
        fprintf(fid,'%s\n',';');
        
    end
    fprintf(fid,'%s\n','');
    
end
fprintf(fid,'%s\n','puts "x-direction wood panels defined"');
fprintf(fid,'%s\n','');

fprintf(fid,'%s\n','# Define z-direction wood panels');

% Looping over number of stories
for i = 1:buildingGeometry.numberOfStories
    fprintf(fid,'%s\n',strcat('# Story', num2str(i)));
    
    % Loop over the number of Z-Direction wood panels
    for j = 1:buildingGeometry.numberOfZDirectionWoodPanels(i,1)
        % Display (commented) panel identifier
        fprintf(fid,'%s\n',strcat('# Z-Direction Story',num2str(i),...
            'Panel',num2str(j)));
        
        % Define element as twoNodeLink
        fprintf(fid,'%s\t','element twoNodeLink');
        % Define panel tag
        fprintf(fid,'%u\t',WoodPanelElementTag);
        WoodPanelElementTag = WoodPanelElementTag + 1;
        % Define start (bottom) node
        fprintf(fid,'%s\t',zDirectionWoodPanelObjects{i,j}. ...
            panelBottomNodeOpenSeesTag);
        % Define end (top) node
        fprintf(fid,'%s\t',zDirectionWoodPanelObjects{i,j}. ...
            panelTopNodeOpenSeesTag);
        % Define material linked to element
        fprintf(fid,'%s\t','-mat');
        fprintf(fid,'%u\t',WoodPanelMaterialTag);
        WoodPanelMaterialTag = WoodPanelMaterialTag + 1;
        % Define material direction
        fprintf(fid,'%s\t','-dir');
        fprintf(fid,'%u\t',3);
        % Define element orientation
        fprintf(fid,'%s\t','-orient');
        fprintf(fid,'%u\t',1);
        fprintf(fid,'%u\t',0);
        fprintf(fid,'%u\t',0);
        fprintf(fid,'-doRayleigh');
        fprintf(fid,'%s\n',';');
        
    end
    fprintf(fid,'%s\n','');
    
end
fprintf(fid,'%s\n','puts "z-direction wood panels defined"');
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','puts "wood panels defined"');
fprintf(fid,'%s\n','');

% Closing and saving tcl file
fclose(fid);

end

