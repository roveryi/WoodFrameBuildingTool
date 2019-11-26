
function defineGravityLoads3DModel(buildingGeometry,buildingLoads,...
    leaningColumnNodes,BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Generating Tcl File with Gravity Loads Defined              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 打开储存DefineNodes3DModel文件夹 %
cd(BuildingModelDirectory);
cd OpenSees3DModels
cd(AnalysisType);
fid = fopen('DefineGravityLoads3DModel.tcl','wt');

% Writing file description into tcl file
fprintf(fid,'%s\n','# Define gravity loads');
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','');

fprintf(fid,'%s\n','pattern Plain 101 Constant {');

% Computing gravity loads to be applied on leaning column based on
% 1.05DL + 0.25LL
% Looping over all stories

% Define gravity loads on leaning column
fprintf(fid,'%s\n','# Define gravity loads on leaning column');

for j = 1:9
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories
        % Defining concentrated load at leaning column node at floor level
        % i + 1
        fprintf(fid,'%s\t','load');
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1,j}(4)));
        fprintf(fid,'%u\t',0);
        fprintf(fid,'%10.4f\t',-buildingLoads.leaningcolumnLoads(i,j));
        fprintf(fid,'%u\t',0);
        fprintf(fid,'%u\t',0);
        fprintf(fid,'%u\t',0);
        fprintf(fid,'%u',0);
        fprintf(fid,'%s\n',';');
    end
    fprintf(fid,'%s\n','');
end
fprintf(fid,'%s\n','}');
% Closing and saving tcl file
fclose(fid);
end

