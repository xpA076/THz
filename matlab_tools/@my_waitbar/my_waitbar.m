% my_waitbar.m
% 继承至 matlab.mixin.SetGet 支持 get/set 接口
classdef my_waitbar < matlab.mixin.SetGet
    properties (Constant)
        bars = my_waitbar_factory;
    end
    properties
        % title
        title

        % type: 'percent', 'count', 'float'
        type

        % total
        total
        
        % waitbar figure handle
        hbar
    end
    
    methods
        function obj = my_waitbar(varargin)
%             pnames = ["title", "type", "total"];
%             argin = struct;
%             argin.title = '--';
%             argin.type = 'percent';
%             argin.total = 1;
%             for i = 1:2:nargin
%                 argin.(varargin{i}) = varargin{i + 1};
%             end
%             for i = 1:length(pnames)
%                 pname = char(pnames(i));
%                 item.(pname) = getfield(argin, pname);
%             end
            obj.title = '--';
            obj.type = 'percent';
            obj.total = 1;
        end
        
        function ret = update(self, current)
            if ~self.is_shown()
                self.hbar = waitbar(0, '', 'WindowStyle', 'docked');
                set(self.hbar, 'Name', self.title);
            end
            progress = current / self.total;
            if strcmp(self.type, 'percent')
                n = num2str(round(progress * 10000)/100, '%05.2f');
                info = [n, ' %'];
            elseif strcmp(self.type, 'count')
                info = [num2str(current), ' / ', num2str(self.total)];
            elseif strcmp(self.type, 'float')
                info = num2str(progress);
            end
            waitbar(progress, self.hbar, info);
        end
        
        function ret = set_count_total(self, num)
            self.type = 'count';
            self.total = num;
        end
        
        function obj = set.title(obj, val)
            obj.title = val;
            try
                if self.is_shown()
                    set(self.hbar, 'Name', val);
                end
            catch exception
            end
        end
        function obj = set.type(obj, val)
            obj.type = val;
        end
        function obj = set.total(obj, val)
            obj.total = val;
        end
        
        function flag = is_shown(self)
            if strcmp(class(self.hbar), 'matlab.ui.Figure')
                try
                    etc = get(self.hbar, 'Name');
                    flag = (1==1);
                catch exception
                    flag = (0==1);
                end
            else
                flag = (0==1);
            end
        end
    end

end