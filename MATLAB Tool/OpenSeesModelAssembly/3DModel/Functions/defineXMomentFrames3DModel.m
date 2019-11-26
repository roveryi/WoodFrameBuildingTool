% This function is used to generate the tcl file that defines the
% x-direction moment frames for a 3D Model in OpenSees
function defineXMomentFrames3DModel(buildingGeometry,...
    xDirectionMomentFrameObjects,BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Generating Tcl File with Retrofit Moment Frames Defined         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Go to model data direction
cd(BuildingModelDirectory)

% Make folder used to store OpenSees models
cd OpenSees3DModels
cd(AnalysisType)

% Opening and defining Tcl file
fid = fopen('DefineXMomentFrames3DModel.tcl','wt');

% Writing file description into tcl file
fprintf(fid,'%s\n','# This file will be used to define x-direction retrofit moment frames');
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','');

% Looping over number x-direction moment frames
for i = 1:xDirectionMomentFrameObjects.numberOfXMomentFrames
    fprintf(fid,'%s\n',strcat('# X Moment Frame Node', num2str(i)));
    % Defining joint nodes
    fprintf(fid,'%s\n',strcat('# Joint Nodes'));
    % Loop over the number of joint nodes
    for j = 1:length(xDirectionMomentFrameObjects.Nodes. ...
            JointNodeNumbers{1,i})
        fprintf(fid,'%s\t','node');
        fprintf(fid,'%s\t',num2str(xDirectionMomentFrameObjects. ...
            Nodes.JointNodeNumbers{1,i}(j,1)));
        fprintf(fid,'%10.3f\t',xDirectionMomentFrameObjects.Nodes. ...
            JointNodeCoordinates{1,i}(j,1));
        fprintf(fid,'%10.3f\t',xDirectionMomentFrameObjects.Nodes. ...
            JointNodeCoordinates{1,i}(j,2));
        fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.Nodes. ...
            JointNodeCoordinates{1,i}(j,3));
        fprintf(fid,'%s\n',';');
    end
    fprintf(fid,'%s\n','');
    
    % Defining beam hinge nodes
    fprintf(fid,'%s\n',strcat('# Beam Hinge Nodes'));
    % Loop over the number of beam hinge nodes
    for j = 1:length(xDirectionMomentFrameObjects.Nodes. ...
            BeamHingeNodeNumbers{1,i})
        fprintf(fid,'%s\t','node');
        fprintf(fid,'%s\t',num2str(xDirectionMomentFrameObjects. ...
            Nodes.BeamHingeNodeNumbers{1,i}(j,1)));
        fprintf(fid,'%10.3f\t',xDirectionMomentFrameObjects.Nodes. ...
            BeamHingeNodeCoordinates{1,i}(j,1));
        fprintf(fid,'%10.3f\t',xDirectionMomentFrameObjects.Nodes. ...
            BeamHingeNodeCoordinates{1,i}(j,2));
        fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.Nodes. ...
            BeamHingeNodeCoordinates{1,i}(j,3));
        fprintf(fid,'%s\n',';');
    end
    fprintf(fid,'%s\n','');
    
    % Defining column hinge nodes
    fprintf(fid,'%s\n',strcat('# Column Hinge Nodes'));
    % Loop over the number of column hinge nodes
    for j = 1:length(xDirectionMomentFrameObjects.Nodes. ...
            ColumnHingeNodeNumbers{1,i})
        fprintf(fid,'%s\t','node');
        fprintf(fid,'%s\t',num2str(xDirectionMomentFrameObjects. ...
            Nodes.ColumnHingeNodeNumbers{1,i}(j,1)));
        fprintf(fid,'%10.3f\t',xDirectionMomentFrameObjects.Nodes. ...
            ColumnHingeNodeCoordinates{1,i}(j,1));
        fprintf(fid,'%10.3f\t',xDirectionMomentFrameObjects.Nodes. ...
            ColumnHingeNodeCoordinates{1,i}(j,2));
        fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.Nodes. ...
            ColumnHingeNodeCoordinates{1,i}(j,3));
        fprintf(fid,'%s\n',';');
    end
    fprintf(fid,'%s\n','');
end

