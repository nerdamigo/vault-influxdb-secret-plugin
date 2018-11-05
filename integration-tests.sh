#!/bin/sh

set -e

docker build -t integration -f ./test/integration/Dockerfile ./src

echo ===================================
cat ./test/integration/run-tests.sh | docker run -i --rm integration
echo "Exited: $? <-------- FIXME SHOULD BE EXIT CODE FROM run-tests.sh"
echo ===================================