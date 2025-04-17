# Matlab-Toolbox

Template project for developing a MATLAB toolbox with git. This project uses cookiecutter for template configuration.

## Features

- `.gitignore` suitable for MATLAB projects
- Easy selection of a license among a common selection of commonly used licenses 
- Workflows for testing code on updates (push/PR) and for packaging a MATLAB toolbox (mltbx) on releases
- Predefined folder organization and some useful placeholder files
- Integration with [MatBox](https://github.com/ehennestad/MatBox) that implements tasks to run during workflows and dependency management using a requirements.txt file

## How to Use This Template

1. Click the "Use this template" button in the upper right corner to create a new repository from this template.
2. Clone your new repository to your local machine.
3. Edit the `config.yaml` file with your toolbox information.
4. Commit and push the changes to your repository.
5. A GitHub Action will automatically run to configure your repository based on the template.

## Post-Setup Instructions

### Step 1
After creating a repository from this template, please follow these steps:

1. Go to your repository's `Settings` tab.
2. Under `Actions`, click `General`.
3. In the `Workflow permissions` section, enable `Read and write permissions`.
4. Save the changes.

This will allow the GitHub Actions workflow to push changes and configure the repository when you edit the `config.yaml` file.

### Step 2
1. Edit the `config.yaml` file and fill out all the variables.
2. Commit and push the `config.yaml` back to the repository. A GitHub action will run and fill out template variables in files and folders of the repository.

## Requirements
It is recommended to use **MATLAB R2023a** or later. Toolbox packaging will only work with R2023 or later, other functionality of the toolbox should work with older releases as well.

## Directory Structure

```
├── code/                  # Main toolbox code
│   ├── +namespace/        # MATLAB package for your toolbox
│   ├── examples/          # Example scripts
│   ├── internal/          # Internal helper functions
│   └── resources/         # Resource files
├── docs/                  # Documentation
├── tools/                 # Development tools
│   ├── build/             # Build scripts
│   ├── tasks/             # Task scripts
│   └── tests/             # Unit tests
```

## How It Works

This template uses cookiecutter as the templating engine, but with a GitHub Action-based approach:

1. When you push changes to the `config.yaml` file, a GitHub Action is triggered.
2. The action reads your configuration and runs cookiecutter to generate the project files.
3. The generated files are applied to your repository, and template-specific files are cleaned up.
4. The result is a clean, configured repository ready for development.

This approach combines the power of cookiecutter templates with the convenience of GitHub's template repository feature.