% Looping over number x-direction moment frames
for i = 1:xDirectionMomentFrameObjects.numberOfXMomentFrames
    fprintf(fid,'%s\n',strcat('# X Moment Frame Fixity', num2str(i)));
    % Defining Fixity
    fprintf(fid,'%s\n',strcat('# Joint Nodes Fixity'));
    for j = 1:length(xDirectionMomentFrameObjects.Nodes. ...
            JointNodeNumbers{1,i})
        if xDirectionMomentFrameObjects.Nodes.JointNodeCoordinates{1,i}(j,2) == 0
            fprintf(fid,'%s\t','fix');
            fprintf(fid,'%s\t',num2str(xDirectionMomentFrameObjects. ...
                Nodes.JointNodeNumbers{1,i}(j,1)));
            fprintf(fid,'%s','1 1 1 1 1 1');
            fprintf(fid,'%s\n',';');
        end
    end
    fprintf(fid,'%s\n','');
end

for i = 1:xDirectionMomentFrameObjects.numberOfXMomentFrames
    fprintf(fid,'%s\n',strcat('# X Moment Frame Rigid Diaphragm', num2str(i)));
    % Defining Rigid Diaphragm
    fprintf(fid,'%s\n',strcat('# Joint Nodes Rigid Diaphragm'));
    fprintf(fid,'%s\n',strcat('# Setting rigid floor diaphragm constraint on'));
    fprintf(fid,'%s\n',strcat('set RigidDiaphragm ON;'));
    fprintf(fid,'%s\n',strcat('set perpDirn 2;'));
    fprintf(fid,'%s\t',strcat('rigidDiaphragm $perpDirn 2000'));
    for j = 1:length(xDirectionMomentFrameObjects.Nodes. ...
            JointNodeNumbers{1,i})
        if xDirectionMomentFrameObjects.Nodes.JointNodeCoordinates{1,i}(j,2) ~= 0
            fprintf(fid,'%s\t',num2str(xDirectionMomentFrameObjects. ...
                Nodes.JointNodeNumbers{1,i}(j,1)));
        end
    end
    fprintf(fid,'%s\n',';');
    fprintf(fid,'%s\n','');
end

fprintf(fid,'%s\n',strcat('## Define Beam Section Properties and Element'));
fprintf(fid,'%s\n','');

fprintf(fid,'%s\n',strcat('uniaxialMaterial Elastic 99999 1e-8'));
fprintf(fid,'%s\n',strcat('uniaxialMaterial Elastic 199999 1e8'));
fprintf(fid,'%s\n','');

fprintf(fid,'%s\n',strcat('# define material properties'));
fprintf(fid,'%s\t',strcat('set Es 29000.0;'));
fprintf(fid,'%s\n',strcat(' # steel Young''s modulus'));
fprintf(fid,'%s\t',strcat('set G  11500.0;'));
fprintf(fid,'%s\n',strcat(' # steel shear modulus'));
fprintf(fid,'%s\n','');

fprintf(fid,'%s\t',strcat('set n 10;'));
fprintf(fid,'%s\n',strcat(' # stiffness multiplier for rotational spring'));
fprintf(fid,'%s\n','');

