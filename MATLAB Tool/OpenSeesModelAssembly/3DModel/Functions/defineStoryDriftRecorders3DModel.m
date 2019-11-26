
function defineStoryDriftRecorders3DModel(buildingGeometry,...
    leaningColumnNodes,BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Generating Tcl File with Defined Story Drift Recorders           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(BuildingModelDirectory);
cd OpenSees3DModels
cd(AnalysisType);
fid = fopen('DefineStoryDriftRecorders3DModel.tcl','wt');

% Writing file description into tcl file
fprintf(fid,'%s\n','# Define story drift recorders');
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','');

% Changing directory to output location
fprintf(fid,'%s\t','cd');
if strcmp(AnalysisType,'PushoverAnalysis') == 1
    fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/StoryDrifts'));
else
    fprintf(fid,'%s\n',strcat('$pathToResults/EQ_$folderNumber/StoryDrifts'));
end
fprintf(fid,'%s\n','');

% Defining X-Direction Story Drift Recorders

% Looping over number of floor levels
%% x direction recorder
fprintf(fid,'%s\n','# X-Direction Story Drifts');

if strcmp(AnalysisType,'PushoverAnalysis') == 1
    fprintf(fid,'%s\t','recorder Drift -file');
    fprintf(fid,'%s\t',strcat('$baseDir/$dataDir/',...
        'StoryDrifts/LeaningColumnXDrift.out'));
    fprintf(fid,'%s\t','-iNode');
    for i = 1:buildingGeometry.numberOfStories
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,5}(4)));
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,2}(4)));
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,8}(4)));
    end
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{1,5}(4)));
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{1,2}(4)));
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{1,8}(4)));

    fprintf(fid,'%s\t','-jNode');
    for i = 1:buildingGeometry.numberOfStories
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1,5}(4)));
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1,2}(4)));
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1,8}(4)));
    end
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{buildingGeometry.numberOfStories+1,5}(4)));
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{buildingGeometry.numberOfStories+1,2}(4)));
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{buildingGeometry.numberOfStories+1,8}(4)));
    fprintf(fid,'%s\n','-dof 1 -perpDirn 2');
else
    fprintf(fid,'%s\t','recorder Drift -file');
    fprintf(fid,'%s\t',strcat('$pathToResults/EQ_$folderNumber/StoryDrifts/MidLeaningColumnXDrift.out'));
    
    fprintf(fid,'%s\t','-time -iNode');

    for i = 1:buildingGeometry.numberOfStories
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,5}(4)));
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,2}(4)));
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,8}(4)));
    end
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{1,5}(4)));
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{1,2}(4)));
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{1,8}(4)));

    fprintf(fid,'%s\t','-jNode');
    for i = 1:buildingGeometry.numberOfStories
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1,5}(4)));
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1,2}(4)));
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1,8}(4)));
    end
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{buildingGeometry.numberOfStories+1,5}(4)));
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{buildingGeometry.numberOfStories+1,2}(4)));
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{buildingGeometry.numberOfStories+1,8}(4)));
    fprintf(fid,'%s\n','-dof 1 -perpDirn 2');

    fprintf(fid,'%s\t','recorder Drift -file');
    fprintf(fid,'%s\t',strcat('$pathToResults/EQ_$folderNumber/StoryDrifts/CornerLeaningColumnXDrift.out'));
    fprintf(fid,'%s\t','-time -iNode');

    for i = 1:buildingGeometry.numberOfStories
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,1}(4)));
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,3}(4)));
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,7}(4)));
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,9}(4)));
    end
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{1,1}(4)));
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{1,3}(4)));
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{1,7}(4)));
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{1,9}(4)));

    fprintf(fid,'%s\t','-jNode');
    for i = 1:buildingGeometry.numberOfStories
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1,1}(4)));
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1,3}(4)));
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1,7}(4)));
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1,9}(4)));

    end
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{buildingGeometry.numberOfStories+1,1}(4)));
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{buildingGeometry.numberOfStories+1,3}(4)));
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{buildingGeometry.numberOfStories+1,7}(4)));
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{buildingGeometry.numberOfStories+1,9}(4)));

    fprintf(fid,'%s\n','-dof 1 -perpDirn 2');
