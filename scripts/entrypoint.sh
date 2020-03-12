#!/bin/bash

# This is the entrypoint for production builds

set -e

./wait-for-it.sh -t 30 db:5432 # wait for db to start

bin/squadster eval "Squadster.Release.migrate"
exec "$@"
