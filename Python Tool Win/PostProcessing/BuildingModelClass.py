
# coding: utf-8

# In[1]:


# This is the main script used for doing post-processing and data analysis for sensitivity study of Peer-CEA project
# Date: 07/12/2018
# Author: Zhengxiang Yi
# Email: roveryi@g.ucla.edu


# In[19]:


# Import packages
import numpy as np
import math
import os
import pandas as pd

from scipy.stats import lognorm
from scipy.stats import binom

import matplotlib.pyplot as plt

from scipy.optimize import minimize

# Import functions
from ExtractMaxEDP import ExtractSDR
from ExtractMaxEDP import ExtractRDR
from ExtractMaxEDP import ExtractPGA
from ExtractMaxEDP import ExtractPFA
from ExtractMaxEDP import Count
from ExtractMaxEDP import lognormfit
from ExtractMaxEDP import neg_loglik
from ExtractMaxEDP import squareerror 

# from LossAssessment import performLossAssessment

# In[16]:


class BuildingModel(object):
    
    def __init__(self, CaseID, BaseDirectory, NumStory, HazardLevel, NumGM, CollapseCriteria = 0.1, DemolitionCriteria = 0.01):
        self.ID = CaseID
        self.BaseDirectory = BaseDirectory
        
        # Directory info
        DynamicDirectory = BaseDirectory + CaseID + '/'
        # EigenDirectory = BaseDirectory + ID + '/OpenSees3DModels/EigenValueAnalysis/'
        GMDirectory = BaseDirectory + 'GM_Info'

        self.HazardLevel = HazardLevel
        self.NumGM = NumGM
        self.NumStory = NumStory
        
        # Post-processing
        self.SDR = ExtractSDR (DynamicDirectory, self.HazardLevel, self.NumGM, self.NumStory)
        self.RDR = ExtractRDR (DynamicDirectory, self.HazardLevel, self.NumGM, self.NumStory)
        self.PGA = ExtractPGA (GMDirectory, self.HazardLevel, self.NumGM)
        self.PFA = ExtractPFA (DynamicDirectory, self.HazardLevel, self.NumGM, self.NumStory, self.PGA, g = 386.4)
        self.CollapseCount = pd.DataFrame(Count(self.SDR, CollapseCriteria, self.NumGM))
        self.CollapseFragility = pd.DataFrame(lognormfit(self.HazardLevel, Count(self.SDR, CollapseCriteria, self.NumGM), self.NumGM, 'SSE'))
        self.DemolitionFragility = pd.DataFrame(lognormfit(self.HazardLevel, Count(self.RDR, DemolitionCriteria, self.NumGM), self.NumGM, 'SSE'))

        
        

    

        
