
classdef xWoodPanel < handle
    
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
        function xWoodPanelObject = xWoodPanel(number,story,...
                panelNodeObjects,XDirectionWoodPanelsPropertiesLocation,...
                classesDirectory)
            
            % Attach xWoodPanel number by story
            xWoodPanelObject.number = number;
            
            % Attach xWoodPanel story
            xWoodPanelObject.story = story;
            
            % Attach xWoodPanel top node number
            xWoodPanelObject.panelTopNodeNumber = panelNodeObjects(2,1).number;
            % Attach xWoodPanel bottom node number
            xWoodPanelObject.panelBottomNodeNumber = panelNodeObjects(1,1).number;
            
            % Attach xWoodPanel material number
            cd(XDirectionWoodPanelsPropertiesLocation)
            xPanelMaterialNumbers = load('Pinching4MaterialNumber.txt');
            xWoodPanelObject.outerpanelMaterialNumber = ...
                xPanelMaterialNumbers(2*story-1,number);
            xWoodPanelObject.innerpanelMaterialNumber = ...
                xPanelMaterialNumbers(2*story,number);
            
            % Attach xWoodPanel length
            cd(XDirectionWoodPanelsPropertiesLocation)
            xPanelLengths = load('length.txt');
            xWoodPanelObject.length = xPanelLengths(story,number);
            
            % Attach xWoodPanel length
            cd(XDirectionWoodPanelsPropertiesLocation)
            xPanelHeights = load('height.txt');
            xWoodPanelObject.height = xPanelHeights(story,number);
            
            % Attach xWoodPanel OpenSees Tag
            xWoodPanelObject.panelOpenSeesTag =  strcat(...
                num2str(story),num2str(100 + number),...
                num2str(xWoodPanelObject.outerpanelMaterialNumber));
            
            % Attach xWoodPanel top node OpenSees Tag
            xWoodPanelObject.panelTopNodeOpenSeesTag = ...
                panelNodeObjects(2,1).openSeesTag;
            % Attach xWoodPanel bottom node OpenSees Tag
            xWoodPanelObject.panelBottomNodeOpenSeesTag = ...
                panelNodeObjects(1,1).openSeesTag;
            
            cd(classesDirectory);
        end
    end
    
end

