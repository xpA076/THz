function [dat,name] = getTDSdata(boxname)
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
	fprintf(fid, '%s\n', path);
	fclose(fid);
end
% process data from file
try
	dat1 = dat1.data;
	signal = dat1(:, 2);
	position = dat1(:, 3);
	dat=[position signal];
    return
catch MyError
	cd(ori_path);
 	% error('Cannot get data ');
    dat=0;
    h_box = errordlg('Cannot get data ', 'Error');
    set(h_box, 'position', [600 400 160 70]);
    set(findall(allchild(h_box), 'type', 'text'), 'fontsize', 14);
    set(findall(allchild(h_box), 'style', 'pushbutton'),...
                     'fontsize', 12, 'position', [70 10 40 20]);
    fprintf(2, 'Cannot get data: did not select a valid file\n');
end
