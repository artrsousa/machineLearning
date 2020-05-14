function file = create_file_result(path)
    file = path;
    results = {};
    save(file,'results');
    clear results;
end