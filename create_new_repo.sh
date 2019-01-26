#!/bin/bash
# Checking for command line arguments.   


command -v git >/dev/null 2>&1 || { echo >&2 "I require git but it's not installed.  Aborting."; exit 1; }
command -v conda >/dev/null 2>&1 || { echo >&2 "I require conda but it's not installed.  Aborting."; exit 1; }
if ! [ -z ${1+x} ]; then
local_repo_path=$1
echo "Creating git rep at $local_repo_path 1";
elif ! [ -z ${local_repo_path+x} ]; then
echo "Creating git rep at $local_repo_path 2";
else
local_repo_path="./new_repo"
echo "Creating git repo at $local_repo_path 3" 
fi

mkdir $local_repo_path
cd $local_repo_path
git init

command=$(conda env list | grep $local_repo_path | cut -d " " -f1)
echo $command
if  [ -z "${command}" ]; then
echo "Conda enviroment of the same name found - using that."
source activate $local_repo_path 
else
echo "No conda environment -- creating one under $local_repo_path"
conda create --name $local_repo_path python=3.6
fi
pip install pylint
pip install flake8
source deactivate
cd -

echo "Installed pylint and flake8 linter tools.   Copying git hooks"
cp ./githooks/* $local_repo_path/.git/hooks
