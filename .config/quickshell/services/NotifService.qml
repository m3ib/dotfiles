import Quickshell
import Quickshell.Services.Notifications
import QtQuick
// Recieve and store notifications
pragma Singleton

Singleton {
    id: root

    property list<var> notifList: []
    property list<var> expiredNotifs: notifList.filter((n) => n.expired)
    property list<var> activeNotifs: notifList.filter((n) => !n.expired)

    property NotificationServer notifServer: NotificationServer {
        keepOnReload: false
        actionsSupported: true
        actionIconsSupported: true
        onNotification: (n) => {
            n.tracked = true
            let notif = notifComp.createObject(root, {
                notification: n
            })
            notifList = [notif, ...notifList]
        }
    }

    Component {
        id: notifComp

        QtObject {
            property date time: new Date()
            property bool expired: false

            property Notification notification
            property string notificationId
            property string summary
            property string body
            property string appIcon
            property string appName
            property string image
            property real expireTimeout
            property list<var> actions

            Component.onCompleted: {
                if (!notification) {
                    return;
                }

                notificationId = notification.id;
                summary = notification.summary;
                body = notification.body;
                appIcon = notification.appIcon;
                appName = notification.appName;
                image = notification.image;
                expireTimeout = notification.expireTimeout > 0 ? notification.expireTimeout : Config.duration.notif;
                actions = notification.actions.map(a => ({
                    identifier: a.identifier,
                    text: a.text,
                    invoke: () => a.invoke()
                }));
            }
        }
    }
}
