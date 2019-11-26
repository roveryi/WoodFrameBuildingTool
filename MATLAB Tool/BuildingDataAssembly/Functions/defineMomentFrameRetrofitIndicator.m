
function momentFrameRetrofitIndicator = ...
    defineMomentFrameRetrofitIndicator(MomentFrameIndicatorLocation)

% Go to folder where moment frame retrofit indicator is stored
cd(MomentFrameIndicatorLocation);

% Define retrofit (used to indicate whether or not this building is
% retrofitted with a moment frame in the X-Direction
momentFrameRetrofitIndicator.XFrame = load('IndicateFrameXRetrofit.txt');

% Define retrofit (used to indicate whether or not this building is
% retrofitted with a moment frame in the Z-Direction
momentFrameRetrofitIndicator.ZFrame = load('IndicateFrameZRetrofit.txt');
end

