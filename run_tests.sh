#!/bin/bash

# enable !! command completion
set -o history -o histexpand


pytest_output=$( pytest -q | awk 'FNR==1' | grep F)

if ! [ -z "${pytest_output}" ]; then
  echo "Unable to commit - tests failed!"
  exit 1
fi

