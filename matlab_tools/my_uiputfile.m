function [file, path] = my_uiputfile(varargin)
% uiputfile with cached path
%
%     file = my_uiputfile
%     [file,path] = my_uiputfile
%     ___ = my_uiputfile(filter)
%     ___ = my_uiputfile(filter,title)

narginchk(0, 2);
%% get cache txt path
script_path = mfilename('fullpath');
script_dir = script_path(1:length(script_path) - 12);
cache_path = fullfile(script_dir, 'cache\matlab_uiputfile_path.txt');
%% read cache txt
ori_path = pwd;
fid = fopen(cache_path);
if fid > 0
    ui_path = fgetl(fid);
    fclose(fid);
    try
        cd(ui_path);
    catch MyError
        cd(ori_path);
    end
end
%% uiputfile
if nargin == 0
    [file, path] = uiputfile;
elseif nargin == 1
    [file, path] = uiputfile(varargin{1});
elseif nargin == 2
    [file, path] = uiputfile(varargin{1}, varargin{2});
end
cd(ori_path);
%% save path to cache txt
if file ~= 0
    fid = fopen(cache_path, 'w+');
    fprintf(fid, '%s\n', path);
    fclose(fid);
end





end

