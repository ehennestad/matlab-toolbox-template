# Matlab toolbox template

Use this template to create a best-practice MATLAB toolbox, ready for continuous integration with testing, code analysis, and toolbox packaging.

- [Instructions for using the template](#step-by-step-instructions)
- [Directory structure](#directory-structure-and-toolbox-best-practices) for initialized toolbox repository
- [Adding (third-party) requirements](#adding-requirements) to your toolbox
- Uses [MatBox](https://github.com/ehennestad/MatBox) and [MatBox Actions](https://github.com/ehennestad/matbox-actions) for continuous integration 

## Step-by-step instructions
[![Image](https://github.com/user-attachments/assets/3ccb3629-cac3-4ffe-bcb8-d5b6bd0c6439)](https://github.com/new?template_owner=ehennestad&template_name=Matlab-Toolbox-Cookiecutter&owner=%40me&name=my-matlab-toolbox&description=My+clone+matlab+toolbox&visibility=public)

1. Right-click **"Use template"** and open the link in a new tab. Fill out the fields and create a new repository

In the new repository:

2. Go to **`Settings`** &#8594; **`Actions`** &#8594; **`General`** &#8594; **`Workflow permissions`** and select this option: **"Read and write permissions"**
3. [**Edit the configuration file**](../../edit/main/config.yaml) (`config.yaml`) to initialize your MATLAB toolbox repository.
4. **Commit and push** the changes to the main branch
5. **Wait** ~30 seconds for the repository to self-initialize and refresh the page

## Configuration reference

The following table describes all available configuration options in `config.yaml`:

| Variable | Description |
|----------|-------------|
| **Repository Settings** | |
| `repository.license` | License type for your project. Options: `MIT`, `Apache-2.0`, `GPL-3.0`, `GPL-2.0`, `LGPL-3.0`, `LGPL-2.1`, `BSD-3-Clause`, `BSD-2-Clause`, `MPL-2.0`, `EPL-1.0`, `AGPL-3.0`, `Unlicense`. Default: `MIT` |
| **MATLAB Toolbox Settings** | |
| `matlab_toolbox.namespace_name` | MATLAB package namespace (lowercase, no spaces, no hyphens). Used for `+namespace` directories and function prefixes. Example: `mytoolbox` |
| `matlab_toolbox.toolbox_name` | Display name of your toolbox. Used in documentation, packaging, and as the repository title. Example: `My MATLAB Toolbox` |
| `matlab_toolbox.author_name` | Full name of the toolbox author. Used in license files, documentation, and package metadata. Example: `John Doe` |
| `matlab_toolbox.author_email` | Email address of the author. Used in package metadata and contact information. Example: `john.doe@example.com` |
| `matlab_toolbox.author_company` | Company or organization name. Used in license files and documentation headers. Example: `Acme Corporation` |
| `matlab_toolbox.toolbox_summary` | Brief one-line description of what the toolbox does. Used in package metadata and README headers. Example: `A collection of signal processing utilities` |
| `matlab_toolbox.toolbox_description` | Detailed multi-line description of the toolbox functionality, features, and use cases. Supports YAML multi-line syntax with `\|`. Used in documentation and package descriptions. |
| **Optional Settings** | |
| `fileexchange.fex_url` | (Optional) MATLAB File Exchange URL if your toolbox is published there. Used for badges and links. Example: `https://www.mathworks.com/matlabcentral/fileexchange/12345` |
| `codecov.badge_token` | (Optional) Codecov badge token. Used to display code coverage badges with codecov in README. |

### Example configuration

```yaml
repository:
  license: MIT

matlab_toolbox:
  namespace_name: signaltools
  toolbox_name: Signal Processing Toolbox
  author_name: Jane Smith
  author_email: jane.smith@university.edu
  author_company: University Research Lab
  toolbox_summary: Advanced signal processing and analysis tools for MATLAB
  toolbox_description: |
    A comprehensive collection of signal processing utilities including:
    - Advanced filtering algorithms
    - Spectral analysis tools
    - Time-frequency analysis methods
    - Signal generation and manipulation functions
    
    Designed for researchers and engineers working with digital signal processing.

fileexchange:
  fex_url: None

codecov:
  badge_token: None
```

## Directory structure and toolbox best practices

The toolbox will have the following directory structure:
```
├── src/mynamespace        # Main toolbox code
│   ├── +mynamespace/      # MATLAB package/namespace for your toolbox
│   ├── examples/          # Example scripts
│   ├── internal/          # Internal helper functions
│   └── resources/         # Resource files
├── docs/                  # Documentation
├── tools/                 # Development tools
│   ├── build/             # Build scripts
│   ├── tasks/             # Task scripts
└── tests/                 # Unit tests and test-related scripts
```

This template and it's directory structure is heavily inspired by the [MATLAB Toolbox Best Practices](https://github.com/mathworks/toolboxdesign). If you're looking for a thorough introduction to toolbox design, their guide is a great place to start.  

In the following section, I highlight some intentional deviations from their recommendations:

- `src/namespace_name` is used instead of `toolbox` for the [folder containing code and resources](https://github.com/mathworks/toolboxdesign?tab=readme-ov-file#toolbox-folder) that will be shared with the user.  
  - *"Toolbox"* is a very specific term, and not every MATLAB package "feels" like a toolbox.  
  - `src` is widely used and familiar to many developers.  
  - The additional subfolder named `namespace_name` supports the inclusion of a [Contents.m](https://se.mathworks.com/help/matlab/matlab_prog/create-a-help-summary-contents-m.html) file, enabling the use of `help namespace_name` to display detailed help for the package.
- `tools` is used instead of `buildUtilities` as a general-purpose folder for developer tools—such as code analysis, toolbox packaging, and documentation generation.

This template is intended as a starting point, not a one-size-fits-all solution. No single structure will be ideal for every project. However, keep the following in mind:

- The integrated GitHub Actions workflow assumes that user-facing code and tests are stored in separate subfolders at the root of the project.
- Customizations to [MatBox](https://github.com/ehennestad/MatBox) tasks should be placed in a `tools` folder.

## Adding requirements

The initialised repository will have a requirements.txt file where you can add requirements for the toolbox. 

`requirements.txt`:
```
# This file is used to specify the dependencies for the project.
# You can install these dependencies using MatBox:
#   matbox.installRequirements(toolboxRootFolder)
#
# Example of a dependency from the File Exchange:
#   fex://12345-my-awesome-toolbox/1.0.0 - with fixed version number
#   fex://67890-another-toolbox - will install the latest version
#
# Example of a dependency from GitHub:
#   https://github.com/some-owner/some-repo@some-branch - pinned to branch
#   https://github.com/some-owner/some-repo - uses default branch
```

The requirements will be included in the list of dependencies when a Matlab Toolbox installer is created, and users installing from an mltbx file should get all the requirements automatically. Users or developers who clone the repository using git can use [MatBox](https://github.com/ehennestad/MatBox) to easily install requirements:

```matlab
<namespace_name>tools.installMatBox() % If MatBox is not installed
matbox.installRequirements(path/to/toolboxRootDir)
```

## How it works
   - Checks write permissions to ensure the workflow can proceed
   - Archives the current repository state to the `template-archive` branch
   - Generates the main MATLAB toolbox project from `main_template` → pushes to `main` branch
   - Generates the GitHub badges content from `gh-badges_template` → pushes to `gh-badges` branch
   - Both templates use the same configuration from `config.yaml`

## Generated branches

- **`main`**: Complete skeleton for a MATLAB toolbox project generated from your configuration
- **`gh-badges`**: GitHub badges content for repository display
- **`template-archive`**: Backup of the original template repository

## Template Structure

The system uses two predefined templates:

### `main_template`
Located in `cookiecutter_templates/main_template/`, this creates a full-featured MATLAB toolbox with comprehensive project structure, testing, documentation, and packaging capabilities.

### `gh-badges_template`
Located in `cookiecutter_templates/gh-badges_template/`, this creates a minimal structure optimized for displaying GitHub badges and basic repository information.

## Workflow Details

The GitHub Actions workflow consists of two jobs:

1. **`check_write_permissions`**: Validates that the workflow has the necessary permissions to write to the repository
2. **`initialize`**: Performs the actual template generation and branch updates

The workflow is designed to be safe and reliable:
- Uses the existing `reusable-check-push-permission.yml` workflow for permission validation
- Archives the current state before making any changes
- Generates both templates from the same configuration
- Handles branch creation and updates gracefully
- Provides detailed logging and error handling

## Customizing Templates

To modify the generated projects:

1. Edit files in `cookiecutter_templates/main_template/` for the main toolbox structure
2. Edit files in `cookiecutter_templates/gh-badges_template/` for the badges content
3. Use `{{cookiecutter.variable_name}}` syntax to reference configuration values
4. Test changes by updating `config.yaml` and triggering the workflow

## Troubleshooting

### Common Issues

1. **Permission errors**: Ensure the repository has Actions write permissions enabled
2. **Workflow not triggering**: Ensure you're pushing changes to `config.yaml` on the main branch
3. **Template errors**: Verify that both template directories exist and contain valid cookiecutter structures
4. **Configuration errors**: Verify your `config.yaml` syntax is valid YAML

### Debugging

- Check the GitHub Actions logs for detailed error messages
- Verify your `config.yaml` syntax using a YAML validator
- Ensure all required fields in `matlab_toolbox` section are provided
- Check that template directories contain the expected `cookiecutter.json` files
- Verify that the `reusable-check-push-permission.yml` workflow exists and is accessible

## Contributing

To contribute improvements:

1. Fork this repository
2. Make changes to templates in `cookiecutter_templates/`
3. Test by updating `config.yaml` and triggering the workflow
4. Submit a pull request with your changes

## License

This template system is provided under the MIT License. Generated projects will use the license specified in your `config.yaml` configuration.
