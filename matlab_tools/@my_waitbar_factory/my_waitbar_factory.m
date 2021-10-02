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
                bar.set('title', name);
                self.storage.(name) = bar;
            end
        end
        function close_all(self)
            names = fieldnames(self.storage);
            for i = 1:length(names)
                if self.storage.(names{i}).is_shown()
                    close(self.storage.(names{i}).bar);
                end
            end
        end
        
    end
end
