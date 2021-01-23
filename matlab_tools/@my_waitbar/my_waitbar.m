% my_waitbar.m
classdef my_waitbar
    properties
        a
        % title
        title
        % type: 'percent', 'count', 'float'
        type
        % current
        current
        % total
        total
    

    end
    
    methods
        function item = my_waitbar()
            item.a =1;
        end
    end
end