import numpy as np
import os 
import pandas as pd


class BuildingModel(object):

  def __init__(self, CaseID, BaseDirectory, SeismicDesignParameterFlag = True):
      self.ID = None
      self.numberOfStories = None
      self.storyHeights = None
      self.floorHeights = None

      self.floorMaximumXDimension = None
      self.floorMaximumZDimension = None
      self.floorAreas = None

      self.leaningColumnNodesOpenSeesTags = None
      self.leaningColumnNodesXCoordinates = None
      self.leaningColumnNodesZCoordinates = None

      self.numberOfXDirectionWoodPanels = None
      self.numberOfZDirectionWoodPanels = None

      self.XDirectionWoodPanelsXCoordinates = None
      self.XDirectionWoodPanelsZCoordinates = None
      self.ZDirectionWoodPanelsXCoordinates = None
      self.ZDirectionWoodPanelsZCoordinates = None
 
      self.XDirectionWoodPanelsBotTag = None
      self.XDirectionWoodPanelsTopTag = None
       
      self.ZDirectionWoodPanelsBotTag = None
      self.ZDirectionWoodPanelsTopTag = None

      self.floorWeights = None
      self.liveLoads = None
      self.leaningcolumnLoads = None
      self.PushoverParameter = None
      self.DynamicParameter = None

      self.MaterialProperty = None
      self.XPanelLength = None
      self.XPanelHeight = None
      self.XPanelMaterial = None

      self.ZPanelLength = None
      self.ZPanelHeight = None
      self.ZPanelMaterial = None

      self.XRetrofitFlag = None 
      self.ZRetrofitFlag = None
 
      self.NumXFrames = None
      self.XRetrofit = None
     
      self.NumZFrames = None
      self.ZRetrofit = None
          
      self.SeismicDesignParameter = None

  def read_in_txt_inputs(self, CaseID, BaseDirectory, SeismicDesignParameterFlag = True):
      
      self.ID = CaseID
        
##################################################################################################
# Read in Geometry
      os.chdir(BaseDirectory + '/Geometry')

      self.numberOfStories = np.genfromtxt('numberOfStories.txt').astype(int)
      self.storyHeights = np.genfromtxt('storyHeights.txt').tolist()
      self.floorHeights = np.cumsum(np.insert(self.storyHeights,0, 0))

      self.floorMaximumXDimension = np.genfromtxt('floorMaximumXDimension.txt')
      self.floorMaximumZDimension = np.genfromtxt('floorMaximumZDimension.txt')
      self.floorAreas = np.genfromtxt('floorAreas.txt')

      self.leaningColumnNodesOpenSeesTags = np.genfromtxt('leaningColumnNodesOpenSeesTags.txt').astype(int)
      self.leaningColumnNodesXCoordinates = np.genfromtxt('leaningColumnNodesXCoordinates.txt')
      self.leaningColumnNodesZCoordinates = np.genfromtxt('leaningColumnNodesZCoordinates.txt')

      self.numberOfXDirectionWoodPanels = np.genfromtxt('numberOfXDirectionWoodPanels.txt').astype(int)
      self.numberOfZDirectionWoodPanels = np.genfromtxt('numberOfZDirectionWoodPanels.txt').astype(int)

      self.XDirectionWoodPanelsXCoordinates = np.genfromtxt('XDirectionWoodPanelsXCoordinates.txt')
      self.XDirectionWoodPanelsZCoordinates = np.genfromtxt('XDirectionWoodPanelsZCoordinates.txt')
      self.ZDirectionWoodPanelsXCoordinates = np.genfromtxt('ZDirectionWoodPanelsXCoordinates.txt')
      self.ZDirectionWoodPanelsZCoordinates = np.genfromtxt('ZDirectionWoodPanelsZCoordinates.txt')

      temp1 = np.zeros([self.XDirectionWoodPanelsXCoordinates.shape[0],self.XDirectionWoodPanelsXCoordinates.shape[1]])
      temp2 = np.zeros([self.XDirectionWoodPanelsXCoordinates.shape[0],self.XDirectionWoodPanelsXCoordinates.shape[1]])

      temp3 = np.zeros([self.ZDirectionWoodPanelsZCoordinates.shape[0],self.ZDirectionWoodPanelsZCoordinates.shape[1]])
      temp4 = np.zeros([self.ZDirectionWoodPanelsZCoordinates.shape[0],self.ZDirectionWoodPanelsZCoordinates.shape[1]])

      for i in range (self.numberOfStories):
        for j in range(self.numberOfXDirectionWoodPanels[i]):    

          temp1[i,j] = (i+1)*10000+1000+(j+1)*10+1
          temp2[i,j] = (i+1)*10000+1000+(j+1)*10+2
      self.XDirectionWoodPanelsBotTag = temp1
      self.XDirectionWoodPanelsTopTag = temp2

      for i in range (self.numberOfStories):
        for j in range(self.numberOfZDirectionWoodPanels[i]):    

          temp3[i,j] = (i+1)*10000+3000+(j+1)*10+1
          temp4[i,j] = (i+1)*10000+3000+(j+1)*10+2        
      self.ZDirectionWoodPanelsBotTag = temp3
      self.ZDirectionWoodPanelsTopTag = temp4
          

