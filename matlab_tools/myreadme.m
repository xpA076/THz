function myreadme(varargin)
% 当前目录下创建 _readme.pptx 文件 (参数数量: 0 - 2)
% varargin{1}: 创建文件目录 (默认为当前工作目录)
% varargin{2}: 创建文件名称 (默认为_readme.pptx)
narginchk(0,2)
cur_path = mfilename('fullpath');
cur_path = cur_path(1:length(cur_path)-8);
src_path = [cur_path '\_readme.pptx'];

%% 创建文件目录
aim_dir=pwd;
if (nargin >= 1)
    if (length(varargin{1})>0)
        aim_dir = varargin{1};
    end
end

%% 创建文件名称
aim_name = '_readme.pptx';
if (nargin >= 2)
    if (length(varargin{2})>0)
        aim_name = varargin{2};
        if (length(aim_name) < 5 | ...
                not(strcmp(aim_name(end-4:end), '.pptx')))
            aim_name = strcat(aim_name, '.pptx');
        end
    end
end

aim_path = [aim_dir '\' aim_name]; 

if (exist(aim_path, 'file'))
    fprintf('readme file already exist\n');
else
    copyfile(src_path, aim_path);
    fprintf(['-- creating readme file in:\n-- '...
        strrep(aim_path,'\','\\') '\n-- success\n']);
end
