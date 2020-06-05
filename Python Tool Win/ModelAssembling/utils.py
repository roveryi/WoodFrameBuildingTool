import numpy as np 
import os 
import pandas as pd
import json
from distutils.dir_util import copy_tree
from win32api import ShellExecute

def defineNodes3DModel(ModelDirectory, BuildingModel):
  
  os.chdir(ModelDirectory)
  
  with open('DefineNodes3DModel.tcl', 'w') as tclfile:
    tclfile.write("# This file will be used to define all nodes \n")  # Introduce the file usage
    tclfile.write("# Units: inch\n\n\n")  # Explain the units

    tclfile.write("# Define x-direction wood panel nodes\n")
      
    for i in range (1, BuildingModel.numberOfStories+1):
      tclfile.write("# Story %i \n"%i)

      for j in range(1, BuildingModel.numberOfXDirectionWoodPanels[i-1]+1):

        Tag = i*10000+1000+j*10+1
        tclfile.write('node \t %i \t %.3f \t %.3f \t %.3f; \n'%(BuildingModel.XDirectionWoodPanelsBotTag[i-1,j-1],
                                                                BuildingModel.XDirectionWoodPanelsXCoordinates[i-1,j-1],
                                                                BuildingModel.floorHeights[i-1],
                                                                BuildingModel.XDirectionWoodPanelsZCoordinates[i-1,j-1]))

        Tag = i*10000+1000+j*10+2
        tclfile.write('node \t %i \t %.3f \t %.3f \t %.3f; \n'%(BuildingModel.XDirectionWoodPanelsTopTag[i-1,j-1],
                                                    BuildingModel.XDirectionWoodPanelsXCoordinates[i-1,j-1],
                                                    BuildingModel.floorHeights[i],
                                                    BuildingModel.XDirectionWoodPanelsZCoordinates[i-1,j-1]))

    tclfile.write('puts "x-direction wood panel nodes defined"\n\n')

    tclfile.write('# Define z-direction wood panel nodes \n')

    for i in range (1, BuildingModel.numberOfStories+1):
      tclfile.write("# Story %i \n"%i)

      for j in range(1, BuildingModel.numberOfZDirectionWoodPanels[i-1]+1):

        # Bottom tag
        Tag = i*10000+3000+j*10+1
        tclfile.write('node \t %i \t %.3f \t %.3f \t %.3f; \n'%(BuildingModel.ZDirectionWoodPanelsBotTag[i-1,j-1],
                                                                BuildingModel.ZDirectionWoodPanelsXCoordinates[i-1,j-1],
                                                                BuildingModel.floorHeights[i-1],
                                                                BuildingModel.ZDirectionWoodPanelsZCoordinates[i-1,j-1]))

        Tag = i*10000+3000+j*10+2
        tclfile.write('node \t %i \t %.3f \t %.3f \t %.3f; \n'%(BuildingModel.ZDirectionWoodPanelsTopTag[i-1,j-1],
                                                                BuildingModel.ZDirectionWoodPanelsXCoordinates[i-1,j-1],
                                                                BuildingModel.floorHeights[i],
                                                                BuildingModel.ZDirectionWoodPanelsZCoordinates[i-1,j-1]))

    tclfile.write('puts "z-direction wood panel nodes defined" \n\n')
    
    tclfile.write('# Define main leaning column nodes \n')

    NumLeaningCol = BuildingModel.leaningColumnNodesOpenSeesTags.shape[1]

    for j in range(NumLeaningCol):
      for i in range(1, BuildingModel.numberOfStories+2):

        tclfile.write('node \t %i \t %.3f \t %.3f \t %.3f; \n'%(BuildingModel.leaningColumnNodesOpenSeesTags[i-1,j],
                                                                BuildingModel.leaningColumnNodesXCoordinates[i-1,j],
                                                                BuildingModel.floorHeights[i-1],
                                                                BuildingModel.leaningColumnNodesZCoordinates[i-1,j]))
      tclfile.write('\n')
      
    tclfile.write('puts "main leaning column nodes defined" \n\n')
   
    tclfile.write('# Define leaning column top nodes for zero length springs \n')
    for j in range(NumLeaningCol):
      for i in range(1, BuildingModel.numberOfStories+1):
        tclfile.write('node \t %i \t %.3f \t %.3f \t %.3f; \n'%(BuildingModel.leaningColumnNodesOpenSeesTags[i-1,j]+1,
                                                             BuildingModel.leaningColumnNodesXCoordinates[i-1,j],
                                                             BuildingModel.floorHeights[i-1],
                                                             BuildingModel.leaningColumnNodesZCoordinates[i-1,j]))
      tclfile.write('\n')

    tclfile.write('# Define leaning column bottom nodes for zero length springs \n')

    for j in range(NumLeaningCol):
      for i in range(2, BuildingModel.numberOfStories+2):
        tclfile.write('node \t %i \t %.3f \t %.3f \t %.3f; \n'%(BuildingModel.leaningColumnNodesOpenSeesTags[i-1,j]+2,
                                                             BuildingModel.leaningColumnNodesXCoordinates[i-1,j],
                                                             BuildingModel.floorHeights[i-1],
                                                             BuildingModel.leaningColumnNodesZCoordinates[i-1,j]))
      tclfile.write('\n')
    tclfile.write('puts "Leaning column nodes for zero length spring defined"')
      
      
      
      
def defineRigidFloorDiaphragm3DModel(ModelDirectory, BuildingModel):
  os.chdir(ModelDirectory)
  
  with open('DefineRigidFloorDiaphragm3DModel.tcl', 'w') as tclfile:
    
    tclfile.write("# This file will be used to define the rigid floor diaphragm properties \n")  # Introduce the file usage
    
    tclfile.write("\n # Setting rigid floor diaphragm constraint con")
    tclfile.write("\nset RigidDiaphragm ON; \n")
    
    tclfile.write("\n # Define Rigid Diaphragm,dof 2 is normal to floor")
    tclfile.write("\nset perpDirn 2; \n\n")
    
    for i in range(1, BuildingModel.numberOfStories+1):
      tclfile.write('rigidDiaphragm $perpDirn')

      # Leaning column top nodes of story i
      for ii in range(BuildingModel.leaningColumnNodesOpenSeesTags.shape[1]):
        tclfile.write('\t %i' %BuildingModel.leaningColumnNodesOpenSeesTags[i, ii])

      # All top nodes of story i
      for j in range(BuildingModel.numberOfXDirectionWoodPanels[i-1]):
        tclfile.write('\t %i' %BuildingModel.XDirectionWoodPanelsTopTag[i-1,j])

      for j in range(BuildingModel.numberOfZDirectionWoodPanels[i-1]):
        tclfile.write('\t %i' %BuildingModel.ZDirectionWoodPanelsTopTag[i-1,j])

      # All bottom nodes of story i+1
      if i < BuildingModel.numberOfStories:
        for j in range(BuildingModel.numberOfXDirectionWoodPanels[i]):
          tclfile.write('\t %i' %BuildingModel.XDirectionWoodPanelsBotTag[i,j])

        for j in range(BuildingModel.numberOfZDirectionWoodPanels[i]):
          tclfile.write('\t %i' %BuildingModel.ZDirectionWoodPanelsBotTag[i,j])    
          
      tclfile.write('\n')
      
    tclfile.write('\nputs "rigid diaphragm constraints defined"')
                                                                
                                                                
                                                                
                                                                
def defineFixities3DModel(ModelDirectory, BuildingModel):
  os.chdir(ModelDirectory)
  
  with open('DefineFixities3DModel.tcl', 'w') as tclfile:
    tclfile.write('# This file will be used to define all fixities; \n\n')
    tclfile.write('# Defining fixity at x-direction wood panel nodes \n')

    for i in range(BuildingModel.numberOfStories):
      tclfile.write('# Story %i \n' %(i+1))

      for j in range(BuildingModel.numberOfXDirectionWoodPanels[i]):
        tclfile.write('fix\t%i\t'%(BuildingModel.XDirectionWoodPanelsBotTag[i,j]))

        if i == 0:
          tclfile.write('%i\t%i\t%i\t%i\t%i\t%i;\n'%(1,1,1,1,1,1)) # Bottom nodes at first story are fixed 
        else: tclfile.write('%i\t%i\t%i\t%i\t%i\t%i;\n'%(0,1,0,1,0,1))

        tclfile.write('fix\t%i\t%i\t%i\t%i\t%i\t%i\t%i;\n'%(BuildingModel.XDirectionWoodPanelsTopTag[i,j],0,1,0,1,0,1))

    tclfile.write('puts "fixities at x-direction wood panel nodes defined" \n')

    tclfile.write('# Defining fixity at z-direction wood panel nodes \n')
    for i in range(BuildingModel.numberOfStories):
      tclfile.write('# Story %i \n' %(i+1))

      for j in range(BuildingModel.numberOfZDirectionWoodPanels[i]):
        tclfile.write('fix\t%i\t'%(BuildingModel.ZDirectionWoodPanelsBotTag[i,j]))

        if i == 0:
          tclfile.write('%i\t%i\t%i\t%i\t%i\t%i;\n'%(1,1,1,1,1,1)) # Bottom nodes at first story are fixed 
        else: tclfile.write('%i\t%i\t%i\t%i\t%i\t%i;\n'%(0,1,0,1,0,1))

        tclfile.write('fix\t%i\t%i\t%i\t%i\t%i\t%i\t%i;\n'%(BuildingModel.ZDirectionWoodPanelsTopTag[i,j],0,1,0,1,0,1))

    tclfile.write('puts "fixities at z-direction wood panel nodes defined" \n')


    tclfile.write('# Defining fixity at leaning column nodes \n')

    for j in range(BuildingModel.leaningColumnNodesOpenSeesTags.shape[1]):
      for i in range(BuildingModel.numberOfStories+1):

        tclfile.write('fix\t%i\t'%(BuildingModel.leaningColumnNodesOpenSeesTags[i,j]))

        if i == 0:
          tclfile.write('%i\t%i\t%i\t%i\t%i\t%i;\n'%(1,1,1,1,1,1)) # Bottom nodes at first story are fixed 
        else: tclfile.write('%i\t%i\t%i\t%i\t%i\t%i;\n'%(0,0,0,1,0,1))

    tclfile.write('puts "fixities at leaning column nodes defined" \n')
    
    
    
def defineWoodPanels3DModel(ModelDirectory, BuildingModel):
  os.chdir(ModelDirectory)
  
  with open('DefineWoodPanels3DModel.tcl', 'w') as tclfile:

    tclfile.write('# This file will be used to define wood panel elements \n\n')

    WoodPanelMaterialTag = 600000
    WoodPanelElementTag = 700000

    tclfile.write('# Define x-direction wood panels \n')
    for i in range(BuildingModel.numberOfStories):
      tclfile.write('# Story %i \n'%(i+1))

      for j in range(BuildingModel.numberOfXDirectionWoodPanels[i]):

        tclfile.write('# X-Direction Story %i Panel %i \n'%(i+1,j+1))

        tclfile.write('element twoNodeLink\t%i\t%i\t%i\t-mat\t%i\t-dir\t%i\t-orient\t%i\t%i\t%i\t-doRayleigh;\n'
                      %(WoodPanelElementTag, BuildingModel.XDirectionWoodPanelsBotTag[i,j], BuildingModel.XDirectionWoodPanelsTopTag[i,j], WoodPanelMaterialTag,2,1,0,0))
        WoodPanelElementTag += 1
        WoodPanelMaterialTag += 1

    tclfile.write('puts "x-direction wood panels defined" \n\n')

    tclfile.write('# Define z-direction wood panels \n')
    for i in range(BuildingModel.numberOfStories):
      tclfile.write('# Story %i \n'%(i+1))

      for j in range(BuildingModel.numberOfZDirectionWoodPanels[i]):

        tclfile.write('# Z-Direction Story %i Panel %i \n'%(i+1,j+1))

        tclfile.write('element twoNodeLink\t%i\t%i\t%i\t-mat\t%i\t-dir\t%i\t-orient\t%i\t%i\t%i\t-doRayleigh;\n'
                      %(WoodPanelElementTag, BuildingModel.ZDirectionWoodPanelsBotTag[i,j], BuildingModel.ZDirectionWoodPanelsTopTag[i,j], WoodPanelMaterialTag,3,1,0,0))
        WoodPanelElementTag += 1
        WoodPanelMaterialTag += 1

    tclfile.write('puts "z-direction wood panels defined" \n\n')
    
    
