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
setup. The user confirms at two checkpoints: the configuration and any package install (end of step 3), and
everything that goes to GitHub (end of step 5). Between them, ask only when a check fails or a value is
missing.

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
  - Python present but packages missing: note it. They are installed in step 4, in a virtual environment,
    once the user approves at the first checkpoint. Do not install into the user's global Python.
  - No Python: use the GitHub flow.

## 2. Get the template

Use the template version this skill came from, so the steps here match the generator's options. When the
skill was installed with `gh skill install`, the frontmatter of the installed `SKILL.md` file has a
`metadata.github-ref` field. It holds a full ref such as `refs/tags/v1.0.0` or `refs/heads/main`, or a commit
SHA when the install was pinned to one. Fetch that value as it is:

```bash
git init <work>/template
git -C <work>/template fetch --depth 1 https://github.com/ehennestad/matlab-toolbox-template <ref>
git -C <work>/template checkout FETCH_HEAD
```

Do not use `git clone --branch`, which rejects a commit SHA. If the field is missing, use the latest release
tag (`gh release view --repo ehennestad/matlab-toolbox-template --json tagName --jq .tagName`) as `<ref>`, or
`HEAD` for the default branch if there is no release. Tell the user which version you used.

`<work>` is a new temporary folder. Never generate inside the template clone.

## 3. Collect the configuration

Read the "Configuration reference" in `<work>/template/README.md` for what each field means, then ask the user
for all the values in one message. Suggest values where you can; the user confirms them at checkpoint 1. Do
not fill in a field silently.

- GitHub repository as `owner/repo`. Suggest the user's login (`gh api user --jq .login`) as owner and a
  kebab-case name from the toolbox name. The repository name is also the folder name and is written into the
  generated files.
- Visibility: public or private. The template's CI runs MATLAB on GitHub-hosted runners, which MathWorks
  licenses for public repositories only. In a private repository the test and release workflows fail with a
  licensing error. Tell the user this before they choose.
- Where on disk the toolbox goes. The output folder must not exist or must be empty.
- `matlab_toolbox`: `namespace_name`, `toolbox_name`, `author_name`, `author_email`, `author_company`
  (optional), `toolbox_summary`, `toolbox_description`, `dependencies`. `git config user.name` and
  `git config user.email` are fair suggestions for the author.
- `repository.license`: one of the files in `<work>/template/resources/licenses/` without `.txt`, or `null`
  for no license.
- Optional: `fileexchange.fex_url`, `codecov.badge_token`. Leave them `null` unless the user has them.

**Checkpoint 1.** Show the user one summary: every value above, the template version, and whether the Python
packages will be installed in a virtual environment in `<work>`. Ask for one confirmation of all of it, and
correct any value the user changes before going on.

Write the values to `<work>/config.yaml`, with the same layout as `<work>/template/config.yaml`. Quote every text
value, so YAML does not read words like `yes` or `no` as true or false.

## 4. Generate

If step 1 found the packages missing, install them now in a virtual environment:

```bash
python3 -m venv <work>/venv
<work>/venv/bin/pip install cookiecutter pyyaml jinja2
```

Then start each command that needs them, the generator and the YAML check in step 5, with
`PATH="<work>/venv/bin:$PATH"`. A shell may not keep an exported variable from one command to the next.

```bash
<work>/template/.github/scripts/generate_toolbox.sh --config <work>/config.yaml --repository <owner>/<repo> <output-folder>
```

The script checks the configuration first. Each problem is printed as a line of the form
`::error file=...::<message>`. Show the messages to the user, correct the values with them and run it again.
Do not work around a check.

## 5. Review before anything leaves the machine

- Show the user the file tree and the generated `README.md`.
- If `dependencies` lists products other than `MATLAB`, CI does not install them yet. In
  `.github/workflows/run-tests.yml` and `.github/workflows/prepare-release.yml`, replace the commented block
  (`# matlab_products: >` and the two commented example lines under it) with the key and one product per line,
  indented two spaces deeper than the key, with underscores for spaces:

  ```yaml
        matlab_products: >
          Signal_Processing_Toolbox
  ```

  A product line after commented lines that are kept breaks the YAML, and an example line indented under the
  key becomes part of the value. Check that both files still parse, with the Python that has `pyyaml`:
  `python3 -c "import sys, yaml; [yaml.safe_load(open(f)) for f in sys.argv[1:]]" <the two files>`. Show the
  user the diff.
- Make the first commit:

  ```bash
  git -C <output-folder> init -b main
  git -C <output-folder> add -A
  git -C <output-folder> commit -m "feat: initialize toolbox from matlab-toolbox-template"
  ```

**Checkpoint 2.** List what step 6 will do: create `<owner>/<repo>` with its visibility and description, set
the repository's workflow permissions to write, and push `main`. Ask for one go-ahead for all three. If the user
declines, stop here; the local folder and commit stay as they are.

## 6. Create the GitHub repository

Run these after the go-ahead at checkpoint 2:

```bash
gh repo create <owner>/<repo> --<public|private> --description "<toolbox_summary>" --source <output-folder> --remote origin
gh api -X PUT repos/<owner>/<repo>/actions/permissions/workflow -f default_workflow_permissions=write
git -C <output-folder> push -u origin main
```

The workflows commit updated badges back to the repository, which needs write permission for the workflow
token. Set it before the first push.

The test and spelling workflows skip their first run, so the first push runs no tests. The tests run on the
next push to `main`, or the next pull request, that changes files outside `*.md` and `.github/`. Tell the user.

## 7. Finish the setup

Give the user these steps; do not run them yourself. They create and store secrets, and a private key should
not pass through you.

- Before the first release: the deploy key from the template README's step-by-step instructions. The release
  workflow pushes the release commit and tag with it and fails without it.
- If they use Codecov: add the upload token as the `CODECOV_TOKEN` Actions secret.

End with the repository URL, the local folder, the template version used and what is still left for the user
to do.
