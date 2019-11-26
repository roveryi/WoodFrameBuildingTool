
classdef dynamicProperties < handle
    
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
        % Damping ratio
        dampingRatio
        
        % Floor masses. N x 1 vector of floor masses where N is the number
        % of stories in the building
        floorMasses
        
        % Mode shape. N x M array where N is the number of stories and M
        % is the number of modes considered
        modeShape
        
        % Modal masses. N x 1 vector modal masses where N is the number
        % of modes considered
        modalMasses
        
        % Modal participation factors. N x 1 vector of modal participation
        % factors where N is the number of modes considered
        modalParticipationFactors
        
        % Modal spectral intensities. N x 1 vector of modal spectral
        % intensities where N is the number of modes considered
        modalSpectralIntensities
        
        % Modal story forces. N x M array of story forces where N is the
        % number of stories and M is the number of modes considered
        modalStoryForces
        
        % Modal story shears. N x M array of story shears where N is the
        % number of stories and M is the number of modes considered
        modalStoryShears
    end
    properties (SetAccess = public)
        % Modal periods for 3D model. N x 1 vector of modal periods
        % where N is the number of modes considered
        modalPeriods3DModel
        
        % Modal periods for 2D X models. N x M vector of modal periods
        % where N is the number of modes considered and M is the number of
        % X models
        modalPeriods2DXModels
        
        % Modal periods for 2D Z models. N x M vector of modal periods
        % where N is the number of modes considered and M is the number of
        % Z models
        modalPeriods2DZModels
    end
    
    methods
        % Constructor function
        function dynamicPropertiesObject = ...
                dynamicProperties(DynamicPropertiesLocation, buildingLoads)
            
            % Go to folder where building dynamic properties are stored
            cd(DynamicPropertiesLocation);
            
            % Damping ratio
            dynamicPropertiesObject.dampingRatio = load('dampingRatio.txt');
            
            % Floor masses
            dynamicPropertiesObject.floorMasses = ...
                buildingLoads.floorWeights/(32.2*12);
        end
    end
    
end

