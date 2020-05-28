%{
create_file_result.m
  This function creates a result file
  in the directory of the given path

  Inputs:
      path: Directory path for the results file
  Outputs:
      file: Directory path for the results file
%}
function file = create_file_result(path)
  file = path;
  results = {};
  save(file,'results');
  clear results;
end