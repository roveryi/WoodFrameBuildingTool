
function defineLeaningColumnFlexuralSprings3DModel(buildingGeometry,...
    leaningColumnNodes,BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 Generating Tcl File with Columns Defined                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(BuildingModelDirectory);
cd OpenSees3DModels
cd(AnalysisType);
fid = fopen('DefineLeaningColumnFlexuralSprings3DModel.tcl','wt');

% Writing file description into tcl file
fprintf(fid,'%s\t','# This file will be used to define');
fprintf(fid,'%s\n',...
    'the flexible flexural springs at the ends of the leaning column');
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','');

% Initialize integer used as element tags for the flexible flexural
% springs at the ends of the leaning column
LeaningColumnFlexuralSpringElementTag = 900000;

% Defining the leaning column flexural springs
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

% Defining springs allow rotations aboout x, y, and z
fprintf(fid,'%s\n','# Define Leaning Column Flexural Springs');

% Looping over all leaning columns (center of mass, southwest, south face, 
% southeast, west face, northwest, north face, northeast, east face)
for j = 1:9 
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories
            fprintf(fid,'%s\t','CreatePinJointRXRYRZ');
        % Element tag
        fprintf(fid,'%u\t',LeaningColumnFlexuralSpringElementTag);
        LeaningColumnFlexuralSpringElementTag = ...
            LeaningColumnFlexuralSpringElementTag + 1;
        % Start node (mass center)
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,j}(4)));
        % End node (top node)
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,j}(4) + 1));
        % Stiff material
        fprintf(fid,'%s\t','$StiffMat');
        % Soft material
        fprintf(fid,'%s','$SoftMat');
        fprintf(fid,'%s\n',';');
    end

    % Defining springs allow rotations about x and z
    for i=2:buildingGeometry.numberOfStories + 1
        fprintf(fid,'%s\t','CreatePinJointRXRZ');
        % Element tag
        fprintf(fid,'%u\t',LeaningColumnFlexuralSpringElementTag);
        LeaningColumnFlexuralSpringElementTag = ...
            LeaningColumnFlexuralSpringElementTag + 1;
        % Start node (mass center)
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,j}(4)));
        % End node (bottom node)
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,j}(4) + 2));
        % Stiff material
        fprintf(fid,'%s\t','$StiffMat');
        % Soft material
        fprintf(fid,'%s','$SoftMat');
        fprintf(fid,'%s\n',';');
    end
    fprintf(fid,'%s\n','');
    
end
fprintf(fid,'%s\n','');

fprintf(fid,'%s\n',...
    'puts "Leaning column flexible flexural springs defined"');
fprintf(fid,'%s\n','');

% Closing and saving tcl file
fclose(fid);
end

