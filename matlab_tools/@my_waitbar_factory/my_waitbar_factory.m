% my_waitbar_factory.m
classdef my_waitbar_factory < handle
    properties
        storage
    end
    
    methods
        function bar = get_by_name(self, name)
            if strcmp(class(self.storage), 'double')
                self.storage = struct;
            end
            if isfield(self.storage, name)
                bar = getfield(self.storage, name);
            else
                bar = my_waitbar;
                self.storage.(name) = bar;
            end
        end
    end
end
