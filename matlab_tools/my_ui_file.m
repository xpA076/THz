% work for my_uigetfile / my_uiputfile
function [file, path] = my_ui_file(args, script, handle)
%% args in
type = 'default';
filter = 0;
title = 0;
% set parameters
if length(args) > 0
    beg = 1;
    if isa(args{1}, 'char')
        type = args{1};
        beg = 2;
    end
    if length(args) >= beg
        filter = args{beg};
    end
    if length(args) >= beg + 1
        title = args{beg + 1};
    end
end

%% dir
path = mfilename('fullpath');
fnd = strfind(path, '\');
dir = [path(1:fnd(end)), 'cache\'];

%% read cache txt
ori_path = pwd;
cache = load_ui_cache(script, dir);
try
    cd(cache.(type));
catch MyError
    cd(ori_path);
end

%% ui_file
if isa(filter, 'cell')
    if isa(title, 'char')
        [file, path] = handle(filter, title);
    else
        [file, path] = handle(filter);
    end
else
    [file, path] = handle();
end
cd(ori_path);

%% save path to cache txt
if file ~= 0
    cache.(type) = path;
    save_ui_cache(cache, script, dir);
end

end

function cache = load_ui_cache(script, dir)
cache = struct('default', '');
cache_path = fullfile(dir, ['matlab_ui', script, 'file_path.txt']);
fid = fopen(cache_path);
if fid > 0
    cache.('default') = fgetl(fid);
    while ~feof(fid)
        type = fgetl(fid);
        path = fgetl(fid);
        cache.(type) = path;
    end
    fclose(fid);
end
end

function ret = save_ui_cache(cache, script, dir)
% open txt
cache_path = fullfile(dir, ['matlab_ui', script, 'file_path.txt']);
fid = fopen(cache_path, 'w+');
% default
fprintf(fid, '%s\n', cache.('default'));
% others
cache_ = rmfield(cache, 'default');
names = fieldnames(cache_);
for i = 1:length(names)
    fprintf(fid, '%s\n%s\n', names{i}, cache_.(names{i}));
end
% close txt
fclose(fid);
ret = 0;
end
