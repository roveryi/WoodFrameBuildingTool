
classdef seismicParameters < handle
    
    % Hidden properties will not be displayed when you access the property
    % list using get(object) or object.property
    properties (Hidden)
    end
    
    % These properties are the same for all instances of of the class
    properties (Constant)
    end
    
    % For SetAcess = protected you can only access the properties from the
    % class or subclass.
    % For SetAccess = public you can access the properties from anywhere
    % For SetAccess = private you can access the properties from class
    % members only (not subclasses)
    properties (SetAccess = protected)
        % Mapped MCE spectral acceleration at 1s period
        S1
        
        % Mapped MCE spectral acceleration at short period
        Ss
        
        % Site coefficients
        Fa
        Fv
        
        % Coefficient for upper limit on code period
        Cu
        
        % Code period coefficient
        Ct
        
        % code period coefficient
        x
        
        % R factor
        R
        
        % Redundancy factor
        rho
        
        % Long period transition
        TL
        
        %         % Hazard curve. N x 2 array where N is the number of points used to
        %         % define hazard curve. The first column contains the spectral
        %         % intensity ordinates and the 2nd column contains the mean annual
        %         % frequency of exceedance
        % %         hazardCurve
        
        % Code period
        Tcode
        
        % Code period with upper limit factor
        CuTcode
        
        % MCE spectral acceleration at short period
        SMS
        
        % MCE spectral acceleration at 1s period
        SM1
        
        % DBE spectral acceleration at short period
        SDS
        
        % DBE spectral acceleration at 1s period
        SD1
        
        % Response spectra transition periods
        T0
        TS
        
        % MCE Spectral acceleration
        SaMCE
        
        % DBE Spectral acceleration
        SaDBE
        
        % Vertical distribution factor for equivalent lateral loads
        Cvx
        
        % Scale factor needed to anchor median spectra of ground motion set
        % to MCE level
        MCEScaleFactor
    end
    
    methods
        % Constructor function
        function seismicParametersObject = seismicParameters...
                (SeismicParametersLocation, buildingGeometry, buildingLoads)
            
            % Go to folder where building seismic parameters are stored
            cd(SeismicParametersLocation);
            
            % Mapped MCE spectral acceleration at 1s period
            seismicParametersObject.S1 = load('S1.txt');
            
            % Mapped MCE spectral acceleration at short period
            seismicParametersObject.Ss = load('Ss.txt');
            
            seismicParametersObject.Fa = load('Fa.txt'); % Site coefficient
            seismicParametersObject.Fv = load('Fv.txt'); % Site coefficient
            
            % Coefficient for upper limit on code period
            seismicParametersObject.Cu = load('Cu.txt');
            
            % Code period coefficient
            seismicParametersObject.Ct = load('Ct.txt');
            seismicParametersObject.x = load('x.txt');
            
            % R factor
            seismicParametersObject.R = load('R.txt'); % R factor
            % Redundancy Factor
            seismicParametersObject.rho = load('rho.txt');
            
            % Long period transition
            seismicParametersObject.TL = load('TL.txt');
            
            %             % Hazard curve
            %             seismicParametersObject.hazardCurve = load('hazardCurve.txt');
            %
            %             % MCE Scale Factor
            %             seismicParametersObject.MCEScaleFactor = load('MCEScaleFactor.txt');
            
            % Code period
            seismicParametersObject.Tcode = seismicParametersObject.Ct*...
                (sum(buildingGeometry.storyHeights/12))^seismicParametersObject.x;
            seismicParametersObject.CuTcode = ...
                seismicParametersObject.Cu*seismicParametersObject.Tcode;
            
            % MCE spectral acceleration at short period
            seismicParametersObject.SMS = ...
                seismicParametersObject.Fa*seismicParametersObject.Ss;
            
            % MCE spectral acceleration at 1s period
            seismicParametersObject.SM1 = ...
                seismicParametersObject.Fv*seismicParametersObject.S1;
            
            % DBE spectral acceleration at short period
            seismicParametersObject.SDS = seismicParametersObject.SMS*2/3;
            
            % DBE spectral acceleration at 1s period
            seismicParametersObject.SD1 = seismicParametersObject.SM1*2/3;
            
            % Response spectra transition periods
            % T0
            seismicParametersObject.T0 = .2*seismicParametersObject.SD1/...
                seismicParametersObject.SDS;
            % TS
            seismicParametersObject.TS = seismicParametersObject.SD1/...
                seismicParametersObject.SDS;
            
            % MCE Spectral acceleration
            if seismicParametersObject.CuTcode <= seismicParametersObject.T0
                seismicParametersObject.SaMCE = ...
                    seismicParametersObject.SMS*(.4 + ...
                    .6*seismicParametersObject.CuTcode/seismicParametersObject.T0);
            elseif seismicParametersObject.CuTcode <= seismicParametersObject.TS
                seismicParametersObject.SaMCE = seismicParametersObject.SMS;
            elseif seismicParametersObject.CuTcode <= seismicParametersObject.TL
                seismicParametersObject.SaMCE = ...
                    seismicParametersObject.SM1/seismicParametersObject.CuTcode;
            else
                seismicParametersObject.SaMCE = ...
                    seismicParametersObject.SM1/...
                    seismicParametersObject.TL/(seismicParametersObject.CuTcode^2);
            end
            
            %          % DBE Spectral acceleration
            seismicParametersObject.SaDBE = ...
                seismicParametersObject.SaMCE*2/3;
            
            % Vertical distribution factor for equivalent lateral loads
            if seismicParametersObject.CuTcode <= .5
                k = 1;
            elseif seismicParametersObject.CuTcode <= 2.5
                k = 1 + (seismicParametersObject.CuTcode - 0.5)/2;
            else
                k = 2;
            end
            
            cumulative = 0; % temporary variable
            for i = 1:buildingGeometry.numberOfStories
                cumulative = cumulative + (...
                    buildingLoads.floorWeights(i)*...
                    (buildingGeometry.floorHeights(i + 1)/12)^k);
            end
            for i = 1:buildingGeometry.numberOfStories
                seismicParametersObject.Cvx(i) = ...
                    (buildingLoads.floorWeights(i,:)*...
                    (buildingGeometry.floorHeights(i + 1)/12)^k)/cumulative;
            end
        end
    end
    
end

