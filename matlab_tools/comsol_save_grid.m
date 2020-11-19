function ret = comsol_save_grid(x, y, data)
%% uiputfile
[name, path] = my_uiputfile({'*.csv', 'COMSOL grid data'},...
    'Save COMSOL grid data');
if name == 0
    fprintf(2, '** no save data\n');
    return
end
%% write file
fid = fopen(fullfile(path, name), 'w+');
fprintf(fid, '%s\n', '% Grid');
fprintf(fid, concat_vector(x));
fprintf(fid, concat_vector(y));
fprintf(fid, '%s\n', '% Data');
for i = 1:size(data, 1)
    fprintf(fid, concat_vector(data(i, :)));
end
fclose(fid);

end



function str = concat_vector(vec)
str = '';
for i = 1:length(vec) - 1
    str = [str, num2str(vec(i)), ','];
end
str = [str, num2str(vec(length(vec))), '\n'];
end



