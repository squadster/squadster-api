#!/bin/bash

# Script for more convenient running dev server with soursing environment variables, the first arg is MIX_ENV
# To make it usable add 'alias srv="./scripts/dev_server.sh"' to any shell startup file

source .env

[ -z "$1" ] && environment=dev || environment=$1
echo "Starting server in $environment environment"
MIX_ENV=$environment iex --erl "-kernel shell_history enabled" -S mix phx.server
