function codecheckToolbox(varargin)
% codecheckToolbox - Run MATLAB code analysis on the toolbox with MatBox
%
%   codecheckToolbox() checks the code in the src/{{ cookiecutter.namespace_name }} folder and saves a report
%   in docs/reports. Name-value arguments other than FoldersToCheck are
%   passed on to matbox.tasks.codecheckToolbox.
%
%   The test workflow calls this function when it is on the path, so local
%   runs and CI runs use the same settings.

    {{ cookiecutter.namespace_name }}tools.installMatBox()
    projectRootDirectory = {{ cookiecutter.namespace_name }}tools.projectdir();
    % The folder to check is passed last so it overrides the one the CI workflows
    % pass, which is the src folder above it
    matbox.tasks.codecheckToolbox(projectRootDirectory, ...
        varargin{:}, ...
        "FoldersToCheck", fullfile(projectRootDirectory, "src", "{{ cookiecutter.namespace_name }}"));
end
