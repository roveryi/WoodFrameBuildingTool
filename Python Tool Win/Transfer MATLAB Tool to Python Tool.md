# Transfer MATLAB Tool to Python Tool

### Input

$\bullet$ AnalysisParameters/DynamicAnalysis

Add file 'DemolitionDriftLimit.txt': rediual drift that trigger demolition 

Add file 'dampingModel.txt': Current options include 'TangentRayleigh', 'InitialRayleigh', 'CommittedRayleigh'

Add file 'dampingRatio.txt': damping ratio in absolute number, e.g 0.05 for 5% damping ratio

$\bullet$ BaselineTclFiles/OpenSees3DModels/DynamicAnalysis

Delete folder 'GroundMotionInfo', 'histories': save storage

$\bullet$ FrameRetrofit/*MomentFrames/Frame*/

Two options can be used for modeling retrofitting: 1. directly use AISC specified member sizes to retrofit, IKM model parameters are derived from member section size and paper (cite); 2. use user defined area and parameters to retrofit (hinge parameters should be given)

Add file 'BeamSection.txt': illustrates the beam section for retrofitting, can be None, which represents canteliver column retrofit

Add file 'ColumnSection.txt': illustrates the column section for retrofitting

$\bullet$ Loads

Change file name 'leaningcolumnLoads .txt' to 'leaningcolumnLoads.txt'

$\bullet$ SeismicDesignParameters

Add file 'SiteClass.txt': ASCE 7-16 specified site class A, B, C, D and E

$\bullet$ StructuralProperties

Merge folders 'XWoodPanelPinching4Materials' and 'ZWoodPanelPinching4Materials' to 'Pinching4Materials'