BeamID = 9500;
fprintf(fid,'%s\n','# Define Geometric Transformations');
fprintf(fid,'%s\n','set XBeamLinearTransf 4;');
fprintf(fid,'%s\n','geomTransf Linear $XBeamLinearTransf 0 0 1;');
fprintf(fid,'%s\n','');
for i = 1:xDirectionMomentFrameObjects.numberOfXMomentFrames
    fprintf(fid,'%s\n',strcat('# X Moment Frame Beam', num2str(i)));
    fprintf(fid,'%s\n',strcat('# define beam section W10x39'));
    
    fprintf(fid,'%s\t',strcat('set Abm'));
    fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.Beams.A{1,i}(1,1));
    fprintf(fid,'%s\t',';');
    fprintf(fid,'%s\n',strcat(' # cross-sectional area'));
    
    fprintf(fid,'%s\t',strcat('set Ibm'));
    fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.Beams.I{1,i}(1,1));
    fprintf(fid,'%s\t',';');
    fprintf(fid,'%s\n',strcat(' # moment of inertia'));
    
    fprintf(fid,'%s\t',strcat('set Ibm_mod'));
    fprintf(fid,'%s','[expr $Ibm*($n+1.0)/$n]');
    fprintf(fid,'%s\t',';');
    fprintf(fid,'%s\n',strcat(' # modified moment of inertia for beam'));
    
    fprintf(fid,'%s\t',strcat('set Jbm'));
    fprintf(fid,'%10.1f',xDirectionMomentFrameObjects.Beams.J{1,i}(1,1));
    fprintf(fid,'%s\t',';');
    fprintf(fid,'%s\n',strcat(' # inertia of tortion for beams, just assign a small number'));
    
    fprintf(fid,'%s\t',strcat('set WBay'));
    fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.Nodes.BeamHingeNodeCoordinates{1,i}(2,1) - ...
        xDirectionMomentFrameObjects.Nodes.BeamHingeNodeCoordinates{1,i}(1,1));
    fprintf(fid,'%s\n',';');
    fprintf(fid,'%s\n','');
    
    fprintf(fid,'%s\t',strcat('set Ks_bm'));
    fprintf(fid,'%s','[expr $n*6.0*$Es*$Ibm_mod/$WBay]');
    fprintf(fid,'%s\t',';');
    fprintf(fid,'%s\n',strcat(' # rotational stiffness of beam springs'));
    fprintf(fid,'%s\n','');
    
    fprintf(fid,'%s\n','# define rotational spring properties and create spring elements using "rotSpring3DModIKModel" procedure');
    fprintf(fid,'%s\n','# rotSpring3DModIKModel creates a uniaxial material spring with a bilinear response based on Modified Ibarra Krawinkler Deterioration Model');
    fprintf(fid,'%s\n','');
    
    fprintf(fid,'%s\n','# define beam Hinge W10x39');
    fprintf(fid,'%s\t',strcat('set My_bm'));
    fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.BeamHinges.My{1,i}(1,1));
    fprintf(fid,'%s\t',';');
    fprintf(fid,'%s\n',strcat(' # yield moment'));
    
    fprintf(fid,'%s\t',strcat('set McMy_bm'));
    fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.BeamHinges.McMy{1,i}(1,1));
    fprintf(fid,'%s\n',';');
    
    fprintf(fid,'%s\t',strcat('set LS_bm'));
    fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.BeamHinges.lambda{1,i}(1,1)/...
        xDirectionMomentFrameObjects.BeamHinges.thetaCap{1,i}(1,1)*11);
    fprintf(fid,'%s\n',';');
    
    fprintf(fid,'%s\t',strcat('set LK_bm'));
    fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.BeamHinges.lambda{1,i}(1,1)/...
        xDirectionMomentFrameObjects.BeamHinges.thetaCap{1,i}(1,1)*11);
    fprintf(fid,'%s\n',';');
    
    fprintf(fid,'%s\t',strcat('set LA_bm'));
    fprintf(fid,'%10.3f',1000);
    fprintf(fid,'%s\n',';');
    
    fprintf(fid,'%s\t',strcat('set LD_bm'));
    fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.BeamHinges.lambda{1,i}(1,1)/...
        xDirectionMomentFrameObjects.BeamHinges.thetaCap{1,i}(1,1)*11);
    fprintf(fid,'%s\n',';');
    
    fprintf(fid,'%s\n',strcat('set cS_bm 1.0;'));
    fprintf(fid,'%s\n',strcat('set cK_bm 1.0;'));
    fprintf(fid,'%s\n',strcat('set cA_bm 1.0;'));
    fprintf(fid,'%s\n',strcat('set cD_bm 1.0;'));
    
    fprintf(fid,'%s\t',strcat('set theta_pP_bm'));
    fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.BeamHinges.thetaCap{1,i}(1,1));
    fprintf(fid,'%s\n',';');
    
    fprintf(fid,'%s\t',strcat('set theta_pN_bm'));
    fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.BeamHinges.thetaCap{1,i}(1,1));
    fprintf(fid,'%s\n',';');
    
    fprintf(fid,'%s\t',strcat('set theta_pcP_bm'));
    fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.BeamHinges.thetaPC{1,i}(1,1));
    fprintf(fid,'%s\n',';');
    
    fprintf(fid,'%s\t',strcat('set theta_pcN_bm'));
    fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.BeamHinges.thetaPC{1,i}(1,1));
    fprintf(fid,'%s\n',';');
    
    fprintf(fid,'%s\n',strcat('set ResP_bm 0.4;'));
    fprintf(fid,'%s\n',strcat('set ResN_bm 0.4;'));
    
    fprintf(fid,'%s\t',strcat('set theta_uP_bm'));
    fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.BeamHinges.thetaU{1,i}(1,1));
    fprintf(fid,'%s\n',';');
    
    fprintf(fid,'%s\t',strcat('set theta_uN_bm'));
    fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.BeamHinges.thetaU{1,i}(1,1));
    fprintf(fid,'%s\n',';');
    
    fprintf(fid,'%s\n',strcat('set DP_bm 1.0;'));
    fprintf(fid,'%s\n',strcat('set DN_bm 1.0;'));
    
    fprintf(fid,'%s\n',strcat('set a_bm	[expr ($n+1.0)*($My_bm*($McMy_bm-1.0)) / ($Ks_bm*$theta_pP_bm)];'));
    fprintf(fid,'%s\n',strcat('set b_bm	[expr ($a_bm)/(1.0+$n*(1.0-$a_bm))];'));
    fprintf(fid,'%s\n','');
    
    
    fprintf(fid,'%s\n','# define beam springs');
    fprintf(fid,'%s\n','# Spring ID: "8xya", where 8 = beam spring, x = Direction, y = Column Line, a = Floor');
    fprintf(fid,'%s\n','# "x" convention: 5 = x Frame, 6 = z Frame');
    fprintf(fid,'%s\n','# redefine the rotations since they are not the same');
    
    for j = 1:length(xDirectionMomentFrameObjects.Nodes. ...
            BeamHingeNodeNumbers{1,i})
        fprintf(fid,'%s\t','rotSpring3DRotZModIKModel');
        fprintf(fid,'%s\t',num2str(xDirectionMomentFrameObjects.Nodes. ...
            BeamHingeNodeNumbers{1,i}(j,1)+400));
        fprintf(fid,'%s\t',num2str(xDirectionMomentFrameObjects.Nodes. ...
            JointNodeNumbers{1,i}(j+2,1)));
        fprintf(fid,'%s\t',num2str(xDirectionMomentFrameObjects.Nodes. ...
            BeamHingeNodeNumbers{1,i}(j,1)));
        fprintf(fid,'%s\t','$Ks_bm $b_bm $b_bm $My_bm [expr -$My_bm]');
        fprintf(fid,'%s\t','$LS_bm $LK_bm $LA_bm $LD_bm $cS_bm $cK_bm $cA_bm $cD_bm');
        fprintf(fid,'%s\t','$theta_pP_bm $theta_pN_bm $theta_pcP_bm $theta_pcN_bm');
        fprintf(fid,'%s\n','$ResP_bm $ResN_bm $theta_uP_bm $theta_uN_bm $DP_bm $DN_bm;');
    end
    fprintf(fid,'%s\n','');
    
    %         fprintf(fid,'%s\n','# Define Geometric Transformations');
    %         fprintf(fid,'%s\n','set XBeamLinearTransf 4;');
    %         fprintf(fid,'%s\n','geomTransf Linear $XBeamLinearTransf 0 0 1;');
    %         fprintf(fid,'%s\n','');
    
    fprintf(fid,'%s\n','# Define X-Direction beams');
    fprintf(fid,'%s\t','element elasticBeamColumn');
    fprintf(fid,'%s\t',num2str(BeamID));
    BeamID = BeamID + 1;
    for j = 1:length(xDirectionMomentFrameObjects.Nodes. ...
            BeamHingeNodeNumbers{1,i})
        fprintf(fid,'%s\t',num2str(xDirectionMomentFrameObjects.Nodes. ...
            BeamHingeNodeNumbers{1,i}(j,1)));
    end
    fprintf(fid,'%10.3f\t',xDirectionMomentFrameObjects.Beams.A{1,i}(1,1));
    fprintf(fid,'%10.3f\t',xDirectionMomentFrameObjects.Beams.E{1,i}(1,1));
    fprintf(fid,'%10.3f\t',xDirectionMomentFrameObjects.Beams.G{1,i}(1,1));
    fprintf(fid,'%10.3f\t',xDirectionMomentFrameObjects.Beams.J{1,i}(1,1));
    fprintf(fid,'%10.3f\t',xDirectionMomentFrameObjects.Beams.I{1,i}(1,1));
    fprintf(fid,'%10.3f\t',xDirectionMomentFrameObjects.Beams.I{1,i}(1,1));
    fprintf(fid,'%s\n','$XBeamLinearTransf;');
    
