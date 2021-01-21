% uigetfile with cached path
%
%     file = my_uigetfile
%     [file,path] = my_uigetfile
%     ___ = my_uigetfile([type,])
%     ___ = my_uigetfile([type,] filter)
%     ___ = my_uigetfile([type,] filter, title)

function [file, path] = my_uigetfile(varargin)
narginchk(0, 3);
[file, path] = my_ui_file(varargin, 'get', @uigetfile);
end

