function testToolbox(varargin)
% testToolbox - Run the toolbox tests with MatBox
%
%   testToolbox() runs the tests in the tests folder and saves the test and
%   coverage reports in docs/reports. Name-value arguments are passed on to
%   matbox.tasks.testToolbox.
%
%   The test workflow calls this function when it is on the path, so local
%   runs and CI runs use the same settings.

    {{ cookiecutter.namespace_name }}tools.installMatBox()
    projectRootDirectory = {{ cookiecutter.namespace_name }}tools.projectdir();
    matbox.tasks.testToolbox(projectRootDirectory, ...
        "SourceFolderName", "src", ...
        "TestsFolderName", "tests", ...
        varargin{:});
end
