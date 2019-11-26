clear all
close all
tic

% Define path to base directory where MATLAB files are located
MATLABFilesDirectory = pwd;

% Define path to base directory
BaseDirectory = strcat(...
    'C:\Users\hvburton\Documents\CEAProject\MATLABModelGenerator');

% Define location of EDP data
EDPDataDirectory = strcat(BaseDirectory,...
    '\EDPData\TestingData\NonCollapse');

% Define location of EDP data for SP3
EDPDataForSP3Directory = strcat(BaseDirectory,...
    '\EDPDataForSP3\Mechanistic');
% EDPDataForSP3Directory = strcat(BaseDirectory,...
%     '\EDPDataForSP3\Surrogate');

% Define location of collapse and demolition data
CandDDataDirectory = strcat(BaseDirectory,...
    '\EDPData\TestingData');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Define Key Variables                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define ground motion intensities
SaMCE = 1.5;
% Define IDA Scales
IDAScales = 5:5:100;
IDAScales = IDAScales';
% Define IDA Sas
IDASas = SaMCE*IDAScales/100;

% Number of stories
numberOfStories = 2;

% number of surrogate models
numberOfSurrogates = 25;

% number of input parameters
numberOfInputParameters = 5;

% number of ground motions
numberOfGroundMotions = 44;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         Import Actual Responses                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load response data
cd(EDPDataDirectory)
% Maximum story drift statistics
load logMeanMaxXStoryDrifts
load logMeanMaxZStoryDrifts
load dispersionMaxXStoryDrifts
load dispersionMaxZStoryDrifts
% Residual story drift statistics
load logMeanMaxXResidualDrifts
load logMeanMaxZResidualDrifts
load dispersionMaxXResidualDrifts
load dispersionMaxZResidualDrifts
% Peak floor acceleration statistics
load medianMaxXPFAs
load medianMaxZPFAs
load dispersionMaxXPFAs
load dispersionMaxZPFAs

% Load collapse and demolition data 
cd(CandDDataDirectory)
load betaCollapse
load betaDemolition
load thetaCollapse
load thetaDemolition

