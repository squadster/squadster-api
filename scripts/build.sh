#!/bin/bash

MIX_ENV=prod mix compile
MIX_ENV=prod mix release

docker build . --tag squadster

# TODO: push to registry here
