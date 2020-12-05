#!/bin/bash

MIX_ENV=prod mix compile
MIX_ENV=prod mix release

echo $GITHUB_TOKEN | docker login -u $GITHUB_USER --password-stdin docker.pkg.github.com
docker build -t docker.pkg.github.com/squadster/squadster-api/release:$RELEASE_VERSION .
docker push docker.pkg.github.com/squadster/squadster-api/release:$RELEASE_VERSION
