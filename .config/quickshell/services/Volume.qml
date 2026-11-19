import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import QtQuick
// Handles volume
pragma Singleton

Singleton {
    id: root

    PwObjectTracker {
        objects: [
            Pipewire.defaultAudioSink,
            Pipewire.defaultAudioSource
        ]
    }

    signal newData()

    property var defaulSink: Pipewire.defaultAudioSink
    property var defaulSource: Pipewire.defaultAudioSource
    property real volume: defaulSink?.audio?.volume
    property bool muted: defaulSink?.audio?.muted
    property bool micMuted: defaulSource?.audio?.muted

    function setVolume(value) {
        if (muted) defaulSink.audio.muted = false;
        root.defaulSink.audio.volume = Math.max(0, Math.min(value, 1.5))
        root.newData()
    }

    GlobalShortcut {
        appid: "volume"
        name: "increment"
        description: "Increment default sink's volume"
        onPressed: {
            setVolume(volume+0.05)
        }
    }

    GlobalShortcut {
        appid: "volume"
        name: "decrement"
        description: "Decrement default sink's volume"
        onPressed: {
            setVolume(volume-0.05)
        }
    }
}
