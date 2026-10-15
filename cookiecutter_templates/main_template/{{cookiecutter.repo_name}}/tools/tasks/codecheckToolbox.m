function codecheckToolbox(varargin)
% codecheckToolbox - Run MATLAB code analysis on the toolbox with MatBox
%
%   codecheckToolbox() checks the code in the src folder and saves a report
%   in docs/reports. Name-value arguments are passed on to
%   matbox.tasks.codecheckToolbox.
%
%   The test workflow calls this function when it is on the path, so local
%   runs and CI runs use the same settings.

    {{ cookiecutter.namespace_name }}tools.installMatBox()
    projectRootDirectory = {{ cookiecutter.namespace_name }}tools.projectdir();
    matbox.tasks.codecheckToolbox(projectRootDirectory, ...
        "FoldersToCheck", fullfile(projectRootDirectory, "src"), ...
        varargin{:});
end
