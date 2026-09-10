// Caffeine mode
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

import qs.services

Singleton {
  id: root

  property list<string> wantedBy: []
  property bool isRunning: false

  onWantedByChanged: {
    root.isRunning = root.wantedBy.length !== 0;
  }

  onIsRunningChanged: {
    OsdService.showOsd(`Caffeine mode ${isRunning ? 'enabled' : 'disabled'}.`)
  }

  Process {
    running: root.isRunning
    command: ["sh", "-c", "systemd-inhibit --what=idle --who=caffeine-mode --why='Too much coffee' sleep inf"]
    stdout: StdioCollector {
      onStreamFinished: {
        if (root.isRunning) {
          console.error("Caffeine mode ended abruptly.");
          root.isRunning = false;
        }
      }
    }
  }

  function enableRequest(identity) {
    if (root.wantedBy.includes(identity)) return;
    root.wantedBy = [...root.wantedBy, identity];
  }

  function disableRequest(identity) {
    // force-stop if demanded explicitly by the user
    if (identity === "explicitUser") {
      root.wantedBy = [];
    }
    root.wantedBy = root.wantedBy.filter((i) => i !== identity);
  }
}
