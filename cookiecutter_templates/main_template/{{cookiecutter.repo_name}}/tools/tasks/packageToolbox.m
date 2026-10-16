function [newVersion, mltbxPath] = packageToolbox(releaseType, versionString, varargin)
% packageToolbox - Package the toolbox as an MLTBX file with MatBox
%
%   [newVersion, mltbxPath] = packageToolbox(releaseType, versionString)
%   packages the src/{{ cookiecutter.namespace_name }} folder into the releases folder. releaseType is one of
%   "build", "major", "minor", "patch" or "specific", and versionString is
%   the version to use with "specific". Name-value arguments other than
%   SourceFolderName are passed on to matbox.tasks.packageToolbox.
%
%   The release workflow calls this function when it is on the path, so
%   local runs and CI runs use the same settings.

    arguments
        releaseType (1,1) string ...
            {mustBeMember(releaseType, ["build", "major", "minor", "patch", "specific"])} = "build"
        versionString (1,1) string = ""
    end
    arguments (Repeating)
        varargin
    end

    {{ cookiecutter.namespace_name }}tools.installMatBox()
    projectRootDirectory = {{ cookiecutter.namespace_name }}tools.projectdir();
    % The source folder is passed last so it overrides the one the CI workflows
    % pass, which is the src folder above it
    [newVersion, mltbxPath] = matbox.tasks.packageToolbox(projectRootDirectory, ...
        releaseType, versionString, ...
        varargin{:}, ...
        "SourceFolderName", fullfile("src", "{{ cookiecutter.namespace_name }}"));
end
