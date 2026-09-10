import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import qs.components
import qs.services

import "./widgets/"

Item {
  id: root

  anchors.fill: parent

  ColumnLayout {
    anchors.fill: parent
    spacing: 24

    Column {
      Layout.alignment: Qt.AlignHCenter

      Text {
        anchors.horizontalCenter: parent.horizontalCenter
        text: Clock.fmtTime("hh:mm:ss")
        font.pixelSize: Config.fontSize.heading
      }

      Text {
        anchors.horizontalCenter: parent.horizontalCenter
        text: Clock.fmtTime(`ddd, MMM d'${Clock.ordinalSuffix(Number(Clock.fmtTime('dd')))}' M/yy`)
        color: Config.clr.fgDrk
        font.weight: Config.fontWeight.light
      }
    }

    Column {
      id: pomoSection

      Layout.fillWidth: true
      spacing: 12
      visible: Clock.focusing

      Rectangle {
        width: parent.width
        height: pomoContainer.height + 8*2
        color: Config.clr.bgLt
        radius: Config.size.rounding

        ColumnLayout {
          id: pomoContainer

          anchors.centerIn: parent
          width: parent.width - 8*2
          spacing: 12

          Text {
            Layout.alignment: Qt.AlignHCenter
            text: Clock.pomo.mode === "FOCUS" ? `${Clock.getPomoTitleCase()} (${Clock.pomoSessions})` : Clock.getPomoTitleCase()
            color: Config.clr.primaryLt
          }

          Text {
            Layout.alignment: Qt.AlignHCenter
            text: Clock.fmtDuration(Clock.pomo.timeLeft)
            font.pixelSize: Config.fontSize.heading
          }

          Text {
            Layout.alignment: Qt.AlignHCenter
            visible: Clock.pomo.mode === "FOCUS"
            text: `${Clock.getPomoTitleCase(Clock.getNextPomo())} Next.`
            color: Config.clr.fgDrk
            font.weight: Config.fontWeight.light
          }

        }
      }

      RowLayout {
        width: parent.width
        spacing: 4

        Button {
          Layout.fillWidth: true
          height: body.height + 8*2
          area.onClicked: Clock.resetPomoTimer()

          bg: Config.clr.bgLt
          body.text: "󰦛"
        }

        Button {
          Layout.fillWidth: true
          height: body.height + 8*2
          area.onClicked: Clock.togglePomo()

          bg: Config.clr.bgLt
          body.text: Clock.pomo.paused ? "" :  ""
        }

        Button {
          Layout.fillWidth: true
          height: body.height + 8*2
          area.onClicked: Clock.nextPomoMode()

          bg: Config.clr.bgLt
          body.text: "󰒭"
        }
      }

      Button {
        width: parent.width
        height: body.height + 8*2
        area.onClicked: Clock.endFocusSession()

        bg: Config.clr.bgLt
        body.text: "End Focus"
      }
    }

    Column {
      Layout.fillWidth: true
      spacing: 12
      visible: !Clock.focusing

      Text {
        text: "Set up"
        color: Config.clr.primaryLt
        font.pixelSize: Config.fontSize.small
      }

      Text {
        text: `${Clock.fmtHumanDuration(Clock.todayFocusTimeMsec)} Focused Today.`
      }

      Button {
        width: parent.width
        height: body.height + 8*2
        area.onClicked: Clock.startFocusSession()

        body.text: "Focus"
      }

      Rectangle {
        width: parent.width
        height: stopwatchContainer.height + 8*2
        color: Config.clr.bgLt
        radius: Config.size.rounding

        ColumnLayout {
          id: stopwatchContainer

          anchors.centerIn: parent
          width: parent.width - 8*2
          spacing: 4

          Text {
            Layout.alignment: Qt.AlignHCenter
            text: "Stopwatch"
            color: Config.clr.fgDrk
            font.weight: Config.fontWeight.light
          }

          Text {
            Layout.alignment: Qt.AlignHCenter
            text: Clock.fmtDuration(Clock.stopwatch)
            font.pixelSize: Config.fontSize.heading
          }

          Row {
            Layout.alignment: Qt.AlignHCenter
            spacing: 4

            Button {
              visible: !Clock.stopwatchRunning && Clock.stopwatch !== 0
              area.onClicked: Clock.resetStopwatch()
              bg: Config.clr.bg
              body.text: "󰑓"
            }

            Button {
              area.onClicked: Clock.toggleStopwatch()
              body.text: Clock.stopwatchRunning ? "" : ""
            }
          }
        }
      }

      Rectangle {
        width: parent.width
        height: timerContainer.height + 8*2
        color: Config.clr.bgLt
        radius: Config.size.rounding

        ColumnLayout {
          id: timerContainer

          anchors.centerIn: parent
          width: parent.width - 8*2
          spacing: 4

          Text {
            Layout.alignment: Qt.AlignHCenter
            text: "Timer"
            color: Config.clr.fgDrk
            font.weight: Config.fontWeight.light
          }

          CTextField {
            id: timerTitleField

            Layout.alignment: Qt.AlignHCenter
            placeholderText: "Eggs"
          }

          CTextField {
            id: timerDurationField

            Layout.alignment: Qt.AlignHCenter
            placeholderText: "8m 30s"

            onAccepted: {
              Clock.createTimer(timerTitleField.text, Clock.parseDuration(timerDurationField.text))
              timerTitleField.text = "";
              timerDurationField.text = "";
            }
          }
        }
      }
    }

    ColumnLayout {
      Layout.fillWidth: true
      spacing: 8
      visible: !Clock.focusing

      Text {
        text: "Ongoing"
        color: Config.clr.primaryLt
        font.pixelSize: Config.fontSize.small
      }

      Column {
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: 8

        Repeater {
          model: Clock.timersModel
          delegate: Rectangle {
            required property var modelData
            property bool isTimerPositive: modelData.timeLeft >= 0

            width: parent.width
            height: ongoingTimerCol.height + 16*2
            color: Config.clr.bgLt
            radius: Config.size.rounding

            ColumnLayout {
              id: ongoingTimerCol
              anchors.centerIn: parent
              width: parent.width - 8*2
              spacing: 4

              Text {
                Layout.alignment: Qt.AlignHCenter
                text: modelData.title
                color: Config.clr.fgDrk
                font.weight: Config.fontWeight.light
              }

              Text {
                Layout.alignment: Qt.AlignHCenter
                text: (isTimerPositive ? "" : "-") + Clock.fmtDuration(modelData.timeLeft)
                color: isTimerPositive ? Config.clr.fg : Config.clr.danger
                font.pixelSize: Config.fontSize.heading
              }

              Row {
                Layout.alignment: Qt.AlignHCenter
                spacing: 4

                Button {
                  visible: !modelData.running

                  bg: Config.clr.bg
                  area.onClicked: Clock.resetTimer(modelData.id)
                  body.text: "󰑓"
                }

                Button {
                  area.onClicked: Clock.toggleTimer(modelData.id)
                  body.text: modelData.running ? "" : ""
                }

                Button {
                  visible: !modelData.running

                  bg: Config.clr.bg
                  area.onClicked: Clock.removeTimer(modelData.id)
                  body.text: ""
                }
              }
            }
          }
        }
      }
    }

    Item {
      Layout.fillWidth: true
      Layout.fillHeight: true
    }
  }
}
