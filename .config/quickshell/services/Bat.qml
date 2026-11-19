import QtQuick
import Quickshell
import Quickshell.Services.UPower
import qs.services
// Battery state
pragma Singleton

Singleton {
    property var device: UPower.displayDevice
    property bool full: device.state == UPowerDeviceState.FullyCharged
    property bool charging: device.state == UPowerDeviceState.Charging
    property real percentage: Math.round(device.percentage * 100)
    property real timeRemaining: charging ? device.timeToFull : device.timeToEmpty

    onFullChanged: {
        if (OsdService.initialStartup || !full)
            return ;

        OsdService.showOsd(`Battery charged 100%.`);
    }
    onChargingChanged: {
        if (OsdService.initialStartup)
            return ;

        OsdService.showOsd(`Battery ${charging ? 'charging' : 'discharging'}.`);
    }
}
