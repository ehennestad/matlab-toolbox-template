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
    examplesDir = fullfile({{ cookiecutter.namespace_name }}.toolboxdir(), 'code', 'examples');
    if exist(examplesDir, 'dir')
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
    
    % Display documentation
    fprintf('\nDocumentation:\n');
    docsDir = fullfile({{ cookiecutter.namespace_name }}.toolboxdir(), 'docs');
    if exist(docsDir, 'dir')
        fprintf('  Documentation is available in the docs directory:\n');
        fprintf('  %s\n', docsDir);
    else
        fprintf('  Documentation directory not found.\n');
    end
    
    fprintf('\nFor more information, see the README.md file in the toolbox directory.\n');
end
