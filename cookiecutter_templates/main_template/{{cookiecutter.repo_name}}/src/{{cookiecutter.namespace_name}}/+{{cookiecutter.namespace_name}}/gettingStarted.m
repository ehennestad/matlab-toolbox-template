function gettingStarted()
    % GETTINGSTARTED Open the getting started guide for the toolbox
    %
    %   GETTINGSTARTED() opens the getting started guide for the toolbox.
    %
    %   Example:
    %       {{ cookiecutter.namespace_name }}.gettingStarted()
    %
    %   See also {{ cookiecutter.namespace_name }}.toolboxdir, {{ cookiecutter.namespace_name }}.toolboxversion

    % Display welcome message
    fprintf('Welcome to {{ cookiecutter.toolbox_name }}!\n\n');
    fprintf('{{ cookiecutter.toolbox_summary }}\n\n');
    
    % Display version information
    fprintf('Version: %s\n', {{ cookiecutter.namespace_name }}.toolboxversion());
    
    % Display directory information
    fprintf('Toolbox directory: %s\n\n', {{ cookiecutter.namespace_name }}.toolboxdir());
    
    % Display available functions
    fprintf('Available functions:\n');
    fprintf('  - {{ cookiecutter.namespace_name }}.toolboxdir\n');
    fprintf('  - {{ cookiecutter.namespace_name }}.toolboxversion\n');
    fprintf('  - {{ cookiecutter.namespace_name }}.gettingStarted\n\n');
    
    % Display examples
    fprintf('Examples:\n');
    % toolboxdir returns the folder that contains the {{ cookiecutter.namespace_name }} folder
    examplesDir = fullfile({{ cookiecutter.namespace_name }}.toolboxdir(), '{{ cookiecutter.namespace_name }}', 'examples');
    if isfolder(examplesDir)
        exampleFiles = dir(fullfile(examplesDir, '*.m'));
        if ~isempty(exampleFiles)
            for i = 1:length(exampleFiles)
                fprintf('  - %s\n', exampleFiles(i).name);
            end
        else
            fprintf('  No examples found.\n');
        end
    else
        fprintf('  Examples directory not found.\n');
    end
    
    fprintf('\nFor more information, see https://github.com/{{ cookiecutter.repo_owner }}/{{ cookiecutter.repo_name }}\n');
end
