% 此函数用来定义 DefineWoodPanelRecorders3DModel.tcl 文件 %
% recorder Element -file fileName -time -ele eleTag force %

function defineWoodPanelRecorders3DModel(buildingGeometry,...,...
    BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Generating Tcl File with Defined Beam Hinge Recorders           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % 打开储存DefineNodes3DModel文件夹 %
    cd(BuildingModelDirectory);
    cd OpenSees3DModels
    cd(AnalysisType);
    fid = fopen('DefineWoodPanelRecorders3DModel.tcl','wt');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    正文                                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Writing file description into tcl file
    fprintf(fid,'%s\n','# Define wood panel force-deformation recorders');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Define force recorders
    % Changing directory to output location
    fprintf(fid,'%s\t','cd');
    if strcmp(AnalysisType,'PushoverAnalysis') == 1
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/WoodPanelShearForces'));
        fprintf(fid,'%s\n','');
    else
        fprintf(fid,'%s\n',strcat('$$pathToResults/EQ_$folderNumber/WoodPanelShearForces'));
        fprintf(fid,'%s\n','');
    end
        
    % Initialize integer used as wood panel element tag
    WoodPanelElementTag = 700000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    定义x-方向panel force                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Defining recorders for X-Direction wood panel elements
    fprintf(fid,'%s\n','# X-Direction wood panel element force recorders');
    % Looping over number of stories
    for i = 1:buildingGeometry.numberOfStories
        fprintf(fid,'%s\t','recorder Element -file'); 
        fprintf(fid,'%s\t',strcat('XWoodPanelShearForcesStory',...
            num2str(i),'.out'));
        fprintf(fid,'%s\t','-time -ele');     
        % Loop over the number of X-Direction wood panels
        for j = 1:buildingGeometry.numberOfXDirectionWoodPanels(i,1)
            % Define panel openSees tag
            fprintf(fid,'%u\t',WoodPanelElementTag); 
            WoodPanelElementTag = WoodPanelElementTag + 1;
        end
        fprintf(fid,'%s\n','force');    
    end
    fprintf(fid,'%s\n','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    定义z-方向panel force                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Defining recorders for Z-Direction wood panel elements
    fprintf(fid,'%s\n','# Z-Direction wood panel element force recorders');
    % Looping over number of stories
    for i = 1:buildingGeometry.numberOfStories
        fprintf(fid,'%s\t','recorder Element -file'); 
        fprintf(fid,'%s\t',strcat('ZWoodPanelShearForcesStory',...
            num2str(i),'.out'));
        fprintf(fid,'%s\t','-time -ele');     
        % Loop over the number of Z-Direction wood panels
        for j = 1:buildingGeometry.numberOfZDirectionWoodPanels(i,1)
            % Define panel openSees tag
            fprintf(fid,'%u\t',WoodPanelElementTag); 
            WoodPanelElementTag = WoodPanelElementTag + 1;
        end
        fprintf(fid,'%s\n','force');    
    end
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');
    

    % Define deformation recorders
    % Changing directory to output location
    fprintf(fid,'%s\t','cd');
    if strcmp(AnalysisType,'PushoverAnalysis') == 1
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/',...
            'WoodPanelDeformations'));
        fprintf(fid,'%s\n','');
    else
        fprintf(fid,'%s\n',strcat('$pathToResults/EQ_$folderNumber/WoodPanelDeformations'));
        fprintf(fid,'%s\n','');
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    定义x-方向panel deformation                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Initialize integer used as wood panel element tag
    WoodPanelElementTag = 700000;
    
    % Defining recorders for X-Direction wood panel elements
    fprintf(fid,'%s\n',...
        '# X-Direction wood panel element deformation recorders');
    % Looping over number of stories
    for i = 1:buildingGeometry.numberOfStories
        fprintf(fid,'%s\t','recorder Element -file'); 
        fprintf(fid,'%s\t',strcat('XWoodPanelDeformationsStory',...
            num2str(i),'.out'));
        fprintf(fid,'%s\t','-time -ele');     
        % Loop over the number of X-Direction wood panels
        for j = 1:buildingGeometry.numberOfXDirectionWoodPanels(i,1)
            % Define panel openSees tag
            fprintf(fid,'%u\t',WoodPanelElementTag); 
            WoodPanelElementTag = WoodPanelElementTag + 1;
        end
        fprintf(fid,'%s\n','deformation');    
    end
    fprintf(fid,'%s\n','');

    % Defining recorders for Z-Direction wood panel elements
    fprintf(fid,'%s\n',...
        '# Z-Direction wood panel element deformation recorders');
    % Looping over number of stories
    for i = 1:buildingGeometry.numberOfStories
        fprintf(fid,'%s\t','recorder Element -file'); 
        fprintf(fid,'%s\t',strcat('ZWoodPanelDeformationsStory',...
            num2str(i),'.out'));
        fprintf(fid,'%s\t','-time -ele');     
        % Loop over the number of Z-Direction wood panels
        for j = 1:buildingGeometry.numberOfZDirectionWoodPanels(i,1)
            % Define panel openSees tag
            fprintf(fid,'%u\t',WoodPanelElementTag); 
            WoodPanelElementTag = WoodPanelElementTag + 1;
        end
        fprintf(fid,'%s\n','deformation');    
    end
    fprintf(fid,'%s\n','');

    % Closing and saving tcl file
    fclose(fid);
end