def defineWoodPanelMaterials3DModel(ModelDirectory, BuildingModel):
  os.chdir(ModelDirectory)
  
  with open('DefineWoodPanelMaterials3DModel.tcl', 'w') as tclfile:
    
    tclfile.write('# This file will be used to define wood panel material models \n\n')

    WoodPanelMaterialTag = 600000
    OuterWoodPanelMaterialTag = 610000
    InnerWoodPanelMaterialTag = 620000

    tclfile.write('# Define x-direction wood panel materials \n')

    for i in range(BuildingModel.numberOfStories):
      tclfile.write('# Story %i \n' %(i+1))
      for j in range(BuildingModel.numberOfXDirectionWoodPanels[i]):

        tclfile.write('# X-Direction Story %i Panel %i \n'%(i+1,j+1))

        tclfile.write('set\tXOuterWoodPanelMatStory%iPanel%i\t%i;\n'%(i+1,j+1,OuterWoodPanelMaterialTag))
        tclfile.write('set\tp1OuterWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['f1'][int(BuildingModel.XPanelMaterial[2*i,j]-1)]))
        tclfile.write('set\td1OuterWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['d1'][int(BuildingModel.XPanelMaterial[2*i,j]-1)]))
        tclfile.write('set\tp2OuterWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['f2'][int(BuildingModel.XPanelMaterial[2*i,j]-1)]))
        tclfile.write('set\td2OuterWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['d2'][int(BuildingModel.XPanelMaterial[2*i,j]-1)]))
        tclfile.write('set\tp3OuterWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['f3'][int(BuildingModel.XPanelMaterial[2*i,j]-1)]))
        tclfile.write('set\td3OuterWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['d3'][int(BuildingModel.XPanelMaterial[2*i,j]-1)]))
        tclfile.write('set\tp4OuterWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['f4'][int(BuildingModel.XPanelMaterial[2*i,j]-1)]))
        tclfile.write('set\td4OuterWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['d4'][int(BuildingModel.XPanelMaterial[2*i,j]-1)]))

        tclfile.write('set\trDispOuterWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['rDisp'][int(BuildingModel.XPanelMaterial[2*i,j]-1)]))
        tclfile.write('set\trForceOuterWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['rForce'][int(BuildingModel.XPanelMaterial[2*i,j]-1)]))
        tclfile.write('set\tuForceOuterWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['uForce'][int(BuildingModel.XPanelMaterial[2*i,j]-1)]))
        tclfile.write('set\tgammaD1OuterWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['gD1'][int(BuildingModel.XPanelMaterial[2*i,j]-1)]))
        tclfile.write('set\tgDlimOuterWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['gDlim'][int(BuildingModel.XPanelMaterial[2*i,j]-1)]))
        tclfile.write('set\tgammaK1OuterWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['gK1'][int(BuildingModel.XPanelMaterial[2*i,j]-1)]))
        tclfile.write('set\tgKlimOuterWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['gKlim'][int(BuildingModel.XPanelMaterial[2*i,j]-1)]))

        tclfile.write('set\tdam\t"energy";\n')
        tclfile.write('set\twallLengthWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.XPanelLength[i,j]))
        tclfile.write('set\twallHeightWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.XPanelHeight[i,j]))

        tclfile.write('%s\t'%('procUniaxialPinching'))
        tclfile.write('%s\t'%('$XOuterWoodPanelMatStory%iPanel%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$p1OuterWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$d1OuterWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$p2OuterWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$d2OuterWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$p3OuterWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$d3OuterWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$p4OuterWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$d4OuterWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$rDispOuterWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$rForceOuterWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$uForceOuterWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$gammaD1OuterWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$gDlimOuterWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$gammaK1OuterWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$gKlimOuterWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$dam'))
        tclfile.write('%s\t'%('$wallLengthWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s;\n'%('$wallHeightWoodPanelMatStory%iPier%i'%(i+1,j+1)))

        OuterWoodPanelMaterialTag += 1

        tclfile.write('set\tXInnerWoodPanelMatStory%iPanel%i\t%i;\n'%(i+1,j+1,InnerWoodPanelMaterialTag))
        tclfile.write('set\tp1InnerWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['f1'][int(BuildingModel.XPanelMaterial[2*i+1,j]-1)]))
        tclfile.write('set\td1InnerWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['d1'][int(BuildingModel.XPanelMaterial[2*i+1,j]-1)]))
        tclfile.write('set\tp2InnerWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['f2'][int(BuildingModel.XPanelMaterial[2*i+1,j]-1)]))
        tclfile.write('set\td2InnerWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['d2'][int(BuildingModel.XPanelMaterial[2*i+1,j]-1)]))
        tclfile.write('set\tp3InnerWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['f3'][int(BuildingModel.XPanelMaterial[2*i+1,j]-1)]))
        tclfile.write('set\td3InnerWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['d3'][int(BuildingModel.XPanelMaterial[2*i+1,j]-1)]))
        tclfile.write('set\tp4InnerWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['f4'][int(BuildingModel.XPanelMaterial[2*i+1,j]-1)]))
        tclfile.write('set\td4InnerWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['d4'][int(BuildingModel.XPanelMaterial[2*i+1,j]-1)]))

        tclfile.write('set\trDispInnerWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['rDisp'][int(BuildingModel.XPanelMaterial[2*i+1,j]-1)]))
        tclfile.write('set\trForceInnerWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['rForce'][int(BuildingModel.XPanelMaterial[2*i+1,j]-1)]))
        tclfile.write('set\tuForceInnerWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['uForce'][int(BuildingModel.XPanelMaterial[2*i+1,j]-1)]))
        tclfile.write('set\tgammaD1InnerWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['gD1'][int(BuildingModel.XPanelMaterial[2*i+1,j]-1)]))
        tclfile.write('set\tgDlimInnerWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['gDlim'][int(BuildingModel.XPanelMaterial[2*i+1,j]-1)]))
        tclfile.write('set\tgammaK1InnerWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['gK1'][int(BuildingModel.XPanelMaterial[2*i+1,j]-1)]))
        tclfile.write('set\tgKlimInnerWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['gKlim'][int(BuildingModel.XPanelMaterial[2*i+1,j]-1)]))

        tclfile.write('set\tdam\t"energy";\n')
        tclfile.write('set\twallLengthWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.XPanelLength[i,j]))
        tclfile.write('set\twallHeightWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.XPanelHeight[i,j]))

        tclfile.write('%s\t'%('procUniaxialPinching'))
        tclfile.write('%s\t'%('$XInnerWoodPanelMatStory%iPanel%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$p1InnerWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$d1InnerWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$p2InnerWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$d2InnerWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$p3InnerWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$d3InnerWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$p4InnerWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$d4InnerWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$rDispInnerWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$rForceInnerWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$uForceInnerWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$gammaD1InnerWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$gDlimInnerWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$gammaK1InnerWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$gKlimInnerWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$dam'))
        tclfile.write('%s\t'%('$wallLengthWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s;\n'%('$wallHeightWoodPanelMatStory%iPier%i'%(i+1,j+1)))

        InnerWoodPanelMaterialTag += 1    
    tclfile.write('puts "x-direction wood panel nodes defined" \n\n')

    tclfile.write('# Define z-direction wood panel materials \n')

    for i in range(BuildingModel.numberOfStories):
      tclfile.write('# Story %i \n' %(i+1))
      for j in range(BuildingModel.numberOfZDirectionWoodPanels[i]):

        tclfile.write('# Z-Direction Story %i Panel %i \n'%(i+1,j+1))

        tclfile.write('set\tZOuterWoodPanelMatStory%iPanel%i\t%i;\n'%(i+1,j+1,OuterWoodPanelMaterialTag))
        tclfile.write('set\tp1OuterWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['f1'][int(BuildingModel.ZPanelMaterial[2*i,j]-1)]))
        tclfile.write('set\td1OuterWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['d1'][int(BuildingModel.ZPanelMaterial[2*i,j]-1)]))
        tclfile.write('set\tp2OuterWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['f2'][int(BuildingModel.ZPanelMaterial[2*i,j]-1)]))
        tclfile.write('set\td2OuterWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['d2'][int(BuildingModel.ZPanelMaterial[2*i,j]-1)]))
        tclfile.write('set\tp3OuterWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['f3'][int(BuildingModel.ZPanelMaterial[2*i,j]-1)]))
        tclfile.write('set\td3OuterWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['d3'][int(BuildingModel.ZPanelMaterial[2*i,j]-1)]))
        tclfile.write('set\tp4OuterWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['f4'][int(BuildingModel.ZPanelMaterial[2*i,j]-1)]))
        tclfile.write('set\td4OuterWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['d4'][int(BuildingModel.ZPanelMaterial[2*i,j]-1)]))

        tclfile.write('set\trDispOuterWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['rDisp'][int(BuildingModel.ZPanelMaterial[2*i,j]-1)]))
        tclfile.write('set\trForceOuterWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['rForce'][int(BuildingModel.ZPanelMaterial[2*i,j]-1)]))
        tclfile.write('set\tuForceOuterWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['uForce'][int(BuildingModel.ZPanelMaterial[2*i,j]-1)]))
        tclfile.write('set\tgammaD1OuterWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['gD1'][int(BuildingModel.ZPanelMaterial[2*i,j]-1)]))
        tclfile.write('set\tgDlimOuterWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['gDlim'][int(BuildingModel.ZPanelMaterial[2*i,j]-1)]))
        tclfile.write('set\tgammaK1OuterWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['gK1'][int(BuildingModel.ZPanelMaterial[2*i,j]-1)]))
        tclfile.write('set\tgKlimOuterWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['gKlim'][int(BuildingModel.ZPanelMaterial[2*i,j]-1)]))

        tclfile.write('set\tdam\t"energy";\n')
        tclfile.write('set\twallLengthWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.ZPanelLength[i,j]))
        tclfile.write('set\twallHeightWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.ZPanelHeight[i,j]))

        tclfile.write('%s\t'%('procUniaxialPinching'))
        tclfile.write('%s\t'%('$ZOuterWoodPanelMatStory%iPanel%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$p1OuterWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$d1OuterWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$p2OuterWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$d2OuterWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$p3OuterWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$d3OuterWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$p4OuterWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$d4OuterWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$rDispOuterWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$rForceOuterWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$uForceOuterWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$gammaD1OuterWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$gDlimOuterWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$gammaK1OuterWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$gKlimOuterWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$dam'))
        tclfile.write('%s\t'%('$wallLengthWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s;\n'%('$wallHeightWoodPanelMatStory%iPier%i'%(i+1,j+1)))

        OuterWoodPanelMaterialTag += 1

        tclfile.write('set\tZInnerWoodPanelMatStory%iPanel%i\t%i;\n'%(i+1,j+1,InnerWoodPanelMaterialTag))
        tclfile.write('set\tp1InnerWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['f1'][int(BuildingModel.ZPanelMaterial[2*i+1,j]-1)]))
        tclfile.write('set\td1InnerWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['d1'][int(BuildingModel.ZPanelMaterial[2*i+1,j]-1)]))
        tclfile.write('set\tp2InnerWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['f2'][int(BuildingModel.ZPanelMaterial[2*i+1,j]-1)]))
        tclfile.write('set\td2InnerWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['d2'][int(BuildingModel.ZPanelMaterial[2*i+1,j]-1)]))
        tclfile.write('set\tp3InnerWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['f3'][int(BuildingModel.ZPanelMaterial[2*i+1,j]-1)]))
        tclfile.write('set\td3InnerWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['d3'][int(BuildingModel.ZPanelMaterial[2*i+1,j]-1)]))
        tclfile.write('set\tp4InnerWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['f4'][int(BuildingModel.ZPanelMaterial[2*i+1,j]-1)]))
        tclfile.write('set\td4InnerWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['d4'][int(BuildingModel.ZPanelMaterial[2*i+1,j]-1)]))

        tclfile.write('set\trDispInnerWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['rDisp'][int(BuildingModel.ZPanelMaterial[2*i+1,j]-1)]))
        tclfile.write('set\trForceInnerWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['rForce'][int(BuildingModel.ZPanelMaterial[2*i+1,j]-1)]))
        tclfile.write('set\tuForceInnerWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['uForce'][int(BuildingModel.ZPanelMaterial[2*i+1,j]-1)]))
        tclfile.write('set\tgammaD1InnerWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['gD1'][int(BuildingModel.ZPanelMaterial[2*i+1,j]-1)]))
        tclfile.write('set\tgDlimInnerWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['gDlim'][int(BuildingModel.ZPanelMaterial[2*i+1,j]-1)]))
        tclfile.write('set\tgammaK1InnerWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['gK1'][int(BuildingModel.ZPanelMaterial[2*i+1,j]-1)]))
        tclfile.write('set\tgKlimInnerWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.MaterialProperty['gKlim'][int(BuildingModel.ZPanelMaterial[2*i+1,j]-1)]))

        tclfile.write('set\tdam\t"energy";\n')
        tclfile.write('set\twallLengthWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.ZPanelLength[i,j]))
        tclfile.write('set\twallHeightWoodPanelMatStory%iPier%i\t%.3f;\n'%(i+1,j+1,BuildingModel.ZPanelHeight[i,j]))

        tclfile.write('%s\t'%('procUniaxialPinching'))
        tclfile.write('%s\t'%('$ZInnerWoodPanelMatStory%iPanel%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$p1InnerWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$d1InnerWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$p2InnerWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$d2InnerWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$p3InnerWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$d3InnerWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$p4InnerWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$d4InnerWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$rDispInnerWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$rForceInnerWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$uForceInnerWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$gammaD1InnerWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$gDlimInnerWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$gammaK1InnerWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$gKlimInnerWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s\t'%('$dam'))
        tclfile.write('%s\t'%('$wallLengthWoodPanelMatStory%iPier%i'%(i+1,j+1)))
        tclfile.write('%s;\n'%('$wallHeightWoodPanelMatStory%iPier%i'%(i+1,j+1)))

        InnerWoodPanelMaterialTag += 1    

    tclfile.write('puts "z-direction wood panel nodes defined" \n\n')

    WoodPanelMaterialTag = 600000
    OuterWoodPanelMaterialTag = 610000
    InnerWoodPanelMaterialTag = 620000

    tclfile.write('# Define x-direction parrallel wood panel materials \n')

    for i in range(BuildingModel.numberOfStories):
      tclfile.write('# Story%i \n'%(i+1))

      for j in range(BuildingModel.numberOfXDirectionWoodPanels[i]):
        tclfile.write('# X-Direction Story %i Panel %i \n'%(i+1,j+1))

        tclfile.write('uniaxialMaterial Parallel\t%i\t%i\t%i\t;\n'%(WoodPanelMaterialTag,OuterWoodPanelMaterialTag,InnerWoodPanelMaterialTag))


        WoodPanelMaterialTag += 1
        OuterWoodPanelMaterialTag += 1
        InnerWoodPanelMaterialTag += 1

      tclfile.write('\n')

    tclfile.write('# Define z-direction parrallel wood panel materials \n')

    for i in range(BuildingModel.numberOfStories):
      tclfile.write('# Story%i \n'%(i+1))

      for j in range(BuildingModel.numberOfZDirectionWoodPanels[i]):
        tclfile.write('# Z-Direction Story %i Panel %i \n'%(i+1,j+1))

        tclfile.write('uniaxialMaterial Parallel\t%i\t%i\t%i\t;\n'%(WoodPanelMaterialTag,OuterWoodPanelMaterialTag,InnerWoodPanelMaterialTag))


        WoodPanelMaterialTag += 1
        OuterWoodPanelMaterialTag += 1
        InnerWoodPanelMaterialTag += 1

      tclfile.write('\n')

    tclfile.write('puts "wood panel materials defined"')
  
def defineLeaningColumn3DModel(ModelDirectory, BuildingModel):
  os.chdir(ModelDirectory)
  
  with open('DefineLeaningColumn3DModel.tcl', 'w') as tclfile:
    
    tclfile.write('# This file will be used to define the leaning column; \n\n')

    LeaningColumnElementTag = 800000;
    NumLeaningColumn = BuildingModel.leaningColumnNodesOpenSeesTags.shape[1]

    tclfile.write('# Define leaning columns \n')

    for j in range(NumLeaningColumn):
      for i in range(BuildingModel.numberOfStories):
        tclfile.write('element elasticBeamColumn\t%i\t%i\t%i\t$LargeNumber\t%.3f\t%.3f\t$LargeNumber\t$LargeNumber\t$LargeNumber\t$PDeltaTransf;\n'%(LeaningColumnElementTag,
                                                                                                                                            BuildingModel.leaningColumnNodesOpenSeesTags[i,j]+1,
                                                                                                                                            BuildingModel.leaningColumnNodesOpenSeesTags[i+1,j]+2,
                                                                                                                                            1,1))
        LeaningColumnElementTag += 1
      tclfile.write('\n')


    tclfile.write('puts "Leaning columns defined"')
    
    
def defineLeaningColumnFlexuralSprings3DModel(ModelDirectory, BuildingModel):
  os.chdir(ModelDirectory)
  
  with open('DefineLeaningColumnFlexuralSprings3DModel.tcl', 'w') as tclfile:
    
    tclfile.write('# This file will be used to define \n # the flaxural springs at the ends of the leaning columns \n\n')

    LeaningColumnFlexuralSpringElementTag = 900000

    tclfile.write('# Define leaning column flexural springs \n')

    NumLeaningColumn = BuildingModel.leaningcolumnLoads.shape[1]

    for j in range(NumLeaningColumn):
      for i in range(BuildingModel.numberOfStories):

        tclfile.write('CreatePinJointRXRYRZ\t%i\t%i\t%i\t$StiffMat\t$SoftMat;\n'%(LeaningColumnFlexuralSpringElementTag,
                                                                          BuildingModel.leaningColumnNodesOpenSeesTags[i,j],
                                                                          BuildingModel.leaningColumnNodesOpenSeesTags[i,j]+1))
        LeaningColumnFlexuralSpringElementTag += 1


      for i in range(1,BuildingModel.numberOfStories+1):

        tclfile.write('CreatePinJointRXRZ\t%i\t%i\t%i\t$StiffMat\t$SoftMat;\n'%(LeaningColumnFlexuralSpringElementTag,
                                                                          BuildingModel.leaningColumnNodesOpenSeesTags[i,j],
                                                                          BuildingModel.leaningColumnNodesOpenSeesTags[i,j]+2))
        LeaningColumnFlexuralSpringElementTag += 1 
        
      tclfile.write('\n')

    tclfile.write('puts "Leaning column flexible flexural springs defined"')
    
    
    
def defineDamping3DModel(ModelDirectory, BuildingModel, ModalPeriod):
  os.chdir(ModelDirectory)
  
  with open('DefineDamping3DModel.tcl', 'w') as tclfile:
    
    tclfile.write('# This file will be used to define damping \n\n')
    
    tclfile.write('# Define the periods to use for damping parameter calculation \n')
    tclfile.write('set periodForRayleighDamping_1 %.3f; \n'%ModalPeriod[0])
    tclfile.write('set periodForRayleighDamping_2 %.3f; \n'%ModalPeriod[2])
    
    tclfile.write('# Define damping parameters \n')
    tclfile.write('set omegaI [expr (2.0 * $pi) / ($periodForRayleighDamping_1)] \n')
    tclfile.write('set omegaJ [expr (2.0 * $pi) / ($periodForRayleighDamping_2)] \n')
    tclfile.write('set alpha1Coeff [expr (2.0 * $omegaI * $omegaJ) / ($omegaI + $omegaJ)] \n')
    tclfile.write('set alpha2Coeff [expr (2.0) / ($omegaI + $omegaJ)] \n')

    tclfile.write('set alpha1 [expr $alpha1Coeff*%.3f] \n'%(BuildingModel.DynamicParameter['DampingRatio']))
    tclfile.write('set alpha2 [expr $alpha2Coeff*%.3f] \n'%(BuildingModel.DynamicParameter['DampingRatio']))

    tclfile.write('# Assign damping to wood panel elements \n')
    tclfile.write('region 1 -eleRange\t%i\t%i\t'%(700000, 700000 + BuildingModel.numberOfXDirectionWoodPanels.sum()+BuildingModel.numberOfZDirectionWoodPanels.sum()-1))

    if BuildingModel.DynamicParameter['DampingModel'] == 'TangentRayleigh':
      tclfile.write('-rayleigh\t%i\t%s\t%i\t%i; \n'%(0,'$alpha2',0,0))
    elif BuildingModel.DynamicParameter['DampingModel'] == 'InitialRayleigh':
      tclfile.write('-rayleigh\t%i\t%i\t%s\t%i; \n'%(0,0,'$alpha2',0))
    elif BuildingModel.DynamicParameter['DampingModel'] == 'CommittedRayleigh':
      tclfile.write('-rayleigh\t%i\t%i\t%i\t%s; \n'%(0,0,0,'$alpha2'))
    else:   
      tclfile.write('-rayleigh\t%i\t%i\t%i\t%i; \n'%(0,0,0,0))

    tclfile.write('# Assign damping to nodes \n')
    tclfile.write('region 2 -node\t')

    numLeaningColumn = BuildingModel.leaningColumnNodesOpenSeesTags.shape[1]

    for i in range(1,BuildingModel.numberOfStories+1):
      for j in range(numLeaningColumn):
        tclfile.write('%i\t'%BuildingModel.leaningColumnNodesOpenSeesTags[i,j])
    tclfile.write('-rayleigh\t%s\t%i\t%i\t%i; \n'%('$alpha1', 0, 0, 0))
    tclfile.write('puts "Damping defined"\n')
    
    
    

def defineAllRecorders3DModel(ModelDirectory, AnalysisType):
  os.chdir(ModelDirectory)
  
  with open('DefineAllRecorders3DModel.tcl', 'w') as tclfile:

    
    tclfile.write('# This file will be used to define all recorders \n\n')
    tclfile.write('# Setting up folders \n')

    if 'Dynamic' in AnalysisType:
      tclfile.write('cd\t$pathToResults/ \n')
      tclfile.write('if {$Pairing == 1} { \n')
      tclfile.write('    set folderNumber $eqNumber \n')
      tclfile.write('} else { \n')
      tclfile.write('    set folderNumber [expr $eqNumber + $numberOfGroundMotionXIDs] \n')
      tclfile.write('} \n')
      tclfile.write('\n')


      tclfile.write('file mkdir EQ_$folderNumber\n')
      tclfile.write('cd\t$pathToResults/EQ_$folderNumber\n')
      tclfile.write('\n')


      tclfile.write('file mkdir NodeAccelerations \n')
      tclfile.write('file mkdir StoryDrifts \n')
      tclfile.write('#file mkdir BaseReactions \n')
      tclfile.write('#file mkdir WoodPanelShearForces \n')
      tclfile.write('#file mkdir WoodPanelDeformations \n')
      tclfile.write('#file mkdir NodeDisplacements \n')
      tclfile.write('#file mkdir NodeDampingForces \n')
      tclfile.write('\n')

      tclfile.write('cd $pathToModel\n')
      tclfile.write('source DefineStoryDriftRecorders3DModel.tcl\n')
      tclfile.write('cd $pathToModel\n')
      tclfile.write('source DefineNodeAccelerationRecorders3DModel.tcl\n')  
      tclfile.write('cd $pathToModel\n')
      tclfile.write('#source DefineBaseReactionRecorders3DModel.tcl\n')  
      tclfile.write('#cd $pathToModel\n')
      tclfile.write('#source DefineWoodPanelRecorders3DModel.tcl\n')  
      tclfile.write('#cd $pathToModel\n')
      tclfile.write('#source DefineNodeDisplacementRecorders3DModel.tcl\n')  
      tclfile.write('#cd $pathToModel\n')
      tclfile.write('#source DefineNodeDampingForceRecorders3DModel.tcl\n')  
      tclfile.write('#cd $pathToModel\n')


    elif 'Pushover' in AnalysisType:
      tclfile.write('set baseDir [pwd]; \n')
      tclfile.write('cd\t$baseDir/$dataDir/ \n\n')
      tclfile.write('\n')

      tclfile.write('file mkdir StoryDrifts \n')
      tclfile.write('file mkdir BaseReactions \n')
      tclfile.write('#file mkdir WoodPanelShearForces \n')
      tclfile.write('#file mkdir WoodPanelDeformations \n')
      tclfile.write('#file mkdir NodeDisplacements \n')
      tclfile.write('#file mkdir NodeDampingForces \n')
      tclfile.write('\n')

      tclfile.write('cd $baseDir\n')
      tclfile.write('source DefineStoryDriftRecorders3DModel.tcl\n')
      tclfile.write('cd $baseDir\n')
      tclfile.write('source DefineBaseReactionRecorders3DModel.tcl\n')  
      tclfile.write('cd $baseDir\n')
      tclfile.write('#source DefineWoodPanelRecorders3DModel.tcl\n')  
      tclfile.write('#cd $baseDir\n')
      tclfile.write('#source DefineNodeDisplacementRecorders3DModel.tcl\n')  
      tclfile.write('#cd $baseDir\n')
      tclfile.write('#source DefineNodeDampingForceRecorders3DModel.tcl\n')  
      tclfile.write('#cd $baseDir\n')
      
      
def defineBaseReactionRecorders3DModel(ModelDirectory,BuildingModel,AnalysisType):
    os.chdir(ModelDirectory)
    
    with open('DefineBaseReactionRecorders3DModel.tcl', 'w') as tclfile:
        tclfile.write('# Define base node reaction recorders \n')
        tclfile.write('\n')
        numLeaningColumn = BuildingModel.leaningColumnNodesOpenSeesTags.shape[1]
        if 'Dynamic' in AnalysisType:
            tclfile.write('cd $pathToResults/EQ_$folderNumber/BaseReactions \n\n')
        elif 'Pushover' in AnalysisType:
            tclfile.write('cd $baseDir/$dataDir/BaseReactions \n\n')
            
        tclfile.write('# Base node vertical reactions \n')
        
        tclfile.write('recorder\tNode\t-file\tXPanelBaseNodesVerticalReactions.out\t-time\t-node\t')
        for i in range(BuildingModel.numberOfXDirectionWoodPanels[0]):
            tclfile.write('%i\t'%BuildingModel.XDirectionWoodPanelsBotTag[0,i])
        tclfile.write('-dof\t2\treaction\n')
        
        tclfile.write('recorder\tNode\t-file\tZPanelBaseNodesVerticalReactions.out\t-time\t-node\t')
        for i in range(BuildingModel.numberOfZDirectionWoodPanels[0]):
            tclfile.write('%i\t'%BuildingModel.ZDirectionWoodPanelsBotTag[0,i])
        tclfile.write('-dof\t2\treaction\n')
        
        tclfile.write('recorder\tNode\t-file\tLeaningColumnBaseNodeVerticalReactions.out\t-time\t-node\t')
        for i in range(numLeaningColumn):
            tclfile.write('%i\t'%BuildingModel.leaningColumnNodesOpenSeesTags[0,i])
        tclfile.write('-dof\t2\treaction\n')
        tclfile.write('\n')
        
        tclfile.write('# Base node horizontal reactions \n')
        
        tclfile.write('recorder\tNode\t-file\tXPanelBaseNodesHorizontalReactions.out\t-time\t-node\t')
        for i in range(BuildingModel.numberOfXDirectionWoodPanels[0]):
            tclfile.write('%i\t'%BuildingModel.XDirectionWoodPanelsBotTag[0,i])
        tclfile.write('-dof\t1\treaction\n')
        
        tclfile.write('recorder\tNode\t-file\tZPanelBaseNodesHorizontalReactions.out\t-time\t-node\t')
        for i in range(BuildingModel.numberOfZDirectionWoodPanels[0]):
            tclfile.write('%i\t'%BuildingModel.ZDirectionWoodPanelsBotTag[0,i])
        tclfile.write('-dof\t3\treaction\n')
        
        tclfile.write('recorder\tNode\t-file\tLeaningColumnBaseNodeXHorizontalReactions.out\t-time\t-node\t')
        for i in range(numLeaningColumn):
            tclfile.write('%i\t'%BuildingModel.leaningColumnNodesOpenSeesTags[0,i])
        tclfile.write('-dof\t1\treaction\n')
        
        tclfile.write('recorder\tNode\t-file\tLeaningColumnBaseNodeZHorizontalReactions.out\t-time\t-node\t')
        for i in range(numLeaningColumn):
            tclfile.write('%i\t'%BuildingModel.leaningColumnNodesOpenSeesTags[0,i])
        tclfile.write('-dof\t3\treaction\n')

        if BuildingModel.XRetrofitFlag:
            tclfile.write('# X-direction frame base node horizontal reactions\n')
            tclfile.write('recorder\tNode\t-file\tOMFXHorizontalReactions.out\t-time\t-node\t')
            for i in BuildingModel.XRetrofit:
                for p,q in enumerate(i['JointCoor']):
                    if q[1] == 0:
                        tclfile.write('%i\t'%(i['JointOSLabel'][p]))
            tclfile.write('-dof\t1\treaction\n')

        if BuildingModel.ZRetrofitFlag:
            tclfile.write('# Z-direction frame base node horizontal reactions\n')
            tclfile.write('recorder\tNode\t-file\tOMFZHorizontalReactions.out\t-time\t-node\t')
            for i in BuildingModel.ZRetrofit:
                for p,q in enumerate(i['JointCoor']):
                    if q[1] == 0:
                        tclfile.write('%i\t'%(i['JointOSLabel'][p]))
            tclfile.write('-dof\t3\treaction\n')

    
def defineWoodPanelRecorders3DModel(ModelDirectory,BuildingModel,AnalysisType):
  os.chdir(ModelDirectory)
  
  with open('DefineWoodPanelRecorders3DModel.tcl', 'w') as tclfile:
    
    tclfile.write('# Define wood panel force-deformation recorders \n\n')

    if 'Dynamic' in AnalysisType:
      tclfile.write('cd $pathToResults/EQ_$folderNumber/WoodPanelShearForces \n\n')

    elif 'Pushover' in AnalysisType:
      tclfile.write('cd $baseDir/$dataDir/WoodPanelShearForces \n\n')

    WoodPanelElementTag = 700000

    tclfile.write('# X-Direction wood panel element shear force recorders \n')
    for i in range(BuildingModel.numberOfStories):
      tclfile.write('recorder\tElement\t-file\tXWoodPanelShearForcesStory%i.out\t-time\t-ele\t'%(i+1))
      for j in range(BuildingModel.numberOfXDirectionWoodPanels[i]):
        tclfile.write('%i\t'%(WoodPanelElementTag))
        WoodPanelElementTag += 1

      tclfile.write('force\n')
    tclfile.write('\n')   

    tclfile.write('# Z-Direction wood panel element shear force recorders\n')
    for i in range(BuildingModel.numberOfStories):
      tclfile.write('recorder\tElement\t-file\tZWoodPanelShearForcesStory%i.out\t-time\t-ele\t'%(i+1))
      for j in range(BuildingModel.numberOfZDirectionWoodPanels[i]):
        tclfile.write('%i\t'%(WoodPanelElementTag))
        WoodPanelElementTag += 1

      tclfile.write('force\n')
    tclfile.write('\n\n')   


    if 'Dynamic' in AnalysisType:
      tclfile.write('cd $pathToResults/EQ_$folderNumber/WoodPanelDeformations \n\n')

    elif 'Pushover' in AnalysisType:
      tclfile.write('cd $baseDir/$dataDir/WoodPanelDeformations \n\n')

    WoodPanelElementTag = 700000

    tclfile.write('# X-Direction wood panel element deformation recorders\n')
    for i in range(BuildingModel.numberOfStories):
      tclfile.write('recorder\tElement\t-file\tXWoodPanelDeformationsStory%i.out\t-time\t-ele\t'%(i+1))
      for j in range(BuildingModel.numberOfXDirectionWoodPanels[i]):
        tclfile.write('%i\t'%(WoodPanelElementTag))
        WoodPanelElementTag += 1

      tclfile.write('deformation\n')
    tclfile.write('\n')   

    tclfile.write('# Z-Direction wood panel element shear force recorders\n')
    for i in range(BuildingModel.numberOfStories):
      tclfile.write('recorder\tElement\t-file\tZWoodPanelDeformationsStory%i.out\t-time\t-ele\t'%(i+1))
      for j in range(BuildingModel.numberOfZDirectionWoodPanels[i]):
        tclfile.write('%i\t'%(WoodPanelElementTag))
        WoodPanelElementTag += 1

      tclfile.write('deformation\n')
    tclfile.write('\n\n')    
    
    
def defineNodeAccelerationRecorders3DModel(ModelDirectory, BuildingModel):
  os.chdir(ModelDirectory)
  
  with open('DefineNodeAccelerationRecorders3DModel.tcl', 'w') as tclfile:
    tclfile.write('# Define node acceleration recorders \n\n')

    tclfile.write('cd $pathToResults/EQ_$folderNumber/NodeAccelerations \n\n')

    tclfile.write('# Record accelerations at leaning column nodes  \n')

    for i in range(BuildingModel.numberOfStories):
      # Current script only record the central leaning column absolute acceleration 
      tclfile.write('recorder\tNode\t-file\tLeaningColumnNodeXAbsoAccLevel%i.out\t-timeSeries\t11\t-time\t-node\t%i\t-dof\t1\taccel\n'%(i+2,BuildingModel.leaningColumnNodesOpenSeesTags[i+1,0]))
      tclfile.write('recorder\tNode\t-file\tLeaningColumnNodeZAbsoAccLevel%i.out\t-timeSeries\t12\t-time\t-node\t%i\t-dof\t3\taccel\n'%(i+2,BuildingModel.leaningColumnNodesOpenSeesTags[i+1,0]))

      
def defineNodeDisplacementRecorders3DModel(ModelDirectory, BuildingModel, AnalysisType):
  with open('DefineNodeDisplacementRecorders3DModel.tcl', 'w') as tclfile:
    
    tclfile.write('# Define node displacement recorders \n\n')

    AnalysisType = 'PushoverAnalysis'
    if 'Dyanamic' in AnalysisType: 
      tclfile.write('cd\t$pathToResults/EQ_$folderNumber/NodeDisplacements\n')

    elif 'Pushover' in AnalysisType:
      tclfile.write('cd\t$baseDir/$dataDir/NodeDisplacements\n')

    tclfile.write('\n')

    tclfile.write('# Record displacements for x-direction wood panel nodes\n')

    # Here we are only interested in the x-direction disp of x-direction panels and z-direction displacement of z-direction panels
    for i in range(BuildingModel.numberOfStories):
      tclfile.write('recorder\tNode\t-file\tXWoodPanelNodeDispLevel%i.out\t-time\t-node\t'%(i+1))

      for j in range(BuildingModel.numberOfXDirectionWoodPanels[i]):
        tclfile.write('%i\t'%(BuildingModel.XDirectionWoodPanelsTopTag[i,j]))

      tclfile.write('-dof\t1\tdisp\n')
    tclfile.write('\n')  
    
    tclfile.write('# Record displacements for z-direction wood panel nodes\n')

    for i in range(BuildingModel.numberOfStories):
      tclfile.write('recorder\tNode\t-file\tZWoodPanelNodeDispLevel%i.out\t-time\t-node\t'%(i+1))

      for j in range(BuildingModel.numberOfZDirectionWoodPanels[i]):
        tclfile.write('%i\t'%(BuildingModel.ZDirectionWoodPanelsTopTag[i,j]))

      tclfile.write('-dof\t3\tdisp\n')
    tclfile.write('\n')    

    tclfile.write('# Record displacements for leaning column nodes \n')
    for i in range(BuildingModel.numberOfStories):
      tclfile.write('recorder\tNode\t-file\tLeaningColumnNodeDispLevel%i.out\t-time\t-node\t%i\t-dof\t1\t2\t3\tdisp\n'
            %(i+1, BuildingModel.leaningColumnNodesOpenSeesTags[i+1,0]))
      
def defineNodeDampingForceRecorders3DModel(ModelDirectory, BuildingModel):
  os.chdir(ModelDirectory)
  
  with open('DefineNodeDampingForceRecorders3DModel.tcl', 'w') as tclfile:
    tclfile.write('# Define node damping force recorders \n\n')
    
    tclfile.write('cd\t$pathToResults/EQ_$folderNumber/NodeDampingForces\n')
    tclfile.write('# Define the rayleigh force recorder at leaning column nodes\n')


    tclfile.write('# Record displacements for leaning column nodes \n')
    # Mass proportional rayleight damping force only application for the nodes assigned masses,
    # so only leanging column nodes are included
    for i in range(BuildingModel.numberOfStories):
      tclfile.write('recorder\tNode\t-file\tLeaningColumnNodeDampingForceLevel%i.out\t-time\t-node\t'%(i+1))

      for j in range(BuildingModel.leaningColumnNodesOpenSeesTags.shape[1]):
        tclfile.write('%i\t'%(BuildingModel.leaningColumnNodesOpenSeesTags[i+1,j]))

      tclfile.write('-dof\t1\t3\trayleighForces\n')
      
def defineStoryDriftRecorders3DModel(ModelDirectory,BuildingModel,AnalysisType):
  os.chdir(ModelDirectory)
  
  with open('DefineStoryDriftRecorders3DModel.tcl', 'w') as tclfile:
    
    # Each three columns correcponding to three leaning columns at one story
    # Specially, the last three columns record the roof drift
    tclfile.write('# Define story drift recorders \n\n')
    if 'Dynamic' in AnalysisType:
      tclfile.write('cd $pathToResults/EQ_$folderNumber/StoryDrifts \n')
      tclfile.write('# Define x-direction story drift recorders \n')
      tclfile.write('recorder\tDrift\t-file\t$pathToResults/EQ_$folderNumber/StoryDrifts/MidLeaningColumnXDrift.out\t-time\t-iNode\t')
      for i in range(BuildingModel.numberOfStories):

        for j in [0,2,7]:
          # Remember to put the central leaning column at the very beginning 
          tclfile.write('%i\t'%(BuildingModel.leaningColumnNodesOpenSeesTags[i,j]))

      for j in [0,2,7]:
        tclfile.write('%i\t'%(BuildingModel.leaningColumnNodesOpenSeesTags[0,j]))

      tclfile.write('-jNode\t')

      for i in range(BuildingModel.numberOfStories):

        for j in [0,2,7]:
          # Remember to put the central leaning column at the very beginning 
          tclfile.write('%i\t'%(BuildingModel.leaningColumnNodesOpenSeesTags[i+1,j]))

      for j in [0,2,7]:
        tclfile.write('%i\t'%(BuildingModel.leaningColumnNodesOpenSeesTags[-1,j])) 

      tclfile.write('-dof\t1\t-perpDirn\t2\n')

      tclfile.write('recorder\tDrift\t-file\t$pathToResults/EQ_$folderNumber/StoryDrifts/CornerLeaningColumnXDrift.out\t-time\t-iNode\t')
      for i in range(BuildingModel.numberOfStories):

        for j in [1,3,6,8]:
          # Remember to put the central leaning column at the very beginåning 
          tclfile.write('%i\t'%(BuildingModel.leaningColumnNodesOpenSeesTags[i,j]))

      for j in [1,3,6,8]:
        tclfile.write('%i\t'%(BuildingModel.leaningColumnNodesOpenSeesTags[0,j]))

      tclfile.write('-jNode\t')

      for i in range(BuildingModel.numberOfStories):

        for j in [1,3,6,8]:
          # Remember to put the central leaning column at the very beginning 
          tclfile.write('%i\t'%(BuildingModel.leaningColumnNodesOpenSeesTags[i+1,j]))

      for j in [1,3,6,8]:
        tclfile.write('%i\t'%(BuildingModel.leaningColumnNodesOpenSeesTags[-1,j])) 

      tclfile.write('-dof\t1\t-perpDirn\t2\n')

      tclfile.write('# Define z-direction story drift recorders \n')
      tclfile.write('recorder\tDrift\t-file\t$pathToResults/EQ_$folderNumber/StoryDrifts/MidLeaningColumnZDrift.out\t-time\t-iNode\t')
      for i in range(BuildingModel.numberOfStories):

        for j in [0,2,7]:
          # Remember to put the central leaning column at the very beginning 
          tclfile.write('%i\t'%(BuildingModel.leaningColumnNodesOpenSeesTags[i,j]))

      for j in [0,2,7]:
        tclfile.write('%i\t'%(BuildingModel.leaningColumnNodesOpenSeesTags[0,j]))

      tclfile.write('-jNode\t')

      for i in range(BuildingModel.numberOfStories):

        for j in [0,4,5]:
          # Remember to put the central leaning column at the very beginning 
          tclfile.write('%i\t'%(BuildingModel.leaningColumnNodesOpenSeesTags[i+1,j]))

      for j in [0,4,5]:
        tclfile.write('%i\t'%(BuildingModel.leaningColumnNodesOpenSeesTags[-1,j])) 

      tclfile.write('-dof\t3\t-perpDirn\t2\n')

      tclfile.write('recorder\tDrift\t-file\t$pathToResults/EQ_$folderNumber/StoryDrifts/CornerLeaningColumnZDrift.out\t-time\t-iNode\t')
      for i in range(BuildingModel.numberOfStories):

        for j in [1,3,6,8]:
          # Remember to put the central leaning column at the very beginning 
          tclfile.write('%i\t'%(BuildingModel.leaningColumnNodesOpenSeesTags[i,j]))

      for j in [1,3,6,8]:
        tclfile.write('%i\t'%(BuildingModel.leaningColumnNodesOpenSeesTags[0,j]))

      tclfile.write('-jNode\t')

      for i in range(BuildingModel.numberOfStories):

        for j in [1,3,6,8]:
          # Remember to put the central leaning column at the very beginning 
          tclfile.write('%i\t'%(BuildingModel.leaningColumnNodesOpenSeesTags[i+1,j]))

      for j in [1,3,6,8]:
        tclfile.write('%i\t'%(BuildingModel.leaningColumnNodesOpenSeesTags[-1,j])) 

      tclfile.write('-dof\t3\t-perpDirn\t2\n')  



    elif 'Pushover' in AnalysisType:
      tclfile.write('cd $baseDir/$dataDir/StoryDrifts \n')
      tclfile.write('# Define x-direction story drift recorders \n')
      tclfile.write('recorder\tDrift\t-file\t$baseDir/$dataDir/StoryDrifts/LeaningColumnXDrift.out\t-iNode\t')
      for i in range(BuildingModel.numberOfStories):

        for j in [0,2,7]:
          # Remember to put the central leaning column at the very beginning 
          tclfile.write('%i\t'%(BuildingModel.leaningColumnNodesOpenSeesTags[i,j]))

      for j in [0,2,7]:
        tclfile.write('%i\t'%(BuildingModel.leaningColumnNodesOpenSeesTags[0,j]))

      tclfile.write('-jNode\t')

      for i in range(BuildingModel.numberOfStories):

        for j in [0,2,7]:
          # Remember to put the central leaning column at the very beginning 
          tclfile.write('%i\t'%(BuildingModel.leaningColumnNodesOpenSeesTags[i+1,j]))

      for j in [0,2,7]:
        tclfile.write('%i\t'%(BuildingModel.leaningColumnNodesOpenSeesTags[-1,j])) 

      tclfile.write('-dof\t1\t-perpDirn\t2\n')

      tclfile.write('\n# Define z-direction story drift recorders\n')
      tclfile.write('recorder\tDrift\t-file\t$baseDir/$dataDir/StoryDrifts/LeaningColumnZDrift.out\t-iNode\t')
      for i in range(BuildingModel.numberOfStories):

        for j in [0,4,5]:
          # Remember to put the central leaning column at the very beginning 
          tclfile.write('%i\t'%(BuildingModel.leaningColumnNodesOpenSeesTags[i,j]))

      for j in [0,4,5]:
        tclfile.write('%i\t'%(BuildingModel.leaningColumnNodesOpenSeesTags[0,j]))

      tclfile.write('-jNode\t')

      for i in range(BuildingModel.numberOfStories):

        for j in [0,4,5]:
          # Remember to put the central leaning column at the very beginning 
          tclfile.write('%i\t'%(BuildingModel.leaningColumnNodesOpenSeesTags[i+1,j]))

      for j in [0,4,5]:
        tclfile.write('%i\t'%(BuildingModel.leaningColumnNodesOpenSeesTags[-1,j])) 

      tclfile.write('-dof\t3\t-perpDirn\t2\n')  
      
      
def defineGravityLoads3DModel(ModelDirectory, BuildingModel):
  
  os.chdir(ModelDirectory)
  
  with open('DefineGravityLoads3DModel.tcl', 'w') as tclfile:
    
    tclfile.write('# Define gravity loads \n\n')

    tclfile.write('pattern Plain 101 Constant {\n')
    tclfile.write('# Define gravity loads on leaning columns \n')

    numLeaningColumn = BuildingModel.leaningColumnNodesOpenSeesTags.shape[1]

    for j in range(numLeaningColumn):
      for i in range(BuildingModel.numberOfStories):
        tclfile.write('load\t%i\t%i\t%.3f\t%i\t%i\t%i\t%i;\n'%(BuildingModel.leaningColumnNodesOpenSeesTags[i+1,j], 
                                                               0, -BuildingModel.leaningcolumnLoads[i,j], 0, 0, 0, 0))

      tclfile.write('\n')

    tclfile.write('}')
    
    
def defineMasses3DModel(ModelDirectory, BuildingModel):
  
  os.chdir(ModelDirectory)
  
  with open('DefineMasses3DModel.tcl', 'w') as tclfile:
    
    tclfile.write('# This file will be used to define all nodal masses \n\n')
    tclfile.write('# Unit: kip-s2/in \n')
    tclfile.write('# Define nodal masses for leaning column nodes \n')

    numLeaningColumn = BuildingModel.leaningColumnNodesOpenSeesTags.shape[1]
    g = 32.2*12

    for j in range(numLeaningColumn):
      if j != 0:
        for i in range(BuildingModel.numberOfStories):
          tclfile.write('mass\t%i\t%.3f\t%.3f\t%.3f\t%i\t%i\t%i;\n'%(BuildingModel.leaningColumnNodesOpenSeesTags[i+1,j], BuildingModel.leaningcolumnLoads[i,j]/g,
                                                            BuildingModel.leaningcolumnLoads[i,j]/g,BuildingModel.leaningcolumnLoads[i,j]/g,
                                                            0,0,0))
          tclfile.write('\n')
  
      else:
        for i in range(BuildingModel.numberOfStories):
          tclfile.write('mass\t%i\t%.3f\t%.3f\t%.3f\t%i\t%i\t%i;\n'%(BuildingModel.leaningColumnNodesOpenSeesTags[i+1,j], 
                                                             BuildingModel.leaningcolumnLoads[i,j]/g,
                                                             BuildingModel.leaningcolumnLoads[i,j]/g,
                                                             BuildingModel.leaningcolumnLoads[i,j]/g,
                                                             BuildingModel.leaningcolumnLoads[i,j]/12/g*((BuildingModel.floorMaximumXDimension[i+1]/2)**2 + (BuildingModel.floorMaximumZDimension[i+1]/2)**2),
                                                             BuildingModel.leaningcolumnLoads[i,j]/12/g*((BuildingModel.floorMaximumXDimension[i+1]/2)**2 + (BuildingModel.floorMaximumZDimension[i+1]/2)**2),
                                                             BuildingModel.leaningcolumnLoads[i,j]/12/g*((BuildingModel.floorMaximumXDimension[i+1]/2)**2 + (BuildingModel.floorMaximumZDimension[i+1]/2)**2)))
          tclfile.write('\n')
          
def defineDynamicAnalysisParameters3DModel(ModelDirectory, BuildingModel):
  os.chdir(ModelDirectory)
  
  with open('DefineDynamicAnalysisParameters3DModel.tcl', 'w') as tclfile:
    
    tclfile.write('# This file will be used to define the parameters needed for collapse analysis solver \n\n')
    
    tclfile.write('set\tNStories\t%i;\n'%BuildingModel.numberOfStories)
    tclfile.write('set\tHTypicalStory\t')
    # Typical story height sometimes is not the first story height, e.g. cripple wall building 
    if BuildingModel.numberOfStories == 1:
      tclfile.write('%i;\n'%(BuildingModel.storyHeights[0]))
      
    else: tclfile.write('%i;\n'%(BuildingModel.storyHeights[1]))
    tclfile.write('set\tHFirstStory\t%i;\n'%(BuildingModel.storyHeights[0]))
    
    tclfile.write('set\tFloorNodes\t[list\t')
    
    for i in range(BuildingModel.numberOfStories+1):
      tclfile.write('%i\t'%BuildingModel.leaningColumnNodesOpenSeesTags[i,0])
    tclfile.write('];')
  
def definePushoverLoading3DModel(ModelDirectory, BuildingModel):
  os.chdir(ModelDirectory)
  
  with open('DefinePushoverXLoading3DModel.tcl', 'w') as tclfile:
    
    tclfile.write('# This file will be used to define X direction pushover analysis loading \n\n')

    tclfile.write('pattern Plain 200 Linear {\n\n')
    tclfile.write('# Pushover load pattern \n')

    # Pay attention to the leaning column nodes, it is better to be the central leaning column 
    for i in range(BuildingModel.numberOfStories):
      tclfile.write('load\t%i\t%.3f\t%i\t%i\t%i\t%i\t%i;\n'%(BuildingModel.leaningColumnNodesOpenSeesTags[i+1,0],
                                                    BuildingModel.SeismicDesignParameter['Cvx'][i],
                                                    0,0,0,0,0))
    tclfile.write('}')
    
  os.chdir(ModelDirectory)
  
  with open('DefinePushoverZLoading3DModel.tcl', 'w') as tclfile:
    
    tclfile.write('# This file will be used to define Z direction pushover analysis loading \n\n')

    tclfile.write('pattern Plain 200 Linear {\n\n')
    tclfile.write('# Pushover load pattern \n')

    # Pay attention to the leaning column nodes, it is better to be the central leaning column 
    for i in range(BuildingModel.numberOfStories):
      tclfile.write('load\t%i\t%i\t%i\t%.3f\t%i\t%i\t%i;\n'%(BuildingModel.leaningColumnNodesOpenSeesTags[i+1,0],0,0,
                                                    BuildingModel.SeismicDesignParameter['Cvx'][i],
                                                    0,0,0))
    tclfile.write('}')
    
def setupEigenAnalysis(ModelDirectory, BuildingModel, NumModes = 4):
  os.chdir(ModelDirectory)

  with open('EigenValueAnalysis.tcl', 'w') as tclfile:
    tclfile.write('# Thif file is used for performing eigen value analysis \n\n')
    tclfile.write('set\tpi\t[expr 2.0*asin(1.0)];\n')
    for i in range(NumModes):
      tclfile.write('set\tnEigen%i\t%i;\n'%((i+1),(i+1)))

    tclfile.write('set\tlambdaN\t[eigen $nEigen%i];\n'%(i+1))
    tclfile.write('puts\t$lambdaN\n')

    tclfile.write('foreach lambda $lambdaN {\n')
    tclfile.write('\tlappend Tlist [expr {2*$pi/sqrt($lambda)}];\n')
    tclfile.write('} \n')

    tclfile.write('# Saving periods\n')
    tclfile.write('set recorderdir Analysis_Results/Modes;   # Recorder folder \n')
    tclfile.write('file mkdir $recorderdir;   # Creating recorder folder if it does not exist \n')
    tclfile.write('set period_file [open $recorderdir/periods.out w];\n')
    tclfile.write('foreach T $Tlist {\n')
    tclfile.write('\tputs $period_file "$T";\n')
    tclfile.write('} \n')
    tclfile.write('close $period_file\n\n')

    tclfile.write('puts "eigen value analysis - periods done!" \n\n')

    tclfile.write('# Saving mode shapes\n')
    tclfile.write('set mode_file [open $recorderdir/mode_shape.out w];\n')
    for i in range(BuildingModel.numberOfStories):
      tclfile.write('puts $mode_file "')
      for j in range(NumModes):
        tclfile.write('[nodeEigenvector %i %i 1]\t'%(BuildingModel.leaningColumnNodesOpenSeesTags[i+1,0], j+1))
      tclfile.write('"\n')
    tclfile.write('close $mode_file\n')
    tclfile.write('puts "eigen value analysis - mode shape done!"')


def define3DEigenValueAnalysisModel(ModelDirectory, BuildingModel):
  os.chdir(ModelDirectory)
  
  with open('Model.tcl', 'w') as tclfile:
    tclfile.write('# Clear memory \n')
    tclfile.write('wipe all \n\n')
    tclfile.write('# Define model builder\n')
    tclfile.write('model BasicBuilder -ndm 3 -ndf 6 \n\n')

    tclfile.write('# Define variables \n')
    tclfile.write('source DefineVariables.tcl\n\n')
    
    tclfile.write('# Define units and constants \n')
    tclfile.write('source DefineUnitsAndConstants.tcl\n\n')

    tclfile.write('# Define functions and procedures \n')
    tclfile.write('source DefineFunctionsAndProcedures.tcl\n\n')

    tclfile.write('# Define nodes \n')
    tclfile.write('source DefineNodes3DModel.tcl\n\n')

    tclfile.write('# Define rigid floor diaphragm constraints \n')
    tclfile.write('source DefineRigidFloorDiaphragm3DModel.tcl\n\n')

    tclfile.write('# Define nodes fixities\n')
    tclfile.write('source DefineFixities3DModel.tcl\n\n')

    tclfile.write('# Define wood panel material models \n')
    tclfile.write('source DefineWoodPanelMaterials3DModel.tcl\n\n')

    tclfile.write('# Define wood panel elements \n')
    tclfile.write('source DefineWoodPanels3DModel.tcl\n\n')
    
    tclfile.write('# Define leaning column \n')
    tclfile.write('source DefineLeaningColumn3DModel.tcl\n\n')

    tclfile.write('# Define leaning column flexural springs\n')
    tclfile.write('source DefineLeaningColumnFlexuralSprings3DModel.tcl\n\n')

    if BuildingModel.XRetrofit or BuildingModel.ZRetrofit:
      tclfile.write('# Define retrofit components\n')
      tclfile.write('source DefineRetrofit3DModel.tcl\n\n')

    tclfile.write('# Define masses \n')
    tclfile.write('source DefineMasses3DModel.tcl\n\n')

    tclfile.write('# Define gravity loads \n')
    tclfile.write('source DefineGravityLoads3DModel.tcl\n\n')

    tclfile.write('# Perform gravity analysis \n')
    tclfile.write('source PerformGravityAnalysis.tcl\n\n')

    tclfile.write('# Perform eigen value analysis \n')
    tclfile.write('source EigenValueAnalysis.tcl\n\n')
    
    
def define3DPushoverAnalysisModel(ModelDirectory, BuildingModel):
  os.chdir(ModelDirectory)
  
  with open('Model.tcl', 'w') as tclfile:
    tclfile.write('# Define nodes \n')
    tclfile.write('source DefineNodes3DModel.tcl\n\n')

    tclfile.write('# Define rigid floor diaphragm constraints \n')
    tclfile.write('source DefineRigidFloorDiaphragm3DModel.tcl\n\n')

    tclfile.write('# Define nodes fixities\n')
    tclfile.write('source DefineFixities3DModel.tcl\n\n')

    tclfile.write('# Define wood panel material models \n')
    tclfile.write('source DefineWoodPanelMaterials3DModel.tcl\n\n')

    tclfile.write('# Define wood panel elements \n')
    tclfile.write('source DefineWoodPanels3DModel.tcl\n\n')
    
    tclfile.write('# Define leaning column \n')
    tclfile.write('source DefineLeaningColumn3DModel.tcl\n\n')

    tclfile.write('# Define leaning column flexural springs\n')
    tclfile.write('source DefineLeaningColumnFlexuralSprings3DModel.tcl\n\n')

    if BuildingModel.XRetrofit or BuildingModel.ZRetrofit:
      tclfile.write('# Define retrofit components\n')
      tclfile.write('source DefineRetrofit3DModel.tcl\n\n')

    tclfile.write('# Define masses \n')
    tclfile.write('source DefineMasses3DModel.tcl\n\n')

    tclfile.write('# Define gravity loads \n')
    tclfile.write('source DefineGravityLoads3DModel.tcl\n\n')

    tclfile.write('# Perform gravity analysis \n')
    tclfile.write('source PerformGravityAnalysis.tcl\n\n')

    tclfile.write('# Define all recorders\n')
    tclfile.write('source DefineAllRecorders3DModel.tcl\n\n')
    
    
    
def setupPushoverAnalysis(ModelDirectory, BuildingModel):
  os.chdir(ModelDirectory)
  
  with open('RunXPushoverAnalysis.tcl', 'w') as tclfile:
    tclfile.write('# Clear memory \n')
    tclfile.write('wipe all \n\n')

    tclfile.write('# Define model builder \n');
    tclfile.write('model BasicBuilder -ndm 3 -ndf 6 \n\n');

    tclfile.write('# Define pushover analysis parameters\n')
    tclfile.write('set\tIDctrlNode\t%i\n'%(BuildingModel.leaningColumnNodesOpenSeesTags[BuildingModel.numberOfStories,0]))
    tclfile.write('set\tIDctrlDOF\t%i\n'%1)
    tclfile.write('set\tDincr\t%.5f\n'%BuildingModel.PushoverParameter['Increment'])
    tclfile.write('set\tDmax\t%.5f\n\n'%(BuildingModel.PushoverParameter['PushoverXDrift']/100*sum(BuildingModel.storyHeights)))


    tclfile.write('# Set up output directory \n')
    tclfile.write('set dataDir Static-Pushover-Output-Model3D-XPushoverDirection\n')
    tclfile.write('file mkdir $dataDir\n')
    tclfile.write('set baseDir [pwd]\n')

    tclfile.write('# Define variables \n')
    tclfile.write('source DefineVariables.tcl\n\n')
    
    tclfile.write('# Define units and constants \n')
    tclfile.write('source DefineUnitsAndConstants.tcl\n\n')

    tclfile.write('# Define functions and procedures \n')
    tclfile.write('source DefineFunctionsAndProcedures.tcl\n\n')
    
    tclfile.write('# Source display procedures \n')
    tclfile.write('source DisplayModel3D.tcl\n')
    tclfile.write('source DisplayPlane.tcl\n\n')
    
    tclfile.write('# Source buliding model \n')
    tclfile.write('source Model.tcl \n\n')
    
    tclfile.write('# Define pushover loading \n')
    tclfile.write('source DefinePushoverXLoading3DModel.tcl \n\n')
    
    tclfile.write('# Define model run time parameters \n')
    tclfile.write('set\tstartT\t[clock seconds]\n\n')
    
    tclfile.write('# Run pushvoer analysis \n')
    tclfile.write('source RunStaticPushover.tcl \n\n')
    
    tclfile.write('# Define model run time parameters \n')
    tclfile.write('set\tendT\t[clock seconds]\n')
    tclfile.write('set\tRunTime\t[expr ($endT - $endT)]\n')
    tclfile.write('puts "Run Time = $RunTime Seconds"\n\n')
    
    
  with open('RunZPushoverAnalysis.tcl', 'w') as tclfile:
    tclfile.write('# Clear memory \n')
    tclfile.write('wipe all \n\n')

    tclfile.write('# Define model builder \n');
    tclfile.write('model BasicBuilder -ndm 3 -ndf 6 \n\n');

    tclfile.write('# Define pushover analysis parameters\n')
    tclfile.write('set\tIDctrlNode\t%i\n'%(BuildingModel.leaningColumnNodesOpenSeesTags[BuildingModel.numberOfStories,0]))
    tclfile.write('set\tIDctrlDOF\t%i\n'%3)
    tclfile.write('set\tDincr\t%.5f\n'%BuildingModel.PushoverParameter['Increment'])
    tclfile.write('set\tDmax\t%.5f\n\n'%(BuildingModel.PushoverParameter['PushoverZDrift']/100*sum(BuildingModel.storyHeights)))


    tclfile.write('# Set up output directory \n')
    tclfile.write('set dataDir Static-Pushover-Output-Model3D-ZPushoverDirection\n')
    tclfile.write('file mkdir $dataDir\n')
    tclfile.write('set baseDir [pwd]\n')

    tclfile.write('# Define variables \n')
    tclfile.write('source DefineVariables.tcl\n\n')
    
    tclfile.write('# Define units and constants \n')
    tclfile.write('source DefineUnitsAndConstants.tcl\n\n')

    tclfile.write('# Define functions and procedures \n')
    tclfile.write('source DefineFunctionsAndProcedures.tcl\n\n')
    
    tclfile.write('# Source display procedures \n')
    tclfile.write('source DisplayModel3D.tcl\n')
    tclfile.write('source DisplayPlane.tcl\n\n')
    
    tclfile.write('# Source buliding model \n')
    tclfile.write('source Model.tcl \n\n')
    
    tclfile.write('# Define pushover loading \n')
    tclfile.write('source DefinePushoverZLoading3DModel.tcl \n\n')
    
    tclfile.write('# Define model run time parameters \n')
    tclfile.write('set\tstartT\t[clock seconds]\n\n')
    
    tclfile.write('# Run pushvoer analysis \n')
    tclfile.write('source RunStaticPushover.tcl \n\n')
    
    tclfile.write('# Define model run time parameters \n')
    tclfile.write('set\tendT\t[clock seconds]\n')
    tclfile.write('set\tRunTime\t[expr ($endT - $endT)]\n')
    tclfile.write('puts "Run Time = $RunTime Seconds"\n\n')

def define3DDynamicAnalysisModel(ModelDirectory, BuildingModel):
  os.chdir(ModelDirectory)
  
  with open('Model.tcl', 'w') as tclfile:
    tclfile.write('wipe all; \n\n\n')
    tclfile.write('model BasicBuilder -ndm 3 -ndf 6; \n\n\n')

    tclfile.write('source DefineUnitsAndConstants.tcl \n')
    tclfile.write('source DefineVariables.tcl \n')
    tclfile.write('source DefineFunctionsAndProcedures.tcl \n')


    tclfile.write('# Define nodes \n')
    tclfile.write('source DefineNodes3DModel.tcl\n\n')

    tclfile.write('# Define rigid floor diaphragm constraints \n')
    tclfile.write('source DefineRigidFloorDiaphragm3DModel.tcl\n\n')

    tclfile.write('# Define nodes fixities\n')
    tclfile.write('source DefineFixities3DModel.tcl\n\n')

    tclfile.write('# Define wood panel material models \n')
    tclfile.write('source DefineWoodPanelMaterials3DModel.tcl\n\n')

    tclfile.write('# Define wood panel elements \n')
    tclfile.write('source DefineWoodPanels3DModel.tcl\n\n')
    
    tclfile.write('# Define leaning column \n')
    tclfile.write('source DefineLeaningColumn3DModel.tcl\n\n')

    tclfile.write('# Define leaning column flexural springs\n')
    tclfile.write('source DefineLeaningColumnFlexuralSprings3DModel.tcl\n\n')

    if BuildingModel.XRetrofit or BuildingModel.ZRetrofit:
      tclfile.write('# Define retrofit components\n')
      tclfile.write('source DefineRetrofit3DModel.tcl\n\n')

    tclfile.write('# Define masses \n')
    tclfile.write('source DefineMasses3DModel.tcl\n\n')

    tclfile.write('# Define gravity loads \n')
    tclfile.write('source DefineGravityLoads3DModel.tcl\n\n')

    tclfile.write('# Define all recorders\n')
    tclfile.write('# source DefineAllRecorders3DModel.tcl\n\n')

    tclfile.write('# Perform gravity analysis \n')
    tclfile.write('source PerformGravityAnalysis.tcl\n\n')

    tclfile.write('# Define damping model\n')
    tclfile.write('source DefineDamping3DModel.tcl \n\n')

    tclfile.write('# Define ground motion scale factor \n')
    tclfile.write('set scalefactor [expr $g*100/100*$MCE_SF]; \n\n')

    tclfile.write('# Run time history \n')
    tclfile.write('source DefineBiDirectionalTimeHistory.tcl \n\n')

    

def generateModalAnalysisModel(ID, BuildingModel, BaseDirectory, DB_Directory, NumModes = 4, GenerateModelSwitch = True):
    ModelDirectory = BaseDirectory + '/BuildingModels/%s'%ID
    if os.path.isdir(ModelDirectory + '/EigenValueAnalysis') != True:
        os.chdir(ModelDirectory)
        os.mkdir('EigenValueAnalysis')
        
    if GenerateModelSwitch: 
        # Copy baseline files 
        copy_tree(BaseDirectory + "/BuildingInfo/%s/BaselineTclFiles/OpenSees3DModels/EigenValueAnalysis"%ID, 
                  ModelDirectory + '/EigenValueAnalysis')

        os.chdir(ModelDirectory + '/EigenValueAnalysis')
        # Generate OpenSees model
        defineNodes3DModel(ModelDirectory + '/EigenValueAnalysis', BuildingModel)
        defineRigidFloorDiaphragm3DModel(ModelDirectory + '/EigenValueAnalysis', BuildingModel)
        defineFixities3DModel(ModelDirectory + '/EigenValueAnalysis', BuildingModel)
        defineWoodPanelMaterials3DModel(ModelDirectory + '/EigenValueAnalysis', BuildingModel)
        defineWoodPanels3DModel(ModelDirectory + '/EigenValueAnalysis', BuildingModel)
        defineLeaningColumn3DModel(ModelDirectory + '/EigenValueAnalysis', BuildingModel)
        defineLeaningColumnFlexuralSprings3DModel(ModelDirectory + '/EigenValueAnalysis', BuildingModel)
        defineGravityLoads3DModel(ModelDirectory + '/EigenValueAnalysis', BuildingModel)
        defineMasses3DModel(ModelDirectory + '/EigenValueAnalysis', BuildingModel)
        if BuildingModel.XRetrofitFlag or BuildingModel.ZRetrofitFlag:
            defineMomentFrame3DModel(ModelDirectory + '/EigenValueAnalysis', BuildingModel, DB_Directory)
        setupEigenAnalysis(ModelDirectory + '/EigenValueAnalysis', BuildingModel, NumModes)
        define3DEigenValueAnalysisModel(ModelDirectory + '/EigenValueAnalysis', BuildingModel)

        os.system("cd %s/EigenValueAnalysis"%ModelDirectory)
        os.system('OpenSees Model.tcl')
    
    with open(ModelDirectory + '/EigenValueAnalysis/Analysis_Results/Modes/periods.out', 'r') as f:
        temp = f.read() 
    temp = temp.split('\n')
    periods = [float(i) for i in temp[0:NumModes]]

    return periods

def generatePushoverAnalysisModel(ID, BuildingModel, BaseDirectory, DB_Directory, GenerateModelSwitch = True, RunPushoverSwitch = False):
    ModelDirectory = BaseDirectory + '/BuildingModels/%s'%ID
    if os.path.isdir(ModelDirectory + '/PushoverAnalysis') != True:
        os.chdir(ModelDirectory)
        os.mkdir('PushoverAnalysis')
        
    if GenerateModelSwitch: 
        # Copy baseline files 
        copy_tree(BaseDirectory + "/BuildingInfo/%s/BaselineTclFiles/OpenSees3DModels/PushoverAnalysis"%ID, 
                  ModelDirectory + '/PushoverAnalysis')

        os.chdir(ModelDirectory + '/PushoverAnalysis')
        # Generate OpenSees model
        defineNodes3DModel(ModelDirectory + '/PushoverAnalysis', BuildingModel)
        defineRigidFloorDiaphragm3DModel(ModelDirectory + '/PushoverAnalysis', BuildingModel)
        defineFixities3DModel(ModelDirectory + '/PushoverAnalysis', BuildingModel)
        defineWoodPanelMaterials3DModel(ModelDirectory + '/PushoverAnalysis', BuildingModel)
        defineWoodPanels3DModel(ModelDirectory + '/PushoverAnalysis', BuildingModel)
        defineLeaningColumn3DModel(ModelDirectory + '/PushoverAnalysis', BuildingModel)
        defineLeaningColumnFlexuralSprings3DModel(ModelDirectory + '/PushoverAnalysis', BuildingModel)
        defineGravityLoads3DModel(ModelDirectory + '/PushoverAnalysis', BuildingModel)
        defineMasses3DModel(ModelDirectory + '/PushoverAnalysis', BuildingModel)
        if BuildingModel.XRetrofitFlag or BuildingModel.ZRetrofitFlag:
            defineMomentFrame3DModel(ModelDirectory + '/PushoverAnalysis', BuildingModel, DB_Directory)
        defineBaseReactionRecorders3DModel(ModelDirectory + '/PushoverAnalysis', BuildingModel, 'Pushover')
        defineWoodPanelRecorders3DModel(ModelDirectory + '/PushoverAnalysis', BuildingModel, 'Pushover')
        defineNodeDisplacementRecorders3DModel(ModelDirectory + '/PushoverAnalysis', BuildingModel, 'Pushover')
        defineStoryDriftRecorders3DModel(ModelDirectory + '/PushoverAnalysis', BuildingModel, 'Pushover')
        defineAllRecorders3DModel(ModelDirectory + '/PushoverAnalysis', 'Pushover')
        definePushoverLoading3DModel(ModelDirectory + '/PushoverAnalysis', BuildingModel)
        define3DPushoverAnalysisModel(ModelDirectory + '/PushoverAnalysis', BuildingModel)
        setupPushoverAnalysis(ModelDirectory + '/PushoverAnalysis', BuildingModel)
        
    if RunPushoverSwitch:
        os.system("cd %s/PushoverAnalysis"%ModelDirectory)
        os.system('OpenSees RunXPushoverAnalysis.tcl')
        os.system('OpenSees RunZPushoverAnalysis.tcl')
        
        

def generateDynamicAnalysisModel(ID, BuildingModel, BaseDirectory, DB_Directory, ModalPeriod, GenerateModelSwitch = True):
    ModelDirectory = BaseDirectory + '/BuildingModels/%s'%ID
    if os.path.isdir(ModelDirectory + '/DynamicAnalysis') != True:
        os.chdir(ModelDirectory)
        os.mkdir('DynamicAnalysis')
        
    if GenerateModelSwitch: 
        # Copy baseline files 
        copy_tree(BaseDirectory + "/BuildingInfo/%s/BaselineTclFiles/OpenSees3DModels/DynamicAnalysis"%ID, 
                  ModelDirectory + '/DynamicAnalysis')

        os.chdir(ModelDirectory + '/DynamicAnalysis')
        # Generate OpenSees model
        defineNodes3DModel(ModelDirectory + '/DynamicAnalysis', BuildingModel)
        defineRigidFloorDiaphragm3DModel(ModelDirectory + '/DynamicAnalysis', BuildingModel)
        defineFixities3DModel(ModelDirectory + '/DynamicAnalysis', BuildingModel)
        defineWoodPanelMaterials3DModel(ModelDirectory + '/DynamicAnalysis', BuildingModel)
        defineWoodPanels3DModel(ModelDirectory + '/DynamicAnalysis', BuildingModel)
        defineLeaningColumn3DModel(ModelDirectory + '/DynamicAnalysis', BuildingModel)
        defineLeaningColumnFlexuralSprings3DModel(ModelDirectory + '/DynamicAnalysis', BuildingModel)
        defineGravityLoads3DModel(ModelDirectory + '/DynamicAnalysis', BuildingModel)
        defineMasses3DModel(ModelDirectory + '/DynamicAnalysis', BuildingModel)
        if BuildingModel.XRetrofitFlag or BuildingModel.ZRetrofitFlag:
            defineMomentFrame3DModel(ModelDirectory + '/DynamicAnalysis', BuildingModel, DB_Directory)
        defineDamping3DModel(ModelDirectory + '/DynamicAnalysis', BuildingModel, ModalPeriod)
        
        defineBaseReactionRecorders3DModel(ModelDirectory + '/DynamicAnalysis', BuildingModel, 'Dynamic')
        defineWoodPanelRecorders3DModel(ModelDirectory + '/DynamicAnalysis', BuildingModel, 'Dynamic')
        defineNodeDisplacementRecorders3DModel(ModelDirectory + '/DynamicAnalysis', BuildingModel, 'Dynamic')
        defineNodeAccelerationRecorders3DModel(ModelDirectory + '/DynamicAnalysis', BuildingModel)
        defineStoryDriftRecorders3DModel(ModelDirectory + '/DynamicAnalysis', BuildingModel, 'Dynamic')
        defineAllRecorders3DModel(ModelDirectory + '/DynamicAnalysis', 'Dynamic')
        defineDynamicAnalysisParameters3DModel(ModelDirectory + '/DynamicAnalysis', BuildingModel)
        define3DDynamicAnalysisModel(ModelDirectory + '/DynamicAnalysis', BuildingModel)
        

def defineMomentFrame3DModel(ModelDirectory, BuildingModel, DB_Directory):
	os.chdir(DB_Directory)
	section_db = pd.read_csv('Database.csv',encoding = "ISO-8859-1")

	os.chdir(ModelDirectory)
	with open('DefineRetrofit3DModel.tcl','w') as tclfile:
		tclfile.write('## Define Beam Section Properties and Element\n')
		tclfile.write('# These number can be modified regarding convergence issues]\n')
		tclfile.write('uniaxialMaterial Elastic\t99999\t1e-6;\n')
		tclfile.write('uniaxialMaterial Elastic\t199999\t1e6;\n\n')
		tclfile.write('# Define Material Properties\n')
		tclfile.write('set\tEs\t29000.0; #steel Young modulus\n')
		tclfile.write('set\tG\t11500.0; # steel shear modulus\n')
		tclfile.write('set\tn\t10.0; # stiffness multiplier for rotational spring\n\n')
		tclfile.write('## Define Moment Frame Damping Parameters\n')
		tclfile.write('set omegaI [expr (2.0 * $pi) / ($periodForRayleighDamping_1)];\n')
		tclfile.write('set omegaJ [expr (2.0 * $pi) / ($periodForRayleighDamping_2)];\n')
		tclfile.write('set alpha1Coeff [expr (2.0 * $omegaI * $omegaJ) / ($omegaI + $omegaJ)];\n')
		tclfile.write('set alpha2Coeff [expr (2.0) / ($omegaI + $omegaJ)];\n')
		tclfile.write('set alpha1  [expr $alpha1Coeff*0.02];\n')
		tclfile.write('set alpha2  [expr $alpha2Coeff*0.02];\n')
		tclfile.write('set alpha2ToUse [expr 1.1 * $alpha2];  # 1.1 factor is becuase we apply to only LE elements\n\n')

		tclfile.write('#Define Geometric Transformations\n')
		tclfile.write('set XBeamLinearTransf 4;\n')
		tclfile.write('geomTransf Linear $XBeamLinearTransf\t0\t0\t1;\n\n')
		tclfile.write('set ZBeamLinearTransf 3;\n')
		tclfile.write('geomTransf Linear $ZBeamLinearTransf\t1\t0\t0;\n\n')       

		if BuildingModel.XRetrofit:
			for i in BuildingModel.XRetrofit:
				writeSingleFrameInfo(tclfile, BuildingModel, i, 'x', section_db, True)

		if BuildingModel.ZRetrofit:
			for i in BuildingModel.ZRetrofit:
				writeSingleFrameInfo(tclfile, BuildingModel, i, 'z', section_db, True)



def writeSingleFrameInfo(tclfile, ModelClass, FrameDict, Direction, section_db, DBFlag = True):
    tclfile.write('#Joint Nodes \n')
    for i,j in enumerate(FrameDict['JointCoor']):
        tclfile.write('node\t%i\t%.4f\t%.4f\t%.4f;\n'%(FrameDict['JointOSLabel'][i],j[0],j[1],j[2]))
    tclfile.write('\n')

    tclfile.write('#Beam Hinge Nodes \n')
    for i,j in enumerate(FrameDict['BeamHingeCoor']):
        tclfile.write('node\t%i\t%.4f\t%.4f\t%.4f;\n'%(FrameDict['BeamHingeOSLabel'][i],j[0],j[1],j[2]))
    tclfile.write('\n')

    tclfile.write('#Column Hinge Nodes \n')
    for i,j in enumerate(FrameDict['ColHingeCoor']):
        tclfile.write('node\t%i\t%.4f\t%.4f\t%.4f;\n'%(FrameDict['ColHingeOSLabel'][i],j[0],j[1],j[2]))  
    tclfile.write('\n')

    tclfile.write('#Frame Fixities\n')
    for i,j in enumerate(FrameDict['JointCoor']):
        if j[1] == 0:
            tclfile.write('fix\t%i\t%i\t%i\t%i\t%i\t%i\t%i;\n'%(FrameDict['JointOSLabel'][i],1,1,1,1,1,1))
    tclfile.write('\n')

    tclfile.write('#Joint Nodes Rigid Diaphragm\n')
    tclfile.write('#Seeting rigid floor diaphragm constraint on\n')
    tclfile.write('set RigidDiaphragm ON;\n')
    tclfile.write('set perpDirn\t2;\n')

    floorlabel = 2000
    for k in range(1, len(ModelClass.floorHeights)):
        for i,j in enumerate(FrameDict['JointCoor']):
            if j[1] == ModelClass.floorHeights[k]:
                tclfile.write('rigidDiaphragm\t$perpDirn\t%i\t%i;\n'%(floorlabel,FrameDict['JointOSLabel'][i]))
        floorlabel += 1000
    tclfile.write('\n')
    tclfile.write('#Define Moment Frame Beam Section Properties and Element\n')
    ComponentID = []
    # There not necessarily exists beam in the retrofit, where the cases represent canteliver column retorfit 
    if FrameDict['BeamSection']:
        # Two options: select based on section or select based on self-defined area and moment of intertia 
        # If section size is directly used, hinge parameters would be directly calculated
        # Otherwise, the hinge parameters should be given 
        if DBFlag: 
            s_info = extractSectionInfo(FrameDict['BeamSection'][0], section_db)
            s_info['unbraced_length'] = compute3DDistance(FrameDict['BeamHingeCoor'])
            Abm, Ibm = s_info['A'], s_info['Ix'] # Section information 
            hinge_param = calculateHingeParameters(s_info) # Compute hinge parameters
            FrameDict['BeamHingeParameter'] = hinge_param
        else: 
            Abm, Ibm = FrameDict['BeamArea'], FrameDict['BeamI']
            hingeparam = FrameDict['BeamHingeParameter']

        tclfile.write('set Abm\t%.4f; # cross-section area \n'%Abm)
        tclfile.write('set Ibm\t%.4f; # momment of inertia \n'%Ibm)
        tclfile.write('set Ibm_mod\t[expr $Ibm*($n+1.0)/$n]; # modified moment of inertia for beam \n')
        tclfile.write('set Jbm\t1000000.0; # inertia of tortion for beam, just assign a small number \n')
        tclfile.write('set WBay\t%.4f; # bay length \n'%compute3DDistance(FrameDict['BeamHingeCoor']))
        tclfile.write('set Ks_bm\t[expr $n*6.0*$Es*$Ibm_mod/$WBay]; # rotational stiffness of beam springs \n\n')

        tclfile.write('#define rotational spring properties and create spring elements using "rotSpring3DModIKModel" procedure\n')
        tclfile.write('#rotSpring3DModIKModel creates a uniaxial material spring with a bilinear response based on Modified Ibarra Krawinkler Deterioration Model\n\n')
        tclfile.write('#define beam hinges\n')
        tclfile.write('set My_bm\t%.4f; #yield moment\n'%(hinge_param['My']))
        tclfile.write('set McMy_bm\t%.4f; \n'%(hinge_param['McMy']))
        tclfile.write('set LS_bm\t%.4f; \n'%((hinge_param['Lambda']/hinge_param['theta_p'])*11))
        tclfile.write('set LK_bm\t%.4f; \n'%((hinge_param['Lambda']/hinge_param['theta_p'])*11))
        tclfile.write('set LA_bm\t%.4f; \n'%1000)
        tclfile.write('set LD_bm\t%.4f; \n'%((hinge_param['Lambda']/hinge_param['theta_p'])*11))
        tclfile.write('set cS_bm\t%.2f; \n'%1)
        tclfile.write('set cK_bm\t%.2f; \n'%1)
        tclfile.write('set cA_bm\t%.2f; \n'%1)
        tclfile.write('set cD_bm\t%.2f; \n'%1)
        tclfile.write('set theta_pP_bm\t%.4f; \n'%hinge_param['theta_p'])
        tclfile.write('set theta_pN_bm\t%.4f; \n'%hinge_param['theta_p'])
        tclfile.write('set theta_pcP_bm\t%.4f; \n'%hinge_param['theta_pc'])
        tclfile.write('set theta_pcN_bm\t%.4f; \n'%hinge_param['theta_pc'])
        tclfile.write('set ResP_bm\t%.4f; \n'%0.4)
        tclfile.write('set ResN_bm\t%.4f; \n'%0.4)
        tclfile.write('set theta_uP_bm\t%.4f; \n'%hinge_param['theta_u'])
        tclfile.write('set theta_uN_bm\t%.4f; \n'%hinge_param['theta_u'])
        tclfile.write('set DP_bm\t%.2f; \n'%1)
        tclfile.write('set DN_bm\t%.2f; \n'%1)
        tclfile.write('set a_bm\t[expr ($n+1.0)*($My_bm*($McMy_bm-1.0)) / ($Ks_bm*$theta_pP_bm)];\n')
        tclfile.write('set b_bm\t[expr ($a_bm)/(1.0+$n*(1.0-$a_bm))];\n\n')

        tclfile.write('#define beam springs\n')
        tclfile.write('#Spring ID: "8xya", where 8 = beam spring, x = Direction, y = Column Line, a = Floor, "x" convention: 5 = x Frame, 6 = z Frame\n')

        # if Direction == 'x':
        #     BeamHingeID = 8500
        # elif Direction == 'z':
        #     BeamHingeID = 8600
        # else: print('Invalid direction')

        for i, j in zip(FrameDict['BeamHingeCoor'], FrameDict['BeamHingeOSLabel']):
            BeamNodeLabel = FrameDict['JointOSLabel'][FrameDict['JointCoor'].index(i)]
            if Direction == 'x':
              tclfile.write('rotSpring3DRotZModIKModel\t%i\t%i\t%i\t$Ks_bm $b_bm $b_bm $My_bm [expr -$My_bm]\t$LS_bm $LK_bm $LA_bm $LD_bm $cS_bm $cK_bm $cA_bm $cD_bm\t$theta_pP_bm $theta_pN_bm $theta_pcP_bm $theta_pcN_bm\t$ResP_bm $ResN_bm $theta_uP_bm $theta_uN_bm $DP_bm $DN_bm;\n'%(BeamNodeLabel+j, BeamNodeLabel, j))
            elif Direction == 'z':
              tclfile.write('rotSpring3DRotXModIKModel\t%i\t%i\t%i\t$Ks_bm $b_bm $b_bm $My_bm [expr -$My_bm]\t$LS_bm $LK_bm $LA_bm $LD_bm $cS_bm $cK_bm $cA_bm $cD_bm\t$theta_pP_bm $theta_pN_bm $theta_pcP_bm $theta_pcN_bm\t$ResP_bm $ResN_bm $theta_uP_bm $theta_uN_bm $DP_bm $DN_bm;\n'%(BeamNodeLabel+j, BeamNodeLabel, j))

        tclfile.write('#Define beams\n')
        if Direction == 'x':
            tclfile.write('element elasticBeamColumn\t%s\t%i\t%i\t $Abm\t$Es\t$G\t$Jbm\t$Ibm\t$Ibm\t$XBeamLinearTransf;\n\n'%(str(int(FrameDict['BeamHingeOSLabel'][0]))+str(int(FrameDict['BeamHingeOSLabel'][1])), FrameDict['BeamHingeOSLabel'][0],FrameDict['BeamHingeOSLabel'][1]))
        elif Direction == 'z':
            tclfile.write('element elasticBeamColumn\t%s\t%i\t%i\t $Abm\t$Es\t$G\t$Jbm\t$Ibm\t$Ibm\t$ZBeamLinearTransf;\n\n'%(str(int(FrameDict['BeamHingeOSLabel'][0]))+str(int(FrameDict['BeamHingeOSLabel'][1])), FrameDict['BeamHingeOSLabel'][0],FrameDict['BeamHingeOSLabel'][1]))            
        ComponentID.append(str(int(FrameDict['BeamHingeOSLabel'][0]))+str(int(FrameDict['BeamHingeOSLabel'][1])))

# Loop over all columns
    for i in range(len(FrameDict['ColSection'])):
        if DBFlag: 
            s_info = extractSectionInfo(FrameDict['ColSection'][i], section_db)
            s_info['unbraced_length'] = ModelClass.storyHeights[0]
            Acol, Icol = s_info['A'], s_info['Ix'] # Section information 
            hinge_param = calculateHingeParameters(s_info) # Compute hinge parameters
            FrameDict['ColumnHingeParameter'] = hinge_param
        else: 
            Acol, Icol = FrameDict['ColumnArea'][i], ModelClass.XRetrofit[0]['ColumnI'][i]
            hingeparam = FrameDict['ColumnHingeParameter']

        tclfile.write('set Acol\t%.4f; # cross-section area \n'%Acol)
        tclfile.write('set Icol\t%.4f; # momment of inertia \n'%Icol)
        tclfile.write('set Icol_mod\t[expr $Icol*($n+1.0)/$n]; # modified moment of inertia for beam \n')
        tclfile.write('set Jcol\t1000000.0; # inertia of tortion for beam, just assign a small number \n')
        tclfile.write('set HStory\t%.4f; # column length \n'%ModelClass.storyHeights[0])
        tclfile.write('set Ks_col\t[expr $n*6.0*$Es*$Icol_mod/$HStory]; # rotational stiffness of beam springs \n\n')

        tclfile.write('#define rotational spring properties and create spring elements using "rotSpring3DModIKModel" procedure\n')
        tclfile.write('#rotSpring3DModIKModel creates a uniaxial material spring with a bilinear response based on Modified Ibarra Krawinkler Deterioration Model\n\n')
        tclfile.write('set My_col\t%.4f; #yield moment\n'%(hinge_param['My']))
        tclfile.write('set McMy_col\t%.4f; \n'%(hinge_param['McMy']))
        tclfile.write('set LS_col\t%.4f; \n'%((hinge_param['Lambda']/hinge_param['theta_p'])*11))
        tclfile.write('set LK_col\t%.4f; \n'%((hinge_param['Lambda']/hinge_param['theta_p'])*11))
        tclfile.write('set LA_col\t%.4f; \n'%1000)
        tclfile.write('set LD_col\t%.4f; \n'%((hinge_param['Lambda']/hinge_param['theta_p'])*11))
        tclfile.write('set cS_col\t%.2f; \n'%1)
        tclfile.write('set cK_col\t%.2f; \n'%1)
        tclfile.write('set cA_col\t%.2f; \n'%1)
        tclfile.write('set cD_col\t%.2f; \n'%1)
        tclfile.write('set theta_pP_col\t%.4f; \n'%hinge_param['theta_p'])
        tclfile.write('set theta_pN_col\t%.4f; \n'%hinge_param['theta_p'])
        tclfile.write('set theta_pcP_col\t%.4f; \n'%hinge_param['theta_pc'])
        tclfile.write('set theta_pcN_col\t%.4f; \n'%hinge_param['theta_pc'])
        tclfile.write('set ResP_col\t%.4f; \n'%0.4)
        tclfile.write('set ResN_col\t%.4f; \n'%0.4)
        tclfile.write('set theta_uP_col\t%.4f; \n'%hinge_param['theta_u'])
        tclfile.write('set theta_uN_col\t%.4f; \n'%hinge_param['theta_u'])
        tclfile.write('set DP_col\t%.2f; \n'%1)
        tclfile.write('set DN_col\t%.2f; \n'%1)
        tclfile.write('set a_col\t[expr ($n+1.0)*($My_col*($McMy_col-1.0)) / ($Ks_col*$theta_pP_col)];\n')
        tclfile.write('set b_col\t[expr ($a_col)/(1.0+$n*(1.0-$a_col))];\n\n')   

        tclfile.write('#define column springs\n')
        tclfile.write('#Spring ID: "7xya", where 7 = column spring, x = Direction, y = Column Line, a = Floor, "x" convention: 5 = x Frame, 6 = z Frame\n')

        # Direction = 'x'
        # if Direction == 'x':
        #     ColHingeID = 7500
        # elif Direction == 'z':
        #     ColHingeID = 7600
        # else: print('Invalid direction')

        for p, q in zip(FrameDict['ColHingeCoor'][2*i:2*(i+1)], FrameDict['ColHingeOSLabel'][2*i:2*(i+1)]):
            ColNodeLabel = FrameDict['JointOSLabel'][FrameDict['JointCoor'].index(p)]
            if Direction == 'x':
              tclfile.write('rotSpring3DRotZModIKModel\t%i\t%i\t%i\t$Ks_col $b_col $b_col $My_col [expr -$My_col]\t$LS_col $LK_col $LA_col $LD_col $cS_col $cK_col $cA_col $cD_col\t$theta_pP_col $theta_pN_col $theta_pcP_col $theta_pcN_col\t$ResP_col $ResN_col $theta_uP_col $theta_uN_col $DP_col $DN_col;\n'%(ColNodeLabel+q, ColNodeLabel, q))
            elif Direction == 'z':
              tclfile.write('rotSpring3DRotXModIKModel\t%i\t%i\t%i\t$Ks_col $b_col $b_col $My_col [expr -$My_col]\t$LS_col $LK_col $LA_col $LD_col $cS_col $cK_col $cA_col $cD_col\t$theta_pP_col $theta_pN_col $theta_pcP_col $theta_pcN_col\t$ResP_col $ResN_col $theta_uP_col $theta_uN_col $DP_col $DN_col;\n'%(ColNodeLabel+q, ColNodeLabel, q))

        tclfile.write('#Define columns\n')
        tclfile.write('element elasticBeamColumn\t%s\t%i\t%i\t $Acol\t$Es\t$G\t$Jcol\t$Icol\t$Icol\t$PDeltaTransf;\n\n'%(str(int(FrameDict['ColHingeOSLabel'][i]))+str(int(FrameDict['ColHingeOSLabel'][i+2])), FrameDict['ColHingeOSLabel'][i],FrameDict['ColHingeOSLabel'][i+2]))   
        ComponentID.append(str(int(FrameDict['ColHingeOSLabel'][i]))+str(int(FrameDict['ColHingeOSLabel'][i+2])))

    tclfile.write('region\t10\t-node\t')
    for i in FrameDict['JointOSLabel']:
        tclfile.write('%i\t'%i)
    tclfile.write('-rayleigh\t$alpha1\t0\t$alpha2ToUse\t0;\n')
    tclfile.write('region\t20\t-ele\t')
    for i in ComponentID:
        tclfile.write('%s\t'%i)
    tclfile.write('-rayleigh\t$alpha1\t0\t$alpha2ToUse\t0;\n')

###########################################

def extractSectionInfo(Section, DB):
	output = {'A': float(DB.loc[DB['AISC_Manual_Label'] == Section, 'A'].values[0]),
	'd': float(DB.loc[DB['AISC_Manual_Label'] == Section, 'd'].values[0]),
	'tf': float(DB.loc[DB['AISC_Manual_Label'] == Section, 'tf'].values[0]),
	'Ix': float(DB.loc[DB['AISC_Manual_Label'] == Section, 'Ix'].values[0]),
	'Zx': float(DB.loc[DB['AISC_Manual_Label'] == Section, 'Zx'].values[0]),
	'tw': float(DB.loc[DB['AISC_Manual_Label'] == Section, 'tw'].values[0]),
	'bf': float(DB.loc[DB['AISC_Manual_Label'] == Section, 'bf'].values[0]),
	'ry': float(DB.loc[DB['AISC_Manual_Label'] == Section, 'ry'].values[0])}
	return output
     
def calculateHingeParameters(section):
        """
        This method is used to compute the modeling parameters for plastic hinge using modified IMK material model.
        :return: a dictionary including each parameters required for nonlinear modeling in OpenSees.
        """
        # Following content is based on the following reference:
        # [1] Hysteretic models tha incorporate strength and stiffness deterioration
        # [2] Deterioration modeling of steel components in support of collapse prediction of steel moment frames under
        #     earthquake loading
        # [3] Global collapse of frame structures under seismic excitations
        # [4] Sidesway collapse of deteriorating structural systems under seismic excitations
        # dictionary keys explanations:
        #                              K0: beam stiffness, 6*E*Iz/L
        #                              Myp: bending strength, product of section modulus and material yield strength
        #                              My: effective yield strength, 1.06 * bending strength
        #                              Lambda: reference cumulative plastic rotation
        #                              theta_p: pre-capping plastic rotation
        #                              theta_pc: post-capping plastic rotation
        #                              as: strain hardening before modified by n (=10)
        #                              residual: residual strength ratio, use 0.40 per Lignos' OpenSees example
        #                              theta_u: ultimate rotation, use 0.40 per Lignos' OpenSees example
        # Note that for column, the unbraced length is the column length itself.
        # units: kips, inches
        # Note that column unbraced length is in feet, remember to convert it to inches
        c1 = 25.4  # c1_unit
        c2 = 6.895  # c2_unit
        McMy = 1.11  # Capping moment to yielding moment ratio. Lignos et al. used 1.05 whereas Prof. Burton used 1.11.
        Fy = 50 # Use 50ksi for woodframe building retrofit 
        plastic_hinge = {}
        h = section['d'] - 2*section['tf']  # Web depth
        plastic_hinge['McMy'] = 1.11
        plastic_hinge['K0'] = 6 * 29000 * section['Ix'] / (section['unbraced_length']) # Unbraced length should be in in
        plastic_hinge['Myp'] = section['Zx'] * Fy
        plastic_hinge['My'] = 1.06 * plastic_hinge['Myp']
        plastic_hinge['Lambda'] = 585 * (h/section['tw'])**(-1.14) \
                                       * (section['bf']/(2*section['tf']))**(-0.632) \
                                       * (section['unbraced_length']/section['ry'])**(-0.205) \
                                       * (c2 * Fy/355)**(-0.391)
        plastic_hinge['theta_p'] = 0.19 * (h/section['tw'])**(-0.314) \
                                        * (section['bf']/(2*section['tf']))**(-0.100) \
                                        * (section['unbraced_length']/section['ry'])**(-0.185) \
                                        * (section['unbraced_length']/section['d'])**0.113 \
                                        * (c1*section['d']/533)**(-0.760) \
                                        * (c2*Fy/355)**(-0.070)
        plastic_hinge['theta_pc'] = 9.52 * (h/section['tw'])**(-0.513) \
                                         * (section['bf']/(2*section['tf']))**(-0.863) \
                                         * (section['unbraced_length']/section['ry'])**(-0.108) \
                                         * (c2*Fy/355)**(-0.360)
        plastic_hinge['as'] = (McMy-1.0)*plastic_hinge['My']\
                                   /(plastic_hinge['theta_p']*plastic_hinge['K0'])
        plastic_hinge['residual'] = 0.40
        plastic_hinge['theta_u'] = 0.40

        return plastic_hinge

def compute3DDistance(coor):
    diff = [x-y for x, y in zip(coor[0] ,coor[1])]
    dif2 = [x**2 for x in diff]
    return np.sqrt(sum(dif2))  


def SaveModelJason(BuildingModelClass, FileName):
    # Convert all sub-sequences to list, since np.ndarry is not supported by json format
    model_dict = {}

    for key, vals in BuildingModelClass.__dict__.items():
        if isinstance(vals, np.ndarray):
            model_dict[key] = vals.tolist()
        elif isinstance(vals, dict): 
            temp = {}
            for subkey, subvalues in vals.items():
                if isinstance(subvalues, np.ndarray):
                    temp[subkey] = subvalues.tolist()
                else: temp[subkey] = subvalues
            model_dict[key] = temp
        else: model_dict[key] = vals

    with open(FileName,'w') as file:
        json.dump(model_dict, file, indent = 2)

        

def SetupDyamaicAnalysis(ModelDirectory, Scale_Sa_GM, GM_Num, GM_ID, GM_set, Model_Name, PairingID):
    '''
    This function is used for set up dynamic analysis for running single ground motion nonlinear analysis, incremental dynamic analysis, run to collapse dynamic analysis locally. 
    The function is based on RunDynamic.tcl. Make sure your model directory has this file.
    Scale_Sa_GM: the median Sa values for each hazard level 
    GM_Num: number of ground motion pairs in each hazard level (22 for FEMA Far Filed GM, 28 for FEMA Near Field GM)
    GM_ID: the ground motion pair you want to analyze 
    GM_set: specified ground motion folder 
    Model_Name: the name of model for current run
    PairinID: 1 or 2 the direction of applied ground motion 
                1 - apply X ground motion to X direction of the building
                2 - apply X ground motion to Z direction of the building
    '''
    os.chdir(ModelDirectory)
    fin = open('RunDynamic.tcl', 'rt')
    fout = open('RunDynamic_Single.tcl', 'wt')

    filedata = fin.read()
    filedata = filedata.replace('*Scale_Sa_GM*', Scale_Sa_GM)
    filedata = filedata.replace('*GMset_Num*', GM_Num)
    filedata = filedata.replace('*globalCounter*', str(GM_ID))
    filedata = filedata.replace('*GM_Info*', GM_set)
    filedata = filedata.replace('*ModelName*', Model_Name)
    filedata = filedata.replace('*PairingID*', str(PairingID))

    fout.write(filedata)
    fin.close()
    fout.close()