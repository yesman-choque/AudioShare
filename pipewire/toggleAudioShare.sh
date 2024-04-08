#!/bin/bash

# Retrieves the ID and stores it in the 'id' variable
id=$(pw-cli list-objects | grep -B3 'node.name = "my-share"' | grep 'id' | awk '{print $2}' | tr -d ',=\n')

# Use the variable 'id' to get the current state of 'mute'
state=$(pw-cli enum-params $id 2 | grep -A 1 'mute' | tail -n 1 | awk '{print $2}')

# Checks 'mute' status and switches as needed
if [ "$state" = "false" ]; then
        pw-cli s $id Props '{mute:true}'
else
        pw-cli s $id Props '{mute:false}'
fi

