// The bar's center section

import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services


Item {
  id: root

  property alias rect: rect

  property var monitor

  property bool shouldShow: !Hypr.isFullscreenMonitor(monitor?.name) && row.children.length > 0

  implicitWidth: rect.width
  visible: shouldShow

  /** Truncate a string if it's longer than len.
   * @param {String} str The string to truncate.
   * @param {Number} maxLen If longer than this, then it's truncated.
   * @return {String} A string that's maxLen long or less.
   */
     else {
      root.visible = true
     else {
      root.visible = true
     else {
      root.visible = true
  function truncate(str, maxLen) {
    if (str.length <= maxLen) {
      return str;
    }

    return str.substring(0, Math.floor(maxLen/2)) + "…" + str.substring(str.length - Math.floor(maxLen/2))
  }

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
    x: -width
    angle: 180
  }

  Rectangle {
    id: rect

    width: row.implicitWidth + Config.spacing.barHPadding*2
    height: parent.height
    bottomRightRadius: Config.size.rounding
    bottomLeftRadius: Config.size.rounding
    color: Config.clr.bg

    Behavior on width {
      NumberAnimation { duration: Config.duration.animations; easing.type: Easing.InOutQuad }
    }
  }

  RowLayout {
    id: row

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    anchors.leftMargin: Config.spacing.barHPadding
    height: parent.height - Config.spacing.barVPadding*2
    spacing: Config.spacing.barComp

    Text {
      text: truncate(Hyprland.activeToplevel.title, 48)
    }
  }

  Corner {
    anchors.top: parent.top
    x: rect.width
    angle: 90
  }
}
