#!/bin/bash

shopt -s extglob
find ~+ -type d -name '*-*-*-*-*' -exec sh -c 'if [[ "{}" != *"$(cat ~/.testenv/latest_stack_id)"* ]]; then rm -rf {};fi' \; &>/dev/null

