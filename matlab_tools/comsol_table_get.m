% comsol 导出表格数据 转换成 复数矩阵 data
% varargin{1}: 原始数据标题行（默认为 以 "%" 开头的最后一行）
% varargin{2}: 原始数据列索引（向量形式）
% varargin{3}: comsol数据文件路径
function [data,title] = comsol_table_get(varargin)
%% 输入验证
narginchk(0,3);
title_row = 0;
idxes=[];
if (nargin>=1)
    if (varargin{1}>0)
        title_row = varargin{1};
    end
end
if (nargin>=2)
    idxes=varargin{1};
    if (length(idxes)==0)
        idxes=[];
    elseif (idxes(1)==0)
        idxes=[];
    end
end
datafile_path = '';
if (nargin>=3)
    datafile_path=varargin{3};
end

%% 从cache中获取uigetfile路径
% 获取数据文件路径
if(length(datafile_path)==0)
    ori_path = pwd;
    script_path = mfilename('fullpath');
    cache_path = fullfile(script_path(1:size(script_path,2)-11),...
        'cache\matlab_uigetfile_path.txt');
    fid = fopen(cache_path);
    if (fid>0)
        ui_path = fgetl(fid);
        fclose(fid);
        try
            cd(ui_path);
        catch MyError
            cd(ori_path)
        end
    end
    [name, path] = uigetfile({'*.csv','.csv for COMSOL';...
        '*.txt','.txt for COMSOL'}, 'data');
    cd(ori_path);
    if(name==0)
        fprintf('no import data\n');
        return
    end
    datafile_path=fullfile(path,name);
    fid = fopen(cache_path,'w+');
    fprintf(fid,'%s\n',path);
    fclose(fid);
else
    datafile_path=varargin{3};
end

%% csv 文件处理
if strfind(name,'.csv')
    fprintf('-- reading *.csv file...\n');
    fprintf(['-- ' name '\n']);
    data=csvread(datafile_path, 5, 0);
    [tmp1,tmp2,tmp3]=xlsread(datafile_path);
    title=tmp3(5,:);
    for i=1:length(title)
        fprintf(['col-', num2str(i,'%02d'), ': ']);
        fprintf('%s\n',char(title(i)));
    end
    return
end

%% txt 文件处理
fprintf('-- reading *.txt file...');

% 获取 rawdata (以换行符分隔的字符串数组)
fid_data=fopen(datafile_path);
rawdata=[];
while ~feof(fid_data)
    cur_line=string(fgetl(fid_data));
    rawdata=[rawdata;cur_line];
end
fclose(fid_data);

% 获取标题行 (以 "%" 开头的最后一行)
if (title_row <= 0)
    data_row = 0;
    for i = 1:length(rawdata)
        if (length(strfind(rawdata(i), '%')) == 0)
            data_row = i;
            break;
        end
    end
    title_row = data_row - 1;
end

fprintf('-- processing data...');

% 处理 rawdata 成 data
% title 字符串矩阵
rawtitle = rawdata(title_row);
celltitle = regexp(rawtitle,'\s\s+','split');
cols = length(celltitle);
rawtitle=[];
for i=1:cols
    rawtitle=[rawtitle string(celltitle{1,i})];
end
% data 数值矩阵
numdata = zeros(size(rawdata, 1) - title_row, cols);
for row = 1:size(numdata,1)
    cur_celldata = regexp(rawdata(row + title_row),'\s+','split');
    for col = 1:size(numdata,2)
        numdata(row,col) = str2num(cur_celldata{1,col});
    end
end
% data 截取 ( 根据 idxes )
if (length(idxes)==0)
    data=numdata;
    title=rawtitle;
else
    data=[];
    title=[];
    for i=1:length(idxes)
        data=[data numdata(:,idxes(i))];
        title=[title rawtitle(idxes(i))];
    end
end
% 打印 title
for i=1:length(title)
    fprintf(['col-', num2str(i,'%02d'), ': ']);
    fprintf('%s\n',char(title(i)));
end
end


    