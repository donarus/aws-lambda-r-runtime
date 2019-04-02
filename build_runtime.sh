#!/bin/bash

set -euo pipefail

if [[ -z ${1+x} ]];
then
    echo 'version number required'
    exit 1
else
    VERSION=$1
fi

rm -rf build/runtime/
mkdir -p build/runtime/
cp src/* build/runtime/
cd build/runtime/
unzip -q ../../R-$VERSION.zip -d R/
rm -r R/doc/manual/
#remove some libraries to save space
recommended=(boot class cluster codetools foreign KernSmooth lattice MASS Matrix mgcv nlme nnet rpart spatial survival)
for package in "${recommended[@]}"
do
   rm -r R/library/$package/
done
chmod -R 755 bootstrap runtime.R R/
rm -f runtime.zip
zip -r -q runtime.zip runtime.R bootstrap R/
mkdir -p ../layers/
mv runtime.zip ../layers/
