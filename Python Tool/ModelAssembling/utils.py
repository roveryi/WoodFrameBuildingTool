import numpy as np 
import os 
import pandas as pd
import json


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

      for j in range(BuildingModel.numberOfXDirectionWoodPanels[i]):
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
                                                             BuildingModel.leaningcolumnLoads[i,j]/g*((BuildingModel.floorMaximumXDimension[i+1]/2)**2 + (BuildingModel.floorMaximumZDimension[i+1]/2)**2),
                                                             BuildingModel.leaningcolumnLoads[i,j]/g*((BuildingModel.floorMaximumXDimension[i+1]/2)**2 + (BuildingModel.floorMaximumZDimension[i+1]/2)**2),
                                                             BuildingModel.leaningcolumnLoads[i,j]/g*((BuildingModel.floorMaximumXDimension[i+1]/2)**2 + (BuildingModel.floorMaximumZDimension[i+1]/2)**2)))
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

    if BuildingModel.XRetrofit:
      tclfile.write('# Define x-direction retrofit \n')
      tclfile.write('source DefineXMomentFrames3DModel.tcl\n\n')

    if BuildingModel.ZRetrofit:
      tclfile.write('# Define z-direction retrofit \n')
      tclfile.write('source DefineZMomentFrames3DModel.tcl\n\n')

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

    if BuildingModel.XRetrofit:
      tclfile.write('# Define x-direction retrofit \n')
      tclfile.write('source DefineXMomentFrames3DModel.tcl\n\n')

    if BuildingModel.ZRetrofit:
      tclfile.write('# Define z-direction retrofit \n')
      tclfile.write('source DefineZMomentFrames3DModel.tcl\n\n')

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

    if BuildingModel.XRetrofit:
      tclfile.write('# Define x-direction retrofit \n')
      tclfile.write('source DefineXMomentFrames3DModel.tcl\n\n')

    if BuildingModel.ZRetrofit:
      tclfile.write('# Define z-direction retrofit \n')
      tclfile.write('source DefineZMomentFrames3DModel.tcl\n\n')

    tclfile.write('# Define masses \n')
    tclfile.write('source DefineMasses3DModel.tcl\n\n')

    tclfile.write('# Define gravity loads \n')
    tclfile.write('source DefineGravityLoads3DModel.tcl\n\n')

    tclfile.write('# Perform gravity analysis \n')
    tclfile.write('source PerformGravityAnalysis.tcl\n\n')

    tclfile.write('# Define damping model\n')
    tclfile.write('source DefineDamping3DModel.tcl \n\n')

    tclfile.write('# Define ground motion scale factor \n')
    tclfile.write('set scalefactor [expr $g*100/100*$MCE_SF]; \n\n')

    tclfile.write('# Run time history \n')
    tclfile.write('source DefineBiDirectionalTimeHistory.tcl \n\n')

    tclfile.write('# Define all recorders\n')
    tclfile.write('source DefineAllRecorders3DModel.tcl\n\n')

def generateModalAnalysisModel(ID, BuildingModel, BaseDirectory, NumModes = 4, GenerateModelSwitch = True):
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
        setupEigenAnalysis(ModelDirectory + '/EigenValueAnalysis', BuildingModel, NumModes)
        define3DEigenValueAnalysisModel(ModelDirectory + '/EigenValueAnalysis', BuildingModel)

        os.system("cd %s/EigenValueAnalysis"%ModelDirectory)
        #!OpenSees Model.tcl
    
    with open(ModelDirectory + '/EigenValueAnalysis/Analysis_Results/Modes/periods.out', 'r') as f:
        temp = f.read() 
    temp = temp.split('\n')
    periods = [float(i) for i in temp[0:NumModes]]

    return periods

def generatePushoverAnalysisModel(ID, BuildingModel, BaseDirectory, GenerateModelSwitch = True, RunPushoverSwitch = False):
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
        #!OpenSees RunXPushoverAnalysis.tcl
        #!OpenSees RunZPushoverAnalysis.tcl
        
        

def generateDynamicAnalysisModel(ID, BuildingModel, BaseDirectory, ModalPeriod, GenerateModelSwitch = True):
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
        defineDamping3DModel(ModelDirectory + '/DynamicAnalysis', BuildingModel, ModalPeriod)
        
        defineBaseReactionRecorders3DModel(ModelDirectory + '/DynamicAnalysis', BuildingModel, 'Dynamic')
        defineWoodPanelRecorders3DModel(ModelDirectory + '/DynamicAnalysis', BuildingModel, 'Dynamic')
        defineNodeDisplacementRecorders3DModel(ModelDirectory + '/DynamicAnalysis', BuildingModel, 'Dynamic')
        defineNodeAccelerationRecorders3DModel(ModelDirectory + '/DynamicAnalysis', BuildingModel)
        defineStoryDriftRecorders3DModel(ModelDirectory + '/DynamicAnalysis', BuildingModel, 'Dynamic')
        defineAllRecorders3DModel(ModelDirectory + '/DynamicAnalysis', 'Dynamic')
        defineDynamicAnalysisParameters3DModel(ModelDirectory + '/DynamicAnalysis', BuildingModel)
        define3DDynamicAnalysisModel(ModelDirectory + '/DynamicAnalysis', BuildingModel)
        

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
    
   