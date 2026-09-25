// An interface for taking screenshots using hyprshot.

import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services

ShellRoot {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: root

      required property var modelData

      property var savePaths: Object.freeze({
        CLIPBOARD: "--clipboard-only",
        DIR: `-o ${Config.path.screenshots}`,
      })
      property var targets: Object.freeze({
        WINDOW: "-m window",
        MONITOR: "-m output",
        REGION: "-m region",
        ACTIVE: "-m active"
      })
      property QtObject options: QtObject {
        property string saveTo: savePaths.CLIPBOARD
        property string target: targets.REGION
        property string active: ""
      }
      property string cmd: "hyprshot"

      screen: modelData
      exclusionMode: ExclusionMode.Ignore
      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
      anchors {
        top: true
        right: true
        bottom: true
        left: true
      }
      color: "transparent"
      focusable: true
      visible: ShellState.screenshot.show && (modelData.name == Hyprland.focusedMonitor.name)

      Item {
        focus: true
        Keys.onPressed: (event) => {
          if (event.modifiers) {
            if (event.modifiers & Qt.ShiftModifier) {
              root.options.saveTo = root.savePaths.DIR;
            }
            if (event.modifiers & Qt.ControlModifier) {
              root.options.active = root.options.active ? "" : root.targets.ACTIVE;
            }
          } else if ([Qt.Key_W, Qt.Key_M, Qt.Key_R].includes(event.key)) {
            root.options.saveTo = root.savePaths.CLIPBOARD;
          }
          switch (event.key) {
            case Qt.Key_Return:
              ShellState.screenshot.show = false;
              const freeze = root.options.active ? "" : "-z";
              const opts = `${freeze} ${root.options.saveTo} ${root.options.active} ${root.options.target}`;
              // slight delay until this panel fully hides
              Quickshell.execDetached(["sh", "-c", `sleep 0.2; ${root.cmd} ${opts}`]);
              event.accepted = true;
              break;
            case Qt.Key_Escape:
              ShellState.screenshot.show = false;
              event.accepted = true;
              break;
            case Qt.Key_W:
              root.options.target = root.targets.WINDOW;
              event.accepted = true;
              break;
            case Qt.Key_M:
              root.options.target = root.targets.MONITOR;
              event.accepted = true;
              break;
            case Qt.Key_R:
              root.options.target = root.targets.REGION;
              event.accepted = true;
              break;
            default:
              event.accepted = true; // capture all other keys
          }
        }
      }

      // overlay
      Rectangle {
        id: overlay

        anchors.fill: parent
        color: Config.clr.bg
        opacity: 0.8
      }

      ColumnLayout {
        id: main

        property int btnWidth: 124
        property int btnHeight: 82

        anchors.centerIn: parent
        spacing: Config.spacing.wsGrid

        Text {
          text: "Choose a target"
        }

        RowLayout {
          spacing: Config.spacing.wsGrid

          Button {
            Layout.preferredWidth: main.btnWidth
            Layout.preferredHeight: main.btnHeight
            area.hoverEnabled: true
            area.onClicked: {
              root.options.target = root.targets.MONITOR;
            }
            bg: (area.containsMouse || root.options.target === root.targets.MONITOR) ? Config.clr.primary : Config.clr.bgLt
            body.large: true
            body.text: "󰍹"
          }

          Button {
            Layout.preferredWidth: main.btnWidth
            Layout.preferredHeight: main.btnHeight
            area.hoverEnabled: true
            area.onClicked: {
              root.options.target = root.targets.WINDOW;
            }
            bg: (area.containsMouse || root.options.target === root.targets.WINDOW) ? Config.clr.primary : Config.clr.bgLt
            body.large: true
            body.text: ""
          }

          Button {
            Layout.preferredWidth: main.btnWidth
            Layout.preferredHeight: main.btnHeight
            area.hoverEnabled: true
            area.onClicked: {
              root.options.target = root.targets.REGION;
            }
            bg: (area.containsMouse || root.options.target === root.targets.REGION) ? Config.clr.primary : Config.clr.bgLt
            body.large: true
            body.text: "󰒉"
          }
        }

        Text {
          text: "Auto capture the active output"
        }

        Button {
          Layout.preferredWidth: main.btnWidth
          Layout.preferredHeight: main.btnHeight
          area.hoverEnabled: true
          area.onClicked: {
            if (root.options.active) {
              root.options.active = "";
            } else {
              root.options.active = root.targets.ACTIVE;
            }
          }
          bg: (area.containsMouse || root.options.active) ? Config.clr.primary : Config.clr.bgLt
          body.large: true
          body.text: ""
        }

        Text {
          text: "Choose where to save"
        }

        RowLayout {
          spacing: Config.spacing.wsGrid

          Button {
            Layout.preferredWidth: main.btnWidth
            Layout.preferredHeight: main.btnHeight
            area.hoverEnabled: true
            area.onClicked: {
              root.options.saveTo = root.savePaths.CLIPBOARD;
            }
            bg: (area.containsMouse || root.options.saveTo === root.savePaths.CLIPBOARD) ? Config.clr.primary : Config.clr.bgLt
            body.large: true
            body.text: ""
          }

          Button {
            Layout.preferredWidth: main.btnWidth
            Layout.preferredHeight: main.btnHeight
            area.hoverEnabled: true
            area.onClicked: {
              root.options.saveTo = root.savePaths.DIR;
            }
            bg: (area.containsMouse || root.options.saveTo === root.savePaths.DIR) ? Config.clr.primary : Config.clr.bgLt
            body.large: true
            body.text: "󰉋"
          }
        }
      }
    }
  }
}
