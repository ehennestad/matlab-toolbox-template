# Matlab-Toolbox

Template project for developing a MATLAB toolbox with git. This project includes:
- `.gitignore` suitable for MATLAB projects
- easy selection of a license among a common selection of commonly used licenses 
- workflows for testing code on updates (push/PR) and for packaging a MATLAB toolbox (mltbx) on releases
- predefined folder organization and some useful placeholder files
- Integration with [MatBox](https://github.com/ehennestad/MatBox) that implements tasks to run during workflows and dependency management using a requirements.txt file

To use this template, press the green "Use this template..." button in the upper right corner of this page and the follow the [post-setup instructions](#post-setup-instructions) below.

## Post-Setup Instructions

### Step 1
After creating a repository from this template, please follow these steps:

1. Go to your repository's `Settings` tab.
2. Under `Actions`, click `General`.
3. In the `Workflow permissions` section, enable `Read and write permissions`.
4. Save the changes.

This will allow the GitHub Actions workflow to push changes and configure the repository when you edit the `config.yaml` file.

### Step 2
Edit and commit the config.yaml file
