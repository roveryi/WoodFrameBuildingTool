
# coding: utf-8

# In[7]:


# Import packages
import numpy as np
import math
import os
import pandas as pd
import csv
from BuildingModelClass import BuildingModel


# Use environment variable to realize parallel computing  
seed = int(os.getenv('SGE_TASK_ID'))

for i in range(seed,seed+1):
	# Define inputs for post processing
	# Make sure to check the case name, number of story, hazard level and number of ground motions to match the current project
	ProjectName = 'SWOF'
	ID = 'case%s'%i
	NumStory = 2
	HazardLevel = np.array([0.177852,0.273467,0.444298,0.5601,0.65216,0.790259,0.982082,1.246203,1.563623, 2.013842])
	NumGM = np.array([44,44,44,44,44,44,44,44,44,44,44,44,44,44,44])
	CollapseCriteria = 0.1
	DemolitionCriteria = 0.01

	# Perform post processing
	ModelResults = BuildingModel(ID, '/u/project/hvburton/roveryi/Hoffman/', NumStory, HazardLevel, NumGM, CollapseCriteria, DemolitionCriteria)

	# Save the results
	ResultsDir = '/u/project/hvburton/roveryi/Results/'
	os.chdir(ResultsDir + '%s/'%ProjectName)
	# Check if the folder for current model exists
	if not os.path.exists('./%s'%ID):
		os.mkdir(ModelResults.ID)
	os.chdir(ResultsDir + '%s/'%ProjectName+ModelResults.ID)

	# Save results 
	ModelResults.SDR.to_csv('SDR.csv', sep=',', header = False, index = False)        
	ModelResults.RDR.to_csv('RDR.csv', sep=',', header = False, index = False)        
	ModelResults.PFA.to_csv('PFA.csv', sep=',', header = False, index = False)        

	ModelResults.CollapseCount.to_csv('CollapseCount.csv', sep = ',', header = False, index = False)
	ModelResults.CollapseFragility.to_csv('CollapseFragility.csv', sep='\t', header = False, index = False)    
	ModelResults.DemolitionFragility.to_csv('DemolitionFragility.csv', sep='\t', header = False, index = False)    

