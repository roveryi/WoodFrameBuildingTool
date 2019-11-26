
% This function is used to define the SAWS parameters for each unique
% material used in the building model

function [XWoodPanelSAWSMaterials, ZWoodPanelSAWSMaterials] = ...
    defineSAWSMaterials(XPanelSAWSMaterialParametersLocation,...
    ZPanelSAWSMaterialParametersLocation)

% Go to folder where x-direction wood panel SAWS parameters are stored
cd(XPanelSAWSMaterialParametersLocation);

% Define struct with SAWS parameters
XWoodPanelSAWSMaterials.alpha = load('alpha.txt');
XWoodPanelSAWSMaterials.beta = load('beta.txt');
XWoodPanelSAWSMaterials.DU = load('DU.txt');
XWoodPanelSAWSMaterials.F0 = load('F0.txt');
XWoodPanelSAWSMaterials.FI = load('FI.txt');
XWoodPanelSAWSMaterials.materialNumber = load('materialNumber.txt');
XWoodPanelSAWSMaterials.R1 = load('R1.txt');
XWoodPanelSAWSMaterials.R2 = load('R2.txt');
XWoodPanelSAWSMaterials.R3 = load('R3.txt');
XWoodPanelSAWSMaterials.R4 = load('R4.txt');
XWoodPanelSAWSMaterials.S0 = load('S0.txt');

% Go to folder where z-didirection wood panel SAWS parameters are
% stored
cd(ZPanelSAWSMaterialParametersLocation);

% Define struct with SAWS parameters
ZWoodPanelSAWSMaterials.alpha = load('alpha.txt');
ZWoodPanelSAWSMaterials.beta = load('beta.txt');
ZWoodPanelSAWSMaterials.DU = load('DU.txt');
ZWoodPanelSAWSMaterials.F0 = load('F0.txt');
ZWoodPanelSAWSMaterials.FI = load('FI.txt');
ZWoodPanelSAWSMaterials.materialNumber = load('materialNumber.txt');
ZWoodPanelSAWSMaterials.R1 = load('R1.txt');
ZWoodPanelSAWSMaterials.R2 = load('R2.txt');
ZWoodPanelSAWSMaterials.R3 = load('R3.txt');
ZWoodPanelSAWSMaterials.R4 = load('R4.txt');
ZWoodPanelSAWSMaterials.S0 = load('S0.txt');
end

