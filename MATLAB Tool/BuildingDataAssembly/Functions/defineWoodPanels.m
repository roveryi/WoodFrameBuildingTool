
% This function is used to generate an array of wood panel objects
% (x- and z-panel nodes defined separately) containing the panel number
% (defined by story), story number, node numbers (for nodes used to
% define panel), OpenSees tags, panel length and material type/number
function [XDirectionWoodPanels, ZDirectionWoodPanels] = ...
    defineWoodPanels(buildingGeometry, ClassesDirectory,...
    XDirectionWoodPanelNodes, ZDirectionWoodPanelNodes,...
    XDirectionWoodPanelsPropertiesLocation,...
    ZDirectionWoodPanelsPropertiesLocation)

% Create empty array to store wood panel objects
cd(ClassesDirectory)

% XDirectionWoodPanels is an M X N cell where M is the number of
% stories in the building and N is the maximum number of x-direction
% wood panels on all floors.

% Each cell entry is a xWoodPanel object which contains the panel
% number (defined by story), story number, node numbers (for nodes used
% to define panel), OpenSees tags, panel length and material
% type/number

XDirectionWoodPanels = cell(buildingGeometry.numberOfStories,...
    max(buildingGeometry.numberOfXDirectionWoodPanels));
ZDirectionWoodPanels = cell(buildingGeometry.numberOfStories,...
    max(buildingGeometry.numberOfZDirectionWoodPanels));

% Loop over the number of stories
for i = 1:buildingGeometry.numberOfStories
    
    % Variable used to count number of wood panels at each story
    xCount = 1;
    zCount = 1;
    
    % Loop over the number of X-Direction wood panels
    for j = 1:buildingGeometry.numberOfXDirectionWoodPanels(i,1)
        % Node at bottom of panel
        XDirectionWoodPanels{i,j} = saveToStruct(...
            xWoodPanel(xCount, i, XDirectionWoodPanelNodes{i,j},...
            XDirectionWoodPanelsPropertiesLocation, ClassesDirectory));
        xCount = xCount + 1;
    end
    
    % Loop over the number of Z-Direction wood panels
    for j = 1:buildingGeometry.numberOfZDirectionWoodPanels(i,1)
        % Node at bottom of panel
        ZDirectionWoodPanels{i,j} = saveToStruct(...
            zWoodPanel(zCount, i, ZDirectionWoodPanelNodes{i,j},...
            ZDirectionWoodPanelsPropertiesLocation, ClassesDirectory));
        zCount = zCount + 1;
    end
end

end

