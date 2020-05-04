#!/bin/bash
set -e
set -x
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export VERS_API=arch-2020-alpha
export VERS_WORKER=arch-2020-alpha
export VERS_UI=1.5.1
export VERS_PIWIND=1.6.0
export VERS_WORKER_CONTROLLER=latest
GIT_UI=OasisUI
GIT_API=OasisPlatform
GIT_API_BRANCH=architecture-2020
GIT_PIWIND=OasisPiWind
GIT_WORKER_CONTROLLER=OasisWorkerController
GIT_WORKER_CONTROLLER_BRANCH=master


# ---  OASIS UI --- # 
if [ -d $SCRIPT_DIR/$GIT_UI ]; then
    cd $SCRIPT_DIR/$GIT_UI
    git stash
    git fetch && git checkout $VERS_UI
else
    mkdir -p $SCRIPT_DIR/$GIT_UI
    cd $SCRIPT_DIR/$GIT_UI
    git clone https://github.com/OasisLMF/$GIT_UI.git .
    git checkout $VERS_UI
fi 

# ---  OASIS API --- # 
if [ -d $SCRIPT_DIR/$GIT_API ]; then
    cd $SCRIPT_DIR/$GIT_API
    git stash
    git fetch && git checkout $GIT_API_BRANCH
else
    mkdir -p $SCRIPT_DIR/$GIT_API
    cd $SCRIPT_DIR/$GIT_API
    git clone https://github.com/OasisLMF/$GIT_API.git .
    git checkout $GIT_API_BRANCH
fi 

# ---  MODEL PiWind --- # 
if [ -d $SCRIPT_DIR/$GIT_PIWIND ]; then
    cd $SCRIPT_DIR/$GIT_PIWIND
    git stash
    git fetch && git checkout $VERS_PIWIND
else
    mkdir -p $SCRIPT_DIR/$GIT_PIWIND
    cd $SCRIPT_DIR/$GIT_PIWIND
    git clone https://github.com/OasisLMF/$GIT_PIWIND.git .
    git checkout $VERS_PIWIND
fi

# ---  OASIS Worker Controller --- #
if [ -d $SCRIPT_DIR/$GIT_WORKER_CONTROLLER ]; then
    cd $SCRIPT_DIR/$GIT_WORKER_CONTROLLER
    git stash
    git fetch && git checkout $GIT_WORKER_CONTROLLER_BRANCH
else
    mkdir -p $SCRIPT_DIR/$GIT_WORKER_CONTROLLER
    cd $SCRIPT_DIR/$GIT_WORKER_CONTROLLER
    git clone https://github.com/OasisLMF/$GIT_WORKER_CONTROLLER.git .
    git checkout $GIT_WORKER_CONTROLLER_BRANCH
fi


# setup and run API
cd $SCRIPT_DIR/$GIT_API
export OASIS_MODEL_DATA_DIR=$SCRIPT_DIR/$GIT_PIWIND
git checkout -- docker-compose.yml
sed -i "s|coreoasis/model_worker:latest|coreoasis/model_worker:${VERS_WORKER}|g" docker-compose.yml
sed -i "s|:latest|:${VERS_API}|g" docker-compose.yml

set +e
docker-compose down
docker-compose pull
set -e
docker-compose up -d --no-build worker-monitor channel-layer celery-beat task-controller server worker

# setup and run the worker controller
cd $SCRIPT_DIR/$GIT_WORKER_CONTROLLER
export OASIS_MODEL_DATA_DIR=$SCRIPT_DIR/$GIT_PIWIND
export OASIS_MEDIA_ROOT=$SCRIPT_DIR/$GIT_API/docker-shared-fs/
export OASIS_MODEL_WORKER_VERSION=$VERS_WORKER
git checkout -- docker-compose.yaml
sed -i "s|coreoasis/worker-controller:latest|coreoasis/worker-controller:${VERS_WORKER_CONTROLLER}|g" docker-compose.yaml

set +e
docker-compose down
#docker-compose pull
set -e
docker-compose up -d

# Run Oasis UI
cd $SCRIPT_DIR/$GIT_UI
git checkout -- docker-compose.yml
sed -i "s|:latest|:${VERS_UI}|g" docker-compose.yml
set +e
docker network create shiny-net
set -e
docker pull coreoasis/oasisui_app:$VERS_UI
docker-compose -f $SCRIPT_DIR/$GIT_UI/docker-compose.yml up -d
