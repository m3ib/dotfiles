import QtQuick

import qs.components
import qs.services

Item {
  id: root

  implicitWidth: rect.width
  implicitHeight: rect.height

  visible: Clock.focusing

  Rectangle {
    id: rect

    width: row.implicitWidth + 4*2
    height: row.implicitHeight
    anchors.fill: parent
    color: !Clock.pomo.paused ? Config.clr.primary : "transparent"
    radius: Config.size.rounding

    Behavior on color {
      ColorAnimation { duration: Config.duration.animations; easing.type: Easing.InOutQuad }
    }
  }

  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onClicked: (event) => {
      if (event.button === Qt.LeftButton) {
        Clock.togglePomo()
      } else if (event.button === Qt.RightButton) {
        Clock.endFocusSession()
      }
    }
  }

  Row {
    id: row

    anchors.centerIn: parent
    spacing: Config.spacing.icon

    Icon {
      id: icon

      text: Clock.pomo.mode === "FOCUS" ? "" : "󰒲"
      anchors.verticalCenter: parent.verticalCenter
    }

    Text {
      id: txt

      text: Clock.fmtDuration(Clock.pomo.timeLeft)
      anchors.verticalCenter: parent.verticalCenter
    }
  }
}
