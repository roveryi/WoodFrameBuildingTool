
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
	ProjectName = '20200527OrdinanceRedesign'
	ID = 'case%s'%i

	if i%4 == 1 or i%4 == 2:
		NumStory = 2
	elif i%4 == 3 or i%4 == 0:
		NumStory = 3

	HazardLevel = np.array([0.163,0.326,0.489,0.652,0.815,0.978,1.141,1.304,1.467, 1.63,1.793,1.956,2.118,2.281,2.444])
	NumGM = np.array([44,44,44,44,44,44,44,44,44,44,44,44,44,44,44])
	CollapseCriteria = 0.1
	DemolitionCriteria = 0.01

	# Perform post processing
	ModelResults = BuildingModel(ID, '/u/project/hvburton/roveryi/%s/'%ProjectName, NumStory, HazardLevel, NumGM, CollapseCriteria, DemolitionCriteria)

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

