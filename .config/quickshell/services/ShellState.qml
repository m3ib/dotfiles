// Manages short-term state of the shell, e.g. Workspaces is open/closed, Bar is collapsed
pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick

Singleton {
  property var leftBar: QtObject {
    property list<string> activeMonitors: [];
  }
  property var rightBar: QtObject {
    property list<string> activeMonitors: [];
  }
  property var workspaces: QtObject {
    property bool show: false;
  }
  property var screenshot: QtObject {
    property bool show: false;
  }


  IpcHandler {
    target: "leftBar"

    function toggle(): void { toggleBar(leftBar) }
    function showAll(): void { showBarAll(leftBar) }
    function hideAll(): void { hideBarAll(leftBar) }
  }

  IpcHandler {
    target: "rightBar"

    function toggle(): void { toggleBar(rightBar) }
    function showAll(): void { showBarAll(rightBar) }
    function hideAll(): void { hideBarAll(rightBar) }
  }

  IpcHandler {
    target: "workspaces"

    function toggle(): void { ShellState.workspaces.show = !ShellState.workspaces.show }
    function show(): void { ShellState.workspaces.show = true }
    function hide(): void { ShellState.workspaces.show = false }
  }

  IpcHandler {
    target: "screenshot"

    function toggle(): void { ShellState.screenshot.show = !ShellState.screenshot.show }
  }

  /** Check whether the bar is shown on the given monitor or not.
   * @param {QtObject} bar The bar to operate on.
   * @param {String} mon The target monitor (default: the active monitor).
   * @return {Boolean}
   */
  function isBarShown(bar, mon) {
    const targetMon = mon || Hyprland.focusedMonitor?.name;

    return bar.activeMonitors.includes(targetMon);
  }

  /** Show the left bar on the given monitor.
   * @param {QtObject} bar The bar to operate on.
   * @param {String} mon The target monitor (default: the active monitor).
   */
  function showBar(bar, mon) {
    const targetMon = mon || Hyprland.focusedMonitor.name;

    if (isBarShown(bar, targetMon)) return;
    bar.activeMonitors = [...bar.activeMonitors, targetMon];
  }

  /** Show the bar on all monitors.
   * @param {QtObject} bar The bar to operate on.
   * */
  function showBarAll(bar) {
    Hyprland.monitors.values.forEach((mon) => {
      if (isBarShown(bar, mon?.name)) return;
      bar.activeMonitors = [...bar.activeMonitors, mon];
    })
  }

  /** Hide the left bar on the given monitor.
   * @param {QtObject} bar The bar to operate on.
   * @param {String} mon The target monitor (default: the active monitor).
   */
  function hideBar(bar, mon) {
    const targetMon = mon || Hyprland.focusedMonitor.name;
    bar.activeMonitors = bar.activeMonitors.filter((m) => m !== targetMon);
  }

  /** Hide the bar on all monitors.
   * @param {QtObject} bar The bar to operate on.
   * */
  function hideBarAll(bar) {
    bar.activeMonitors = [];
  }

  /** Toggle the bar on the given monitor.
   * @param {QtObject} bar The bar to operate on.
   * @param {String} mon The target monitor. (default: the active monitor)
   */
  function toggleBar(bar, mon) {
    if (isBarShown(bar, mon)) {
      hideBar(bar, mon);
      return;
    }

    showBar(bar, mon);
  }
}
