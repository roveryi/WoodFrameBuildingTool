
function defineWoodPanelMaterials3DModel(buildingGeometry,...
    XWoodPanelPinching4Materials,ZWoodPanelPinching4Materials,...
    xDirectionWoodPanelObjects,zDirectionWoodPanelObjects,...
    BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Generating Tcl File with Wood Panel Material Models Defined      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(BuildingModelDirectory);
cd OpenSees3DModels
cd(AnalysisType);
fid = fopen('DefineWoodPanelMaterials3DModel.tcl','wt');

% Writing file description into tcl file
fprintf(fid,'%s\n',...
    '# This file will be used to define wood panel material models');
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','');

% Initialize integer used as wood panel material tag
WoodPanelMaterialTag = 600000;
OuterWoodPanelMaterialTag = 610000;
InnerWoodPanelMaterialTag = 620000;

fprintf(fid,'%s\n','# Define x-direction wood panel materials');

% Looping over number of stories
for i = 1:buildingGeometry.numberOfStories
    fprintf(fid,'%s\n',strcat('# Story', num2str(i)));
    
    % Loop over the number of X-Direction wood panels
    for j = 1:buildingGeometry.numberOfXDirectionWoodPanels(i,1)
        fprintf(fid,'%s\n',strcat('# X-Direction Story',num2str(i),...
            '/Panel',num2str(j)));
        
        % panel tag
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('XOuterWoodPanelMatStory',num2str(i),...
            'Panel',num2str(j)));
        fprintf(fid,'%u',OuterWoodPanelMaterialTag);
        OuterWoodPanelMaterialTag = OuterWoodPanelMaterialTag + 1;
        fprintf(fid,'%s\n',';');
        
        % Define panel material properties
        % pEnvelopeLoad-ePf1
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('p1OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        XWoodPanelPinching4Materials.f1(xDirectionWoodPanelObjects{i,j}.outerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % pEnvelopeDeformation-ePd1
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('d1OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        XWoodPanelPinching4Materials.d1(xDirectionWoodPanelObjects{i,j}.outerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % pEnvelopeLoad-ePf2
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('p2OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        XWoodPanelPinching4Materials.f2(xDirectionWoodPanelObjects{i,j}.outerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % pEnvelopeDeformation-ePd2
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('d2OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        XWoodPanelPinching4Materials.d2(xDirectionWoodPanelObjects{i,j}.outerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % pEnvelopeLoad-ePf3
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('p3OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        XWoodPanelPinching4Materials.f3(xDirectionWoodPanelObjects{i,j}.outerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % pEnvelopeDeformation-ePd3
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('d3OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        XWoodPanelPinching4Materials.d3(xDirectionWoodPanelObjects{i,j}.outerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % pEnvelopeLoad-ePf4
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('p4OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        XWoodPanelPinching4Materials.f4(xDirectionWoodPanelObjects{i,j}.outerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % pEnvelopeDeformation-ePd4
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('d4OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        XWoodPanelPinching4Materials.d4(xDirectionWoodPanelObjects{i,j}.outerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % rDisp
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('rDispOuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',XWoodPanelPinching4Materials.rDisp...
         (xDirectionWoodPanelObjects{i,j}.outerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % rForce
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('rForceOuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',XWoodPanelPinching4Materials.rForce...
         (xDirectionWoodPanelObjects{i,j}.outerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % uForce
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('uForceOuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',XWoodPanelPinching4Materials.uForce...
         (xDirectionWoodPanelObjects{i,j}.outerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % gammaD1
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('gammaD1OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',XWoodPanelPinching4Materials.gD1...
         (xDirectionWoodPanelObjects{i,j}.outerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % gDlim
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('gDlimOuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',XWoodPanelPinching4Materials.gDlim...
         (xDirectionWoodPanelObjects{i,j}.outerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % gammaK1
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('gammaK1OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',XWoodPanelPinching4Materials.gK1...
         (xDirectionWoodPanelObjects{i,j}.outerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % gKlim
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('gKlimOuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',XWoodPanelPinching4Materials.gKlim...
         (xDirectionWoodPanelObjects{i,j}.outerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % damage
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t','dam');
        fprintf(fid,'%s\t','"energy"');
        fprintf(fid,'%s\n',';');
        
        % wallLength
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat(...
            'wallLengthWoodPanelMatStory',num2str(i),'Pier',num2str(j)));
        fprintf(fid,'%10.3f',xDirectionWoodPanelObjects{i,j}.length);
        fprintf(fid,'%s\n',';');

        % wallHeight
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat(...
            'wallHeightWoodPanelMatStory',num2str(i),'Pier',num2str(j)));
        fprintf(fid,'%10.3f',xDirectionWoodPanelObjects{i,j}.height);
        fprintf(fid,'%s\n',';');
        
        % Define material
        fprintf(fid,'%s\t','procUniaxialPinching');
        fprintf(fid,'%s\t',strcat('$XOuterWoodPanelMatStory',num2str(i),...
            'Panel',num2str(j)));
        fprintf(fid,'%s\t',strcat('$p1OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$d1OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$p2OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$d2OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$p3OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$d3OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$p4OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$d4OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$rDispOuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$rForceOuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$uForceOuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$gammaD1OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$gDlimOuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$gammaK1OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$gKlimOuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t','$dam');
        fprintf(fid,'%s\t',strcat(...
            '$wallLengthWoodPanelMatStory',num2str(i),'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat(...
            '$wallHeightWoodPanelMatStory',num2str(i),'Pier',num2str(j)));
        fprintf(fid,'%s\n',';');
        fprintf(fid,'%s\n','');
        

        % panel tag
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('XInnerWoodPanelMatStory',num2str(i),...
            'Panel',num2str(j)));
        fprintf(fid,'%u',InnerWoodPanelMaterialTag);
        InnerWoodPanelMaterialTag = InnerWoodPanelMaterialTag + 1;
        fprintf(fid,'%s\n',';');
        
        % Define panel material properties
        % pEnvelopeLoad-ePf1
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('p1InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        XWoodPanelPinching4Materials.f1(xDirectionWoodPanelObjects{i,j}.innerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % pEnvelopeDeformation-ePd1
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('d1InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        XWoodPanelPinching4Materials.d1(xDirectionWoodPanelObjects{i,j}.innerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % pEnvelopeLoad-ePf2
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('p2InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        XWoodPanelPinching4Materials.f2(xDirectionWoodPanelObjects{i,j}.innerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % pEnvelopeDeformation-ePd2
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('d2InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        XWoodPanelPinching4Materials.d2(xDirectionWoodPanelObjects{i,j}.innerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % pEnvelopeLoad-ePf3
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('p3InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        XWoodPanelPinching4Materials.f3(xDirectionWoodPanelObjects{i,j}.innerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % pEnvelopeDeformation-ePd3
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('d3InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        XWoodPanelPinching4Materials.d3(xDirectionWoodPanelObjects{i,j}.innerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % pEnvelopeLoad-ePf4
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('p4InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        XWoodPanelPinching4Materials.f4(xDirectionWoodPanelObjects{i,j}.innerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % pEnvelopeDeformation-ePd4
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('d4InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        XWoodPanelPinching4Materials.d4(xDirectionWoodPanelObjects{i,j}.innerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % rDisp
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('rDispInnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',XWoodPanelPinching4Materials.rDisp...
         (xDirectionWoodPanelObjects{i,j}.innerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % rForce
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('rForceInnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));

        fprintf(fid,'%10.3f',XWoodPanelPinching4Materials.rForce...
         (xDirectionWoodPanelObjects{i,j}.innerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % uForce
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('uForceInnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',XWoodPanelPinching4Materials.uForce...
         (xDirectionWoodPanelObjects{i,j}.innerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        
        % gammaD1
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('gammaD1InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',XWoodPanelPinching4Materials.gD1...
         (xDirectionWoodPanelObjects{i,j}.innerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % gDlim
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('gDlimInnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',XWoodPanelPinching4Materials.gDlim...
         (xDirectionWoodPanelObjects{i,j}.innerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');

        % gammaK1
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('gammaK1InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',XWoodPanelPinching4Materials.gK1...
         (xDirectionWoodPanelObjects{i,j}.innerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % gKlim
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('gKlimInnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',XWoodPanelPinching4Materials.gKlim...
         (xDirectionWoodPanelObjects{i,j}.innerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % damage
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t','dam');
        fprintf(fid,'%s\t','"energy"');
        fprintf(fid,'%s\n',';');
        
        % wallLength
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat(...
            'wallLengthWoodPanelMatStory',num2str(i),'Pier',num2str(j)));
        fprintf(fid,'%10.3f',xDirectionWoodPanelObjects{i,j}.length);
        fprintf(fid,'%s\n',';');

        % wallHeight
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat(...
            'wallHeightWoodPanelMatStory',num2str(i),'Pier',num2str(j)));
        fprintf(fid,'%10.3f',xDirectionWoodPanelObjects{i,j}.height);
        fprintf(fid,'%s\n',';');
        
        % Define material
        fprintf(fid,'%s\t','procUniaxialPinching');
        fprintf(fid,'%s\t',strcat('$XInnerWoodPanelMatStory',num2str(i),...
            'Panel',num2str(j)));
        fprintf(fid,'%s\t',strcat('$p1InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
         fprintf(fid,'%s\t',strcat('$d1InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$p2InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
         fprintf(fid,'%s\t',strcat('$d2InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$p3InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
         fprintf(fid,'%s\t',strcat('$d3InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$p4InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
         fprintf(fid,'%s\t',strcat('$d4InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$rDispInnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$rForceInnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$uForceInnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$gammaD1InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$gDlimInnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$gammaK1InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$gKlimInnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t','$dam');
        fprintf(fid,'%s\t',strcat(...
            '$wallLengthWoodPanelMatStory',num2str(i),'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat(...
            '$wallHeightWoodPanelMatStory',num2str(i),'Pier',num2str(j)));
        fprintf(fid,'%s\n',';');
        fprintf(fid,'%s\n','');
        
    end
end
fprintf(fid,'%s\n','puts "x-direction wood panel nodes defined"');
fprintf(fid,'%s\n','');

fprintf(fid,'%s\n','# Define z-direction wood panel materials');

% Looping over number of stories
for i = 1:buildingGeometry.numberOfStories
    fprintf(fid,'%s\n',strcat('# Story', num2str(i)));
    
    % Loop over the number of Z-Direction wood panels
    for j = 1:buildingGeometry.numberOfZDirectionWoodPanels(i,1)
        fprintf(fid,'%s\n',strcat('# Z-Direction Story',num2str(i),...
            'Panel',num2str(j)));
        
        
        % panel tag
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('ZOuterWoodPanelMatStory',num2str(i),...
            'Panel',num2str(j)));
        fprintf(fid,'%u',OuterWoodPanelMaterialTag);
        OuterWoodPanelMaterialTag = OuterWoodPanelMaterialTag + 1;
        fprintf(fid,'%s\n',';');
        
        % Define panel material properties
        % pEnvelopeLoad-ePf1
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('p1OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        ZWoodPanelPinching4Materials.f1(zDirectionWoodPanelObjects{i,j}.outerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % pEnvelopeDeformation-ePd1
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('d1OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        ZWoodPanelPinching4Materials.d1(zDirectionWoodPanelObjects{i,j}.outerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % pEnvelopeLoad-ePf2
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('p2OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        ZWoodPanelPinching4Materials.f2(zDirectionWoodPanelObjects{i,j}.outerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % pEnvelopeDeformation-ePd2
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('d2OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        ZWoodPanelPinching4Materials.d2(zDirectionWoodPanelObjects{i,j}.outerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % pEnvelopeLoad-ePf3
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('p3OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        ZWoodPanelPinching4Materials.f3(zDirectionWoodPanelObjects{i,j}.outerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % pEnvelopeDeformation-ePd3
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('d3OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        ZWoodPanelPinching4Materials.d3(zDirectionWoodPanelObjects{i,j}.outerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % pEnvelopeLoad-ePf4
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('p4OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        ZWoodPanelPinching4Materials.f4(zDirectionWoodPanelObjects{i,j}.outerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % pEnvelopeDeformation-ePd4
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('d4OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        ZWoodPanelPinching4Materials.d4(zDirectionWoodPanelObjects{i,j}.outerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % rDisp
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('rDispOuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',ZWoodPanelPinching4Materials.rDisp...
         (zDirectionWoodPanelObjects{i,j}.outerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % rForce
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('rForceOuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',ZWoodPanelPinching4Materials.rForce...
         (zDirectionWoodPanelObjects{i,j}.outerpanelMaterialNumber,:));
        fprintf(fid,'%s\n',';');
        
        % uForce
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('uForceOuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',ZWoodPanelPinching4Materials.uForce...
         (zDirectionWoodPanelObjects{i,j}.outerpanelMaterialNumber,:));
        fprintf(fid,'%s\n',';');
        
        % gammaD
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('gammaD1OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',ZWoodPanelPinching4Materials.gD1...
         (zDirectionWoodPanelObjects{i,j}.outerpanelMaterialNumber,:));
        fprintf(fid,'%s\n',';');
        
        % gDlim
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('gDlimOuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',ZWoodPanelPinching4Materials.gDlim...
         (zDirectionWoodPanelObjects{i,j}.outerpanelMaterialNumber,:));
        fprintf(fid,'%s\n',';');

        % gammaK
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('gammaK1OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',ZWoodPanelPinching4Materials.gK1...
         (zDirectionWoodPanelObjects{i,j}.outerpanelMaterialNumber,:));
        fprintf(fid,'%s\n',';');
        
        % gKlim
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('gKlimOuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',ZWoodPanelPinching4Materials.gKlim...
         (zDirectionWoodPanelObjects{i,j}.outerpanelMaterialNumber,:));
        fprintf(fid,'%s\n',';');
        
        % damage
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t','dam');
        fprintf(fid,'%s\t','"energy"');
        fprintf(fid,'%s\n',';');
        
        % wallLength
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('wallLengthWoodPanelMatStory',...
            num2str(i),'Pier',num2str(j)));
        fprintf(fid,'%10.3f',zDirectionWoodPanelObjects{i,j}.length);
        fprintf(fid,'%s\n',';');
        
        % wallHeight
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('wallHeightWoodPanelMatStory',...
            num2str(i),'Pier',num2str(j)));
        fprintf(fid,'%10.3f',zDirectionWoodPanelObjects{i,j}.height);
        fprintf(fid,'%s\n',';');
        
        % Define material
        fprintf(fid,'%s\t','procUniaxialPinching');
        fprintf(fid,'%s\t',strcat('$ZOuterWoodPanelMatStory',num2str(i),...
            'Panel',num2str(j)));
        fprintf(fid,'%s\t',strcat('$p1OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$d1OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$p2OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$d2OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$p3OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$d3OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$p4OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$d4OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$rDispOuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$rForceOuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$uForceOuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$gammaD1OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$gDlimOuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));  
        fprintf(fid,'%s\t',strcat('$gammaK1OuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$gKlimOuterWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j))); 
        fprintf(fid,'%s\t','$dam');
        fprintf(fid,'%s\t',strcat(...
            '$wallLengthWoodPanelMatStory',num2str(i),'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat(...
            '$wallHeightWoodPanelMatStory',num2str(i),'Pier',num2str(j)));
        fprintf(fid,'%s\n',';');
        fprintf(fid,'%s\n','');
        

        
        % panel tag
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('ZInnerWoodPanelMatStory',num2str(i),...
            'Panel',num2str(j)));
        fprintf(fid,'%u',InnerWoodPanelMaterialTag);
        InnerWoodPanelMaterialTag = InnerWoodPanelMaterialTag + 1;
        fprintf(fid,'%s\n',';');
        
        % Define panel material properties
        % pEnvelopeLoad-ePf1
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('p1InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        ZWoodPanelPinching4Materials.f1(zDirectionWoodPanelObjects{i,j}.innerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % pEnvelopeDeformation-ePd1
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('d1InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        ZWoodPanelPinching4Materials.d1(zDirectionWoodPanelObjects{i,j}.innerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % pEnvelopeLoad-ePf2
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('p2InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        ZWoodPanelPinching4Materials.f2(zDirectionWoodPanelObjects{i,j}.innerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % pEnvelopeDeformation-ePd2
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('d2InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        ZWoodPanelPinching4Materials.d2(zDirectionWoodPanelObjects{i,j}.innerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % pEnvelopeLoad-ePf3
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('p3InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        ZWoodPanelPinching4Materials.f3(zDirectionWoodPanelObjects{i,j}.innerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % pEnvelopeDeformation-ePd3
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('d3InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        ZWoodPanelPinching4Materials.d3(zDirectionWoodPanelObjects{i,j}.innerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % pEnvelopeLoad-ePf4
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('p4InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        ZWoodPanelPinching4Materials.f4(zDirectionWoodPanelObjects{i,j}.innerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % pEnvelopeDeformation-ePd4
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('d4InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',...
        ZWoodPanelPinching4Materials.d4(zDirectionWoodPanelObjects{i,j}.innerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % rDisp
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('rDispInnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',ZWoodPanelPinching4Materials.rDisp...
         (zDirectionWoodPanelObjects{i,j}.innerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % rForce
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('rForceInnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',ZWoodPanelPinching4Materials.rForce...
         (zDirectionWoodPanelObjects{i,j}.innerpanelMaterialNumber));
        fprintf(fid,'%s\n',';');
        
        % uForce
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('uForceInnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',ZWoodPanelPinching4Materials.uForce...
         (zDirectionWoodPanelObjects{i,j}.innerpanelMaterialNumber,:));
        fprintf(fid,'%s\n',';');
        
        % gammaD1
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('gammaD1InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',ZWoodPanelPinching4Materials.gD1...
         (zDirectionWoodPanelObjects{i,j}.innerpanelMaterialNumber,:));
        fprintf(fid,'%s\n',';');
        
        % gDlim
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('gDlimInnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',ZWoodPanelPinching4Materials.gDlim...
         (zDirectionWoodPanelObjects{i,j}.innerpanelMaterialNumber,:));
        fprintf(fid,'%s\n',';');

        % gammaK1
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('gammaK1InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',ZWoodPanelPinching4Materials.gK1...
         (zDirectionWoodPanelObjects{i,j}.innerpanelMaterialNumber,:));
        fprintf(fid,'%s\n',';');
        
        % gKlim
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('gKlimInnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%10.3f',ZWoodPanelPinching4Materials.gKlim...
         (zDirectionWoodPanelObjects{i,j}.innerpanelMaterialNumber,:));
        fprintf(fid,'%s\n',';');
        
        % damage
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t','dam');
        fprintf(fid,'%s\t','"energy"');
        fprintf(fid,'%s\n',';');
        
        % wallLength
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('wallLengthWoodPanelMatStory',...
            num2str(i),'Pier',num2str(j)));
        fprintf(fid,'%10.3f',zDirectionWoodPanelObjects{i,j}.length);
        fprintf(fid,'%s\n',';');       
        
        % wallHeight
        fprintf(fid,'%s\t','set');
        fprintf(fid,'%s\t',strcat('wallHeightWoodPanelMatStory',...
            num2str(i),'Pier',num2str(j)));
        fprintf(fid,'%10.3f',zDirectionWoodPanelObjects{i,j}.height);
        fprintf(fid,'%s\n',';');
        
        % Define material
        fprintf(fid,'%s\t','procUniaxialPinching');
        fprintf(fid,'%s\t',strcat('$ZInnerWoodPanelMatStory',num2str(i),...
            'Panel',num2str(j)));
        fprintf(fid,'%s\t',strcat('$p1InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$d1InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$p2InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$d2InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$p3InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$d3InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$p4InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$d4InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$rDispInnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$rForceInnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$uForceInnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$gammaD1InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$gDlimInnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$gammaK1InnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat('$gKlimInnerWoodPanelMatStory',num2str(i),...
            'Pier',num2str(j)));
        fprintf(fid,'%s\t','$dam');
        fprintf(fid,'%s\t',strcat(...
            '$wallLengthWoodPanelMatStory',num2str(i),'Pier',num2str(j)));
        fprintf(fid,'%s\t',strcat(...
            '$wallHeightWoodPanelMatStory',num2str(i),'Pier',num2str(j)));
        fprintf(fid,'%s\n',';');
        fprintf(fid,'%s\n','');
        
    end
end
fprintf(fid,'%s\n','puts "z-direction wood panel nodes defined"');
fprintf(fid,'%s\n','');

WoodPanelMaterialTag = 600000;
OuterWoodPanelMaterialTag = 610000;
InnerWoodPanelMaterialTag = 620000;


fprintf(fid,'%s\n','# Define x-direction parralle wood panel materials');
% Looping over number of stories
for i = 1:buildingGeometry.numberOfStories
    fprintf(fid,'%s\n',strcat('# Story', num2str(i)));
    % Loop over the number of X-Direction wood panels
    for j = 1:buildingGeometry.numberOfXDirectionWoodPanels(i,1)
        fprintf(fid,'%s\n',strcat('# X-Direction Story',num2str(i),...
            'Panel',num2str(j)));
        
        fprintf(fid,'%s\t','uniaxialMaterial Parallel');
        fprintf(fid,'%u\t',WoodPanelMaterialTag);
        fprintf(fid,'%u\t',OuterWoodPanelMaterialTag);
        fprintf(fid,'%u',InnerWoodPanelMaterialTag);
        fprintf(fid,'%s\n',';');
        WoodPanelMaterialTag = WoodPanelMaterialTag + 1;
        OuterWoodPanelMaterialTag = OuterWoodPanelMaterialTag + 1;
        InnerWoodPanelMaterialTag = InnerWoodPanelMaterialTag + 1;
        
    end
    fprintf(fid,'%s\n','');
end

fprintf(fid,'%s\n','# Define z-direction parralle wood panel materials');
% Looping over number of stories
for i = 1:buildingGeometry.numberOfStories
    fprintf(fid,'%s\n',strcat('# Story', num2str(i)));
    % Loop over the number of Z-Direction wood panels
    for j = 1:buildingGeometry.numberOfZDirectionWoodPanels(i,1)
        fprintf(fid,'%s\n',strcat('# Z-Direction Story',num2str(i),...
            'Panel',num2str(j)));
        
        fprintf(fid,'%s\t','uniaxialMaterial Parallel');
        fprintf(fid,'%u\t',WoodPanelMaterialTag);
        fprintf(fid,'%u\t',OuterWoodPanelMaterialTag);
        fprintf(fid,'%u',InnerWoodPanelMaterialTag);
        fprintf(fid,'%s\n',';');
        WoodPanelMaterialTag = WoodPanelMaterialTag + 1;
        OuterWoodPanelMaterialTag = OuterWoodPanelMaterialTag + 1;
        InnerWoodPanelMaterialTag = InnerWoodPanelMaterialTag + 1;
        
    end
    fprintf(fid,'%s\n','');
end

fprintf(fid,'%s\n','puts "wood panel materials defined"');
fprintf(fid,'%s\n','');



% Closing and saving tcl file
fclose(fid);

end

