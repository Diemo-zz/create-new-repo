#!/bin/bash
pytest_output=$( pytest -q | awk 'FNR==1' | grep F)

if ! [ -z "${pytest_output}" ]; then
  echo "HERE WE ARE"
  exit 1
fi

