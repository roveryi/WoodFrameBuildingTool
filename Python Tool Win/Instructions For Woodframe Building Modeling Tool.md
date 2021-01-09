## Instructions For Woodframe Building Modeling Tool

Author: Zhengxiang Yi

Email: roveryi@g.ucla.edu 



### Prerequisites 

Python Packages: numpy, pandas, os, sys

OpenSees in the environment path (so that Python can directly call OpenSees in the notebooks/scrips)



### Folders 

There are six folders under the main directory:

$\bullet$ BuildingInfo 

Contains the input information of each model  

$\bullet$ BuildingModels 

Contains the generated OpenSees models for each of the input model information and ground motion sets. Each of the subfolder contains DynamicAnalysis, EigenValueAnalysis and PushoverAnalysis folders. 

$\bullet$ ModelAssembling

Contains the functions, databases used for generating OpenSees models. 

$\textbf{NEED TO MODIFY}$: BuildingName.txt, change the file names you want to generate OpenSees model for, the file names should be consistent with the folder names under BuildingInfo directory.  To make life easier when running models on Hoffman, it's better to name the models by name + number. For example, there are 100 models, name them case1 through case 100. 

$\bullet$ PostProcessing

Contains the functions, databases used for performing post-processing and FEMA P-58 loss assessment. DO NOT change anything here. 

$\bullet$ Hoffman 

Contains the dynamic analysis folders and required ground motions, scripts to execute IDA/MSA on Hoffman2. 

$\bullet$ Results 

Contains the results (in json format) of each model. 



### How to create model input information 

1. Go to folder BuildingInfo, go to the folder you want to modify the model inputs 

2. Each model contains 7 subfolders 

   AnalysisParameters: defines the analysis parameters for dynamic and static analysis. Damping related files are under this directory. 

   BaselineTclFiles: don't change 

   FrameRetrofit: defines the retrofit moment frame information, not required for PEER-CEA project

   Geometry: define the building geometry. 

   Loads: define loads

   SeismicDesignParameters: define seismic design parameters, not required for PEER-CEA project

   StructuralProperties: defines material properties, panel heights, panel lengths and materials for each of the wood panel

3. If you want to change damping parameters: go to AnalysisParameters/DynamicAnalysis, change the number in dampingRatio.txt
4. If you want to change cripple wall height: go to Geometry, change the heights in storyHeights.txt; then go to StructuralProperties/XWoodPanels and ZWoodPanels, change the panel heights in height.txt; then compute cripple wall level weight, go to Loads, change the floorWeights.txt and leaningcolumnLoads.txt 
5. If you want to change seismic weight: go to Loads, change the floorWeights.txt and leaningcolumnLoads.txt 
6. If you want to change material properties: go to StructuralProperties/Pinching4Materials, change the material properties of the corresponding material number in d1.txt through d4.txt and f1.txt through f4.txt. The material number for each wood panel is specified in StructuralProperties/XWoodPanels or ZWoodPanels Pinching4MaterialNumber.txt. 

*Alternatively*

You can check the Jupyter notebook GenerateModels.ipynb. 



### How to generate OpenSees models

1. Go to folder ModelAssembling, open Jupyter notebook CreateOSModels.ipynb
2. Modify the path names (quoted by #) to match the folder locations on your local machine 
3. Run the first chunk to load required packages 
4. Run the second chunk to create OpenSees models and run Pushover Analysis
5. Run the third chunk to create all models used for dynamic analysis on Hoffman2

*Optional*

6. Run the fourth chunk to plot pushover curves for each of the models 
7. Run the fifth chunk to run a single ground motion (a single hazard level) for a single model on your local machine (usually I use it for model integrity check)
8. Run the six chunk to run IDA/MSA for a single model on your local machine 
9. Run the seventh chunk to perform IDA/MSA post-processing for a single model on your local machine 
10. Run the eighth chunk to perform FEMA P-58 loss assessment for a single model on your local machine 



### How to run IDA/MAS and post-processing on Hoffman 

###################################################################

My Hoffman ID (The folder 'project-hvburton' has 2TB storage)

ID: roveryi

Password: MAny8Aak

###################################################################

1. Login to your account, go to the folder you want to store the models, upload the entire Hoffman folder. Remember to check storage using command "myquota". (The current ground motions in the Hoffman folder is PEER-CEA San Francisco $Vs_{30}=270m/s$ site. Contact me if changes are needed.)

2. Use cd + folder name to go to the folder containing all models 

3. $\textbf{NEED TO MODIFY}$: 

   $\bullet$ RunIDAHoffmanXx.tcl

   ​	line 105: Model_Num, change the Model_Num to the number of OpenSees models you have

   ​	line 342: $$baseDir/case$ModelID1;  change 'case' to the model name you have 

   $\bullet$ PostProcessing.tcl (you can run analysis first and let me know when you finish the analysis, I can take care of the post-processing from my end)

   ​	line 21: change the ResultsDir to the directory you want to store the results 

   ​	line 22: change the ProjectName to the name of the main folder containing all models 

   ​	line 27: change the cwH to the csv file containing the cripple wall heights for all models 

   ​	line 34: change the NumStory to the number of story of current model you are running post-processing for 

   ​	line 38: change the directory to the folder containing all models 

   ​	line 61: create_component_list function is used for generating the components in the woodframe house based on PEER-CEA project, let me know if you need to change the baseline building type 

4. Use jobarray.q command to go into jobarray mode 

5. Use build command to create a job on Hoffman2

6. Use BuildJobArray_Yi_1.sh for job array program for IDA/MSA

   Use PythonGo.sh for job array program for post-processing 

7. Lower run number for MSA is 1, upper run number for MSA is 720. (16 hazard levels, each contains 45 ground motions)

8. 24 hours time limit, 4096 RAM usage, I usually use 2 cores to run IDA/MSA

9. submit the job

10. Use status command to check 





