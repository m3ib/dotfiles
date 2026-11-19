import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import qs.components
// Handles brightness
pragma Singleton

Singleton {
    id: root

    property real percentage
    property string theme: "" // one of: "light" or "dark"

    signal newData()

    /** Set the built-in monitors brightness to the given value.
     * @param {Number} value Brightness percentage.
     */
    function setBrightness(value) {
        root.percentage = Math.max(0, Math.min(value, 100));
        setProc.running = true;
        root.newData();
    }

    /** Set gsettings color-scheme to the given value.
     * @param {String} theme The target theme ("light" or "dark").
     */
    function setTheme(theme) {
        gsettingsWriteProc.targetTheme = theme;
        gsettingsWriteProc.running = true;
    }

    /** Return gsettings color-scheme value.
     * @return {String} "light" or "dark".
     */
    function getTheme() {
        gsettingsReadProc.running = true;
        return root.theme;
    }

    Process {
        id: initProc

        running: true
        command: ["sh", "-c", "brightnessctl -m"]

        stdout: StdioCollector {
            onStreamFinished: {
                let readPercentage = text.split(",")[3];
                readPercentage = readPercentage.substring(0, readPercentage.length - 1); // remove the "%"
                root.percentage = readPercentage;
            }
        }

    }

    Process {
        id: setProc

        command: ["brightnessctl", "set", `${root.percentage}%`]

        stderr: StdioCollector {
            onStreamFinished: {
                if (text)
                    console.error(`Set brightness command failed. See below:\n>> ${text.trim()}\n>> Command Ran: ${setProc.command}`);

            }
        }

    }

    Process {
        id: gsettingsReadProc

        command: ["gsettings", "get", "org.gnome.desktop.interface", "color-scheme"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.theme = text.split("-")[-1];
            }
        }

        stderr: StdioCollector {
            onStreamFinished: {
                if (text)
                    console.error(`Get theme command failed. See below:\n>> ${text.trim()}\n>> Command Ran: ${gsettingsReadProc.command}`);

            }
        }

    }

    Process {
        id: gsettingsWriteProc

        property string targetTheme: "light"

        command: ["gsettings", "set", "org.gnome.desktop.interface", "color-scheme", `prefer-${targetTheme}`]

        stdout: StdioCollector {
            onStreamFinished: {
                root.theme = gsettingsWriteProc.targetTheme;
            }
        }

        stderr: StdioCollector {
            onStreamFinished: {
                if (text)
                    console.error(`Set theme command failed. See below:\n>> ${text.trim()}\n>> Command Ran: ${gsettingsWriteProc.command}`);

            }
        }

    }

    GlobalShortcut {
        appid: "brightness"
        name: "increment"
        description: "Increment built-in monitor's brightness"
        onPressed: {
            setBrightness(percentage + 4);
        }
    }

    GlobalShortcut {
        appid: "brightness"
        name: "decrement"
        description: "Decrement built-in monitor's brightness"
        onPressed: {
            setBrightness(percentage - 4);
        }
    }

}
