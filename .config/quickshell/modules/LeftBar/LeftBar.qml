// A Left bar for all kind of miscellanous tools

import Quickshell
import QtQuick

import qs.components
import qs.services

ShellRoot {
  Variants {
    model: Quickshell.screens

    Sidebar {
      readonly property string dirPath: Quickshell.shellPath("modules/LeftBar")

      required property var modelData

      anchors.left: true
      monitor: modelData
      sidebar: ShellState.leftBar
      sectionComponents: [`${dirPath}/ClockSection.qml`, `${dirPath}/WallSection.qml`]
      sectionIcons: ["󰀠", "󰸉"]
      rect.topRightRadius: Config.size.rounding
    }
  }
}
