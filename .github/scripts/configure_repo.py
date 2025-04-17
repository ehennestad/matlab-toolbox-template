#!/usr/bin/env python3
import os
import yaml
import json
import shutil
import tempfile
import fnmatch
import uuid
from cookiecutter.main import cookiecutter

# Load configuration from config.yaml
with open('config.yaml', 'r') as f:
    config = yaml.safe_load(f)

# Extract config sections
repository_config = config.get('repository', {})
matlab_config = config.get('matlab_toolbox', {})

# Create a temporary cookiecutter context file
context = {
    "repo_name": matlab_config.get('toolbox_name', 'matlab-toolbox').lower().replace(' ', '-'),
    "toolbox_name": matlab_config.get('toolbox_name', 'My MATLAB Toolbox'),
    "namespace_name": matlab_config.get('namespace_name', 'mytoolbox'),
    "author_name": matlab_config.get('author_name', 'Your Name'),
    "author_email": matlab_config.get('author_email', 'your.email@example.com'),
    "author_company": matlab_config.get('author_company', 'Your Company'),
    "toolbox_summary": matlab_config.get('toolbox_summary', 'A brief description'),
    "toolbox_description": matlab_config.get('toolbox_description', 'A detailed description'),
    "license": repository_config.get('license', 'MIT'),
    "github_username": "yourusername",  # Default value
    "github_repo": "{{ cookiecutter.repo_name }}",
    "matlab_version_min": "R2019b",  # Default value
    "dependencies": ["MATLAB"],  # Default value
    "uuid": str(uuid.uuid4())  # Dynamically generate a UUID
}

# Run cookiecutter with the context
output_dir = tempfile.mkdtemp()
result = cookiecutter(
    '_template',
    no_input=True,
    output_dir=output_dir,
    extra_context=context
)

# Copy generated files back to the repository root
generated_dir = os.path.join(output_dir, context['repo_name'])
for item in os.listdir(generated_dir):
    src = os.path.join(generated_dir, item)
    dst = os.path.join('.', item)
    
    # Skip _template and .github directories to preserve GitHub Actions
    if item in ['_template', '.github']:
        continue
        
    # Remove existing directory/file
    if os.path.exists(dst):
        if os.path.isdir(dst):
            shutil.rmtree(dst)
        else:
            os.remove(dst)
            
    # Copy new directory/file
    if os.path.isdir(src):
        shutil.copytree(src, dst)
    else:
        shutil.copy2(src, dst)

# Clean up template-specific files
if os.path.exists('.templateignore'):
    with open('.templateignore', 'r') as f:
        ignore_patterns = [line.strip() for line in f if line.strip() and not line.startswith('#')]
    
    # Process each ignore pattern
    for pattern in ignore_patterns:
        for root, dirs, files in os.walk('.', topdown=True):
            # Skip .git directory
            if '.git' in dirs:
                dirs.remove('.git')
                
            # Process directories matching the pattern
            for d in list(dirs):
                if fnmatch.fnmatch(os.path.join(root, d), pattern) or \
                   fnmatch.fnmatch(os.path.join(root, d) + '/', pattern):
                    full_path = os.path.join(root, d)
                    print(f"Removing directory: {full_path}")
                    shutil.rmtree(full_path)
                    dirs.remove(d)
            
            # Process files matching the pattern
            for f in files:
                if fnmatch.fnmatch(os.path.join(root, f), pattern):
                    full_path = os.path.join(root, f)
                    print(f"Removing file: {full_path}")
                    os.remove(full_path)

# Remove the .templateignore file itself
if os.path.exists('.templateignore'):
    os.remove('.templateignore')

# Clean up temporary directory
shutil.rmtree(output_dir)
print("Repository configured successfully!")