% Loop over the number of building cases
for bldg = 1:25
    % for ii = 1:length(BuildingNameFile)
    % String used to identify the name of the folder in which the relevant 
    % data for the current building being modeled is stored. The generated 
    % OpenSees models will also be stored in this folder.
    BuildingID = sprintf('Building%d',bldg);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %          Generate Realizations of Story Drift Ratio for SP3         %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Initialize array used to store EDPs in SP3 format
    SDRsForSP3 = zeros(length(IDAScales)*2*numberOfGroundMotions,...
        3 + numberOfStories);

    % Initialize variable used to keep track of row number
    rowNumber = 0;
    % Looping over all ground motion scales
    for sc = 1:length(IDAScales)
        % Looping over the number of building directions
        for bd = 1:2        
            % Loop over the number of ground motions
            for gm = 1:numberOfGroundMotions
                rowNumber = rowNumber + 1;
                % Looping over the number of stories            
                for st = 1:numberOfStories                 
                    if bd == 1
                        % Create truncated distribution
                        xStoryDriftRatioDistribution = ...
                            makedist('Lognormal','mu',...
                            logMeanMaxXStoryDrifts(sc,st,bldg),...
                            'sigma',dispersionMaxXStoryDrifts(sc,st,bldg));
                        % Trucate distribution
                        truncatedXStoryDriftRatioDistribution = ...
                            truncate(xStoryDriftRatioDistribution,0,0.499);
                        SDRsForSP3(rowNumber,3 + st) = random(...
                            truncatedXStoryDriftRatioDistribution); 
                    else
                        % Create truncated distribution
                        zStoryDriftRatioDistribution = ...
                            makedist('Lognormal','mu',...
                            logMeanMaxZStoryDrifts(sc,st,bldg),...
                            'sigma',dispersionMaxZStoryDrifts(sc,st,bldg));
                        % Trucate distribution
                        truncatedZStoryDriftRatioDistribution = ...
                            truncate(zStoryDriftRatioDistribution,0,0.499);
                        SDRsForSP3(rowNumber,3 + st) = random(...
                            truncatedZStoryDriftRatioDistribution); 
                    end    
                    SDRsForSP3(rowNumber,1) = sc;
                    SDRsForSP3(rowNumber,2) = bd;
                    SDRsForSP3(rowNumber,3) = gm;                
                end
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %      Generate Realizations of Residual Drift Ratios for SP3         %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Initialize array used to store EDPs in SP3 format
    RDRsForSP3 = zeros(length(IDAScales)*2*numberOfGroundMotions,...
        3 + numberOfStories);
     % Initialize variable used to keep track of row number
    rowNumber = 0;
    % Looping over all ground motion scales
    for sc = 1:length(IDAScales)
        % Looping over the number of building directions
        for bd = 1:2        
            % Loop over the number of ground motions
            for gm = 1:numberOfGroundMotions
                rowNumber = rowNumber + 1;
                % Looping over the number of stories            
                for st = 1:numberOfStories                 
                    if bd == 1
                        % Create truncated distribution
                        xResidualDriftRatioDistribution = ...
                            makedist('Lognormal','mu',...
                            logMeanMaxXResidualDrifts(sc,st,bldg),...
                            'sigma',dispersionMaxXResidualDrifts(sc,st,...
                            bldg));
                        % Trucate distribution
                        truncatedXResidualDriftRatioDistribution = ...
                            truncate(xResidualDriftRatioDistribution,0,...
                            0.499);
                        RDRsForSP3(rowNumber,3 + st) = random(...
                            truncatedXResidualDriftRatioDistribution); 
                    else
                        % Create truncated distribution
                        zResidualDriftRatioDistribution = ...
                            makedist('Lognormal','mu',...
                            logMeanMaxZResidualDrifts(sc,st,bldg),...
                            'sigma',dispersionMaxZResidualDrifts(sc,st,...
                            bldg));
                        % Trucate distribution
                        truncatedZResidualDriftRatioDistribution = ...
                            truncate(zResidualDriftRatioDistribution,0,...
                            0.499);
                        RDRsForSP3(rowNumber,3 + st) = random(...
                            truncatedZResidualDriftRatioDistribution); 
                    end    
                    RDRsForSP3(rowNumber,1) = sc;
                    RDRsForSP3(rowNumber,2) = bd;
                    RDRsForSP3(rowNumber,3) = gm;                
                end
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %        Generate Realizations of Peak Floor Accelerations for SP3    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Initialize array used to store PFAs in SP3 format
    PFAsForSP3 = zeros(length(IDAScales)*2*numberOfGroundMotions,...
        3 + numberOfStories + 1);

    % Initialize variable used to keep track of row number
    rowNumber = 0;
    % Looping over all ground motion scales
    for sc = 1:length(IDAScales)
        % Looping over the number of building directions
        for bd = 1:2        
            % Loop over the number of ground motions
            for gm = 1:numberOfGroundMotions
                rowNumber = rowNumber + 1;
                % Looping over the number of stories            
                for st = 1:numberOfStories                 
                    if bd == 1
                        PFAsForSP3(rowNumber,3 + st + 1) = lognrnd(log(...
                            medianMaxXPFAs(sc,st,bldg)),...
                            dispersionMaxXPFAs(sc,st,bldg)); 
                    else
                        PFAsForSP3(rowNumber,3 + st + 1) = lognrnd(log(...
                            medianMaxZPFAs(sc,st,bldg)),...
                            dispersionMaxZPFAs(sc,st,bldg));
                    end    
                    PFAsForSP3(rowNumber,1) = sc;
                    PFAsForSP3(rowNumber,2) = bd;
                    PFAsForSP3(rowNumber,3) = gm;                
                end
                % Add ground floor pfas (generated usingg 1st floor
                % distribution)
                if bd == 1
                    PFAsForSP3(rowNumber,4) = lognrnd(log(...
                    	medianMaxXPFAs(sc,1,bldg)),...
                            dispersionMaxXPFAs(sc,1,bldg)); 
                else
                    PFAsForSP3(rowNumber,4) = lognrnd(log(...
                    	medianMaxZPFAs(sc,1,bldg)),...
                        dispersionMaxZPFAs(sc,1,bldg));
                end                 
            end
        end
    end    
    % Save EDP data from incremental dynamic analysis
    cd(EDPDataForSP3Directory)
    % Make directory for current building
    mkdir(BuildingID)
    cd(BuildingID)
    csvwrite('SDRsForSP3.csv',SDRsForSP3)
    csvwrite('RDRsForSP3.csv',RDRsForSP3)
    csvwrite('PFAsForSP3.csv',PFAsForSP3)
    csvwrite('thetaCollapse.csv',thetaCollapse(bldg))
    csvwrite('betaCollapse.csv',betaCollapse(bldg))
    csvwrite('thetaDemolition.csv',thetaDemolition(bldg))
    csvwrite('betaDemolition.csv',betaDemolition(bldg))
end

toc


