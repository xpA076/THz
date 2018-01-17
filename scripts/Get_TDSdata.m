function dat=Get_TDSdata(boxname)
ori_path=pwd;
fid=fopen(strcat(ori_path,'\cache\path.txt'));
if fid>0
	path_s=fgetl(fid);
	fclose(fid);
	cd(path_s);
end
[name,path]=uigetfile('*.txt',boxname);
if name~=0
	path_a=strcat(path,name);
	dat1=importdata(path_a);
	dat1=dat1.data;
	cd(ori_path);
	fid=fopen(strcat(ori_path,'\cache\path.txt'),'w+');
	fprintf(fid,'%s\n',path);
	fclose(fid);
	dat=dat1(:,2);
else
	cd(ori_path);
	dat=[];
end