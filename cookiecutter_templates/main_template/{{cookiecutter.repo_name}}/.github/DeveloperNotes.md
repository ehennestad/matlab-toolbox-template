# Developer Notes

Notes for developing, testing and releasing {{ cookiecutter.toolbox_name }}. The development tasks use [MatBox](https://github.com/ehennestad/MatBox).

## Project structure

```
{{ cookiecutter.repo_name }}/
├── {{ "%-35s" % ("src/" + cookiecutter.namespace_name + "/") }}# Code that is packaged into the toolbox
│   ├── +{{ "%-30s" % (cookiecutter.namespace_name + "/") }}# Toolbox namespace
│   ├── examples/                      # Example scripts
│   └── Contents.m                     # Toolbox name and version
├── tests/                             # Unit tests
├── tools/                             # Development tools, not packaged
│   ├── +{{ "%-30s" % (cookiecutter.namespace_name + "tools/") }}# installMatBox and projectdir
│   ├── tasks/                         # testToolbox, codecheckToolbox, packageToolbox
│   └── MLToolboxInfo.json             # Toolbox packaging metadata
├── docs/                              # Documentation; reports are written to docs/reports
└── requirements.txt                   # Requirements, installed with MatBox
```

## Setting up

```matlab
addpath(genpath("tools"))
{{ cookiecutter.namespace_name }}tools.installMatBox()  % Installs MatBox if it is missing
matbox.installRequirements({{ cookiecutter.namespace_name }}tools.projectdir())
```

## Running tests and code checks

```matlab
testToolbox()       % Runs the tests in tests/ and measures coverage of src/{{ cookiecutter.namespace_name }}/
codecheckToolbox()  % Runs Code Analyzer on src/{{ cookiecutter.namespace_name }}/
```

Reports are saved in `docs/reports`. The *Run tests* workflow calls the same functions on pushes and pull requests to `main`.

Tests are class-based `matlab.unittest` tests. See `tests/ToolboxTest.m` for an example.

## Packaging

```matlab
packageToolbox("specific", "1.2.0")
```

This writes an MLTBX file to `releases/`. Packaging requires MATLAB R2023a or later.

## Releasing

Push a tag in `vMAJOR.MINOR.PATCH` form, or run the *Prepare toolbox release* workflow manually with a version number. The workflow tests the toolbox, packages it, then pushes a release commit and tag and creates a GitHub release. Versions follow [semantic versioning](https://semver.org).

The workflow checks out the repository with an SSH deploy key stored in the `DEPLOY_KEY` Actions secret, and fails without it. To set it up once:

```bash
ssh-keygen -t ed25519 -N "" -C "release workflow" -f deploy_key
gh repo deploy-key add deploy_key.pub --allow-write --title "Release workflow"
gh secret set DEPLOY_KEY < deploy_key
rm deploy_key deploy_key.pub
```
