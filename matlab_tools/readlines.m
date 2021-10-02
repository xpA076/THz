function strs = readlines(name, path)
    fid = fopen(fullfile(path, name));
    strs = [];
    while ~feof(fid)
        strs = [strs; string(fgetl(fid))];
    end
    fclose(fid);
end