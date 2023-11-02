import QtQuick 2.15

Loader {
    Component.onDestruction: sourceComponent = undefined
}