end
fprintf(fid,'%s\n','');
fprintf(fid,'%s\n','');

fprintf(fid,'%s\n',strcat('## Define Column Section Properties and Element'));
fprintf(fid,'%s\n','');

count = 0;
for i = 1:xDirectionMomentFrameObjects.numberOfXMomentFrames
    fprintf(fid,'%s\n',strcat('# X Moment Frame Column', num2str(i)));
    fprintf(fid,'%s\n',strcat('# define column section W10x39'));
    
    fprintf(fid,'%s\t',strcat('set Acol'));
    fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.Columns.A{1,i}(1,1));
    fprintf(fid,'%s\t',';');
    fprintf(fid,'%s\n',strcat(' # cross-sectional area'));
    
    fprintf(fid,'%s\t',strcat('set Icol'));
    fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.Columns.I{1,i}(1,1));
    fprintf(fid,'%s\t',';');
    fprintf(fid,'%s\n',strcat(' # moment of inertia'));
    
    fprintf(fid,'%s\t',strcat('set Icol_mod'));
    fprintf(fid,'%s','[expr $Icol*($n+1.0)/$n]');
    fprintf(fid,'%s\t',';');
    fprintf(fid,'%s\n',strcat(' # modified moment of inertia for column'));
    
    fprintf(fid,'%s\t',strcat('set Jcol'));
    fprintf(fid,'%10.1f',xDirectionMomentFrameObjects.Columns.J{1,i}(1,1));
    fprintf(fid,'%s\t',';');
    fprintf(fid,'%s\n',strcat(' # inertia of tortion for columns, just assign a small number'));
    
    fprintf(fid,'%s\t',strcat('set HStory'));
    fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.Nodes.ColumnHingeNodeCoordinates{1,i}(3,2) - ...
        xDirectionMomentFrameObjects.Nodes.ColumnHingeNodeCoordinates{1,i}(1,2));
    fprintf(fid,'%s\n',';');
    fprintf(fid,'%s\n','');
    
    fprintf(fid,'%s\t',strcat('set Ks_col'));
    fprintf(fid,'%s','[expr $n*6.0*$Es*$Icol_mod/$HStory]');
    fprintf(fid,'%s\t',';');
    fprintf(fid,'%s\n',strcat(' # rotational stiffness of column springs'));
    fprintf(fid,'%s\n','');
    
    fprintf(fid,'%s\n','# define rotational spring properties and create spring elements using "rotSpring3DModIKModel" procedure');
    fprintf(fid,'%s\n','# rotSpring3DModIKModel creates a uniaxial material spring with a bilinear response based on Modified Ibarra Krawinkler Deterioration Model');
    fprintf(fid,'%s\n','');
    
    fprintf(fid,'%s\n','# define column Hinge W10x39');
    fprintf(fid,'%s\t',strcat('set My_col'));
    fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.ColumnHinges.My{1,i}(1,1));
    fprintf(fid,'%s\t',';');
    fprintf(fid,'%s\n',strcat(' # yield moment'));
    
    fprintf(fid,'%s\t',strcat('set McMy_col'));
    fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.ColumnHinges.McMy{1,i}(1,1));
    fprintf(fid,'%s\n',';');
    
    fprintf(fid,'%s\t',strcat('set LS_col'));
    fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.ColumnHinges.lambda{1,i}(1,1)/...
        xDirectionMomentFrameObjects.ColumnHinges.thetaCap{1,i}(1,1)*11);
    fprintf(fid,'%s\n',';');
    
    fprintf(fid,'%s\t',strcat('set LK_col'));
    fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.ColumnHinges.lambda{1,i}(1,1)/...
        xDirectionMomentFrameObjects.ColumnHinges.thetaCap{1,i}(1,1)*11);
    fprintf(fid,'%s\n',';');
    
    fprintf(fid,'%s\t',strcat('set LA_col'));
    fprintf(fid,'%10.3f',1000);
    fprintf(fid,'%s\n',';');
    
    fprintf(fid,'%s\t',strcat('set LD_col'));
    fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.ColumnHinges.lambda{1,i}(1,1)/...
        xDirectionMomentFrameObjects.ColumnHinges.thetaCap{1,i}(1,1)*11);
    fprintf(fid,'%s\n',';');
    
    fprintf(fid,'%s\n',strcat('set cS_col 1.0;'));
    fprintf(fid,'%s\n',strcat('set cK_col 1.0;'));
    fprintf(fid,'%s\n',strcat('set cA_col 1.0;'));
    fprintf(fid,'%s\n',strcat('set cD_col 1.0;'));
    
    fprintf(fid,'%s\t',strcat('set theta_pP_col'));
    fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.ColumnHinges.thetaCap{1,i}(1,1));
    fprintf(fid,'%s\n',';');
    
    fprintf(fid,'%s\t',strcat('set theta_pN_col'));
    fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.ColumnHinges.thetaCap{1,i}(1,1));
    fprintf(fid,'%s\n',';');
    
    fprintf(fid,'%s\t',strcat('set theta_pcP_col'));
    fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.ColumnHinges.thetaPC{1,i}(1,1));
    fprintf(fid,'%s\n',';');
    
    fprintf(fid,'%s\t',strcat('set theta_pcN_col'));
    fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.ColumnHinges.thetaPC{1,i}(1,1));
    fprintf(fid,'%s\n',';');
    
    fprintf(fid,'%s\n',strcat('set ResP_col 0.4;'));
    fprintf(fid,'%s\n',strcat('set ResN_col 0.4;'));
    
    fprintf(fid,'%s\t',strcat('set theta_uP_col'));
    fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.ColumnHinges.thetaU{1,i}(1,1));
    fprintf(fid,'%s\n',';');
    
    fprintf(fid,'%s\t',strcat('set theta_uN_col'));
    fprintf(fid,'%10.3f',xDirectionMomentFrameObjects.ColumnHinges.thetaU{1,i}(1,1));
    fprintf(fid,'%s\n',';');
    
    fprintf(fid,'%s\n',strcat('set DP_col 1.0;'));
    fprintf(fid,'%s\n',strcat('set DN_col 1.0;'));
    
    fprintf(fid,'%s\n',strcat('set a_col [expr ($n+1.0)*($My_col*($McMy_col-1.0)) / ($Ks_col*$theta_pP_col)];'));
    fprintf(fid,'%s\n',strcat('set b_col [expr ($a_col)/(1.0+$n*(1.0-$a_col))];'));
    fprintf(fid,'%s\n','');
    
    
    fprintf(fid,'%s\n','# define column springs');
    fprintf(fid,'%s\n','# Spring ID: "7xya", where 7 = column spring, x = Direction, y = Column Line, a = Floor');
    fprintf(fid,'%s\n','# "x" convention: 5 = x Frame, 6 = z Frame');
    fprintf(fid,'%s\n','# redefine the rotations since they are not the same');
    
    for j = 1:length(xDirectionMomentFrameObjects.Nodes. ...
            ColumnHingeNodeNumbers{1,i})
        fprintf(fid,'%s\t','rotSpring3DRotZModIKModel');
        fprintf(fid,'%s\t',num2str(xDirectionMomentFrameObjects.Nodes. ...
            ColumnHingeNodeNumbers{1,i}(j,1)+400));
        fprintf(fid,'%s\t',num2str(xDirectionMomentFrameObjects.Nodes. ...
            JointNodeNumbers{1,i}(j,1)));
        fprintf(fid,'%s\t',num2str(xDirectionMomentFrameObjects.Nodes. ...
            ColumnHingeNodeNumbers{1,i}(j,1)));
        fprintf(fid,'%s\t','$Ks_col $b_col $b_col $My_col [expr -$My_col]');
        fprintf(fid,'%s\t','$LS_col $LK_col $LA_col $LD_col $cS_col $cK_col $cA_col $cD_col');
        fprintf(fid,'%s\t','$theta_pP_col $theta_pN_col $theta_pcP_col $theta_pcN_col');
        fprintf(fid,'%s\n','$ResP_col $ResN_col $theta_uP_col $theta_uN_col $DP_col $DN_col;');
    end
    fprintf(fid,'%s\n','');
    
    fprintf(fid,'%s\n','# Define X-Direction column');
    %         count = 0;
    for j = 1:2
        fprintf(fid,'%s\t','element elasticBeamColumn');
        fprintf(fid,'%s\t',num2str(9300+count));
        count = count + 1;
        fprintf(fid,'%s\t',num2str(xDirectionMomentFrameObjects.Nodes. ...
            ColumnHingeNodeNumbers{1,i}(j,1)));
        fprintf(fid,'%s\t',num2str(xDirectionMomentFrameObjects.Nodes. ...
            ColumnHingeNodeNumbers{1,i}(j+2,1)));
        fprintf(fid,'%10.3f\t',xDirectionMomentFrameObjects.Columns.A{1,i}(1,1));
        fprintf(fid,'%10.3f\t',xDirectionMomentFrameObjects.Columns.E{1,i}(1,1));
        fprintf(fid,'%10.3f\t',xDirectionMomentFrameObjects.Columns.G{1,i}(1,1));
        fprintf(fid,'%10.3f\t',xDirectionMomentFrameObjects.Columns.J{1,i}(1,1));
        fprintf(fid,'%10.3f\t',xDirectionMomentFrameObjects.Columns.I{1,i}(1,1));
        fprintf(fid,'%10.3f\t',xDirectionMomentFrameObjects.Columns.I{1,i}(1,1));
        fprintf(fid,'%s\n','$PDeltaTransf;');
    end
    
