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

if [ -d "$local_repo_path" ]; then 
   echo "Directory $local_repo_path already exists! Aborting."; exit 1; 
fi
mkdir $local_repo_path
cd $local_repo_path
git init

command=$(conda env list | grep -w $local_repo_path | cut -d " " -f1)
echo $command
if ! [ -z "${command}" ]; then
echo "Conda enviroment of the same name found - using that."
source activate $local_repo_path 
else
echo "No conda environment -- creating one under $local_repo_path"
conda create --name $local_repo_path python=3.6
echo "Installing pylint"
pip install pylint
echo "Installing flake 8"
pip install flake8
echo "Installing pytest"
pip install pytest
fi
source deactivate
cd -
echo "Copying scripts"
cp run_tests.sh $local_repo_path
cp -r githooks $local_repo_path
cd $local_repo_path
echo "Adding scripts to git repo"
git add run_tests.sh
git add githooks/*
git commit -m "Initial commit"
echo "Creating simlink"
ln -s githooks/pre-commit .git/hooks/pre-commit
cd -

echo "New git repo created. Exiting"
