---
name: new-matlab-toolbox
license: MIT
description: Create a new MATLAB toolbox repository from the ehennestad/matlab-toolbox-template, generated locally and pushed to a new GitHub repository with testing, code analysis and packaging workflows in place. Use when the user wants to start a new MATLAB toolbox, package or namespace project, set up a MATLAB repository with CI, or scaffold MATLAB toolbox structure. Use this skill instead of creating the folders and files by hand.
---

# New MATLAB toolbox

The template's own generator renders the toolbox. Do not build the folder structure by hand and do not edit
the generated files to look like the template: the generator, its checks and the template are the one source
of truth, and the template's CI tests that output.

Steps: check the tools, collect the configuration, generate, review, create the GitHub repository, finish the
setup. Ask the user before each step that creates or changes something on GitHub.

## 1. Check the tools

When a check below says to use the GitHub flow, stop and tell the user to create the repository on GitHub
with "Use this template" as described in the template's README
(https://github.com/ehennestad/matlab-toolbox-template). That path needs no local tools.

- The generator is a bash script that calls `python3`, so it runs on macOS, on Linux and on Windows inside
  WSL. On Windows outside WSL (PowerShell, cmd or Git Bash), use the GitHub flow: a Windows Python install
  provides `python` and `py` rather than `python3`, and `python3` there usually starts the Microsoft Store.
- `git` and `gh` must be installed. `gh auth status` must show a login with the `repo` and `workflow` token
  scopes. The first push creates files under `.github/workflows/`, and GitHub rejects it without `workflow`.
  If the scope is missing, ask the user to run `gh auth refresh -s workflow`. It opens a browser, so the user
  runs it, not you.
- The generator needs `python3` with `cookiecutter`, `pyyaml` and `jinja2`. Check with
  `python3 -c "import cookiecutter, yaml, jinja2"`.
  - Python present but packages missing: ask the user before installing anything. Then make a virtual
    environment in a temporary folder (`python3 -m venv <work>/venv`,
    `<work>/venv/bin/pip install cookiecutter pyyaml jinja2`) and put `<work>/venv/bin` first on `PATH` when
    you run the generator. Do not install into the user's global Python.
  - No Python: use the GitHub flow.

## 2. Get the template

Clone the template version this skill came from, so the steps here match the generator's options. When the
skill was installed with `gh skill install`, the frontmatter of the installed `SKILL.md` file has a
`metadata.github-ref` field, such as `refs/tags/v1.0.0`. Clone that ref:

```bash
git clone --depth 1 --branch <tag-or-branch> https://github.com/ehennestad/matlab-toolbox-template <work>/template
```

`--branch` takes the name without `refs/tags/` or `refs/heads/`. If the field is missing, use the latest
release (`gh release view --repo ehennestad/matlab-toolbox-template --json tagName --jq .tagName`), or the
default branch if there is no release. Tell the user which version you used.

`<work>` is a new temporary folder. Never generate inside the template clone.

## 3. Collect the configuration

Read the "Configuration reference" in `<work>/template/README.md` for what each field means, then ask the user
for the values. Suggest values where you can and let the user confirm them; do not fill in a field silently.

- GitHub repository as `owner/repo`. Suggest the user's login (`gh api user --jq .login`) as owner and a
  kebab-case name from the toolbox name. The repository name is also the folder name and is written into the
  generated files.
- Visibility: public or private.
- Where on disk the toolbox goes. The output folder must not exist or must be empty.
- `matlab_toolbox`: `namespace_name`, `toolbox_name`, `author_name`, `author_email`, `author_company`
  (optional), `toolbox_summary`, `toolbox_description`, `dependencies`. `git config user.name` and
  `git config user.email` are fair suggestions for the author.
- `repository.license`: one of the files in `<work>/template/resources/licenses/` without `.txt`, or `null`
  for no license.
- Optional: `fileexchange.fex_url`, `codecov.badge_token`. Leave them `null` unless the user has them.

Write the values to `<work>/config.yaml`, with the same layout as `<work>/template/config.yaml`. Quote every text
value, so YAML does not read words like `yes` or `no` as true or false.

## 4. Generate

```bash
<work>/template/.github/scripts/generate_toolbox.sh --config <work>/config.yaml --repository <owner>/<repo> <output-folder>
```

The script checks the configuration first. Each problem is printed as a line of the form
`::error file=...::<message>`. Show the messages to the user, correct the values with them and run it again.
Do not work around a check.

## 5. Review before anything leaves the machine

- Show the user the file tree and the generated `README.md`.
- If `dependencies` lists products other than `MATLAB`, CI does not install them yet. In
  `.github/workflows/test-code.yml` and `.github/workflows/prepare-release.yml`, uncomment `matlab_products: >`
  and list each product on its own line, with underscores for spaces (`Signal_Processing_Toolbox`). Show the
  user the diff.
- Make the first commit:

  ```bash
  git -C <output-folder> init -b main
  git -C <output-folder> add -A
  git -C <output-folder> commit -m "feat: initialize toolbox from matlab-toolbox-template"
  ```

## 6. Create the GitHub repository

Ask the user to confirm the owner, name, visibility and description before you run anything here.

```bash
gh repo create <owner>/<repo> --<public|private> --description "<toolbox_summary>" --source <output-folder> --remote origin
gh api -X PUT repos/<owner>/<repo>/actions/permissions/workflow -f default_workflow_permissions=write
git -C <output-folder> push -u origin main
```

The workflows commit updated badges back to the repository, which needs write permission for the workflow
token. Set it before the first push.

The test and spelling workflows skip their first run, so the first push runs no tests. They run from the next
push to `main` or the first pull request. Tell the user.

## 7. Finish the setup

Give the user these steps; do not run them yourself. They create and store secrets, and a private key should
not pass through you.

- Before the first release: the deploy key from the template README's step-by-step instructions. The release
  workflow pushes the release commit and tag with it and fails without it.
- If they use Codecov: add the upload token as the `CODECOV_TOKEN` Actions secret.

End with the repository URL, the local folder, the template version used and what is still left for the user
to do.
