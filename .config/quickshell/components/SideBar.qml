// A base component for left & right bars.

import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services

PanelWindow {
  id: root

  property var modelData

  property var sidebar // to be filled later

  property list<string> sectionComponents: []
  property list<string> sectionIcons: []
  property real activeSection: 0

  screen: modelData
  WlrLayershell.layer: WlrLayer.Overlay
  focusable: true

  anchors {
    top: true
    bottom: true
  }

  implicitWidth: modelData.width * 0.2

  color: "transparent"
  mask: Region { item: rect }
  visible: ShellState.isBarShown(modelData?.name, sidebar)

  Connections {
    target: sidebar

    function onActiveMonitorsChanged() {
      root.visible = ShellState.isBarShown(modelData?.name, sidebar);
    }
  }

  Item {
    focus: true
    Keys.onPressed: (event) => {
      switch (event.key) {
        case Qt.Key_Escape:
        ShellState.hide(modelData?.name, sidebar);
        event.accepted = true;
        break;
      }
    }
  }

  Rectangle {
    id: rect

    anchors.fill: parent
    color: Config.clr.bg
    topRightRadius: Config.size.rounding
    bottomRightRadius: Config.size.rounding

    ColumnLayout {
      anchors.fill: parent

      Item {
        Layout.fillWidth: true
        Layout.fillHeight: true

        Loader {
          id: loader

          source: root.sectionComponents[root.activeSection]
          anchors.fill: parent
          anchors.margins: Config.spacing.leftBarPadding
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
