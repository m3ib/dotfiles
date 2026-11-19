import QtQuick
import Quickshell
// Store the current OSD message
pragma Singleton

Singleton {
    id: root

    property bool initialStartup: true

    signal textualOsd(string osdText)

    function showOsd(text) {
        root.textualOsd(text);
    }

    // small delay on startup so services don't call osd with initial data.
    // i.e., undefined -> value
    Timer {
        running: true
        interval: 50
        onTriggered: initialStartup = false
    }

}