##################################################################################################        
# Read in Loads
      os.chdir(BaseDirectory + '/Loads')
      self.floorWeights = np.genfromtxt('floorWeights.txt'); # (kips)
      self.liveLoads = np.genfromtxt('liveLoads.txt'); # (kips per square inch)
      self.leaningcolumnLoads = np.genfromtxt('leaningcolumnLoads .txt'); # (kips)

################################################################################################        
# Read in Pushover Analysis Parameters
      os.chdir(BaseDirectory + '/AnalysisParameters/StaticAnalysis')
      Increment = np.genfromtxt('PushoverIncrementSize.txt')
      XDriftLimit = np.genfromtxt('PushoverXDrift.txt')
      ZDriftLimit = np.genfromtxt('PushoverZDrift.txt')

      self.PushoverParameter = {'Increment': Increment,
                                'PushoverXDrift': XDriftLimit,
                                'PushoverZDrift': ZDriftLimit}

##################################################################################################        
# Read in Dynaimic Analysis Parameters
      os.chdir(BaseDirectory + '/AnalysisParameters/DynamicAnalysis')
      DriftLimit = np.genfromtxt('CollapseDriftLimit.txt')
      DemolitionLimit = np.genfromtxt('DemolitionDriftLimit.txt')

      with open('dampingModel.txt', 'r') as myfile:
        dampingModel = myfile.read()  #For now, just use Rayleigh damping
      dampingRatio = np.genfromtxt('dampingRatio.txt')

      self.DynamicParameter = {'CollapseLimit': DriftLimit,
                               'DemolitionLimit': DemolitionLimit,
                               'DampingModel': dampingModel,
                               'DampingRatio':dampingRatio}
        
##################################################################################################        
# Read in Structural Material Property
      os.chdir(BaseDirectory + '/StructuralProperties/Pinching4Materials')

      # For now, Pinching4 material is used
      MaterialLabel = np.genfromtxt('materialNumber.txt')
      d1 = np.genfromtxt('d1.txt')
      d2 = np.genfromtxt('d2.txt')
      d3 = np.genfromtxt('d3.txt')
      d4 = np.genfromtxt('d4.txt')

      f1 = np.genfromtxt('f1.txt')
      f2 = np.genfromtxt('f2.txt')
      f3 = np.genfromtxt('f3.txt')
      f4 = np.genfromtxt('f4.txt')

      gD1 = np.genfromtxt('gD1.txt')
      gDlim = np.genfromtxt('gDlim.txt')

      gK1 = np.genfromtxt('gK1.txt')
      gKlim = np.genfromtxt('gKlim.txt')

      rDisp = np.genfromtxt('rDisp.txt')
      rForce = np.genfromtxt('rForce.txt')
      uForce = np.genfromtxt('uForce.txt')

      self.MaterialProperty = {'MaterialLabel': MaterialLabel,
                               'd1': d1,
                               'd2': d2,
                               'd3': d3,
                               'd4': d4,
                               'f1': f1,
                               'f2': f2,
                               'f3': f3,
                               'f4': f4,
                               'gD1': gD1,
                               'gDlim': gDlim,
                               'gK1': gK1,
                               'gKlim': gKlim,
                               'rDisp': rDisp,
                               'rForce': rForce,
                               'uForce': uForce}
                            
##################################################################################################        
# Read in Structural Panel Property
      os.chdir(BaseDirectory + '/StructuralProperties/XWoodPanels')
      self.XPanelLength = np.genfromtxt('length.txt')
      self.XPanelHeight = np.genfromtxt('height.txt')
      self.XPanelMaterial = np.genfromtxt('Pinching4MaterialNumber.txt')

      os.chdir(BaseDirectory + '/StructuralProperties/ZWoodPanels')
      self.ZPanelLength = np.genfromtxt('length.txt')
      self.ZPanelHeight = np.genfromtxt('height.txt')
      self.ZPanelMaterial = np.genfromtxt('Pinching4MaterialNumber.txt')  

        
