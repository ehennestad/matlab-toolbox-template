#!/usr/bin/env bash
# Generate the content of an initialized toolbox repository from config.yaml.
#
# Usage: generate_toolbox.sh <output-dir>
#
# Writes the main branch content to <output-dir>/main and the gh-badges branch
# content to <output-dir>/gh-badges. Run from the template repository root with
# GITHUB_REPOSITORY and TOOLBOX_UUID set, and with cookiecutter, jinja2 and
# pyyaml installed.

set -euo pipefail

output_dir="$1"
project_name="${GITHUB_REPOSITORY##*/}"
render_dir="$(mktemp -d)"

license=$(python3 -c "import yaml; print(yaml.safe_load(open('config.yaml'))['repository']['license'])")

for template in main_template gh-badges_template; do
    # render_cookiecutter_template.py copies the template into this folder
    # and merges into what is already there
    rm -rf "/tmp/temp_${template}"
    python3 .github/scripts/render_cookiecutter_template.py "$template"

    if [ "$template" = "main_template" ]; then
        if [ -f "resources/licenses/${license}.txt" ]; then
            cp "resources/licenses/${license}.txt" "/tmp/temp_${template}/{{cookiecutter.repo_name}}/LICENSE"
        else
            echo "Warning: License '${license}' not found"
        fi
    fi

    cookiecutter "/tmp/temp_${template}" --no-input --output-dir "${render_dir}/${template}"
done

rm -rf "${output_dir}"
mkdir -p "${output_dir}/main" "${output_dir}/gh-badges"

# The workflows in .github apply to the generated toolbox, except those that
# initialize or test the template itself
cp -r .github "${output_dir}/main/"
rm -f "${output_dir}/main/.github/workflows/initialize.yml"
rm -f "${output_dir}/main/.github/workflows/reusable-check-push-permission.yml"
rm -f "${output_dir}/main/.github/workflows/test-template.yml"
rm -rf "${output_dir}/main/.github/scripts"
cp -r "${render_dir}/main_template/${project_name}/." "${output_dir}/main/"

cp -r "${render_dir}/gh-badges_template/${project_name}/." "${output_dir}/gh-badges/"
