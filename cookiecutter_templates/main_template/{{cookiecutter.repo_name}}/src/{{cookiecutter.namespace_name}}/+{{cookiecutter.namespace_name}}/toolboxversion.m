function versionStr = toolboxversion()
    % TOOLBOXVERSION Return the version number of the toolbox
    %
    %   VERSIONSTR = TOOLBOXVERSION() returns the version number written in
    %   Contents.m, for example '1.2.3', or '1.2.3.4' when it has a build
    %   number.
    %
    %   Example:
    %       versionStr = {{ cookiecutter.namespace_name }}.toolboxversion()
    %
    %   See also {{ cookiecutter.namespace_name }}.toolboxdir

    rootPath = fileparts(fileparts(mfilename('fullpath')));
    contentsFile = fullfile(rootPath, 'Contents.m');

    fileStr = fileread(contentsFile);
    versionMatch = regexp(fileStr, 'Version (?<number>\d+\.\d+\.\d+(?:\.\d+)?)', 'names', 'once');

    if isempty(versionMatch)
        error('{{ cookiecutter.namespace_name | upper}}:Version:VersionNotFound', ...
            'No version was detected for this %s installation.', ...
            '{{ cookiecutter.toolbox_name | replace("'", "''") }}')
    end
    versionStr = versionMatch.number;
end
