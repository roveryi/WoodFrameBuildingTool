
% This function is used to define the Pinching4 parameters for each unique
% material used in the building model

function [XWoodPanelPinching4Materials, ZWoodPanelPinching4Materials] = ...
    definePinching4Materials(XPanelPinching4MaterialParametersLocation,...
    ZPanelPinching4MaterialParametersLocation)

% Go to folder where x-direction wood panel SAWS parameters are stored
cd(XPanelPinching4MaterialParametersLocation);

% Define struct with SAWS parameters
XWoodPanelPinching4Materials.d1 = load('d1.txt');
XWoodPanelPinching4Materials.f1 = load('f1.txt');
XWoodPanelPinching4Materials.d2 = load('d2.txt');
XWoodPanelPinching4Materials.f2 = load('f2.txt');
XWoodPanelPinching4Materials.d3 = load('d3.txt');
XWoodPanelPinching4Materials.f3 = load('f3.txt');
XWoodPanelPinching4Materials.d4 = load('d4.txt');
XWoodPanelPinching4Materials.f4 = load('f4.txt');
XWoodPanelPinching4Materials.materialNumber = load('materialNumber.txt');
XWoodPanelPinching4Materials.rDisp = load('rDisp.txt');
XWoodPanelPinching4Materials.rForce = load('rForce.txt');
XWoodPanelPinching4Materials.uForce = load('uForce.txt');
XWoodPanelPinching4Materials.gD1 = load('gD1.txt');
XWoodPanelPinching4Materials.gDlim = load('gDlim.txt');
XWoodPanelPinching4Materials.gK1 = load('gK1.txt');
XWoodPanelPinching4Materials.gKlim = load('gKlim.txt');

% Go to folder where z-didirection wood panel SAWS parameters are
% stored
cd(ZPanelPinching4MaterialParametersLocation);

% Define struct with SAWS parameters
ZWoodPanelPinching4Materials.d1 = load('d1.txt');
ZWoodPanelPinching4Materials.f1 = load('f1.txt');
ZWoodPanelPinching4Materials.d2 = load('d2.txt');
ZWoodPanelPinching4Materials.f2 = load('f2.txt');
ZWoodPanelPinching4Materials.d3 = load('d3.txt');
ZWoodPanelPinching4Materials.f3 = load('f3.txt');
ZWoodPanelPinching4Materials.d4 = load('d4.txt');
ZWoodPanelPinching4Materials.f4 = load('f4.txt');
ZWoodPanelPinching4Materials.materialNumber = load('materialNumber.txt');
ZWoodPanelPinching4Materials.rDisp = load('rDisp.txt');
ZWoodPanelPinching4Materials.rForce = load('rForce.txt');
ZWoodPanelPinching4Materials.uForce = load('uForce.txt');
ZWoodPanelPinching4Materials.gD1 = load('gD1.txt');
ZWoodPanelPinching4Materials.gDlim = load('gDlim.txt');
ZWoodPanelPinching4Materials.gK1 = load('gK1.txt');
ZWoodPanelPinching4Materials.gKlim = load('gKlim.txt');
end

