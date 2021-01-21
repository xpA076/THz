% uiputfile with cached path
%
%     file = my_uiputfile
%     [file,path] = my_uiputfile
%     ___ = my_uiputfile([type,])
%     ___ = my_uiputfile([type,] filter)
%     ___ = my_uiputfile([type,] filter, title)

function [file, path] = my_uiputfile(varargin)
narginchk(0, 3);
[file, path] = my_ui_file(varargin, 'put', @uiputfile);
end

