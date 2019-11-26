
classdef xWoodPanelNode < handle
    
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
        % Node number
        number
        
        % Node X coordinate in inches
        xCoordinate
        
        % Node Z coordinate in inches
        yCoordinate
        
        % Node Z coordinate in inches
        zCoordinate
        
        % OpenSees node tag
        openSeesTag
        
        % Floor level location
        level
        
        % Panel story number
        panelStory
        
        % Location of node in panel. 1 for bottom and 2 for top
        topOrBottomNode
        
        % Panel number by story
        panelNumber
    end
    
    methods
        % Constructor function
        function xWoodPanelNodeObject = xWoodPanelNode...
                (number, level, xCoordinate, zCoordinate, yCoordinate,...
                topOrBottomNode, panelNumber)
            
            % Attach node number
            xWoodPanelNodeObject.number = number;
            
            % Attach node level
            xWoodPanelNodeObject.level = level;
            
            % Attach x-coordinate
            xWoodPanelNodeObject.xCoordinate = xCoordinate;
            % Attach y-coordinate
            xWoodPanelNodeObject.yCoordinate = yCoordinate;
            % Attach z-coordinate
            xWoodPanelNodeObject.zCoordinate = zCoordinate;
            
            % Attach node location within panel
            xWoodPanelNodeObject.topOrBottomNode = topOrBottomNode;
            
            % Attach panel story
            if topOrBottomNode == 1
                xWoodPanelNodeObject.panelStory = level;
            else
                xWoodPanelNodeObject.panelStory = level - 1;
            end
            
            % Attach panel number by story
            xWoodPanelNodeObject.panelNumber = panelNumber;
            
            % Attach OpenSees Tag
            xWoodPanelNodeObject.openSeesTag = strcat(...
                num2str(xWoodPanelNodeObject.panelStory),...
                num2str(100 + panelNumber), num2str(topOrBottomNode));
        end
    end
    
end

