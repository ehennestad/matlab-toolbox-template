#!/usr/bin/env python3
"""
Render cookiecutter.json template using Jinja2
"""
import json
import os
import shutil
import sys
import yaml
from jinja2 import Template


def render_cookiecutter_template(template_name):
    """
    Render a cookiecutter.json.j2 template with config.yaml and environment data
    
    Args:
        template_name: Name of the template (e.g., 'main_template', 'gh-badges_template')
    
    Returns:
        str: Path to the prepared temporary template directory
    """
    # Read config.yaml
    with open('config.yaml', 'r') as f:
        config = yaml.safe_load(f)
    
    # Prepare environment variables
    env = {
        'GITHUB_REPOSITORY': os.environ.get('GITHUB_REPOSITORY', 'unknown/repo'), 
        'TOOLBOX_UUID': os.environ.get('TOOLBOX_UUID')
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
    
    # Create a temporary template directory
    temp_dir = f'/tmp/temp_{template_name}'
    os.makedirs(temp_dir, exist_ok=True)
    shutil.copytree(template_path, temp_dir, dirs_exist_ok=True)
    
    # Write the rendered JSON directly (don't re-parse and dump)
    with open(f'{temp_dir}/cookiecutter.json', 'w') as f:
        f.write(rendered_json)
    print(rendered_json)
    print(f"Prepared {template_name} with config injection")
    return temp_dir


def get_config_values():
    """
    Get commonly needed config values for the workflow
    
    Returns:
        dict: Dictionary with repo_name and license
    """
    # Read config.yaml
    with open('config.yaml', 'r') as f:
        config = yaml.safe_load(f)
    
    # Get repo name from environment
    repo_name = os.environ.get('GITHUB_REPOSITORY', 'unknown-repo').split('/')[-1]
    
    # Get license from config
    license_name = config.get('repository', {}).get('license', 'MIT')
    
    return {
        'repo_name': repo_name,
        'license': license_name
    }


def main():
    """Main function for command line usage"""
    if len(sys.argv) < 2:
        print("Usage: render_cookiecutter_template.py <template_name> [--get-config]")
        sys.exit(1)
    
    if sys.argv[1] == '--get-config':
        # Output config values as JSON for shell consumption
        config_values = get_config_values()
        print(json.dumps(config_values))
    else:
        template_name = sys.argv[1]
        temp_dir = render_cookiecutter_template(template_name)
        print(f"Template prepared at: {temp_dir}")


if __name__ == '__main__':
    main()
