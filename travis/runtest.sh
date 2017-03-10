#!/bin/bash

envs=$(declare -xp | grep 'export TRAVIS_')

docker exec $(cat /docker-name) bash -c "$envs; cd $PWD; exec bash $PWD/travis/docker_test.sh"
ret=$?
docker kill $(cat /docker-name)
exit $ret
