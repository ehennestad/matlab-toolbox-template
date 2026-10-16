#!/usr/bin/env python3
"""
Check config.yaml before a toolbox is generated from it.

Prints one GitHub Actions error annotation per problem and exits with status 1
if any are found.
"""
import os
import re
import sys

import yaml

CONFIG_FILE = 'config.yaml'
LICENSE_FOLDER = 'resources/licenses'

REQUIRED_TOOLBOX_FIELDS = [
    'namespace_name',
    'toolbox_name',
    'author_name',
    'author_email',
    'toolbox_summary',
    'toolbox_description',
]

# Output of iskeyword() in MATLAB
MATLAB_KEYWORDS = {
    'break', 'case', 'catch', 'classdef', 'continue', 'else', 'elseif', 'end',
    'for', 'function', 'global', 'if', 'otherwise', 'parfor', 'persistent',
    'return', 'spmd', 'switch', 'try', 'while',
}

# Value of namelengthmax in MATLAB
MATLAB_MAX_NAME_LENGTH = 63

# matlab.addons.toolbox.ToolboxOptions rejects these characters in ToolboxName
INVALID_TOOLBOX_NAME_CHARACTERS = '"&:*?<>|'

# The generated tools namespace is the toolbox namespace with this suffix
TOOLS_NAMESPACE_SUFFIX = 'tools'


def validate_config(config):
    """Return a list of problems found in the parsed config.yaml content."""
    if not isinstance(config, dict):
        return ['config.yaml must contain the repository and matlab_toolbox sections.']

    problems = []

    license_name = (config.get('repository') or {}).get('license')
    available_licenses = sorted(
        os.path.splitext(name)[0] for name in os.listdir(LICENSE_FOLDER))
    if license_name is not None and license_name not in available_licenses:
        problems.append(
            f'repository.license is "{license_name}". '
            f'Use one of: {", ".join(available_licenses)}, or null for no license.')

    toolbox = config.get('matlab_toolbox') or {}
    for field in REQUIRED_TOOLBOX_FIELDS:
        value = toolbox.get(field)
        if not isinstance(value, str) or not value.strip():
            problems.append(f'matlab_toolbox.{field} must be a non-empty text value.')

    author_company = toolbox.get('author_company')
    if author_company is not None and not isinstance(author_company, str):
        problems.append('matlab_toolbox.author_company must be a text value.')

    namespace_name = toolbox.get('namespace_name')
    if isinstance(namespace_name, str) and namespace_name.strip():
        problems.extend(validate_namespace_name(namespace_name))

    toolbox_name = toolbox.get('toolbox_name')
    if isinstance(toolbox_name, str):
        invalid_characters = sorted(set(toolbox_name) & set(INVALID_TOOLBOX_NAME_CHARACTERS))
        if invalid_characters:
            problems.append(
                f'matlab_toolbox.toolbox_name contains characters MATLAB does not allow '
                f'in a toolbox name: {" ".join(invalid_characters)}. Remove them.')

    dependencies = toolbox.get('dependencies')
    if dependencies is not None and not (
            isinstance(dependencies, list)
            and all(isinstance(item, str) and item.strip() for item in dependencies)):
        problems.append(
            'matlab_toolbox.dependencies must be a list of MathWorks product names, '
            'for example [MATLAB, Signal Processing Toolbox].')

    return problems


def validate_namespace_name(namespace_name):
    """Return the problems with namespace_name as a MATLAB namespace name."""
    problems = []
    if not re.fullmatch(r'[A-Za-z][A-Za-z0-9_]*', namespace_name):
        problems.append(
            f'matlab_toolbox.namespace_name "{namespace_name}" is not a valid MATLAB name. '
            'Start with a letter and use only letters, digits and underscores.')
    if namespace_name in MATLAB_KEYWORDS:
        problems.append(
            f'matlab_toolbox.namespace_name "{namespace_name}" is a MATLAB keyword. '
            'Choose another name.')
    max_length = MATLAB_MAX_NAME_LENGTH - len(TOOLS_NAMESPACE_SUFFIX)
    if len(namespace_name) > max_length:
        problems.append(
            f'matlab_toolbox.namespace_name is {len(namespace_name)} characters long. '
            f'Use at most {max_length} characters.')
    return problems


def main():
    with open(CONFIG_FILE, 'r') as f:
        try:
            config = yaml.safe_load(f)
        except yaml.YAMLError as e:
            print(f'::error file={CONFIG_FILE}::config.yaml is not valid YAML: {str(e).replace(chr(10), " ")}')
            sys.exit(1)

    problems = validate_config(config)
    for problem in problems:
        print(f'::error file={CONFIG_FILE}::{problem}')
    if problems:
        sys.exit(1)
    print('config.yaml is valid')


if __name__ == '__main__':
    main()
