# Developer Notes

This document provides guidance for developing and maintaining the {{ cookiecutter.toolbox_name }} toolbox.

## 📁 Project Structure

```
{{ cookiecutter.repo_name }}/
├── {{ "%-47s" % ("src/" + cookiecutter.namespace_name + "/") }}# Main toolbox source code
│   ├── +{{ "%-42s" % (cookiecutter.namespace_name + "/") }}# MATLAB package namespace
│   ├── Contents.m                                 # Toolbox contents listing
│   └── gettingStarted.m                           # Getting started guide
├── tests/                                         # Unit tests and test utilities
│   ├── +{{ "%-42s" % (cookiecutter.namespace_name + "/") }}# Namespace for unit tests and test utilites
├── tools/                                         # Development and build tools
│   ├── +{{ "%-42s" % (cookiecutter.namespace_name + "tools/") }}# Toolbox utilities
│   └── MLToolboxInfo.json                         # Toolbox metadata
└── docs/                                          # Documentation
    ├── buildDocs.m                                # Documentation builder
    ├── README.md                                  # Documentation guide
    └── STYLE_GUIDE.md                             # Coding style guide
```

## 🚀 Development Workflow

### 1. Setting Up Development Environment

```matlab
% Add the toolbox to your MATLAB path
addpath(genpath('src/{{ cookiecutter.namespace_name }}'));

% Verify installation
{{ cookiecutter.namespace_name }}.toolboxversion()
```

### 2. Writing Functions

**Location**: Place your main functions in `src/{{ cookiecutter.namespace_name }}/+{{ cookiecutter.namespace_name }}/`

**Naming Convention**: Use camelCase for function names and PascalCase for class names

**Function Template**:
```matlab
function output = myFunction(input, options)
% MYFUNCTION Brief description of what the function does
%
% Syntax:
%   output = {{ cookiecutter.namespace_name }}.myFunction(input)
%   output = {{ cookiecutter.namespace_name }}.myFunction(input, options)
%
% Description:
%   Detailed description of the function's purpose and behavior.
%
% Input Arguments:
%   input - Description of input parameter
%       Type: double | logical | char
%       Size: [m,n] | scalar | vector
%
%   options - Optional parameters (optional)
%       Type: struct
%       Fields:
%         - field1: Description (default: value)
%         - field2: Description (default: value)
%
% Output Arguments:
%   output - Description of output
%       Type: double | logical | char
%       Size: [m,n] | scalar | vector
%
% Examples:
%   % Basic usage
%   result = {{ cookiecutter.namespace_name }}.myFunction(data);
%
%   % With options
%   opts.field1 = value;
%   result = {{ cookiecutter.namespace_name }}.myFunction(data, opts);
%
% See also: RELATEDFUNCTION1, RELATEDFUNCTION2
%
% {{ cookiecutter.toolbox_name }}
% Copyright (c) {{ cookiecutter.author_name }}, {{ cookiecutter.author_company }}

arguments
    input {mustBeNumeric}
    options.field1 (1,1) double = 1
    options.field2 (1,1) logical = false
end

% Function implementation here
output = processInput(input, options);

end
```

### 3. Writing Tests

**Location**: Place tests in `tests/` directory

**Test Template**:
```matlab
function tests = testMyFunction
% TESTMYFUNCTION Unit tests for myFunction
%
% Run tests:
%   runtests('testMyFunction')
%   results = runtests('testMyFunction')

tests = functiontests(localfunctions);
end

function setupOnce(testCase)
% Setup for the entire test suite
addpath(fullfile(fileparts(mfilename('fullpath')), '..', 'src', '{{ cookiecutter.namespace_name }}'));
end

function setup(testCase)
% Setup for each test
testCase.TestData.sampleData = rand(10, 5);
end

function testBasicFunctionality(testCase)
% Test basic functionality
input = testCase.TestData.sampleData;
result = {{ cookiecutter.namespace_name }}.myFunction(input);
verifySize(testCase, result, size(input));
end

function testWithOptions(testCase)
% Test with optional parameters
input = testCase.TestData.sampleData;
options.field1 = 2;
result = {{ cookiecutter.namespace_name }}.myFunction(input, options);
verifyClass(testCase, result, 'double');
end

function testErrorHandling(testCase)
% Test error conditions
verifyError(testCase, @() {{ cookiecutter.namespace_name }}.myFunction('invalid'), ...
    'MATLAB:validators:mustBeNumeric');
end
```

