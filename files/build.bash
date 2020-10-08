#!/bin/bash

repo=${1:-event-formation-unit}
branch=${2:-master}
shift 2
targets=${*:-all}

cpus=$(nproc)

echo "building targets: $targets"
echo "on branch: $branch"
echo "of repo: $repo"

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
for target in $targets
do
  $sclcmd -- make -j $cpus $targets || errexit "make failed"
done

echo "done"
bash -i
