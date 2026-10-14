import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services

Item {
  id: root

  readonly property string wallPath: Config.path.wallpapers
  property ListModel wallsModel: ListModel{}

  anchors.fill: parent

  Process {
    id: proc

    running: true
    command: ["sh", "-c", `ls -1 ${root.wallPath}`]
    stdout: StdioCollector {
      onStreamFinished: {
        const walls = this.text.trim().split("\n")
        walls.forEach((wall) => {
          root.wallsModel.append({"wall": wall})
        })
      }
    }
  }

  ListView {
    id: listView

    anchors.fill: parent
    spacing: 16
    model: root.wallsModel
    delegate: Clickable {
      required property var modelData
      property string modelPath: `${root.wallPath}/${modelData}`

      width: listView.width
      height: wallImg.implicitHeight

      area.hoverEnabled: true
      area.onClicked: {
        Quickshell.execDetached(["sh", "-c", `${Config.path.scripts}/set-wall.sh ${modelPath}`])
      }

      Image {
        id: wallImg

        width: parent.width
        asynchronous: true
        source: `file://${modelPath}`
        sourceSize.width: parent.width
      }
    }
  }
}
