function dat = Get_TDSdata(boxname)
ori_path = pwd;
fid = fopen('E:\Projects\Coding\THz_TDS\scripts\cache\path.txt');
if fid > 0
	path_s = fgetl(fid);
	fclose(fid);
	try
		cd(path_s);
	catch MyError
		cd(ori_path);
	end
end
[name, path] = uigetfile('*.txt', boxname);
if name ~= 0
	path_a = strcat(path,name);
	dat1 = importdata(path_a);
	cd(ori_path);
	fid = fopen('E:\Projects\Coding\THz_TDS\scripts\cache\path.txt', 'w+');
	if fid <= 0
		error('check cache path file ');
	end
	fprintf(fid, '%s\n', path);
	fclose(fid);
	% process data from file
	dat1 = dat1.data;
	signal = dat1(:, 2);
	position = dat1(:, 3);
	dat=[position signal];
else
	cd(ori_path);
	error('Cannot get data ');
end