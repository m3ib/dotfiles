// A Right bar for all kind of system & state tools

import Quickshell
import QtQuick

import qs.components
import qs.services

ShellRoot {
  Variants {
    model: Quickshell.screens

    Sidebar {
      readonly property string dirPath: Quickshell.shellPath("modules/RightBar")

      required property var modelData

      anchors.right: true
      monitor: modelData
      sidebar: ShellState.rightBar
      sectionComponents: [`${dirPath}/SystemSection.qml`]
      sectionIcons: [""]
      rect.topLeftRadius: Config.size.rounding
      iconsRow.layoutDirection: Qt.RightToLeft
    }
  }
}
