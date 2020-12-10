% Executes at MATLAB begin

cur_path = mfilename('fullpath');
cur_path = cur_path(1:length(cur_path)-7);
fid = fopen(fullfile(cur_path,'\cache\matlab_workpath.txt'));

if fid > 0
	matlab_workpath = fgetl(fid);
	fclose(fid);
	try
		cd(matlab_workpath);
	end
	clear cur_path fid matlab_workpath ans
end

% Change default axes fonts.
set(0,'DefaultAxesFontName', 'Times New Roman')
set(0,'DefaultAxesFontSize', 20)

% Change default text fonts.
set(0,'DefaultTextFontname', 'Times New Roman')
set(0,'DefaultTextFontSize', 20)

set(0,'DefaultLineLineWidth', 2)

% set(0,'defaultSurfaceEdgeColor','none')
