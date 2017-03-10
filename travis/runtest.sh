#!/bin/bash

envs=$(declare -xp | grep 'TRAVIS_')
sudo docker exec $(cat /docker-name) bash -c "$envs; cd $PWD; exec bash -e $PWD/travis/docker_test.sh"
ret=$?
sudo docker kill $(cat /docker-name)
exit $ret
