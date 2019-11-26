classdef zWoodPanel < handle
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
        % Wood panel number by story
        number
        % Story
        story
        % Panel top node number
        panelTopNodeNumber
        % Panel bottom node number
        panelBottomNodeNumber
        % Panel opensees tag
        panelOpenSeesTag
        % Panel top node OpenSees tag
        panelTopNodeOpenSeesTag
        % Panel bottom node OpenSees tag
        panelBottomNodeOpenSeesTag
        % Panel length
        length
        % Panel height
        height
        % Panel material number
        outerpanelMaterialNumber
        innerpanelMaterialNumber
    end
    
    methods
        % Constructor function
        function zWoodPanelObject = zWoodPanel(number,story,...
                panelNodeObjects,ZDirectionWoodPanelsPropertiesLocation,...
                classesDirectory)
            
            % Attach zWoodPanel number by story
            zWoodPanelObject.number = number;
            
            % Attach zWoodPanel story
            zWoodPanelObject.story = story;
            
            % Attach zWoodPanel top node number
            zWoodPanelObject.panelTopNodeNumber = ...
                panelNodeObjects(2,1).number;
            
            % Attach zWoodPanel bottom node number
            zWoodPanelObject.panelBottomNodeNumber = ...
                panelNodeObjects(1,1).number;
            
            % Attach zWoodPanel material number
            cd(ZDirectionWoodPanelsPropertiesLocation)
            zPanelMaterialNumbers = load('Pinching4MaterialNumber.txt');
            zWoodPanelObject.outerpanelMaterialNumber = ...
                zPanelMaterialNumbers(2*story-1,number);
            zWoodPanelObject.innerpanelMaterialNumber = ...
                zPanelMaterialNumbers(2*story,number);
            
            % Attach zWoodPanel length
            cd(ZDirectionWoodPanelsPropertiesLocation)
            zPanelLengths = load('length.txt');
            zWoodPanelObject.length = zPanelLengths(story,number);
            
            % Attach zWoodPanel height
            cd(ZDirectionWoodPanelsPropertiesLocation)
            zPanelHeights = load('height.txt');
            zWoodPanelObject.height = zPanelHeights(story,number);
            
            % Attach zWoodPanel OpenSees Tag
            zWoodPanelObject.panelOpenSeesTag =  strcat(...
                num2str(story),num2str(300 + number),...
                num2str(zWoodPanelObject.outerpanelMaterialNumber));
            
            % Attach zWoodPanel top node OpenSees Tag
            zWoodPanelObject.panelTopNodeOpenSeesTag = ...
                panelNodeObjects(2,1).openSeesTag;
            
            % Attach zWoodPanel bottom node OpenSees Tag
            zWoodPanelObject.panelBottomNodeOpenSeesTag = ...
                panelNodeObjects(1,1).openSeesTag;
            
            cd(classesDirectory);
            
        end
        
    end
    
end

