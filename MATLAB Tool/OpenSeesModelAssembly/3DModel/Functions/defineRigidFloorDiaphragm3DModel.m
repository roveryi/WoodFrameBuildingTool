
function defineRigidFloorDiaphragm3DModel(buildingGeometry,...
    XDirectionWoodPanelNodes,ZDirectionWoodPanelNodes,...
    leaningColumnNodes,BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Generating Tcl File with Rigid Floor Diaphragm Properties         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(BuildingModelDirectory);
cd OpenSees3DModels
cd(AnalysisType);
fid = fopen('DefineRigidFloorDiaphragm3DModel.tcl','wt');

% Writing file description into tcl file
fprintf(fid,'%s\n',...
    '# This file will be used to define the rigid floor diaphram properties');
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','');

% Setting rigid diaphragm constraints on
fprintf(fid,'%s\n','# Setting rigid floor diaphragm constraint on');
fprintf(fid,'%s\n','set RigidDiaphragm ON;');
fprintf(fid,'%s\n','');

% Define Rigid Diaphram, dof 2 is normal to floor
fprintf(fid,'%s\n','# Define Rigid Diaphram, dof 2 is normal to floor');
fprintf(fid,'%s\n','set perpDirn 2;');
fprintf(fid,'%s\n','');


% Looping over number of floor levels
for i = 2:(buildingGeometry.numberOfStories + 1)
    fprintf(fid,'%s\t','rigidDiaphragm	$perpDirn');
    % Looping over all leaning columns
    for ii = 1:9
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,ii}(4)));
    end
    
    % Top node of panel "j" in story "i-1"
    % Loop over the number of X-Direction wood panels in story i-1
    for j = 1:buildingGeometry.numberOfXDirectionWoodPanels(i - 1,1)
        fprintf(fid,'%s\t',...
            XDirectionWoodPanelNodes{i - 1,j}(2,1).openSeesTag);
    end
    
    % Bottom node of panel "j" in story "i"
    if i <= buildingGeometry.numberOfStories
        % Loop over the number of X-Direction wood panels in story i
        for j = 1:buildingGeometry.numberOfXDirectionWoodPanels(i,1)
            fprintf(fid,'%s\t',...
                XDirectionWoodPanelNodes{i,j}(1,1).openSeesTag);
        end
    end
    
    % Top node of panel "j" in story "i-1"
    % Loop over the number of Z-Direction wood panels in story i-1
    for j = 1:buildingGeometry.numberOfZDirectionWoodPanels(i - 1,1)
        fprintf(fid,'%s\t',...
            ZDirectionWoodPanelNodes{i - 1,j}(2,1).openSeesTag);
    end
    
    % Bottom node of panel "j" in story "i"
    if i <= buildingGeometry.numberOfStories
        % Loop over the number of Z-Direction wood panels in story i
        for j = 1:buildingGeometry.numberOfZDirectionWoodPanels(i,1)
            fprintf(fid,'%s\t',...
                ZDirectionWoodPanelNodes{i,j}(1,1).openSeesTag);
        end
    end
    fprintf(fid,'%s\n','');
    
end
fprintf(fid,'%s\n','');

fprintf(fid,'%s\n','puts "rigid diaphragm constraints defined"');
fprintf(fid,'%s\n','');

% Closing and saving tcl file
fclose(fid);

end

