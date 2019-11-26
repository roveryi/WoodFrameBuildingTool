
function pushoverAnalysisParameters = definePushoverAnalysisParameters...
    (PushoverAnalysisParametersLocation)

% Go to folder where pushover analysis parameters are stored
cd(PushoverAnalysisParametersLocation);

% Define struct with pushover analysis parameters
pushoverAnalysisParameters.PushoverXDrift = load('PushoverXDrift.txt');
pushoverAnalysisParameters.PushoverZDrift = load('PushoverZDrift.txt');

pushoverAnalysisParameters.PushoverIncrementSize = ...
    load('PushoverIncrementSize.txt');

end

