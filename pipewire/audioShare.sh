#!/bin/bash
id=$(pw-cli list-objects | grep -B3 'node.name = "my-share"' | grep 'id' | awk '{print $2}' | tr -d ',=\n')

pw-cli create-node adapter '{ factory.name=support.null-audio-sink node.name=my-bridge media.class=Audio/Sink object.linger=true audio.position=[FL FR] monitor.channel-volumes=true monitor.passthrough=true }'

pw-cli create-node adapter '{ factory.name=support.null-audio-sink node.name=my-share media.class=Audio/Sink object.linger=true audio.position=[FL FR] monitor.channel-volumes=true monitor.passthrough=true }'

pw-cli create-node adapter '{ factory.name=support.null-audio-sink node.name=my-system media.class=Audio/Sink object.linger=true audio.position=[FL FR] monitor.channel-volumes=true monitor.passthrough=true }'

sleep 5

pw-link my-system:monitor_FL alsa_output.pci-0000_00_1f.3.analog-stereo:playback_FL
pw-link my-system:monitor_FR alsa_output.pci-0000_00_1f.3.analog-stereo:playback_FR

pw-link alsa_input.pci-0000_00_1f.3.analog-stereo:capture_FL my-voice:playback_FL
pw-link alsa_input.pci-0000_00_1f.3.analog-stereo:capture_FR my-voice:playback_FR

pw-link my-system:monitor_FL my-share:playback_FL
pw-link my-system:monitor_FR my-share:playback_FR

pw-link my-share:monitor_FL my-bridge:playback_FL
pw-link my-share:monitor_FR my-bridge:playback_FR

pw-loopback -m '[ FL FR]' --playback-props='media.class=Audio/Source node.name=my-source' -n my-mic &

sleep 5

pw-link my-bridge:monitor_FL my-mic:input_FL
pw-link my-bridge:monitor_FL my-mic:input_FR

pw-cli s $id Props '{ channelVolumes: [ 0.2, 0.2 ] }'

exit 0


