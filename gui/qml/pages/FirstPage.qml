import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.dbus 2.0
import ".."

Page {
    id: root

    SilicaFlickable {
        id: flick
        anchors.fill: parent
        contentHeight: content.height
        interactive: contentHeight > height

        Image {
            id: patternBackground
            source: "../pattern.png"
            anchors.top: parent.top
            width: parent.width
            height: Math.max(flick.height, flick.contentHeight)
            fillMode: Image.Tile
            opacity: Theme.highlightBackgroundOpacity
            visible: appWindow.drunken
        }

        Column {
            id: content
            width: parent.width
            spacing: Theme.paddingSmall

            PageHeader {
                title: "Dalvik Timezone Updater"
            }

            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                x: Theme.horizontalPageMargin
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                horizontalAlignment: Text.AlignHCenter
                text: "Application for updating Alien Dalvik timezone data\nwritten by coderus in 0x7E0\nCool application icon wanted!\n\nJust click \"Update\" button below"
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: dalvikButton.hidden ? "Update" : "No hidden content in this button"
                onClicked: {
                    serviceIface.typedCall("updateTimezones", [], timezonesUpdatedCallback, timezonesUpdatedError)
                }
                onPressAndHold: {
                    dalvikButton.hidden = false
                }
            }

            Button {
                id: dalvikButton
                property bool hidden: true;
                anchors.horizontalCenter: parent.horizontalCenter
                text: appWindow.drunken ? "The Irish Rovers – Drunken Sailor" : "Restart Aliendalvik"
                visible: false
                onClicked: {
                    enabled = false
                    doneLabel.visible = false
                    if (alienDalvikState === "active") {
                        apkInterface.typedCall("controlService", [{ "type": "b", "value": false }])
                        alienDalvikStateChanged.connect(alienDalvikStop)
                    } else {
                        apkInterface.typedCall("controlService", [{ "type": "b", "value": true }])
                        alienDalvikStateChanged.connect(alienDalvikStart)
                    }
                }
                onPressAndHold: {
                    appWindow.drunken = !hidden
                }
            }

            Label {
                id: doneLabel
                width: parent.width - Theme.horizontalPageMargin * 2
                x: Theme.horizontalPageMargin
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                horizontalAlignment: Text.AlignHCenter
                visible: false
                text: "Done!"
            }

            Label {
                id: poem
                width: parent.width - Theme.horizontalPageMargin * 2
                x: Theme.horizontalPageMargin
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                horizontalAlignment: Text.AlignHCenter
                visible: appWindow.drunken
                text: "
What’ll we do with a drunken sailor,
What’ll we do with a drunken sailor,
What’ll we do with a drunken sailor,
Earl-aye in the morning?

Way hay and up she rises,
Way hay and up she rises,
Way hay and up she rises,
Earl-aye in the morning.

Shave his belly with a rusty razor,
Shave his belly with a rusty razor,
Shave his belly with a rusty razor,
Earl-aye in the morning.

Way hay and up she rises,
Way hay and up she rises,
Way hay and up she rises,
Earl-aye in the morning.

Put him in the long boat till he’s sober,
Put him in the long boat till he’s sober,
Put him in the long boat till he’s sober,
Earl-aye in the morning.

Way hay and up she rises,
Way hay and up she rises,
Way hay and up she rises,
Earl-aye in the morning.

Put him in the scuppers with a hawse pipe on him,
Put him in the scuppers with a hawse pipe on him,
Put him in the scuppers with a hawse pipe on him,
Earl-aye in the morning.

Way hay and up she rises,
Way hay and up she rises,
Way hay and up she rises,
Earl-aye in the morning.

Put him in bed with the captain’s daughter,
Put him in bed with the captain’s daughter,
Put him in bed with the captain’s daughter,
Earl-aye in the morning.

Way hay and up she rises,
Way hay and up she rises,
Way hay and up she rises,
Earl-aye in the morning.

That’s what we do with a drunken Sailor,
That’s what we do with a drunken Sailor,
That’s what we do with a drunken Sailor,
Earl-aye in the morning.
"
            }
        }

        VerticalScrollDecorator {}
    }

    function timezonesUpdatedCallback(ok) {
        dalvikButton.visible = ok
    }

    function timezonesUpdatedError() {
        console.log("### something went wrong")
    }

    function alienDalvikStop() {
        if (alienDalvikState === "inactive") {
            alienDalvikStateChanged.disconnect(alienDalvikStop)
            apkInterface.typedCall("controlService", [{ "type": "b", "value": true }])
            alienDalvikStateChanged.connect(alienDalvikStart)
        }
    }

    function alienDalvikStart() {
        if (alienDalvikState === "active") {
            alienDalvikStateChanged.disconnect(alienDalvikStart)
            dalvikButton.enabled = true
            doneLabel.visible = true
        }
    }

    DBusInterface {
        id: serviceIface

        bus: DBus.SessionBus
        service: "org.coderus.dalviktimezoneupdater"
        path: "/"
        iface: "org.coderus.dalviktimezoneupdater"
    }

    property string alienDalvikState

    DBusInterface {
        id: apkInterface

        bus: DBus.SystemBus
        service: "com.jolla.apkd"
        path: "/com/jolla/apkd"
        iface: "com.jolla.apkd"
    }

    DBusInterface {
        id: dalvikService

        bus: DBus.SystemBus
        service: "org.freedesktop.systemd1"
        iface: "org.freedesktop.systemd1.Unit"
        signalsEnabled: true

        function updateProperties() {
            if (path !== "") {
                alienDalvikState = dalvikService.getProperty("ActiveState")
            } else {
                alienDalvikState = "invalid"
            }
        }

        onPropertiesChanged: runningUpdateTimer.start()
        onPathChanged: updateProperties()
    }

    DBusInterface {
        id: manager

        bus: DBus.SystemBus
        service: "org.freedesktop.systemd1"
        path: "/org/freedesktop/systemd1"
        iface: "org.freedesktop.systemd1.Manager"
        signalsEnabled: true

        signal unitNew(string name)
        onUnitNew: {
            if (name == "aliendalvik.service") {
                pathUpdateTimer.start()
            }
        }

        signal unitRemoved(string name)
        onUnitRemoved: {
            if (name == "aliendalvik.service") {
                dalvikService.path = ""
                pathUpdateTimer.stop()
            }
        }

        Component.onCompleted: {
            updatePath()
        }

        function updatePath() {
            manager.typedCall("GetUnit", [{ "type": "s", "value": "aliendalvik.service"}], function(unit) {
                dalvikService.path = unit
            }, function() {
                dalvikService.path = ""
            })
        }
    }

    Timer {
        // starting and stopping can result in lots of property changes
        id: runningUpdateTimer
        interval: 100
        onTriggered: dalvikService.updateProperties()
    }

    Timer {
        // stopping service can result in unit appearing and disappering, for some reason.
        id: pathUpdateTimer
        interval: 100
        onTriggered: manager.updatePath()
    }
}
