// A base component for left & right bars.

import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services

PanelWindow {
  id: root

  property var monitor
  property var sidebar // a ShellState.leftBar or a ShellState.rightBar

  property alias rect: rect
  property alias iconsRow: iconsRow

  property list<string> sectionComponents: []
  property list<string> sectionIcons: []
  property int activeSection: 0

  screen: monitor
  WlrLayershell.layer: WlrLayer.Overlay
  focusable: true

  anchors {
    top: true
    bottom: true
  }

  implicitWidth: monitor.width * 0.2

  color: "transparent"
  mask: Region { item: rect }
  visible: ShellState.isBarShown(sidebar, monitor?.name)

  Connections {
    target: sidebar

    function onActiveMonitorsChanged() {
      root.visible = ShellState.isBarShown(sidebar, monitor?.name);
    }
  }

  Item {
    focus: true
    Keys.onPressed: (event) => {
      switch (event.key) {
        case Qt.Key_Escape:
        ShellState.hideBar(sidebar, monitor?.name);
        event.accepted = true;
        break;
      }
    }
  }

  Rectangle {
    id: rect

    anchors.fill: parent
    color: Config.clr.bg

    ColumnLayout {
      anchors.fill: parent

      Item {
        Layout.fillWidth: true
        Layout.fillHeight: true

        Loader {
          id: loader

          source: root.sectionComponents[root.activeSection]
          anchors.fill: parent
          anchors.margins: Config.spacing.sidebarPadding
        }
      }

      Item {
        Layout.fillWidth: true
        height: 48

        Rectangle {
          anchors.fill: parent
          color: Config.clr.bg
        }

        Column {
          anchors.fill: parent

          Rectangle {
            width: parent.width
            height: Config.size.borderWidth
            color: Config.clr.bgLt
            bottomRightRadius: Config.size.rounding
          }

          Row {
            id: iconsRow

            height: parent.height - 4*2
            width: parent.width
            spacing: 4

            Repeater {
              model: root.sectionComponents.length
              delegate: Clickable {
                required property var modelData

                height: parent.height
                width: 32

                Rectangle {
                  anchors.fill: parent
                  color: "transparent"
                }

                area.hoverEnabled: true
                area.onClicked: {
                  root.activeSection = modelData
                }

                Icon {
                  anchors.centerIn: parent
                  text: root.sectionIcons[modelData]
                  color: (area.containsMouse || modelData === root.activeSection) ? Config.clr.fg : Config.clr.bgLt
                }
              }
            }
          }
        }
      }
    }
  }
}
