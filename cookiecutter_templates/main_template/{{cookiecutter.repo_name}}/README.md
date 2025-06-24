# {{ cookiecutter.toolbox_name }}

[![Version Number](https://img.shields.io/github/v/release/{{ cookiecutter.repo_owner }}/{{ cookiecutter.repo_name }}?label=version)](https://github.com/{{ cookiecutter.repo_owner }}/{{ cookiecutter.repo_name }}/releases/latest)
{%- if cookiecutter.fex_url %}
[![View {{cookiecutter.toolbox_name}} on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)]({{cookiecutter.fex_url}})
{%- endif %}
[![MATLAB Tests](.github/badges/tests.svg)](https://github.com/{{ cookiecutter.repo_owner }}/{{ cookiecutter.repo_name }}/actions/workflows/test-code.yml)
{%- if cookiecutter.codecov_badge_token %}
[![codecov](https://codecov.io/gh/{{ cookiecutter.repo_owner }}/{{ cookiecutter.repo_name }}/graph/badge.svg?token={{ cookiecutter.codecov_badge_token }})](https://codecov.io/gh/{{ cookiecutter.repo_owner }}/{{ cookiecutter.repo_name }})
{%- endif %}
[![MATLAB Code Issues](.github/badges/code_issues.svg)](https://github.com/{{ cookiecutter.repo_owner }}/{{ cookiecutter.repo_name }}/security/code-scanning)
[![Run Codespell](https://github.com/{{ cookiecutter.repo_owner }}/{{ cookiecutter.repo_name }}/actions/workflows/run-codespell.yml/badge.svg)](https://github.com/{{ cookiecutter.repo_owner }}/{{ cookiecutter.repo_name }}/actions/workflows/run-codespell.yml)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://gitHub.com/{{ cookiecutter.repo_owner }}/{{ cookiecutter.repo_name }}/graphs/commit-activity)

{{ cookiecutter.toolbox_summary }}

## Description

{{ cookiecutter.toolbox_description }}

## Requirements and installation
It is recommended to use **MATLAB {{ cookiecutter.matlab_version_min }}** or later. 

{%- if cookiecutter.products %}
The following MathWorks products are required:

{%- for product in cookiecutter.products.split(',') %}
- {{ product }}
{%- endfor %}
{%- endif %}

{%- if cookiecutter.fex_url %}
The toolbox can be installed from MATLAB's [Add-On Explorer](https://se.mathworks.com/help/matlab/matlab_env/get-add-ons.html) (recommended). It is also possible to download the MATLAB toolbox from [FileExchange]({{cookiecutter.fex_url}}) or from the [Releases](https://github.com/{{ cookiecutter.repo_owner }}/{{ cookiecutter.repo_name }}/releases/latest) page of this repository and install it manually.
{%- endif %}

Users or developers who clone the repository using git can use [MatBox](https://github.com/ehennestad/MatBox) to quickly install this project's [requirements](./requirements.txt) (if any):

```matlab
{{cookiecutter.namespace_name}}tools.installMatBox() % If MatBox is not installed
matbox.installRequirements(path/to/toolboxRootDir)
```

## Getting started

```matlab
< add some code examples here >
```

## Contributing
Please see the [Contributing guidelines](.github/CONTRIBUTING.md) and the [Developer notes](.github/DeveloperNotes.md)

## License

This project is available under the {{ cookiecutter.license }} License. See the LICENSE file for details.

## Author

{{ cookiecutter.author_name }} ({{ cookiecutter.author_email }})
{{ cookiecutter.author_company }}
