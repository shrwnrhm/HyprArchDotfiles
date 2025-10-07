#!/bin/bash

# TODO: check if code is ok

# Usage check
if [ $# -ne 2 ]; then
    echo "Usage: $0 VARIABLE_NAME VARIABLE_VALUE"
    exit 1
fi

VAR_NAME=$1
VAR_VALUE=$2
FILE="preferences.sh"

# Escape forward slashes in VAR_VALUE to safely use in sed
ESCAPED_VALUE=$(printf '%s\n' "$VAR_VALUE" | sed 's/[\/&]/\\&/g')

# Check if variable already exists in preferences.sh
if grep -q "^export $VAR_NAME=" "$FILE"; then
    # Variable exists: update its value
    sed -i "s/^export $VAR_NAME=.*/export $VAR_NAME=\"$ESCAPED_VALUE\"/" "$FILE"
    echo "Updated $VAR_NAME in $FILE to \"$VAR_VALUE\""
else
    # Variable doesn't exist: append new export line
    echo "export $VAR_NAME=\"$VAR_VALUE\"" >> "$FILE"
    echo "Added $VAR_NAME with value \"$VAR_VALUE\" to $FILE"
fi
