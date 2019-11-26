function defineDamping3DModel(buildingGeometry,dynamicPropertiesObject,...
    BuildingModelDirectory,leaningColumnNodes,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 Generating Tcl File with Damping Defined                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(BuildingModelDirectory);
cd OpenSees3DModels
cd(AnalysisType);
fid = fopen('DefineDamping3DModel.tcl','wt');

% Writing file description into tcl file
fprintf(fid,'%s\n','# This file will be used to define damping');
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','');

% Defining damping properties
fprintf(fid,'%s\n','# Defining damping parameters');
fprintf(fid,'%s\n',...
    'set omegaI [expr (2.0 * $pi) / ($periodForRayleighDamping_1)]');
fprintf(fid,'%s\n',...
    'set omegaJ [expr (2.0 * $pi) / ($periodForRayleighDamping_2)]');
fprintf(fid,'%s\n',...
    'set alpha1Coeff [expr (2.0 * $omegaI * $omegaJ) / ($omegaI + $omegaJ)]');
fprintf(fid,'%s\n',...
    'set alpha2Coeff [expr (2.0) / ($omegaI + $omegaJ)]');

fprintf(fid,'%s\n',strcat('set alpha1  [expr $alpha1Coeff*',...
    num2str(dynamicPropertiesObject.dampingRatio),']'));
fprintf(fid,'%s\n',strcat('set alpha2  [expr $alpha2Coeff*',...
    num2str(dynamicPropertiesObject.dampingRatio),']'));
fprintf(fid,'%s\n','');

% Computing the number of wood panels
numberOfWoodPanels = sum(buildingGeometry.numberOfXDirectionWoodPanels)...
    + sum(buildingGeometry.numberOfZDirectionWoodPanels);
% Assigning damping to wood panel elements
fprintf(fid,'%s\n','# Assign damping to wood panel elements');
fprintf(fid,'%s\t','region 1 -eleRange');
fprintf(fid,'%s\t',num2str(700000));
fprintf(fid,'%s\t',num2str(700000 + numberOfWoodPanels - 1));
fprintf(fid,'%s\n','-rayleigh 0  0 $alpha2 0;');

% Assigning damping to nodes
fprintf(fid,'%s\n','# Assign damping to nodes');
fprintf(fid,'%s\t','region 2 -node');
for i = 2:buildingGeometry.numberOfStories + 1
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{i}(4)),num2str(leaningColumnNodes{buildingGeometry.numberOfStories+i}(4)),...
        num2str(leaningColumnNodes{2*buildingGeometry.numberOfStories+i}(4)),num2str(leaningColumnNodes{3*buildingGeometry.numberOfStories+i}(4)),...
        num2str(leaningColumnNodes{4*buildingGeometry.numberOfStories+i}(4)),num2str(leaningColumnNodes{5*buildingGeometry.numberOfStories+i}(4)),...
        num2str(leaningColumnNodes{6*buildingGeometry.numberOfStories+i}(4)),num2str(leaningColumnNodes{7*buildingGeometry.numberOfStories+i}(4)),...
        num2str(leaningColumnNodes{8*buildingGeometry.numberOfStories+i}(4)));
end
fprintf(fid,'%s\n','-rayleigh $alpha1 0 0 0;');
fprintf(fid,'%s\n','');

fprintf(fid,'%s\n','# Define the periods to use for the Rayleigh damping calculations');
fprintf(fid,'%s\t',strcat('set periodForRayleighDamping_1 '));
fprintf(fid,'%s\t',strcat(num2str(dynamicPropertiesObject.modalPeriods3DModel(1)),';'));    
fprintf(fid,'%s\n','');
fprintf(fid,'%s\t',strcat('set periodForRayleighDamping_2 '));
fprintf(fid,'%s\t',strcat(num2str(dynamicPropertiesObject.modalPeriods3DModel(3)),';'));    
% Closing and saving tcl file
fclose(fid);

end

