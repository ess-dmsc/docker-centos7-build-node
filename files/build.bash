#!/bin/bash

repo=$1
branch=$2

function errexit() {
  echo "Error: $1"
  bash -i
  exit
}

sclcmd="scl enable devtoolset-8"

git clone https://github.com/ess-dmsc/$repo || errexit "unable to clone"
cd $repo

if [[ $branch != "master" ]]; then
  git checkout $branch || errexit "invalid branch"
fi

mkdir build
cd build

$sclcmd -- cmake .. || errexit "cmake failed"
$sclcmd -- source activate_run.sh || errexit "activate_run failed"
$sclcmd -- make -j 4 || errexit "make failed"
$sclcmd -- make -j 4 unit_tests || errexit "make unit_tests failed"

echo "done"
bash -i
