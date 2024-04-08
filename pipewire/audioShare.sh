#!/bin/bash

# capturing the my-share id
id=$(pw-cli list-objects | grep -B3 'node.name = "my-share"' | grep 'id' | awk '{print $2}' | tr -d ',=\n')

# your audio input, left and right
sound_driver_name=""

# creating the modules that we will use
pw-cli create-node adapter '{ factory.name=support.null-audio-sink node.name=my-bridge media.class=Audio/Sink object.linger=true audio.position=[FL FR] monitor.channel-volumes=true monitor.passthrough=true }'

pw-cli create-node adapter '{ factory.name=support.null-audio-sink node.name=my-share media.class=Audio/Sink object.linger=true audio.position=[FL FR] monitor.channel-volumes=true monitor.passthrough=true }'

pw-cli create-node adapter '{ factory.name=support.null-audio-sink node.name=my-system media.class=Audio/Sink object.linger=true audio.position=[FL FR] monitor.channel-volumes=true monitor.passthrough=true }'

# waiting 5 seconds for everything to happen
sleep 5

# linking the modules
pw-link my-system:monitor_FL $sound_driver_name:playback_FL
pw-link my-system:monitor_FR $sound_driver_name:playback_FR

pw-link my-system:monitor_FL my-share:playback_FL
pw-link my-system:monitor_FR my-share:playback_FR

# creating a virtual microphone
pw-loopback -m '[ FL FR]' --playback-props='media.class=Audio/Source node.name=my-source' -n my-mic &

# waiting 5 seconds for everything to happen
sleep 5

# linking the virtual microphone
pw-link my-share:monitor_FL my-mic:input_FL
pw-link my-share:monitor_FL my-mic:input_FR

# setting the volume of the audio share
pw-cli s $id Props '{ channelVolumes: [ 0.2, 0.2 ] }'

exit 0