end
fprintf(fid,'%s\n','');

fprintf(fid,'%s\n',strcat('## Define Damping'));
fprintf(fid,'%s\n','');

fprintf(fid,'%s\n',strcat('# Defining damping parameters'));
fprintf(fid,'%s\n',...
    'set omegaI [expr (2.0 * $pi) / $periodForRayleighDamping_1]');
fprintf(fid,'%s\n',...
    'set omegaJ [expr (2.0 * $pi) / ($periodForRayleighDamping_2)]');
fprintf(fid,'%s\n',...
    'set alpha1Coeff [expr (2.0 * $omegaI * $omegaJ) / ($omegaI + $omegaJ)]');
fprintf(fid,'%s\n',...
    'set alpha2Coeff [expr (2.0) / ($omegaI + $omegaJ)]');
fprintf(fid,'%s\n','set alpha1  [expr $alpha1Coeff*0.02]');
fprintf(fid,'%s\n','set alpha2  [expr $alpha2Coeff*0.02]');
fprintf(fid,'%s\n',...
    'set alpha2ToUse [expr 1.1 * $alpha2];  # 1.1 factor is becuase we apply to only LE elements');

BeamID = 9500;
fprintf(fid,'%s\n','# Assign damping to beam elements');
fprintf(fid,'%s\t','region 10 -ele');
for i = 1:xDirectionMomentFrameObjects.numberOfXMomentFrames
    fprintf(fid,'%s\t',num2str(BeamID));
    BeamID = BeamID + 1;
end
fprintf(fid,'%s\n','-rayleigh $alpha1 0 $alpha2ToUse 0;');

ColID = 9300;
fprintf(fid,'%s\n','# Assign damping to column elements');
fprintf(fid,'%s\t','region 20 -ele');
for i = 1:xDirectionMomentFrameObjects.numberOfXMomentFrames
    for j = 1:2
        fprintf(fid,'%s\t',num2str(ColID));
        ColID = ColID + 1;
    end
end
fprintf(fid,'%s\n','-rayleigh $alpha1 0 $alpha2ToUse 0;');


fprintf(fid,'%s\n','# Assign damping to nodes');
fprintf(fid,'%s\t','region 30 -node');
for i = 1:xDirectionMomentFrameObjects.numberOfXMomentFrames
    for j = 1:length(xDirectionMomentFrameObjects.Nodes. ...
            JointNodeNumbers{1,i})
        fprintf(fid,'%s\t',num2str(xDirectionMomentFrameObjects. ...
            Nodes.JointNodeNumbers{1,i}(j,1)));
    end
end
fprintf(fid,'%s\n','-rayleigh $alpha1 0 $alpha2ToUse 0;');

% Closing and saving tcl file
fclose(fid);

end

