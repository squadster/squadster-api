#!/bin/bash

MIX_ENV=prod mix release
MIX_ENV=prod mix ecto.create
MIX_ENV=prod mix ecto.migrate
