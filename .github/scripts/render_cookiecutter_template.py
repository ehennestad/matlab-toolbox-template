#!/usr/bin/env python3
"""
Render cookiecutter.json template using Jinja2
"""
import argparse
import json
import shutil
import sys
import yaml
from jinja2 import Template


def render_cookiecutter_template(template_name, config_file, repository, toolbox_uuid, output_dir):
    """
    Render a cookiecutter.json.j2 template with the config file and repository data

    Args:
        template_name: Name of the template (e.g., 'main_template')
        config_file: Path to the toolbox configuration file
        repository: GitHub repository of the toolbox, as owner/repo
        toolbox_uuid: Identifier of the toolbox
        output_dir: Folder to write the prepared template to. Must not exist.

    Returns:
        str: Path to the prepared template directory
    """
    with open(config_file, 'r') as f:
        config = yaml.safe_load(f)

    # cookiecutter.json.j2 reads these under the names of the GitHub Actions
    # environment variables that provide them during initialization
    env = {
        'GITHUB_REPOSITORY': repository,
        'TOOLBOX_UUID': toolbox_uuid,
    }

    template_path = f'cookiecutter_templates/{template_name}'
    jinja_template_path = f'{template_path}/cookiecutter.json.j2'

    # Use Jinja template
    with open(jinja_template_path, 'r') as f:
        template_content = f.read()

    # Render the template with config and env data
    template = Template(template_content)
    rendered_json = template.render(config=config, env=env)

    # Parse the rendered JSON to validate it
    try:
        json.loads(rendered_json)  # Just validate, don't store
    except json.JSONDecodeError as e:
        print(f"Error parsing rendered JSON: {e}")
        print(f"Rendered content: {rendered_json}")
        sys.exit(1)

    print(f"Rendered cookiecutter.json using Jinja template for {template_name}")

    shutil.copytree(template_path, output_dir)

    # Write the rendered JSON directly (don't re-parse and dump)
    with open(f'{output_dir}/cookiecutter.json', 'w') as f:
        f.write(rendered_json)
    print(rendered_json)
    print(f"Prepared {template_name} with config injection")
    return output_dir


def main():
    """Main function for command line usage"""
    parser = argparse.ArgumentParser(description='Prepare a cookiecutter template for rendering.')
    parser.add_argument('template_name', help="Name of the template, e.g. 'main_template'")
    parser.add_argument('--config', required=True, help='Path to the toolbox configuration file')
    parser.add_argument('--repository', required=True, help='GitHub repository of the toolbox, as owner/repo')
    parser.add_argument('--uuid', required=True, help='Identifier of the toolbox')
    parser.add_argument('--output', required=True, help='Folder to write the prepared template to')
    args = parser.parse_args()

    output_dir = render_cookiecutter_template(
        args.template_name, args.config, args.repository, args.uuid, args.output)
    print(f"Template prepared at: {output_dir}")


if __name__ == '__main__':
    main()
