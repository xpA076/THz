% comsol ����������� ת���� �������� data
% varargin{1}: ԭʼ���ݱ����У�Ĭ��Ϊ �� "%" ��ͷ�����һ�У�
% varargin{2}: ԭʼ������������������ʽ��
% varargin{3}: comsol�����ļ�·��
function [data,title] = comsol_table_get(varargin)
%% ������֤
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

%% ��cache�л�ȡuigetfile·��
% ��ȡ�����ļ�·��
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

%% csv �ļ�����
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

%% txt �ļ�����
fprintf('-- reading *.txt file...');

% ��ȡ rawdata (�Ի��з��ָ����ַ�������)
fid_data=fopen(datafile_path);
rawdata=[];
while ~feof(fid_data)
    cur_line=string(fgetl(fid_data));
    rawdata=[rawdata;cur_line];
end
fclose(fid_data);

% ��ȡ������ (�� "%" ��ͷ�����һ��)
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

% ���� rawdata �� data
% title �ַ�������
rawtitle = rawdata(title_row);
celltitle = regexp(rawtitle,'\s\s+','split');
cols = length(celltitle);
rawtitle=[];
for i=1:cols
    rawtitle=[rawtitle string(celltitle{1,i})];
end
% data ��ֵ����
numdata = zeros(size(rawdata, 1) - title_row, cols);
for row = 1:size(numdata,1)
    cur_celldata = regexp(rawdata(row + title_row),'\s+','split');
    for col = 1:size(numdata,2)
        numdata(row,col) = str2num(cur_celldata{1,col});
    end
end
% data ��ȡ ( ���� idxes )
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
% ��ӡ title
for i=1:length(title)
    fprintf(['col-', num2str(i,'%02d'), ': ']);
    fprintf('%s\n',char(title(i)));
end
end


    