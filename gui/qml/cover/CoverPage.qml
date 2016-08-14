import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Image {
        id: patternBackground
        source: "../pattern.png"
        anchors.fill: parent
        fillMode: Image.Tile
        opacity: Theme.highlightBackgroundOpacity
        visible: appWindow.drunken
    }
    Column {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        spacing: Theme.paddingLarge

        Label {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: "Dalvik Timezone Updater"
        }
        Label {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            visible: appWindow.drunken
            font.pixelSize: Theme.fontSizeTiny
            text: "Way hay and up she rises,
Way hay and up she rises,
Way hay and up she rises,
Earl-aye in the morning."
        }
    }
}


