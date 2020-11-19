function [file, path] = my_uigetfile(varargin)
% uigetfile with cached path
%
%     file = uigetfile
%     [file,path] = uigetfile
%     ___ = uigetfile(filter)
%     ___ = uigetfile(filter,title)

narginchk(0,2);
%% get cache txt path
script_path = mfilename('fullpath');
script_dir = script_path(1:length(script_path) - 12);
cache_path = fullfile(script_dir, 'cache\matlab_uigetfile_path.txt');
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
%% uigetfile
if nargin == 0
    [file, path] = uigetfile;
elseif nargin == 1
    [file, path] = uigetfile(varargin{1});
elseif nargin == 2
    [file, path] = uigetfile(varargin{1}, varargin{2});
end
cd(ori_path);
%% save path to cache txt
if file ~= 0
    fid = fopen(cache_path, 'w+');
    fprintf(fid, '%s\n', path);
    fclose(fid);
end

end