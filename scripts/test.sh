#!/bin/bash

echo "TESTS"
echo "TESTS"
echo "TESTS"
echo "TESTS"
echo "TESTS"
echo "TESTS"
echo "TESTS"
echo "TESTS"
echo "TESTS"
echo "TESTS"
echo "TESTS"
echo "TESTS"
echo "TESTS"
echo "TESTS"
echo "TESTS"
echo "TESTS"

MIX_ENV=test mix ecto.create
MIX_ENV=test mix ecto.migrate
MIX_ENV=test mix run priv/repo/seeds.exs

