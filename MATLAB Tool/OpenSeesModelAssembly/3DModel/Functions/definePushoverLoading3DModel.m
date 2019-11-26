
function definePushoverLoading3DModel(buildingGeometry,...
    seismicParametersObject,leaningColumnNodes,BuildingModelDirectory,...
    AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Generating Tcl File with Pushover Loading Defined           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(BuildingModelDirectory);
cd OpenSees3DModels
cd(AnalysisType);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  X-Direction Pushover Loading Defined                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Opening and defining Tcl file
fid = fopen('DefinePushoverXLoading3DModel.tcl','wt');

% Writing file description into tcl file
fprintf(fid,'%s\n','# Define pushover loading');
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','');

% Define pushover loading
fprintf(fid,'%s\n','pattern Plain 200 Linear {');
fprintf(fid,'%s\n','');
% Define lateral loads
fprintf(fid,'%s\n','# Pushover pattern');
for i = 1:buildingGeometry.numberOfStories
    fprintf(fid,'%s\t','load');
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1}(4)));
    fprintf(fid,'%10.3f\t',seismicParametersObject.Cvx(i));
    fprintf(fid,'%s\t','0');
    fprintf(fid,'%s\t','0');
    fprintf(fid,'%s\t','0');
    fprintf(fid,'%s\t','0');
    fprintf(fid,'%s','0');
    fprintf(fid,'%s\n',';');
end
fprintf(fid,'%s\n','}');
fprintf(fid,'%s\n','');

% Closing and saving tcl file
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  Z-Direction Pushover Loading Defined                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Opening and defining Tcl file
fid = fopen('DefinePushoverZLoading3DModel.tcl','wt');

% Writing file description into tcl file
fprintf(fid,'%s\n','# Define pushover loading');
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','');

% Define pushover loading
fprintf(fid,'%s\n','pattern Plain 200 Linear {');
fprintf(fid,'%s\n','');
% Define lateral loads
fprintf(fid,'%s\n','# Pushover pattern');
for i = 1:buildingGeometry.numberOfStories
    fprintf(fid,'%s\t','load');
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1}(4)));
    fprintf(fid,'%s\t','0');
    fprintf(fid,'%s\t','0');
    fprintf(fid,'%10.3f\t',seismicParametersObject.Cvx(i));
    fprintf(fid,'%s\t','0');
    fprintf(fid,'%s\t','0');
    fprintf(fid,'%s','0');
    fprintf(fid,'%s\n',';');
end
fprintf(fid,'%s\n','}');
fprintf(fid,'%s\n','');

% Closing and saving tcl file
fclose(fid);
end

