% Executes at MATLAB close

cur_path = mfilename('fullpath');
cur_path = cur_path(1:size(cur_path,2)-6);
fid = fopen(fullfile(cur_path,'\cache\matlab_workpath.txt'), 'w+');

if fid > 0
	fprintf(fid, '%s\n', pwd);
	fclose(fid);
    clear cur_path fid ans
end
