#!/usr/bin/env bash
# Generate the content of an initialized toolbox repository from a config file.
#
# Run with --help for the options. Can run from any folder. Needs python3 with
# cookiecutter, jinja2 and pyyaml installed.

set -euo pipefail

print_usage() {
    cat <<'EOF'
Usage: generate_toolbox.sh [--config <file>] [--repository <owner/repo>] <output-dir>

  --config      Toolbox configuration. Default: config.yaml in the template
                repository.
  --repository  GitHub repository of the toolbox, as owner/repo. The
                repository name is the name of the toolbox folder and is
                written into the generated files. Default: the
                GITHUB_REPOSITORY environment variable.
  <output-dir>  Folder to write the toolbox to. It must not exist or be empty.

The toolbox identifier is TOOLBOX_UUID, or a new random UUID when it is unset.
EOF
}

config_file=""
repository="${GITHUB_REPOSITORY:-}"
output_dir=""

while [ $# -gt 0 ]; do
    case "$1" in
        --config)
            config_file="${2:?--config needs a file path}"
            shift 2
            ;;
        --repository)
            repository="${2:?--repository needs an owner/repo value}"
            shift 2
            ;;
        -h|--help)
            print_usage
            exit 0
            ;;
        -*)
            echo "Error: unknown option $1" >&2
            print_usage >&2
            exit 1
            ;;
        *)
            if [ -n "$output_dir" ]; then
                echo "Error: more than one output folder given" >&2
                print_usage >&2
                exit 1
            fi
            output_dir="$1"
            shift
            ;;
    esac
done

if [ -z "$output_dir" ]; then
    print_usage >&2
    exit 1
fi

# The characters GitHub allows in owner and repository names
repository_pattern='^[A-Za-z0-9-]+/[A-Za-z0-9._-]+$'
if [[ ! "$repository" =~ $repository_pattern ]]; then
    echo "Error: the repository \"$repository\" is not an owner/repo name. Give it with --repository" \
        "or GITHUB_REPOSITORY, using only letters, digits, hyphens, underscores and periods." >&2
    exit 1
fi

if [ -e "$output_dir" ] && { [ ! -d "$output_dir" ] || [ -n "$(ls -A "$output_dir")" ]; }; then
    echo "Error: $output_dir already exists and is not an empty folder. Choose a new or empty folder." >&2
    exit 1
fi

# Paths given by the caller are relative to the folder the script is run from,
# and the steps below run from the template repository root
case "$output_dir" in
    /*) ;;
    *) output_dir="$PWD/$output_dir" ;;
esac
if [ -n "$config_file" ]; then
    if [ ! -f "$config_file" ]; then
        echo "Error: config file $config_file not found." >&2
        exit 1
    fi
    case "$config_file" in
        /*) ;;
        *) config_file="$PWD/$config_file" ;;
    esac
else
    # Relative, so GitHub Actions annotations from validate_config.py link to
    # the file in the repository
    config_file="config.yaml"
fi

cd "$(dirname "${BASH_SOURCE[0]}")/../.."

project_name="${repository##*/}"
toolbox_uuid="${TOOLBOX_UUID:-$(python3 -c 'import uuid; print(uuid.uuid4())')}"

work_dir="$(mktemp -d)"
trap 'rm -rf "$work_dir"' EXIT
template_dir="${work_dir}/template"
render_dir="${work_dir}/rendered"

python3 .github/scripts/validate_config.py "$config_file"

# Empty when the config has no repository.license or sets it to null
license=$(python3 -c "
import sys
import yaml
config = yaml.safe_load(open(sys.argv[1])) or {}
print((config.get('repository') or {}).get('license') or '')
" "$config_file")

python3 .github/scripts/render_cookiecutter_template.py main_template \
    --config "$config_file" \
    --repository "$repository" \
    --uuid "$toolbox_uuid" \
    --output "$template_dir"

if [ -z "$license" ]; then
    echo "No license specified in $config_file"
elif [ -f "resources/licenses/${license}.txt" ]; then
    cp "resources/licenses/${license}.txt" "${template_dir}/{{cookiecutter.repo_name}}/LICENSE"
else
    echo "Warning: License '${license}' not found"
fi

# --default-config ignores the user's cookiecutter config file, whose
# default_context would otherwise override values from the toolbox config
cookiecutter "$template_dir" --no-input --default-config --output-dir "$render_dir"

mkdir -p "$output_dir"

# The workflows in .github apply to the generated toolbox, except those that
# initialize or test the template itself
cp -r .github "${output_dir}/"
rm -f "${output_dir}/.github/workflows/initialize.yml"
rm -f "${output_dir}/.github/workflows/reusable-check-push-permission.yml"
rm -f "${output_dir}/.github/workflows/test-template.yml"
rm -rf "${output_dir}/.github/scripts"
rm -rf "${output_dir}/.github/test-configs"
cp -r "${render_dir}/${project_name}/." "${output_dir}/"
