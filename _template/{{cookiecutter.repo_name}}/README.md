# {{ cookiecutter.toolbox_name }}

{{ cookiecutter.toolbox_summary }}

## Description

{{ cookiecutter.toolbox_description }}

## Features

- Standardized directory structure for MATLAB toolboxes
- Namespace-based organization using MATLAB packages
- Build and packaging tools
- Documentation templates
- Testing framework integration

## Requirements
It is recommended to use **MATLAB {{ cookiecutter.matlab_version_min }}** or later. Toolbox packaging will only work with R2023 or later, other functionality of the toolbox should work with older releases as well.

## Directory Structure

```
├── code/                  # Main toolbox code
│   ├── +{{ cookiecutter.namespace_name }}/        # MATLAB package for your toolbox
│   ├── examples/          # Example scripts
│   ├── internal/          # Internal helper functions
│   └── resources/         # Resource files
├── docs/                  # Documentation
├── tools/                 # Development tools
│   ├── build/             # Build scripts
│   ├── tasks/             # Task scripts
│   └── tests/             # Unit tests
```

## Development Workflow

1. Write your MATLAB functions in the `code/+{{ cookiecutter.namespace_name }}/` directory
2. Add examples in the `code/examples/` directory
3. Write tests in the `tools/tests/` directory
4. Build your toolbox using the build tools in `tools/build/`
5. Package your toolbox using `tools/tasks/packageToolbox.m`

## License

This project is available under the {{ cookiecutter.license }} License. See the LICENSE file for details.

## Author

{{ cookiecutter.author_name }} ({{ cookiecutter.author_email }})
{{ cookiecutter.author_company }}
