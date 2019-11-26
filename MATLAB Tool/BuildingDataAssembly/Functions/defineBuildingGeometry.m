
function buildingGeometry = defineBuildingGeometry(...
    GeometryParametersLocation)

% Go to folder where building geometry data is stored
cd(GeometryParametersLocation);

% Define struct with building geometry data
buildingGeometry.numberOfStories = load('numberOfStories.txt');
buildingGeometry.storyHeights = load('storyHeights.txt');

buildingGeometry.floorAreas = load('floorAreas.txt');

buildingGeometry.leaningColumnNodesOpenSeesTags = ...
    load('leaningColumnNodesOpenSeesTags.txt');
buildingGeometry.leaningColumnNodesXCoordinates = ...
    load('leaningColumnNodesXCoordinates.txt');
buildingGeometry.leaningColumnNodesZCoordinates = ...
    load('leaningColumnNodesZCoordinates.txt');

buildingGeometry.XDirectionWoodPanelsXCoordinates = ...
    load('XDirectionWoodPanelsXCoordinates.txt');
buildingGeometry.XDirectionWoodPanelsZCoordinates = ...
    load('XDirectionWoodPanelsZCoordinates.txt');

buildingGeometry.ZDirectionWoodPanelsXCoordinates = ...
    load('ZDirectionWoodPanelsXCoordinates.txt');
buildingGeometry.ZDirectionWoodPanelsZCoordinates = ...
    load('ZDirectionWoodPanelsZCoordinates.txt');

buildingGeometry.numberOfXDirectionWoodPanels = ...
    load('numberOfXDirectionWoodPanels.txt');
buildingGeometry.numberOfZDirectionWoodPanels = ...
    load('numberOfZDirectionWoodPanels.txt');

buildingGeometry.floorMaximumXDimension = ...
    load('floorMaximumXDimension.txt');
buildingGeometry.floorMaximumZDimension = ...
    load('floorMaximumZDimension.txt');

% Initialize array used to store building floor heights
buildingGeometry.floorHeights = zeros(...
    buildingGeometry.numberOfStories + 1,1);
% Compute floor heights (including ground floor)
for i = 1:buildingGeometry.numberOfStories
    buildingGeometry.floorHeights(i + 1,1) = ...
        sum(buildingGeometry.storyHeights(1:i));
end

end

