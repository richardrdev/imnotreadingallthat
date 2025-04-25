#!/bin/bash

./container-build.sh
exit_code=$?

if [[ $exit_code -ne 0 ]]; then
    echo "Build failed! Not running the container."
    exit $exit_code
fi

echo "Build successful! Starting the container..."
./container-run.sh
