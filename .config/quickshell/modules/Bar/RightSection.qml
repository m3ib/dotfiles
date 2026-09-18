// The bar's right section

import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services

import "widgets"

Item {
  id: root

  property alias rect: rect

  property var monitor

  property bool shouldShow: !Hypr.isFullscreenMonitor(monitor?.name) && row.children.length > 0

  visible: shouldShow

  Behavior on opacity {
    NumberAnimation { duration: Config.duration.animations }
  }

  onShouldShowChanged: {
    if (!shouldShow) {
      animTimer.running = true
    } else {
      root.visible = true
    }
    root.opacity = shouldShow ? 1 : 0
  }

  Timer {
    id: animTimer

    interval: Config.duration.animations
    onTriggered: {
      root.visible = root.shouldShow
    }
  }

  Corner {
    anchors.top: parent.top
    x: parent.width - rect.width - width
    angle: 180
  }

  Rectangle {
    id: rect

    anchors.right: parent.right
    width: row.implicitWidth + Config.spacing.barHPadding*2
    height: parent.height
    bottomLeftRadius: Config.size.rounding
    color: Config.clr.bg

    Behavior on width {
      NumberAnimation { duration: Config.duration.animations; easing.type: Easing.InOutQuad }
    }
  }

  RowLayout {
    id: row

    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    anchors.rightMargin: Config.spacing.barHPadding
    height: parent.height - Config.spacing.barVPadding*2
    layoutDirection: Qt.RightToLeft
    spacing: Config.spacing.barComp

    Battery {
      Layout.alignment: Qt.AlignVCenter
    }
    Network {
      Layout.alignment: Qt.AlignVCenter
    }
    Caffeine {
      Layout.alignment: Qt.AlignVCenter
    }
  }

  Corner {
    anchors.right: parent.right
    y: parent.height
    angle: 180
  }
}