##################################################################################################        
# Read in Retrofitted Frame Info
      os.chdir(BaseDirectory + '/FrameRetrofit')
      self.XRetrofitFlag = np.loadtxt('IndicateFrameXRetrofit.txt') 
      self.ZRetrofitFlag = np.loadtxt('IndicateFrameZRetrofit.txt')  
        
      if self.XRetrofitFlag:
        os.chdir('XMomentFrames')
        self.NumXFrames = np.loadtxt('numberOfXFrames.txt')
        self.XRetrofit = self.extractRetrofitFrameInfo(BaseDirectory + '/FrameRetrofit/XMomentFrames', self.NumXFrames)
      else: self.XRetrofit = None
        
      if self.ZRetrofitFlag:
        os.chdir('XMomentFrames')
        self.NumZFrames = np.loadtxt('numberOfZFrames.txt')
        self.ZRetrofit = self.extractRetrofitFrameInfo(BaseDirectory + '/FrameRetrofit/XMomentFrames', self.NumZFrames)
        
      else: self.ZRetrofit = None
          
##################################################################################################
# Define read in Seismic Design Parameter 
# Seismic design parameter calculation follows ASCE 7-10 Chapter 12
# In current wood frame building models, only used in defining pushover loading protocal 
      os.chdir(BaseDirectory + '/SeismicDesignParameters')
      if SeismicDesignParameterFlag == 0: 
        self.SeismicDesignParameter = None

      else:
        with open('SiteClass.txt', 'r') as myfile:
          site_class = myfile.read()  
        Ss = np.genfromtxt('Ss.txt')
        S1 = np.genfromtxt('S1.txt')
        Fa = self.determine_Fa_coefficient(site_class, Ss)
        Fv = self.determine_Fv_coefficient(site_class, S1)
        SMS, SM1, SDS, SD1 = self.calculate_DBE_acceleration(Ss, S1, Fa, Fv)
        Cu = self.determine_Cu_coefficient(SD1)
        R = np.genfromtxt('R.txt')
        Ie = np.genfromtxt('I.txt')
        TL = np.genfromtxt('TL.txt')
        x = 0.75 # for 'All other structural systems' specified in ASCE 7-16 Table 12.8-2
        Ct = 0.02 # for 'All other structural systems' specified in ASCE 7-16 Table 12.8-2
        hn = sum(self.storyHeights)/12 # transfer unit to ft
        Tu = Cu*Ct*hn**x # Pay attention to the differences between ASCE and FEMA, here use upper bound period specified per ASCE 7-16 as code estimated period in the following calculation
        Cs = self.calculate_Cs_coefficient(SDS, SD1, S1, Tu, TL, R, Ie)
        k = self.determine_k_coeficient(Tu)
        TotalWeight = sum(self.floorWeights)
        Cvx = self.calculate_Cvx(TotalWeight * Cs, self.floorWeights, self.floorHeights, k)
        self.SeismicDesignParameter = {'Ss': Ss,
                                       'S1': S1,
                                       'Fa': Fa,
                                       'Fv': Fv,
                                       'SMS': SMS,
                                       'SM1': SM1,
                                       'SDS': SDS,
                                       'SD1': SD1,
                                       'Cu': Cu,
                                       'R': R,
                                       'Ie': Ie,
                                       'TL': TL,
                                       'x': x,
                                       'Ct': Ct,
                                       'Tu': Tu,
                                       'Cs': Cs,
                                       'ELF Base Shear': TotalWeight * Cs,
                                       'Cvx': Cvx
                                      }
        
  def determine_Fa_coefficient(self, site_class, Ss):
      """
      This function is used to determine Fa coefficient, which is based on ASCE 7-10 Table 11.4-1
      :param Ss: a scalar given in building class
      :param site_class: a string: 'A', 'B', 'C', 'D', or 'E' given in building information
      :return: a scalar which is Fa coefficient
      """
      if site_class == 'A':
          Fa = 0.8
      elif site_class == 'B':
          Fa = 1.0
      elif site_class == 'C':
          if Ss <= 0.5:
              Fa = 1.2
          elif Ss <= 1.0:
              Fa = 1.2 - 0.4*(Ss - 0.5)
          else:
              Fa = 1.0
      elif site_class == 'D':
          if Ss <= 0.25:
              Fa = 1.6
          elif Ss <= 0.75:
              Fa = 1.6 - 0.8*(Ss - 0.25)
          elif Ss <= 1.25:
              Fa = 1.2 - 0.4*(Ss - 0.75)
          else:
              Fa = 1.0
      elif site_class == 'E':
          if Ss <= 0.25:
              Fa = 2.5
          elif Ss <= 0.5:
              Fa = 2.5 - 3.2*(Ss - 0.25)
          elif Ss <= 0.75:
              Fa = 1.7 - 2.0*(Ss - 0.5)
          elif Ss <= 1.0:
              Fa = 1.2 - 1.2*(Ss - 0.75)
          else:
              Fa = 0.9
      else:
          Fa = None
          print("Site class is entered with an invalid value")

      return Fa  

  def determine_Fv_coefficient(self, site_class, S1):
      """
      This function is used to determine Fv coefficient, which is based on ASCE 7-10 Table 11.4-2
      :param S1: a scalar given in building class
      :param site_class: a string 'A', 'B', 'C', 'D' or 'E' given in building class
      :return: a scalar which is Fv coefficient
      """
      if site_class == 'A':
          Fv = 0.8
      elif site_class == 'B':
          Fv = 1.0
      elif site_class == 'C':
          if S1 <= 0.1:
              Fv = 1.7
          elif S1 <= 0.5:
              Fv = 1.7 - 1.0*(S1 - 0.1)
          else:
              Fv = 1.3
      elif site_class == 'D':
          if S1 <= 0.1:
              Fv = 2.4
          elif S1 <= 0.2:
              Fv = 2.4 - 4*(S1 - 0.1)
          elif S1 <= 0.4:
              Fv = 2.0 - 2*(S1 - 0.2)
          elif S1 <= 0.5:
              Fv = 1.6 - 1*(S1 - 0.4)
          else:
              Fv = 1.5
      elif site_class == 'E':
          if S1 <= 0.1:
              Fv = 3.5
          elif S1 <= 0.2:
              Fv = 3.5 - 3*(S1 - 0.1)
          elif S1 <= 0.4:
              Fv = 3.2 - 4*(S1 - 0.2)
          else:
              Fv = 2.4
      else:
          Fv = None
          print("Site class is entered with an invalid value")

      return Fv

  def calculate_DBE_acceleration(self, Ss, S1, Fa, Fv):
      """
      This function is used to calculate design spectrum acceleration parameters,
      which is based ASCE 7-10 Section 11.4
      Note: All notations for these variables can be found in ASCE 7-10.
      :param Ss: a scalar given in building information (problem statement)
      :param S1: a scalar given in building information (problem statement)
      :param Fa: a scalar computed from determine_Fa_coefficient
      :param Fv: a scalar computed from determine_Fv_coefficient
      :return: SMS, SM1, SDS, SD1: four scalars which are required for lateral force calculation
      """
      SMS = Fa * Ss
      SM1 = Fv * S1
      SDS = 2/3 * SMS
      SD1 = 2/3 * SM1
      return SMS, SM1, SDS, SD1


  def determine_Cu_coefficient(self, SD1):
      """
      This function is used to determine Cu coefficient, which is based on ASCE 7-10 Table 12.8-1
      Note: All notations for these variables can be found in ASCE 7-10.
      :param SD1: a scalar calculated from funtion determine_DBE_acceleration
      :return: Cu: a scalar
      """
      if SD1 <= 0.1:
          Cu = 1.7
      elif SD1 <= 0.15:
          Cu = 1.7 - 2 * (SD1 - 0.1)
      elif SD1 <= 0.2:
          Cu = 1.6 - 2 * (SD1 - 0.15)
      elif SD1 <= 0.3:
          Cu = 1.5 - 1 * (SD1 - 0.2)
      elif SD1 <= 0.4:
          Cu = 1.4
      else:
          Cu = 1.4

      return Cu

  def calculate_Cs_coefficient(self, SDS, SD1, S1, T, TL, R, Ie):
      """
      This function is used to calculate the seismic response coefficient based on ASCE 7-10 Section 12.8.1
      Unit: kips, g (gravity constant), second
      Note: All notations for these variables can be found in ASCE 7-10.
      :param SDS: a scalar determined using Equation 11.4-3; output from "calculate_DBE_acceleration" function
      :param SD1: a scalar determined using Equation 11.4-4; output from "calculate_DBE_acceleration" function
      :param S1: a scalar given in building information (problem statement)
      :param T: building period; a scalar determined using Equation 12.8-1 and Cu;
                implemented in "BuildingInformation" object attribute.
      :param TL: long-period transition
      :param R: a scalar given in building information
      :param Ie: a scalar given in building information
      :return: Cs: seismic response coefficient; determined using Equations 12.8-2 to 12.8-6
      """
      # Equation 12.8-2
      Cs_initial = SDS/(R/Ie)

      # Equation 12.8-3 or 12.8-4, Cs coefficient should not exceed the following value
      if T <= TL:
          Cs_upper = SD1/(T * (R/Ie))
      else:
          Cs_upper = SD1 * TL/(T ** 2 * (R/Ie))

      # Equation 12.8-2 results shall be smaller than upper bound of Cs
      if Cs_initial <= Cs_upper:
          Cs = Cs_initial
      else:
          Cs = Cs_upper

      # Equation 12.8-5, Cs shall not be less than the following value
      Cs_lower_1 = np.max([0.044*SDS*Ie, 0.01])

      # Compare the Cs value with lower bound
      if Cs >= Cs_lower_1:
          pass
      else:
          Cs = Cs_lower_1

      # Equation 12.8-6. if S1 is equal to or greater than 0.6g, Cs shall not be less than the following value
      if S1 >= 0.6:
          Cs_lower_2 = 0.5*S1/(R/Ie)
          if Cs >= Cs_lower_2:
              pass
          else:
              Cs = Cs_lower_2
      else:
          pass

      return Cs

  def determine_k_coeficient(self, period):
      """
      This function is used to determine the coefficient k based on ASCE 7-10 Section 12.8.3
      :param period: building period;
      :return: k: a scalar will be used in Equation 12.8-12 in ASCE 7-10
      """
      if period <= 0.5:
          k = 1
      elif period >= 2.5:
          k = 2
      else:
          k = 1 + 0.5*(period - 0.5)

      return k  

  def calculate_Cvx(self, base_shear, floor_weight, floor_height, k):
      """
      This function is used to calculate the seismic story force for each floor level
      Unit: kip, foot
      :param base_shear: a scalar, total base shear for the building
      :param floor_weight: a vector with a length of number_of_story
      :param floor_height: a vector with a length of (number_of_story+1)
      :param k: a scalar given by "determine_k_coefficient"
      :return: Fx: a vector describes the lateral force for each floor level
      """
      # Calculate the product of floor weight and floor height
      # Note that floor height includes ground floor, which will not be used in the actual calculation.
      # Ground floor is stored here for completeness.
      weight_floor_height = np.multiply(floor_weight , floor_height[1:]**k)
      # Equation 12.8-12 in ASCE 7-10
      Cvx = weight_floor_height/np.sum(weight_floor_height)
      return Cvx       

  def extractRetrofitFrameInfo(self, FrameInfoDirectory, numFrames):
      FrameInfo = []
      
      for i in range(int(numFrames)):
        # go into the directory containing the information of each frame 
        os.chdir(FrameInfoDirectory + '/Frame%i'%(i+1))
        
        BeamSection = []
        with open('BeamSection.txt','rb') as f:
            for line in f:
                BeamSection.append(line.decode().strip())

        ColSection = []
        with open('ColumnSection.txt','rb') as f:
            for line in f:
                ColSection.append(line.decode().strip())
                
        os.chdir(FrameInfoDirectory + '/Frame%i/FrameNodes'%(i+1))
        BeamHingeCoor = np.loadtxt('BeamHingeNodeCoordinates.txt').tolist()
        BeamHingeOSLabel = np.loadtxt('BeamHingeNodeNumbers.txt').tolist()
        ColHingeCoor = np.loadtxt('ColumnHingeNodeCoordinates.txt').tolist()
        ColHingeOSLabel = np.loadtxt('ColumnHingeNodeNumbers.txt').tolist()
        JointCoor = np.loadtxt('JointNodeCoordinates.txt').tolist()
        JointOSLabel = np.loadtxt('JointNodeNumbers.txt').tolist()
        
        SingleFrameInfo = {'BeamSection': BeamSection,
                          'ColSection': ColSection,
                          'BeamHingeCoor': BeamHingeCoor,
                          'BeamHingeOSLabel': BeamHingeOSLabel,
                          'ColHingeCoor': ColHingeCoor,
                          'ColHingeOSLabel': ColHingeOSLabel,
                          'JointCoor': JointCoor,
                          'JointOSLabel' : JointOSLabel}
        
        FrameInfo.append(SingleFrameInfo)
        
      return FrameInfo



