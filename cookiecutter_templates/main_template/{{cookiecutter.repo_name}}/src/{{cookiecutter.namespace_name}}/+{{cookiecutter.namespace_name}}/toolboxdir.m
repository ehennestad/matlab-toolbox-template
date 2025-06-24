function rootDir = toolboxdir()
    % TOOLBOXDIR Return the root directory of the toolbox
    %
    %   ROOT_DIR = TOOLBOXDIR() returns the root directory of the toolbox.
    %
    %   Example:
    %       rootDir = {{ cookiecutter.namespace_name }}.toolboxdir()
    %
    %   See also {{ cookiecutter.namespace_name }}.toolboxversion

    % Get the location of this function
    functionPath = mfilename('fullpath');
    
    % Get the package directory (+{{ cookiecutter.namespace_name }})
    packageDir = fileparts(functionPath);
    
    % Get the code directory (parent of package directory)
    codeDir = fileparts(packageDir);
    
    % Get the toolbox root directory (parent of code directory)
    rootDir = fileparts(codeDir);
end
