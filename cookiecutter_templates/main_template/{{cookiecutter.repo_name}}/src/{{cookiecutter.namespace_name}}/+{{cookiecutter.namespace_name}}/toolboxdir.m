function rootDir = toolboxdir()
    % TOOLBOXDIR Return the root directory of the toolbox
    %
    %   ROOTDIR = TOOLBOXDIR() returns the folder that contains the
    %   +{{ cookiecutter.namespace_name }} namespace folder: the installation folder of the toolbox,
    %   or src/{{ cookiecutter.namespace_name }} in a clone of the repository.
    %
    %   Example:
    %       rootDir = {{ cookiecutter.namespace_name }}.toolboxdir()
    %
    %   See also {{ cookiecutter.namespace_name }}.toolboxversion

    namespaceDir = fileparts(mfilename('fullpath'));
    rootDir = fileparts(namespaceDir);
end
