import numpy as np
import math
import os
import pandas as pd
import csv
from BuildingModelDynamic import BuildingModelDynamic
from LossAssessment import *

# with open('/u/project/hvburton/roveryi/CEA_Baseline/BuildingName.txt', 'r') as f:
#     BuildingList = f.read() 
# BuildingList = BuildingList.split('\n')

HazardLevel = np.array([0.178, 0.274, 0.444, 0.560, 0.652, 0.790, 0.982, 1.246, 1.564, 2.014, 2.417, 3.021, 3.625, 4.028, 4.431, 5.035])
NumGM = np.array([45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45])
CollapseCriteria = 0.2
DemolitionCriteria = 0.01

RETURN_PERIOD = [15, 25, 50, 75, 100, 150, 250, 500, 1000, 2500, 2700, 3000, 3300, 3500, 3700, 4000]
RATE = [1/i for i in RETURN_PERIOD]
HazardData_df = pd.DataFrame(data = [HazardLevel, RATE]).T
ResultsDir = '/u/project/hvburton/roveryi/Results/'
ProjectName = 'LHS-2'

# Use environment variable to realize parallel computing  
seed = int(os.getenv('SGE_TASK_ID'))

cwH = pd.read_csv('/u/project/hvburton/roveryi/LHS-2/cwH_LHS-2.csv')

for i in range(seed,seed+1):
	# Define inputs for post processing
	# Make sure to check the case name, number of story, hazard level and number of ground motions to match the current project
	ID = 'case%s'%i

	NumStory = 3

	# Perform post processing
	ModelResults = BuildingModelDynamic(ID, 
		'/u/project/hvburton/roveryi/%s/'%ProjectName, 
		NumStory, 
		HazardLevel, 
		NumGM, 
		CollapseCriteria, 
		DemolitionCriteria)

	
	# Check if the folder for current model exists
	if not os.path.exists(os.path.join(ResultsDir, '%s/'%ProjectName, './%s'%ID)):
		os.mkdir(os.path.join(ResultsDir, '%s/'%ProjectName, './%s'%ID))
	os.chdir(os.path.join(ResultsDir, '%s/'%ProjectName, './%s'%ID))

	# Save results 
	ModelResults.SDR.to_csv('SDR.csv', sep=',', header = False, index = False)        
	ModelResults.RDR.to_csv('RDR.csv', sep=',', header = False, index = False)        
	ModelResults.PFA.to_csv('PFA.csv', sep=',', header = False, index = False)        

	ModelResults.CollapseCount.to_csv('CollapseCount.csv', sep = ',', header = False, index = False)
	ModelResults.CollapseFragility.to_csv('CollapseFragility.csv', sep='\t', header = False, index = False)    
	ModelResults.DemolitionFragility.to_csv('DemolitionFragility.csv', sep='\t', header = False, index = False)    

	# ComponentList = create_component_list(BuildingList[i-1])
	ComponentList = create_component_list('2L-S2-G2-2C-S2-EX', cwH.iloc[seed-1,:].values[0])
	theta_collapse = ModelResults.CollapseFragility.values.T[0]
	beta = np.array([0.35,0]).reshape([2,1])
	theta_collapse[1] = np.sqrt(theta_collapse[1]**2 + 0.35**2)
	if NumStory == 1:
		BuildingValue = 200 * 30 * 40
	else:
		BuildingValue = 200 * 30 * 40 * (NumStory - 1)

	Loss = performLossAssessment(ComponentList, 
		NumStory, CollapseCriteria, ModelResults.SDR, ModelResults.PFA, ModelResults.RDR, 
		theta_collapse, HazardData_df, BuildingValue, beta, 3000, 'false')

	os.chdir(os.path.join(ResultsDir, '%s/'%ProjectName, './%s'%ID))
	Loss.to_csv('Loss_intensity.csv')

	EAL = ExpectedAnnulLoss(CLoss = Loss['CollapseLoss'].values.tolist()[0:10],
		DLoss = Loss['DemolitionLoss'].values.tolist()[0:10],
		ComLoss = Loss['ComponentLoss'].values.tolist()[0:10],
		HazardData = HazardData_df.iloc[0:10,:])

	pd.DataFrame(data = EAL.reshape(1,-1), columns = ['Total', 'Collapse', 'Demolition', 'Component']).to_csv('EAL.csv')


