% This function is used to generate a struct containing moment frame
% retrofit indicator
function [xDirectionMomentFrame, zDirectionMomentFrame] = ...
    defineRetrofitMomentFrames(XMomentFramesInformationLocation,...
    ZMomentFramesInformationLocation)


% Assemble X-Direction Moment Frame Data

% Go to folder where x-direction moment frame data is stored
cd(XMomentFramesInformationLocation)

% Define struct to store x-direction moment frame data
xDirectionMomentFrame = struct;

% Number of X-Direction Moment Frames
xDirectionMomentFrame.numberOfXMomentFrames = ...
    load('numberOfXFrames.txt');

% Loop over the number of x-direction frames
for i = 1:xDirectionMomentFrame.numberOfXMomentFrames
    % Define current frame folder
    currentFrameFolder = sprintf('Frame%d',i);
    % Assemble node information
    % Go folder where nodal information is stored
    NodalInformationFolder = strcat(...
        XMomentFramesInformationLocation,'/',currentFrameFolder,...
        '/FrameNodes');
    cd(NodalInformationFolder)
    % Store nodal information in xDirectionMomentFrame struct
    xDirectionMomentFrame.Nodes.JointNodeCoordinates{i} = ...
        load('JointNodeCoordinates.txt');
    xDirectionMomentFrame.Nodes.JointNodeNumbers{i} = ...
        load('JointNodeNumbers.txt');
    
    xDirectionMomentFrame.Nodes.BeamHingeNodeCoordinates{i} = ...
        load('BeamHingeNodeCoordinates.txt');
    xDirectionMomentFrame.Nodes.BeamHingeNodeNumbers{i} = ...
        load('BeamHingeNodeNumbers.txt');
    xDirectionMomentFrame.Nodes.ColumnHingeNodeCoordinates{i} = ...
        load('ColumnHingeNodeCoordinates.txt');
    xDirectionMomentFrame.Nodes.ColumnHingeNodeNumbers{i} = ...
        load('ColumnHingeNodeNumbers.txt');
    
    
    % Assemble beam information
    % Go folder where beam information is stored
    BeamInformationFolder = strcat(...
        XMomentFramesInformationLocation,'/',currentFrameFolder,...
        '/Beams');
    cd(BeamInformationFolder)
    % Store beam information in xDirectionMomentFrame struct
    xDirectionMomentFrame.Beams.A{i} = load('A.txt');
    xDirectionMomentFrame.Beams.E{i}= load('E.txt');
    xDirectionMomentFrame.Beams.G{i} = load('G.txt');
    xDirectionMomentFrame.Beams.I{i} = load('I.txt');
    xDirectionMomentFrame.Beams.J{i} = load('J.txt');
    
    % Assemble column information
    % Go folder where column information is stored
    ColumnInformationFolder = strcat(...
        XMomentFramesInformationLocation,'/',currentFrameFolder,...
        '/Columns');
    cd(ColumnInformationFolder)
    % Store column information in xDirectionMomentFrame struct
    xDirectionMomentFrame.Columns.A{i} = load('A.txt');
    xDirectionMomentFrame.Columns.E{i} = load('E.txt');
    xDirectionMomentFrame.Columns.G{i} = load('G.txt');
    xDirectionMomentFrame.Columns.I{i} = load('I.txt');
    xDirectionMomentFrame.Columns.J{i} = load('J.txt');
    
    % Assemble beam hinge information
    % Go folder where beam hinge information is stored
    BeamHingeInformationFolder = strcat(...
        XMomentFramesInformationLocation,'/',currentFrameFolder,...
        '/BeamHinges');
    cd(BeamHingeInformationFolder)
    % Store beam hinge information in xDirectionMomentFrame struct
    xDirectionMomentFrame.BeamHinges.lambda{i} = load('lambda.txt');
    xDirectionMomentFrame.BeamHinges.My{i} = load('My.txt');
    xDirectionMomentFrame.BeamHinges.McMy{i} = load('McMy.txt');
    xDirectionMomentFrame.BeamHinges.thetaCap{i} = ...
        load('thetaCap.txt');
    xDirectionMomentFrame.BeamHinges.thetaPC{i} = ...
        load('thetaPC.txt');
    xDirectionMomentFrame.BeamHinges.thetaU{i} = load('thetaU.txt');
    
    % Assemble column hinge information
    % Go folder where column hinge information is stored
    ColumnHingeInformationFolder = strcat(...
        XMomentFramesInformationLocation,'/',currentFrameFolder,...
        '/ColumnHinges');
    cd(ColumnHingeInformationFolder)
    % Store column hinge information in xDirectionMomentFrame struct
    xDirectionMomentFrame.ColumnHinges.lambda{i} = ...
        load('lambda.txt');
    xDirectionMomentFrame.ColumnHinges.My{i} = load('My.txt');
    xDirectionMomentFrame.ColumnHinges.McMy{i} = load('McMy.txt');
    xDirectionMomentFrame.ColumnHinges.thetaCap{i} = ...
        load('thetaCap.txt');
    xDirectionMomentFrame.ColumnHinges.thetaPC{i} = ...
        load('thetaPC.txt');
    xDirectionMomentFrame.ColumnHinges.thetaU{i} = ...
        load('thetaU.txt');
    
    
    % Assemble Z-Direction Moment Frame Data
    
    % Go to folder where z-direction moment frame data is stored
    cd(ZMomentFramesInformationLocation)
    
    % Define struct to store z-direction moment frame data
    zDirectionMomentFrame = struct;
    
    % Number of Z-Direction Moment Frames
    zDirectionMomentFrame.numberOfZMomentFrames = ...
        load('numberOfZFrames.txt');
    
    % Loop over the number of z-direction frames
    for i = 1:zDirectionMomentFrame.numberOfZMomentFrames
        % Define current frame folder
        currentFrameFolder = sprintf('Frame%d',i);
        % Assemble node information
        % Go folder where nodal information is stored
        NodalInformationFolder = strcat(...
            ZMomentFramesInformationLocation,'/',currentFrameFolder,...
            '/FrameNodes');
        cd(NodalInformationFolder)
        % Store nodal information in zDirectionMomentFrame struct
        zDirectionMomentFrame.Nodes.JointNodeCoordinates{i} = ...
            load('JointNodeCoordinates.txt');
        zDirectionMomentFrame.Nodes.JointNodeNumbers{i} = ...
            load('JointNodeNumbers.txt');
        zDirectionMomentFrame.Nodes.BeamHingeNodeCoordinates{i} = ...
            load('BeamHingeNodeCoordinates.txt');
        zDirectionMomentFrame.Nodes.BeamHingeNodeNumbers{i} = ...
            load('BeamHingeNodeNumbers.txt');
        zDirectionMomentFrame.Nodes.ColumnHingeNodeCoordinates{i} = ...
            load('ColumnHingeNodeCoordinates.txt');
        zDirectionMomentFrame.Nodes.ColumnHingeNodeNumbers{i} = ...
            load('ColumnHingeNodeNumbers.txt');
        
        % Assemble beam information
        % Go folder where beam information is stored
        BeamInformationFolder = strcat(...
            ZMomentFramesInformationLocation,'/',currentFrameFolder,...
            '/Beams');
        cd(BeamInformationFolder)
        % Store beam information in zDirectionMomentFrame struct
        zDirectionMomentFrame.Beams.A{i} = load('A.txt');
        zDirectionMomentFrame.Beams.E{i}= load('E.txt');
        zDirectionMomentFrame.Beams.G{i} = load('G.txt');
        zDirectionMomentFrame.Beams.I{i} = load('I.txt');
        zDirectionMomentFrame.Beams.J{i} = load('J.txt');
        
        % Assemble column information
        % Go folder where column information is stored
        ColumnInformationFolder = strcat(...
            ZMomentFramesInformationLocation,'/',currentFrameFolder,...
            '/Columns');
        cd(ColumnInformationFolder)
        % Store column information in zDirectionMomentFrame struct
        zDirectionMomentFrame.Columns.A{i} = load('A.txt');
        zDirectionMomentFrame.Columns.E{i} = load('E.txt');
        zDirectionMomentFrame.Columns.G{i} = load('G.txt');
        zDirectionMomentFrame.Columns.I{i} = load('I.txt');
        zDirectionMomentFrame.Columns.J{i} = load('J.txt');
        
        % Assemble beam hinge information
        % Go folder where beam hinge information is stored
        BeamHingeInformationFolder = strcat(...
            ZMomentFramesInformationLocation,'/',currentFrameFolder,...
            '/BeamHinges');
        cd(BeamHingeInformationFolder)
        % Store beam hinge information in zDirectionMomentFrame struct
        zDirectionMomentFrame.BeamHinges.lambda{i} = load('lambda.txt');
        zDirectionMomentFrame.BeamHinges.My{i} = load('My.txt');
        zDirectionMomentFrame.BeamHinges.McMy{i} = load('McMy.txt');
        zDirectionMomentFrame.BeamHinges.thetaCap{i} = ...
            load('thetaCap.txt');
        zDirectionMomentFrame.BeamHinges.thetaPC{i} = ...
            load('thetaPC.txt');
        zDirectionMomentFrame.BeamHinges.thetaU{i} = load('thetaU.txt');
        
        % Assemble column hinge information
        % Go folder where column hinge information is stored
        ColumnHingeInformationFolder = strcat(...
            ZMomentFramesInformationLocation,'/',currentFrameFolder,...
            '/ColumnHinges');
        cd(ColumnHingeInformationFolder)
        % Store column hinge information in zDirectionMomentFrame struct
        zDirectionMomentFrame.ColumnHinges.lambda{i} = ...
            load('lambda.txt');
        zDirectionMomentFrame.ColumnHinges.My{i} = load('My.txt');
        zDirectionMomentFrame.ColumnHinges.McMy{i} = load('McMy.txt');
        zDirectionMomentFrame.ColumnHinges.thetaCap{i} = ...
            load('thetaCap.txt');
        zDirectionMomentFrame.ColumnHinges.thetaPC{i} = ...
            load('thetaPC.txt');
        zDirectionMomentFrame.ColumnHinges.thetaU{i} = ...
            load('thetaU.txt');
    end
end
end

