#!/usr/bin/env bash
# Generate the content of an initialized toolbox repository from config.yaml.
#
# Usage: generate_toolbox.sh <output-dir>
#
# Writes the main branch content to <output-dir>/main. Run from the template
# repository root with GITHUB_REPOSITORY and TOOLBOX_UUID set, and with
# cookiecutter, jinja2 and pyyaml installed.

set -euo pipefail

output_dir="$1"
project_name="${GITHUB_REPOSITORY##*/}"
render_dir="$(mktemp -d)"

python3 .github/scripts/validate_config.py

# Empty when config.yaml has no repository.license or sets it to null
license=$(python3 -c "
import yaml
config = yaml.safe_load(open('config.yaml')) or {}
print((config.get('repository') or {}).get('license') or '')
")

# render_cookiecutter_template.py copies the template into this folder and
# merges into what is already there
rm -rf /tmp/temp_main_template
python3 .github/scripts/render_cookiecutter_template.py main_template

if [ -z "$license" ]; then
    echo "No license specified in config.yaml"
elif [ -f "resources/licenses/${license}.txt" ]; then
    cp "resources/licenses/${license}.txt" "/tmp/temp_main_template/{{cookiecutter.repo_name}}/LICENSE"
else
    echo "Warning: License '${license}' not found"
fi

cookiecutter /tmp/temp_main_template --no-input --output-dir "${render_dir}"

rm -rf "${output_dir}"
mkdir -p "${output_dir}/main"

# The workflows in .github apply to the generated toolbox, except those that
# initialize or test the template itself
cp -r .github "${output_dir}/main/"
rm -f "${output_dir}/main/.github/workflows/initialize.yml"
rm -f "${output_dir}/main/.github/workflows/reusable-check-push-permission.yml"
rm -f "${output_dir}/main/.github/workflows/test-template.yml"
rm -rf "${output_dir}/main/.github/scripts"
rm -rf "${output_dir}/main/.github/test-configs"
cp -r "${render_dir}/${project_name}/." "${output_dir}/main/"
