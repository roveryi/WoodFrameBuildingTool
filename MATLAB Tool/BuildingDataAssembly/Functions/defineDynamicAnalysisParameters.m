
function dynamicAnalysisParameters = defineDynamicAnalysisParameters(...
    DynamicAnalysisParametersLocation)

% Go to folder where dynamic analysis parameters are stored
cd(DynamicAnalysisParametersLocation);

% Number of ground motions used for bi-directional inertial loading
% (for 3D model)
dynamicAnalysisParameters.NumberOfGroundMotions = ...
    load('NumberOfGroundMotions.txt');

% N X 1 vector of scale factors used to anchor the geometric mean
% spectral intensity of each ground motion pair to the target spectral
% intensity. N is the number of ground motion pairs
% Used for 3D model
dynamicAnalysisParameters.MCEScaleFactors = ...
    load('BiDirectionMCEScaleFactors.txt');

% Initial spectral intensity increment used in incremental dynamic
% analysis to collapse as a percentage of MCE intensity
dynamicAnalysisParameters. ...
    InitialGroundMotionIncrementScaleForCollapse = ...
    load('InitialGroundMotionIncrementScaleForCollapse.txt');

% Reduced spectral intensity increment used in incremental dynamic
% analysis to collapse (as a percentage of MCE intensity) after
% collapse has occurred with the initial increment
% dynamicAnalysisParameters. ...
%    ReducedGroundMotionIncrementScaleForCollapse = ...
%    load('ReducedGroundMotionIncrementScaleForCollapse.txt');

% Ground motion scale to run (as a percentage of MCE intensity) for
% single intensity dynamic analysis
dynamicAnalysisParameters.SingleScaleToRun = ...
    load('SingleScaleToRun.txt');

% Vector of spectral intensities (as a percentage of MCE Sa) for
% incremental dynamic analysis
dynamicAnalysisParameters.scalesForIDA = ...
    load('scalesForIDA.txt');

% Drift limit used for collapse performance assessment
dynamicAnalysisParameters.CollapseDriftLimit = ...
    load('CollapseDriftLimit.txt');

% MCE Spectral intensity
dynamicAnalysisParameters.SaMCE = load('SaMCE.txt');

end

