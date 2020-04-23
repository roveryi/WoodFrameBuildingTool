# Define wood panel force-deformation recorders 

cd $pathToResults/EQ_$folderNumber/WoodPanelShearForces 

# X-Direction wood panel element shear force recorders 
recorder	Element	-file	XWoodPanelShearForcesStory1.out	-time	-ele	700000	700001	700002	700003	700004	700005	force
recorder	Element	-file	XWoodPanelShearForcesStory2.out	-time	-ele	700006	700007	700008	700009	700010	force

# Z-Direction wood panel element shear force recorders
recorder	Element	-file	ZWoodPanelShearForcesStory1.out	-time	-ele	700011	700012	700013	700014	700015	700016	force
recorder	Element	-file	ZWoodPanelShearForcesStory2.out	-time	-ele	700017	700018	700019	700020	700021	force


cd $pathToResults/EQ_$folderNumber/WoodPanelDeformations 

# X-Direction wood panel element deformation recorders
recorder	Element	-file	XWoodPanelDeformationsStory1.out	-time	-ele	700000	700001	700002	700003	700004	700005	deformation
recorder	Element	-file	XWoodPanelDeformationsStory2.out	-time	-ele	700006	700007	700008	700009	700010	deformation

# Z-Direction wood panel element shear force recorders
recorder	Element	-file	ZWoodPanelDeformationsStory1.out	-time	-ele	700011	700012	700013	700014	700015	700016	deformation
recorder	Element	-file	ZWoodPanelDeformationsStory2.out	-time	-ele	700017	700018	700019	700020	700021	deformation


