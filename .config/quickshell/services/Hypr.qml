import Quickshell
import Quickshell.Hyprland
import QtQuick
// Hyprland functions
pragma Singleton

Singleton {
    /** Lookup a system icon or a desktop entry icon.
     * @param {String} icon The icon to look for.
     * @return {String} The icon path.
     */
    function getIcon(icon) {
        return Quickshell.iconPath(icon, DesktopEntries.heuristicLookup(icon)?.icon);
    }

    /** Check if the given monitor is the focused one.
     * @param {String} mon The monitor's name.
     * @return {Boolean} true if focused otherwise false.
     */
    function isFocusedMonitor(mon) {
        return mon === Hyprland.focusedMonitor?.name;
    }

    /** Check if the given monitor has a fullscreened window.
     * @param {String} mon The monitor's name.
     * @return {Boolean} true if it has a fullscreen window otherwise false.
     */
    function isFullscreenMonitor(mon) {
        const m = Hyprland.monitors.values.find((m) => m?.name === mon);
        if (!m) return false;

        return m?.activeWorkspace?.hasFullscreen
    }
}
