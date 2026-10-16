# Agent instructions

## Initialization must not create or modify workflow files

`initialize.yml` commits the generated toolbox and pushes it with `GITHUB_TOKEN`. That token cannot hold the `workflows` permission, and GitHub rejects a push that creates or modifies a file under `.github/workflows/` without it:

```
! [remote rejected] main -> main (refusing to allow a GitHub App to create or update workflow `.github/workflows/prepare-release.yml` without `workflows` permission)
```

The whole push is rejected, so the repository is left uninitialized.

- The workflows of the generated toolbox live in this repository's `.github/workflows/` and must reach the toolbox byte-for-byte unchanged.
- Initialization may delete workflow files. It removes the workflows that only initialize or test the template this way.
- Do not put workflow files in `cookiecutter_templates/`. Rendering them creates new workflow files.
- Do not write values from `config.yaml` into workflow files during initialization, with `sed`, templating or otherwise. A workflow setting the user must choose, such as `matlab_products`, is documented in the README for the user to edit after initialization.
- A test that generates a toolbox without pushing it does not catch this. Review every change to `initialize.yml`, and to any script it runs, for edits under `.github/workflows/`.
