#!/bin/bash

pactl load-module module-null-sink sink_name=my-share
pactl load-module module-null-sink sink_name=my-system

sleep 10

pw-link my-system:monitor_FL alsa_output.pci-0000_00_1f.3.analog-surround-40:playback_FL
pw-link my-system:monitor_FR alsa_output.pci-0000_00_1f.3.analog-surround-40:playback_FR
pw-link my-system:monitor_FL alsa_output.pci-0000_00_1f.3.analog-surround-40:playback_RL
pw-link my-system:monitor_FR alsa_output.pci-0000_00_1f.3.analog-surround-40:playback_RR

pw-link my-system:monitor_FL my-share:playback_FL
pw-link my-system:monitor_FR my-share:playback_FR


pactl load-module module-virtual-source source_name=my-mic master=alsa_input.pci-0000_00_1f.3.analog-stereo.capture

pw-link my-share:monitor_FL my-mic:playback_FL
pw-link my-share:monitor_FR my-mic:playback_FR

exit 0
