
function defineMasses3DModel(buildingGeometry,buildingLoads,...
    leaningColumnNodes,BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                Generating Tcl File with Defined Nodal Masses            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(BuildingModelDirectory);
cd OpenSees3DModels
cd(AnalysisType);
fid = fopen('DefineMasses3DModel.tcl','wt');

% Define gravitational constant in in/sec^2
g = 32.2*12;

% Writing file description into tcl file
fprintf(fid,'%s\n','# This file will be used to define all nodal masses');
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','');

% Defining nodal masses for leaning column nodes
fprintf(fid,'%s\n','# Define nodal masses for leaning column nodes');
% Looping over number of floor levels
for j = 1:9
    if j ~= 5
        for i = 1:buildingGeometry.numberOfStories
            fprintf(fid,'%s\t','mass');
            fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1,j}(4)));
            fprintf(fid,'%10.3f\t',buildingLoads.leaningcolumnLoads(i,j)/g);
            fprintf(fid,'%10.3f\t',buildingLoads.leaningcolumnLoads(i,j)/g);
            fprintf(fid,'%10.3f\t',buildingLoads.leaningcolumnLoads(i,j)/g);
            fprintf(fid,'%10.3f\t',0);
            fprintf(fid,'%10.3f\t',0);
            fprintf(fid,'%10.3f\t',0);
            fprintf(fid,'%s\n',';');
        end
    else
        for i = 1:buildingGeometry.numberOfStories
            fprintf(fid,'%s\t','mass');
            fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1,j}(4)));
            fprintf(fid,'%10.3f\t',buildingLoads.leaningcolumnLoads(i,j)/g);
            fprintf(fid,'%10.3f\t',buildingLoads.leaningcolumnLoads(i,j)/g);
            fprintf(fid,'%10.3f\t',buildingLoads.leaningcolumnLoads(i,j)/g);
            fprintf(fid,'%10.3f\t',buildingLoads.leaningcolumnLoads(i,j)*...
                ((buildingGeometry.floorMaximumXDimension(i)/2)^2 + ...
                (buildingGeometry.floorMaximumZDimension(i)/2)^2)/12/g);
            fprintf(fid,'%10.3f\t',buildingLoads.leaningcolumnLoads(i,j)*...
                ((buildingGeometry.floorMaximumXDimension(i)/2)^2 + ...
                (buildingGeometry.floorMaximumZDimension(i)/2)^2)/12/g);
            fprintf(fid,'%10.3f\t',buildingLoads.leaningcolumnLoads(i,j)*...
                ((buildingGeometry.floorMaximumXDimension(i)/2)^2 + ...
                (buildingGeometry.floorMaximumZDimension(i)/2)^2)/12/g);
            fprintf(fid,'%s\n',';');
        end
        
    end
fprintf(fid,'%s\n','');
end
fprintf(fid,'%s\n','puts "nodal masses defined"');
fprintf(fid,'%s\n','');

% Closing and saving tcl file
fclose(fid);
end

