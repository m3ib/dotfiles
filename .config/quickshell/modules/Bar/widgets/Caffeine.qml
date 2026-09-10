import QtQuick

import qs.components
import qs.services

Clickable {
  id: root

  readonly property string caffeineId: "explicitUser"

  implicitWidth: icon.width
  implicitHeight: icon.height

  area.onClicked: {
    if (!Caffeine.isRunning) {
      Caffeine.enableRequest(caffeineId);
    } else {
      Caffeine.disableRequest(caffeineId);
    }
  }

  Icon {
    id: icon

    anchors.centerIn: parent
    text: Caffeine.isRunning ? "󰅶" : "󰾪"
    color: Caffeine.isRunning ? Config.clr.fg : Config.clr.fgDrk
    anchors.verticalCenter: parent.verticalCenter

    Behavior on color {
      ColorAnimation { duration: Config.duration.animations; easing.type: Easing.InOutQuad }
    }
  }
}
