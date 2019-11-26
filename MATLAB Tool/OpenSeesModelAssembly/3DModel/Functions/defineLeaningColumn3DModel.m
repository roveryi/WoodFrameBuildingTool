
function defineLeaningColumn3DModel(buildingGeometry,leaningColumnNodes,...
    BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Generating Tcl File with Leaning Columns Defined          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(BuildingModelDirectory);
cd OpenSees3DModels
cd(AnalysisType);
fid = fopen('DefineLeaningColumn3DModel.tcl','wt');

% Writing file description into tcl file
fprintf(fid,'%s\n',...
    '# This file will be used to define the leaning column');
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','');

% Initialize integer used as leaning column element tag
LeaningColumnElementTag = 800000;

fprintf(fid,'%s\n','# Define Leaning Column');

% Looping over all leaning columns (center of mass, southwest, south face, 
% southeast, west face, northwest, north face, northeast, east face)
for j =1:9 
% Looping over all stories
    for i = 1:buildingGeometry.numberOfStories
        % Defining Element
        fprintf(fid,'%s\t','element elasticBeamColumn');
        % Element tag
        fprintf(fid,'%u\t',LeaningColumnElementTag);
        LeaningColumnElementTag = LeaningColumnElementTag + 1;
        % Start node
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,j}(4) + 1));
        % End node
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1,j}(4) + 2));
        fprintf(fid,'%s\t','$LargeNumber'); %A
        fprintf(fid,'%10.3f\t',1); %E
        fprintf(fid,'%10.3f\t',1); %G
        fprintf(fid,'%s\t','$LargeNumber'); %J
        fprintf(fid,'%s\t','$LargeNumber'); %Iz
        fprintf(fid,'%s\t','$LargeNumber'); %Iy
        fprintf(fid,'%s','$PDeltaTransf');
        fprintf(fid,'%s\n',';');
    end
        fprintf(fid,'%s\n','');

end
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','puts "Leaning columns defined"');
fprintf(fid,'%s\n','');

% Closing and saving tcl file
fclose(fid);
end

