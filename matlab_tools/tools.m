cur_path = mfilename('fullpath');
cur_path = cur_path(1:length(cur_path)-5);
cd(cur_path);
clear cur_path