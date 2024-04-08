#!/bin/bash

# use the name of your sound driver name
sound_driver_output_name=""
sound_driver_input_name=""

pactl load-module module-null-sink sink_name=my-share
pactl load-module module-null-sink sink_name=my-system

sleep 10

pw-link my-system:monitor_FL "$sound_driver_output_name":playback_FL
pw-link my-system:monitor_FR "$sound_driver_output_name":playback_FR

pw-link my-system:monitor_FL my-share:playback_FL
pw-link my-system:monitor_FR my-share:playback_FR

pactl load-module module-virtual-source source_name=my-mic master="$sound_driver_input_name".capture

pw-link my-share:monitor_FL my-mic:playback_FL
pw-link my-share:monitor_FR my-mic:playback_FR

exit 0
