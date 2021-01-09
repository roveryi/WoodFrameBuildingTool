# Define wood panel force-deformation recorders 

cd $baseDir/$dataDir/WoodPanelShearForces 

# X-Direction wood panel element shear force recorders 
recorder	Element	-file	XWoodPanelShearForcesStory1.out	-time	-ele	700000	700001	700002	700003	700004	700005	force
recorder	Element	-file	XWoodPanelShearForcesStory2.out	-time	-ele	700006	700007	700008	700009	700010	700011	700012	700013	700014	700015	force

# Z-Direction wood panel element shear force recorders
recorder	Element	-file	ZWoodPanelShearForcesStory1.out	-time	-ele	700016	700017	700018	700019	700020	700021	force
recorder	Element	-file	ZWoodPanelShearForcesStory2.out	-time	-ele	700022	700023	700024	700025	700026	700027	700028	700029	700030	force


cd $baseDir/$dataDir/WoodPanelDeformations 

# X-Direction wood panel element deformation recorders
recorder	Element	-file	XWoodPanelDeformationsStory1.out	-time	-ele	700000	700001	700002	700003	700004	700005	deformation
recorder	Element	-file	XWoodPanelDeformationsStory2.out	-time	-ele	700006	700007	700008	700009	700010	700011	700012	700013	700014	700015	deformation

# Z-Direction wood panel element shear force recorders
recorder	Element	-file	ZWoodPanelDeformationsStory1.out	-time	-ele	700016	700017	700018	700019	700020	700021	deformation
recorder	Element	-file	ZWoodPanelDeformationsStory2.out	-time	-ele	700022	700023	700024	700025	700026	700027	700028	700029	700030	deformation