### 4. Running Tests

```matlab
% Run all tests
runtests('tests')

% Run specific test file
runtests('tests/testMyFunction')

% Run with coverage
import matlab.unittest.TestRunner
import matlab.unittest.plugins.CodeCoveragePlugin
import matlab.unittest.plugins.codecoverage.CoverageReport

suite = testsuite('tests');
runner = TestRunner.withTextOutput;
runner.addPlugin(CodeCoveragePlugin.forFolder('src'));
results = runner.run(suite);
```

### 5. Building Documentation
Todo

### 6. Packaging the Toolbox

**Requirements**: MATLAB R2023a or later for toolbox packaging

```matlab
% Package the toolbox
{{ cookiecutter.namespace_name }}tools.packageToolbox()

% Install locally for testing
{{ cookiecutter.namespace_name }}tools.installMatBox()
```

## 📝 Coding Standards

### Documentation Standards

- **Function Headers**: Use the template above with complete argument descriptions
- **Comments**: Explain complex algorithms and non-obvious code
- **Examples**: Provide practical usage examples in function headers
- **See Also**: Reference related functions

### Code Style

- **Indentation**: 4 spaces (no tabs)
- **Line Length**: Maximum 80 characters
- **Variable Names**: Use descriptive camelCase names
- **Constants**: Use UPPER_CASE for constants
- **Function Names**: Use camelCase, start with lowercase letter

### Error Handling

```matlab
% Use arguments blocks for input validation
arguments
    input {mustBeNumeric, mustBeFinite}
    options.tolerance (1,1) double {mustBePositive} = 1e-6
end

% Provide meaningful error messages
if size(input, 2) ~= 3
    error('{{ cookiecutter.namespace_name | upper }}:invalidInput', ...
        'Input must have exactly 3 columns, got %d', size(input, 2));
end
```

## 🔧 Development Tools

### Useful MATLAB Commands

```matlab
% Check code quality
checkcode('src/{{ cookiecutter.namespace_name }}/')

% Profile performance
profile on
{{ cookiecutter.namespace_name }}.myFunction(data);
profile viewer

% Dependency analysis
[fList, pList] = matlab.codetools.requiredFilesAndProducts('src/{{ cookiecutter.namespace_name }}');
```

### Git Workflow

```bash
# Create feature branch
git checkout -b feature/new-functionality

# Make changes and commit
git add .
git commit -m "Add new functionality for X"

# Push and create pull request
git push origin feature/new-functionality
```

## ⚠️ Important Notes

- **MATLAB Version Compatibility**: Toolbox packaging using [MatBox](https://github.com/ehennestad/MatBox) requires R2023a+.

- **Path Management**: Always use relative paths and the `{{ cookiecutter.namespace_name }}tools.projectdir()` function
- **Testing**: Run tests before committing changes
- **Documentation**: Update documentation when adding new features
- **Versioning**: Follow semantic versioning (MAJOR.MINOR.PATCH)

## 🐛 Troubleshooting

### Common Issues

1. **Path Problems**: Ensure the toolbox is properly added to MATLAB path
2. **Test Failures**: Check that all dependencies are available
3. **Packaging Errors**: Verify MATLAB version and toolbox metadata
4. **Performance Issues**: Use MATLAB Profiler to identify bottlenecks

### Getting Help

- Check existing issues in the repository
- Review the documentation in `docs/`
- Consult the MATLAB documentation
- Contact the maintainers: {{ cookiecutter.author_email }}
