import pandas as pd
import numpy as np 
import matplotlib.pyplot as plt
import os 
import math
from scipy import interpolate
import json


class AnalysisResults(object):
    '''
    This class is defined for extracting analysis results: modal analysis, pushover analysis and dynamic analysis.
    It requires the output in the prespecified format, which means if define recorder files are not modified, there is no need to modify the class methods. 
    ##############################################################################################################
    Input:
    ID                  str Building name in the BuildingName.txt
    ProjectDirectory    str The directory contains the entire project
    ##############################################################################################################
    Generally, modal and pushover analysis are conducted locally. Therefore, the input Modal_Directory and Pushover_Directory are simply the folder contains the model.
    Hoffman2 is used to perform nonlinear dynamic analysis, and post processing is excuted online to get the results. Therefore, the input Dynamic_Directory is the folder with downloaded result files.  
    Input Results_Directory is the destination folder storing all results. 
    '''
    def __init__(self, BuildingID, ProjectDirectory):

        self.ID = BuildingID
        self.ProjectDirectory = ProjectDirectory
        self.Modal_Results = None
        self.Pushover_Results = None
        self.Dyanmic_Results = None

    def ExtractBuildingInfo(self):
        # Extract model information, including number of story, seismic weight and retrofit flag
        BIDirectory = '%s\BuildingInfo\%s'%(self.ProjectDirectory, self.ID)  

        os.chdir(BIDirectory + '\Geometry')
        self.NumStory = np.loadtxt('numberOfStories.txt')

        os.chdir(BIDirectory + '\Loads')
        self.SeismicWeight = np.loadtxt('floorWeights.txt').sum()

        os.chdir(BIDirectory + '\FrameRetrofit')
        temp1 = np.loadtxt('IndicateFrameXRetrofit.txt')
        temp2 = np.loadtxt('IndicateFrameZRetrofit.txt')
        self.RetrofitFlag = {'X': bool(temp1), 'Z': bool(temp2)}


    def ExtractPeriod(self):
        # Extract modal analysis results, including period and mode shape.
        Modal_Directory = '%s\BuildingModels\%s\EigenValueAnalysis\Analysis_Results'%(self.ProjectDirectory, self.ID)  
        os.chdir(Modal_Directory + '\Modes')
        self.Modal_Results = {}
        if os.path.isfile('periods.out'):
            self.Modal_Results['periods'] = np.loadtxt('periods.out').tolist()
        else:
            self.Modal_Results['periods'] = None 
            print('Missing period output file!')

        if os.path.isfile('mode_shape.out'):
            self.Modal_Results['mode shape'] = np.loadtxt('mode_shape.out').T.tolist()
        else:
            self.Modal_Results['mode shape'] = None
            print('Missing mode shape output file!')

    def ExtractPushover(self):
        Pushover_Directory = '%s\BuildingModels\%s\PushoverAnalysis'%(self.ProjectDirectory, self.ID)
        os.chdir(Pushover_Directory)

        self.Pushover_Results = {}
        self.Pushover_Stat = {}

        if os.path.isdir('Static-Pushover-Output-Model3D-XPushoverDirection'):
            self.Pushover_Results['X'] = self.pushoverdata('%s\Static-Pushover-Output-Model3D-XPushoverDirection'%Pushover_Directory, 'X') 
            self.Pushover_Stat['X'] = {}
            self.Pushover_Stat['X']['Peak Strength'], self.Pushover_Stat['X']['Drift Peak Strength'], self.Pushover_Stat['X']['Critical Points'], self.Pushover_Stat['X']['Area'] = self.extractpushoverpoints('X')

        
        else: 
            self.Pushover_Results['X'] = None
            self.Pushover_Stat['X'] = None
            print('Missing X direction pushover analysis results!')

        os.chdir(Pushover_Directory)
        if os.path.isdir('Static-Pushover-Output-Model3D-ZPushoverDirection'):
            self.Pushover_Results['Z'] = self.pushoverdata('%s\Static-Pushover-Output-Model3D-ZPushoverDirection'%Pushover_Directory, 'Z') 
            self.Pushover_Stat['Z'] = {}
            self.Pushover_Stat['Z']['Peak Strength'], self.Pushover_Stat['Z']['Drift Peak Strength'], self.Pushover_Stat['Z']['Critical Points'], self.Pushover_Stat['Z']['Area'] = self.extractpushoverpoints('Z')
        else:
            self.Pushover_Results['Z'] = None
            self.Pushover_Stat['Z'] = None
            print('Missing Z direction pushover analysis results!')

    def ExtractDynamic(self, Dynamic_Directory, HoffmanName):
        os.chdir('%s\%s'%(Dynamic_Directory, HoffmanName))

        self.Dyanmic_Results = {}

        if os.path.isfile('SDR.csv'):
            self.Dyanmic_Results['SDR'] = pd.read_csv('SDR.csv')
        else:
            self.Dyanmic_Results['SDR'] = None 
            print('No story drift ratio file!')

        if os.path.isfile('PFA.csv'):
            self.Dyanmic_Results['PFA'] = pd.read_csv('PFA.csv')
        else:
            self.Dyanmic_Results['PFA'] = None 
            print('No peak floor acceleration file!')

        if os.path.isfile('RDR.csv'):
            self.Dyanmic_Results['RDR'] = pd.read_csv('RDR.csv')
        else:
            self.Dyanmic_Results['RDR'] = None 
            print('No residual drift ratio file!')

        if os.path.isfile('CollapseFragility.csv'):
            self.Dyanmic_Results['CollapseFragility'] = pd.read_csv('CollapseFragility.csv', header=None)
        else:
            self.Dyanmic_Results['CollapseFragility'] = None
            print('No collapse fragility file!')

        if os.path.isfile('CollapseCount.csv'):
            self.Dyanmic_Results['CollapseCount'] = pd.read_csv('CollapseCount.csv')
        else: 
            self.Dyanmic_Results['CollapseCount'] = None
            print('No collapse count file!')

        if os.path.isfile('DemolitionFragility.csv'):
            self.Dyanmic_Results['DemolitionFragility'] = pd.read_csv('DemolitionFragility.csv', header = None)
        else: 
            self.Dyanmic_Results['DemolitionFragility'] = None
            print('No demolition fragility file!')


    def WriteResults2Json(self, ResultsFolder):
        if not os.path.isdir(ResultsFolder):
            os.mkdir(ResultsFolder)
        os.chdir(ResultsFolder)
        with open('ModalResults.json','w', encoding='utf-8') as file:
            json.dump(self.Modal_Results, file, indent = 2)

        PushoverStat = self.Pushover_Stat
        for key, vals in PushoverStat.items():
            if isinstance(vals, np.ndarray):
                PushoverStat[key] = vals.tolist()
            elif isinstance(vals, dict): 
                temp = {}
                for subkey, subvalues in vals.items():
                    if isinstance(subvalues, np.ndarray):
                        temp[subkey] = subvalues.tolist()
                    else: temp[subkey] = subvalues
                PushoverStat[key] = temp
            else: PushoverStat[key] = vals

        with open('PushoverResults.json','w', encoding='utf-8') as file:
            json.dump(PushoverStat, file, indent = 2)

        with open('DynamicResults.json','w', encoding='utf-8') as file:
            json.dump(self.Dyanmic_Results, file, indent = 2)



    def pushoverdata(self, PushoverDirectory, Direction):
        Results = []
        BRDirectory = PushoverDirectory + '\\BaseReactions\\'
        os.chdir(BRDirectory) # Change working directory to base reaction folder

        # load leaning column base shear 
        NodeBS = np.loadtxt('LeaningColumnBaseNode%sHorizontalReactions.out'%Direction) 
        
        if min(NodeBS[:,0]) < 0:
            idx = [ n for n,i in enumerate(NodeBS[:,0]) if i < 0 ][0]
        else: idx = NodeBS.shape[0]

        NodeBS = NodeBS[0:idx,:]

        # load panel base shear 
        PanelBS = np.loadtxt(Direction + 'PanelBaseNodesHorizontalReactions.out') 
        PanelBS = PanelBS[0:idx,:]
                
        if self.RetrofitFlag[Direction]:
            MFBS = np.loadtxt('OMF%sHorizontalReactions.out'%Direction)
            MFBS = MFBS[0:idx,:]
            BR = np.asarray(np.sum(NodeBS[:,1:NodeBS.shape[1]]/self.SeismicWeight,axis=1).tolist()) + \
            np.sum(PanelBS[:,1:PanelBS.shape[1]]/self.SeismicWeight,axis=1).tolist() + \
            np.sum(MFBS[:,1:MFBS.shape[1]]/self.SeismicWeight,axis=1).tolist()
            
        else: BR = np.asarray(np.sum(NodeBS[:,1:NodeBS.shape[1]]/self.SeismicWeight,axis=1).tolist()) + \
        np.sum(PanelBS[:,1:PanelBS.shape[1]]/self.SeismicWeight,axis=1).tolist()

        Results.append(np.abs(BR))
        
        SDRDirectory = PushoverDirectory + '\\StoryDrifts\\'
        os.chdir(SDRDirectory)
        DR = np.abs(np.loadtxt(r'LeaningColumn' + Direction + 'Drift.out'))
        DR = DR[0:idx,:]

        SDRs = []
        for i in range(1,int(self.NumStory)+1):
            SDRs.append(DR[:, 3*i])

        Results.append(SDRs)
            
        return Results
        
    def extractpushoverpoints(self, Direction):
        # peak base shear
        peakstrength = np.max(self.Pushover_Results[Direction][0])
        # roof drift @ peak base shear 
        peakstregth_idx = self.Pushover_Results[Direction][0].argmax()
        driftpeakstrength =self.Pushover_Results[Direction][1][-1][peakstregth_idx] 

        # strength increasing part
        elasticStrength =  self.Pushover_Results[Direction][0][0:peakstregth_idx]
        elasticDrift = self.Pushover_Results[Direction][1][-1][0:peakstregth_idx]
        # strength degradation part
        plasticStrength = self.Pushover_Results[Direction][0][peakstregth_idx : -1]
        plasticDrift = self.Pushover_Results[Direction][1][-1][peakstregth_idx : -1]
        
        # 20% of peak strength point
        proportion = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
        strength_array = []
        drift_array = []
        for i in proportion:
            idx = (np.abs(elasticStrength - i * peakstrength)).argmin()
            drift_array.append(elasticDrift[idx])
            strength_array.append(elasticStrength[idx])

        strength_array.append(peakstrength)
        drift_array.append(driftpeakstrength)
        
        # 20% of peak strength as residual strength
        # Don't use 0 because some cases may have residual drift
        proportion = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8]

        for i in proportion: 
            idx = (np.abs(plasticStrength - i * peakstrength)).argmin()
            drift_array.append(plasticDrift[idx])
            strength_array.append(plasticStrength[idx])
        
        idx = (np.abs(plasticStrength - peakstrength)).argmin()
        totalidx = peakstregth_idx + idx 
        area = np.trapz(self.Pushover_Results[Direction][0][0:totalidx], x = self.Pushover_Results[Direction][1][-1][0:totalidx])
        
        return peakstrength, driftpeakstrength, [drift_array, strength_array], area
    
