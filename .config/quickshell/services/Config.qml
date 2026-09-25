// Long-term static data used by the shell
pragma Singleton

import Quickshell
import QtQuick

Singleton {
  readonly property var clr: QtObject {
    readonly property color primary: "#6666EE";
    readonly property color primaryLt: "#8C8CF1";
    readonly property color bg: "#13181E";
    readonly property color bgLt: "#28323F";
    readonly property color fg: "#F2F2F2";
    readonly property color fgDrk: "#B2B2B2";
    readonly property color danger: "#EC6990";
    readonly property color success: "#69EC90";
  }

  readonly property var fontFamily: QtObject {
    readonly property string text: "Noto Sans";
    readonly property string icon: "FiraCode Nerd Font";
  }

  readonly property var fontSize: QtObject {
    // in pixels
    readonly property real small: 12;
    readonly property real text: 14;
    readonly property real heading: 18;
    readonly property real icon: 16;
    readonly property real iconL: 24;
  }

  readonly property var fontWeight: QtObject {
    readonly property real light: 500;
    readonly property real normal: 700;
    readonly property real bold: 900;
  }

  readonly property var size: QtObject {
    // Global
    readonly property real rounding: 10;
    readonly property real borderWidth: 2;
    readonly property real button: 28;

    readonly property real bar: 32;
    readonly property real notifWidth: 300;
  }

  readonly property var spacing: QtObject {
    // Global
    readonly property real icon: 4; // icon-text gap
    readonly property real labelHPadding: 12;
    readonly property real labelVPadding: 8;

    // Bar module
    // hierarchy: bar>section>component
    readonly property real barSection: 20; // section spacing
    readonly property real barComp: 16; // component spacing
    readonly property real barHPadding: 12; // horizontal padding
    readonly property real barVPadding: 4; // vertical padding

    // LeftBar module
    readonly property real leftBarPadding: 12

    // Workspaces module
    readonly property real wsGrid: 8; // spacing between each workspace

    // Osd module
    readonly property real osdScreenGap: 48;
    readonly property real osdHPadding: 16;
    readonly property real osdVPadding: 12;
    readonly property real progressOsdPadding: 4;

    // Notifs module
    property real notifScreenGap: 2;
    property real notif: 2;
    property real notifHPadding: 16;
    property real notifVPadding: 12;
  }

  readonly property var duration: QtObject {
    // in milliseconds
    readonly property real animations: 150;
    readonly property real osd: 3000;
  }

  readonly property var pomo: QtObject {
    readonly property int sessionsBeforeLongBreak: 4;
    readonly property real focus: 50*60000;
    readonly property real shortBreak: 10*60000;
    readonly property real longBreak: 20*60000;
  }

  readonly property var path: QtObject {
    readonly property string home: Quickshell.env("HOME")
    readonly property string pictures: Quickshell.execDetached(["sh", "-c", ". ~/.config/user-dirs.dirs; echo $XDG_PICTURES_DIR"]) || `${home}/pics`
    readonly property string scripts: `${home}/.config/hypr/scripts`
    readonly property string wallpapers: `${home}/.walls`
    readonly property string data: `${home}/.local/share/quickshell`
    readonly property string screenshots: `${pictures}/screenshots`
  }
}
