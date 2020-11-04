function data=tdsget(varargin)
    %% 从cache中获取uigetfile路径并将数据导入rawdata
    ori_path = pwd;
    script_path = mfilename('fullpath');
    cache_path = fullfile(script_path(1:size(script_path,2)-6),...
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
    [name, path] = uigetfile('*.txt', 'data');
    cd(ori_path);
    if (name~=0)
        rawdata=importdata(fullfile(path,name));
%         fid_data=fopen(fullfile(path,name));
%         rawdata=[];
%         while ~feof(fid_data)
%             cur_line=string(fgetl(fid_data));
%             rawdata=[rawdata;cur_line];
%         end
        fid = fopen(cache_path,'w+');
        fprintf(fid,'%s\n',path);
        fclose(fid);
    else
        fprintf('no import data\n');
        return
    end
    
    %% 处理 rawdata 成 data
    % data
    d=rawdata.data;
    x=d(:,3);
    y=d(:,2);
    data.data=[x y];
    % fft
    c=2.99792458e8;
    step=5e-6;
    f0=(step*2/c)^-1;
    N=size(x,1);
    data.f=(0:N/2-1)'.*(f0/N);
    fft_=fft(y);
    data.fft=fft_(1:N/2);
    data.mgnt=abs(data.fft);