end

%% z direction recorder
fprintf(fid,'%s\n','# Z-Direction Story Drifts');

if strcmp(AnalysisType,'PushoverAnalysis') == 1
    fprintf(fid,'%s\t','recorder Drift -file');
    fprintf(fid,'%s\t',strcat('$baseDir/$dataDir/',...
        'StoryDrifts/LeaningColumnZDrift.out'));
    for i = 1:buildingGeometry.numberOfStories
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,5}(4)));
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,6}(4)));
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,4}(4)));
    end
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{1,5}(4)));
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{1,6}(4)));
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{1,4}(4)));

    fprintf(fid,'%s\t','-jNode');
    for i = 1:buildingGeometry.numberOfStories
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1,5}(4)));
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1,6}(4)));
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1,4}(4)));
    end
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{buildingGeometry.numberOfStories+1,5}(4)));
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{buildingGeometry.numberOfStories+1,6}(4)));
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{buildingGeometry.numberOfStories+1,4}(4)));
    fprintf(fid,'%s\n','-dof 3 -perpDirn 2');
    
else
    fprintf(fid,'%s\t','recorder Drift -file');
    fprintf(fid,'%s\t',strcat('$pathToResults/EQ_$folderNumber/StoryDrifts/MidLeaningColumnZDrift.out'));
    fprintf(fid,'%s\t','-time -iNode');

    for i = 1:buildingGeometry.numberOfStories
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,5}(4)));
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,6}(4)));
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,4}(4)));
    end
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{1,5}(4)));
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{1,6}(4)));
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{1,4}(4)));

    fprintf(fid,'%s\t','-jNode');
    for i = 1:buildingGeometry.numberOfStories
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1,5}(4)));
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1,6}(4)));
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1,4}(4)));
    end
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{buildingGeometry.numberOfStories+1,5}(4)));
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{buildingGeometry.numberOfStories+1,6}(4)));
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{buildingGeometry.numberOfStories+1,4}(4)));
    fprintf(fid,'%s\n','-dof 3 -perpDirn 2');

    fprintf(fid,'%s\t','recorder Drift -file');
    fprintf(fid,'%s\t',strcat('$pathToResults/EQ_$folderNumber/StoryDrifts/CornerLeaningColumnZDrift.out'));
    fprintf(fid,'%s\t','-time -iNode');

    for i = 1:buildingGeometry.numberOfStories
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,1}(4)));
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,3}(4)));
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,7}(4)));
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,9}(4)));
    end
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{1,1}(4)));
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{1,3}(4)));
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{1,7}(4)));
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{1,9}(4)));

    fprintf(fid,'%s\t','-jNode');
    for i = 1:buildingGeometry.numberOfStories
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1,1}(4)));
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1,3}(4)));
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1,7}(4)));
        fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1,9}(4)));

    end
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{buildingGeometry.numberOfStories+1,1}(4)));
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{buildingGeometry.numberOfStories+1,3}(4)));
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{buildingGeometry.numberOfStories+1,7}(4)));
    fprintf(fid,'%s\t',num2str(leaningColumnNodes{buildingGeometry.numberOfStories+1,9}(4)));

    fprintf(fid,'%s\n','-dof 3 -perpDirn 2');
