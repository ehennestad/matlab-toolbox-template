import yaml
import os
import uuid
from jinja2 import Template

# Load configuration from config.yaml
def load_config(config_file):
    with open(config_file, 'r') as file:
        config = yaml.safe_load(file)
    return config

# Replace variables in the given file content using Jinja2 templating
def replace_variables_in_file_content(file_path, variables):
    with open(file_path, 'r') as file:
        content = file.read()

    # Use Jinja2 template rendering to replace placeholders
    template = Template(content)
    rendered_content = template.render(variables)

    # Overwrite the file with the rendered content
    with open(file_path, 'w') as file:
        file.write(rendered_content)

# Replace variables in file or folder names
def replace_variables_in_name(name, variables):
    template = Template(name)
    return template.render(variables)

# Recursively find and replace placeholders in .m and .json files and their names
def replace_in_files_and_folders(root_dir, variables):
    for dirpath, dirnames, filenames in os.walk(root_dir, topdown=False):
        # Replace placeholders in filenames
        for filename in filenames:
            if filename.endswith('.m') or filename.endswith('.json'):
                old_path = os.path.join(dirpath, filename)
                new_filename = replace_variables_in_name(filename, variables)
                new_path = os.path.join(dirpath, new_filename)
                os.rename(old_path, new_path)
                replace_variables_in_file_content(new_path, variables)

        # Replace placeholders in directory names
        for dirname in dirnames:
            old_dirpath = os.path.join(dirpath, dirname)
            new_dirname = replace_variables_in_name(dirname, variables)
            new_dirpath = os.path.join(dirpath, new_dirname)
            os.rename(old_dirpath, new_dirpath)

if __name__ == "__main__":
    # Load the configuration from the YAML file
    config_file = 'config.yaml'
    config = load_config(config_file)
    
    # Define the placeholders and corresponding values from the config
    variables = {
        'namespace_name': config['matlab_toolbox']['namespace_name'],
        'uuid': str(uuid.uuid4()),  # Dynamically generate a UUID
        'toolbox_name': config['matlab_toolbox']['toolbox_name'],
        'author_name': config['matlab_toolbox']['author_name'],
        'author_email': config['matlab_toolbox']['author_email'],
        'author_company': config['matlab_toolbox']['author_company'],
        'toolbox_summary': config['matlab_toolbox']['toolbox_summary'],
        'toolbox_description': config['matlab_toolbox']['toolbox_description'].replace('\n', ' ').strip()
    }
    
    # Set the root directory for your project (assuming current directory)
    root_dir = '.'

    # Replace variables in all .m and .json files in the project
    replace_in_files_and_folders(root_dir, variables)
