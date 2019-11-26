
function buildingLoads = defineBuildingLoads(LoadParametersLocation)

% Go to folder where building load data is stored
cd(LoadParametersLocation);

% Define struct with building loads
buildingLoads.floorWeights = load('floorWeights.txt'); % (kips)
buildingLoads.liveLoads = load('liveLoads.txt'); % (kips per square inch)
buildingLoads.leaningcolumnLoads = load('leaningcolumnLoads .txt'); %(kips)
end

