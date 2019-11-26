% This function is used to generate an array of coordinates and OpenSees
% Tags for the  leaning column (joint and hinge) nodes, which are defined
% at (approximately) the center of mass of the building.

% Note that the leaning column nodes must be defined at the same location
% in plan at all floor levels regardless of whether the center of mass is
% the same (in plan) at each level.

function leaningColumnNodes = defineLeaningColumnNodes(buildingGeometry)

% leaningColumnNodes is an M X 1 cell where M is the number of
% floor levels (including the ground floor) in the building. Each cell
% entry contains a 1 x 4 row vector of the x, z and y coordinates of
% the leaning column nodes (joint and column hinge) at each floor
% and the OpenSees tag for the leaning column node (column 4)
leaningColumnNodes = cell(buildingGeometry.numberOfStories + 1,9);

for j = 1:9
    % Loop over the number of stories
    for i = 1:buildingGeometry.numberOfStories + 1
        % Define leaning column node coordinates
        leaningColumnNodes{i,j} = [...
            buildingGeometry.leaningColumnNodesXCoordinates(i,j), ...
            buildingGeometry.leaningColumnNodesZCoordinates(i,j), ...
            buildingGeometry.floorHeights(i,1), ...
            buildingGeometry.leaningColumnNodesOpenSeesTags(i,j)];
    end
end

end

