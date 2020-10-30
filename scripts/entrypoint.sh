#!/bin/bash

# This is the entrypoint for production builds

set -e

bin/squadster eval "Squadster.Release.migrate"

exec "$@"
