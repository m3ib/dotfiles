import QtQuick

import qs.components
import qs.services

Clickable {
  id: root

  property alias body: iconText

  property color bg: Config.clr.primary

  width: Config.size.button
  height: Config.size.button

  Rectangle {
    id: rect

    anchors.fill: parent
    color: root.bg
    radius: Config.size.rounding
  }

  Icon {
    id: iconText

    anchors.centerIn: parent
    text: ""

    Behavior on color {
      ColorAnimation { duration: Config.duration.animations; easing.type: Easing.InOutQuad }
    }
  }
}