end
%% Center of mass x direction recorder
% fprintf(fid,'%s\n','# Center of Mass X-Direction Story Drifts');
% for i = 1:buildingGeometry.numberOfStories
% 
%     if strcmp(AnalysisType,'PushoverAnalysis') == 1
%         fprintf(fid,'%s\t','recorder Drift -file');
%         fprintf(fid,'%s\t',strcat('$baseDir/$dataDir/',...
%             'StoryDrifts/COMStoryX',num2str(i),'.out'));
%     else
%         fprintf(fid,'%s\t','recorder Drift -file');
%         fprintf(fid,'%s\t',strcat('$pathToResults/EQ_$folderNumber/StoryDrifts/COMStoryX',...
%             num2str(i),'.out'));
%     end
% 
%     fprintf(fid,'%s\t','-time -iNode');
%     fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,5}(4)));
%     fprintf(fid,'%s\t','-jNode');
%     fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1,5}(4)));
%     fprintf(fid,'%s\n','-dof 1 -perpDirn 2');
% end
% 
% % Roof drift recorder
% if strcmp(AnalysisType,'PushoverAnalysis') == 1
%     fprintf(fid,'%s\t','recorder Drift -file');
%     fprintf(fid,'%s\t',strcat('$baseDir/$dataDir/StoryDrifts/COMRoofX.out'));
% else
%     fprintf(fid,'%s\t','recorder Drift -file');
%     fprintf(fid,'%s\t',strcat('$pathToResults/EQ_$folderNumber/StoryDrifts/COMRoofX.out'));
% end
% 
% fprintf(fid,'%s\t','-time -iNode');
% fprintf(fid,'%s\t',num2str(leaningColumnNodes{1,5}(4)));
% fprintf(fid,'%s\t','-jNode');
% fprintf(fid,'%s\t',num2str(leaningColumnNodes{...
%     buildingGeometry.numberOfStories + 1,5}(4)));
% fprintf(fid,'%s\n','-dof 1 -perpDirn 2');
% fprintf(fid,'%s\n','');
% 
% 
% 
% %% South x direction recorder
% fprintf(fid,'%s\n','# South X-Direction Story Drifts');
% for i = 1:buildingGeometry.numberOfStories
% 
%     if strcmp(AnalysisType,'PushoverAnalysis') == 1
%         fprintf(fid,'%s\t','recorder Drift -file');
%         fprintf(fid,'%s\t',strcat('$baseDir/$dataDir/',...
%             'StoryDrifts/SouthStoryX',num2str(i),'.out'));
%     else
%         fprintf(fid,'%s\t','recorder Drift -file');
%         fprintf(fid,'%s\t',strcat('$pathToResults/EQ_$folderNumber/StoryDrifts/SouthStoryX',...
%             num2str(i),'.out'));
%     end
% 
%     fprintf(fid,'%s\t','-time -iNode');
%     fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,2}(4)));
%     fprintf(fid,'%s\t','-jNode');
%     fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1,2}(4)));
%     fprintf(fid,'%s\n','-dof 1 -perpDirn 2');
% end
% 
% % Roof drift recorder
% if strcmp(AnalysisType,'PushoverAnalysis') == 1
%     fprintf(fid,'%s\t','recorder Drift -file');
%     fprintf(fid,'%s\t',strcat('$baseDir/$dataDir/StoryDrifts/SouthRoofX.out'));
% else
%     fprintf(fid,'%s\t','recorder Drift -file');
%     fprintf(fid,'%s\t',strcat('$pathToResults/EQ_$folderNumber/StoryDrifts/SouthRoofX.out'));
% end
% 
% fprintf(fid,'%s\t','-time -iNode');
% fprintf(fid,'%s\t',num2str(leaningColumnNodes{1,2}(4)));
% fprintf(fid,'%s\t','-jNode');
% fprintf(fid,'%s\t',num2str(leaningColumnNodes{...
%     buildingGeometry.numberOfStories + 1,2}(4)));
% fprintf(fid,'%s\n','-dof 1 -perpDirn 2');
% fprintf(fid,'%s\n','');
% 
% 
% %% North x direction recorder
% fprintf(fid,'%s\n','# North X-Direction Story Drifts');
% for i = 1:buildingGeometry.numberOfStories
% 
%     if strcmp(AnalysisType,'PushoverAnalysis') == 1
%         fprintf(fid,'%s\t','recorder Drift -file');
%         fprintf(fid,'%s\t',strcat('$baseDir/$dataDir/',...
%             'StoryDrifts/NorthStoryX',num2str(i),'.out'));
%     else
%         fprintf(fid,'%s\t','recorder Drift -file');
%         fprintf(fid,'%s\t',strcat('$pathToResults/EQ_$folderNumber/StoryDrifts/NorthStoryX',...
%             num2str(i),'.out'));
%     end
% 
%     fprintf(fid,'%s\t','-time -iNode');
%     fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,8}(4)));
%     fprintf(fid,'%s\t','-jNode');
%     fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1,8}(4)));
%     fprintf(fid,'%s\n','-dof 1 -perpDirn 2');
% end
% 
% % Roof drift recorder
% if strcmp(AnalysisType,'PushoverAnalysis') == 1
%     fprintf(fid,'%s\t','recorder Drift -file');
%     fprintf(fid,'%s\t',strcat('$baseDir/$dataDir/StoryDrifts/NorthRoofX.out'));
% else
%     fprintf(fid,'%s\t','recorder Drift -file');
%     fprintf(fid,'%s\t',strcat('$pathToResults/EQ_$folderNumber/StoryDrifts/NorthRoofX.out'));
% end
% 
% fprintf(fid,'%s\t','-time -iNode');
% fprintf(fid,'%s\t',num2str(leaningColumnNodes{1,8}(4)));
% fprintf(fid,'%s\t','-jNode');
% fprintf(fid,'%s\t',num2str(leaningColumnNodes{...
%     buildingGeometry.numberOfStories + 1,8}(4)));
% fprintf(fid,'%s\n','-dof 1 -perpDirn 2');
% fprintf(fid,'%s\n','');
% 
% 
% %% Defining Z-Direction Story Drift Recorders
% fprintf(fid,'%s\n','# Center of Mass(COM) Z-Direction Story Drifts');
% % Looping over number of floor levels
% for i = 1:buildingGeometry.numberOfStories
%     if strcmp(AnalysisType,'PushoverAnalysis') == 1
%         fprintf(fid,'%s\t','recorder Drift -file');
%         fprintf(fid,'%s\t',strcat('$baseDir/$dataDir/',...
%             'StoryDrifts/COMStoryZ',num2str(i),'.out'));
%     else
%         fprintf(fid,'%s\t','recorder Drift -file');
%         fprintf(fid,'%s\t',strcat('$pathToResults/EQ_$folderNumber/StoryDrifts/COMStoryZ',...
%             num2str(i),'.out'));
%     end
%     fprintf(fid,'%s\t','-time -iNode');
%     fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,5}(4)));
%     fprintf(fid,'%s\t','-jNode');
%     fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1,5}(4)));
%     fprintf(fid,'%s\n','-dof 3 -perpDirn 2');
% end
% % Roof drift recorder
% if strcmp(AnalysisType,'PushoverAnalysis') == 1
%     fprintf(fid,'%s\t','recorder Drift -file');
%     fprintf(fid,'%s\t',strcat('$baseDir/$dataDir/StoryDrifts/COMRoofZ.out'));
% else
%     fprintf(fid,'%s\t','recorder Drift -file');
%     fprintf(fid,'%s\t',strcat('$pathToResults/EQ_$folderNumber/StoryDrifts/COMRoofZ.out'));
% end
% fprintf(fid,'%s\t','-time -iNode');
% fprintf(fid,'%s\t',num2str(leaningColumnNodes{1,5}(4)));
% fprintf(fid,'%s\t','-jNode');
% fprintf(fid,'%s\t',num2str(leaningColumnNodes{...
%     buildingGeometry.numberOfStories + 1,5}(4)));
% fprintf(fid,'%s\n','-dof 3 -perpDirn 2');
% 
% fprintf(fid,'%s\n','');
% 
% %% Defining Z-Direction Story Drift Recorders
% fprintf(fid,'%s\n','# East Z-Direction Story Drifts');
% % Looping over number of floor levels
% for i = 1:buildingGeometry.numberOfStories
%     if strcmp(AnalysisType,'PushoverAnalysis') == 1
%         fprintf(fid,'%s\t','recorder Drift -file');
%         fprintf(fid,'%s\t',strcat('$baseDir/$dataDir/',...
%             'StoryDrifts/EastStoryZ',num2str(i),'.out'));
%     else
%         fprintf(fid,'%s\t','recorder Drift -file');
%         fprintf(fid,'%s\t',strcat('$pathToResults/EQ_$folderNumber/StoryDrifts/EastStoryZ',...
%             num2str(i),'.out'));
%     end
%     fprintf(fid,'%s\t','-time -iNode');
%     fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,6}(4)));
%     fprintf(fid,'%s\t','-jNode');
%     fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1,6}(4)));
%     fprintf(fid,'%s\n','-dof 3 -perpDirn 2');
% end
% % Roof drift recorder
% if strcmp(AnalysisType,'PushoverAnalysis') == 1
%     fprintf(fid,'%s\t','recorder Drift -file');
%     fprintf(fid,'%s\t',strcat('$baseDir/$dataDir/StoryDrifts/EastRoofZ.out'));
% else
%     fprintf(fid,'%s\t','recorder Drift -file');
%     fprintf(fid,'%s\t',strcat('$pathToResults/EQ_$folderNumber/StoryDrifts/EastRoofZ.out'));
% end
% fprintf(fid,'%s\t','-time -iNode');
% fprintf(fid,'%s\t',num2str(leaningColumnNodes{1,6}(4)));
% fprintf(fid,'%s\t','-jNode');
% fprintf(fid,'%s\t',num2str(leaningColumnNodes{...
%     buildingGeometry.numberOfStories + 1,6}(4)));
% fprintf(fid,'%s\n','-dof 3 -perpDirn 2');
% 
% fprintf(fid,'%s\n','');
% 
% 
% 
% 
% %% Defining Z-Direction Story Drift Recorders
% fprintf(fid,'%s\n','# West Z-Direction Story Drifts');
% % Looping over number of floor levels
% for i = 1:buildingGeometry.numberOfStories
%     if strcmp(AnalysisType,'PushoverAnalysis') == 1
%         fprintf(fid,'%s\t','recorder Drift -file');
%         fprintf(fid,'%s\t',strcat('$baseDir/$dataDir/',...
%             'StoryDrifts/WestStoryZ',num2str(i),'.out'));
%     else
%         fprintf(fid,'%s\t','recorder Drift -file');
%         fprintf(fid,'%s\t',strcat('$pathToResults/EQ_$folderNumber/StoryDrifts/WestStoryZ',...
%             num2str(i),'.out'));
%     end
%     fprintf(fid,'%s\t','-time -iNode');
%     fprintf(fid,'%s\t',num2str(leaningColumnNodes{i,4}(4)));
%     fprintf(fid,'%s\t','-jNode');
%     fprintf(fid,'%s\t',num2str(leaningColumnNodes{i + 1,4}(4)));
%     fprintf(fid,'%s\n','-dof 3 -perpDirn 2');
% end
% % Roof drift recorder
% if strcmp(AnalysisType,'PushoverAnalysis') == 1
%     fprintf(fid,'%s\t','recorder Drift -file');
%     fprintf(fid,'%s\t',strcat('$baseDir/$dataDir/StoryDrifts/WestRoofZ.out'));
% else
%     fprintf(fid,'%s\t','recorder Drift -file');
%     fprintf(fid,'%s\t',strcat('$pathToResults/EQ_$folderNumber/StoryDrifts/WestRoofZ.out'));
% end
% fprintf(fid,'%s\t','-time -iNode');
% fprintf(fid,'%s\t',num2str(leaningColumnNodes{1,4}(4)));
% fprintf(fid,'%s\t','-jNode');
% fprintf(fid,'%s\t',num2str(leaningColumnNodes{...
%     buildingGeometry.numberOfStories + 1,4}(4)));
% fprintf(fid,'%s\n','-dof 3 -perpDirn 2');
% 
% fprintf(fid,'%s\n','');
% 
% % Closing and saving tcl file
% fclose(fid);

end

