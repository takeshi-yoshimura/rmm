#!/bin/bash
#
# Adopted from https://github.com/tmcdonell/travis-scripts/blob/dfaac280ac2082cd6bcaba3217428347899f2975/update-accelerate-buildbot.sh

set -e

if [ "$BUILD_LIBRMM" == '1' ]; then
  export UPLOADFILE=`conda build conda/recipes/librmm -c rapidsai -c rapidsai-nightly -c nvidia -c conda-forge --python=$PYTHON --output`

  SOURCE_BRANCH=master
  CUDA_REL=${CUDA_VERSION%.*}

  SOURCE_BRANCH=master

  LABEL_OPTION="--label main --label cuda${CUDA_REL}"
  echo "LABEL_OPTION=${LABEL_OPTION}"

  # Restrict uploads to master branch
  if [ ${GIT_BRANCH} != ${SOURCE_BRANCH} ]; then
    echo "Skipping upload"
    return 0
  fi

  if [ -z "$MY_UPLOAD_KEY" ]; then
      echo "No upload key"
      return 0
  fi

  echo "Upload"
  echo ${UPLOADFILE}
  anaconda -t ${MY_UPLOAD_KEY} upload -u ${CONDA_USERNAME:-rapidsai} ${LABEL_OPTION} --force ${UPLOADFILE}
fi
