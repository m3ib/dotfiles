// The shell's bar
// Widgets are loaded in LeftSection, CenterSection, or RightSection

import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import qs.services

ShellRoot {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: root

      property var modelData

      screen: modelData
      WlrLayershell.layer: WlrLayer.Overlay

      anchors {
        top: true
        right: true
        left: true
      }

      implicitHeight: modelData.height // fullscreen

      color: "transparent"
      mask: Region {
        item: leftSection.visible ? leftSection.rect : nullRegion
        Region { item: centerSection.visible ? centerSection.rect : nullRegion }
        Region { item: rightSection.visible ? rightSection.rect : nullRegion }
      }
      exclusiveZone: Config.size.bar

      Item {
        id: nullRegion

        width: 0; height: 0
        x: 0; y: 0
      }

      Rectangle {
        id: rect

        anchors.top: parent.top
        width: parent.width
        height: Config.size.bar
        color: "transparent"

        RowLayout {
          anchors.fill: parent
          spacing: Config.spacing.barSection

          LeftSection {
            id: leftSection

            monitor: root.modelData

            Layout.fillWidth: true
            Layout.fillHeight: true
          }

          CenterSection {
            id: centerSection

            monitor: root.modelData

            Layout.fillHeight: true
          }

          RightSection {
            id: rightSection

            monitor: root.modelData

            Layout.fillWidth: true
            Layout.fillHeight: true
          }
        }
      }
    }
  }
}
