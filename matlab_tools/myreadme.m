function myreadme(varargin)
% ��ǰĿ¼�´��� _readme.pptx �ļ� (��������: 0 - 2)
% varargin{1}: �����ļ�Ŀ¼ (Ĭ��Ϊ��ǰ����Ŀ¼)
% varargin{2}: �����ļ����� (Ĭ��Ϊ_readme.pptx)
narginchk(0,2)
cur_path = mfilename('fullpath');
cur_path = cur_path(1:length(cur_path)-8);
src_path = [cur_path '\_readme.pptx'];

%% �����ļ�Ŀ¼
aim_dir=pwd;
if (nargin >= 1)
    if (length(varargin{1})>0)
        aim_dir = varargin{1};
    end
end

%% �����ļ�����
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
