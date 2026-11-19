import Quickshell
import Quickshell.Networking
import QtQuick
import qs.services
// Network state
pragma Singleton

Singleton {
    property var device: Networking.devices.values[0]
    property var networks: device?.networks
    property var activeNetwork: networks?.values.find((nw) => nw.connected)

    property string nwName: activeNetwork?.name ?? ""
    property real nwSignal: (device?.type === DeviceType.Wifi) ? (activeNetwork?.signalStrength ?? 0) : 1

    Connections {
        function onNwNameChanged() {
            if (OsdService.initialStartup) {
                return;
            }
            if (nwName) {
                OsdService.showOsd(`Connected to ${nwName}.`)
                return;
            }
            OsdService.showOsd(`Disconnected.`)
        }
    }
}
