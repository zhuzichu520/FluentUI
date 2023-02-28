import QtQuick 2.15

Item {

    id:root

    anchors.fill: parent
    anchors.margins: -5
    property color shadowColor: "#333333"
    property int radius: 5
    property bool isShadow: true


    Rectangle{
        id:react_background
        width: root.width - 8
        height: root.height - 8
        anchors.centerIn: parent
        radius: root.radius
        color:"#00000000"
        opacity:  0.25
        border.width: 1
        border.color : Qt.lighter(shadowColor,1.1)
    }

    Rectangle{
        width: root.width - 6
        height: root.height - 6
        anchors.centerIn: parent
        radius: root.radius
        color:"#00000000"
        border.width: 1
        opacity:  0.2
        border.color : Qt.lighter(shadowColor,1.2)
    }

    Rectangle{
        width: root.width - 4
        height: root.height - 4
        anchors.centerIn: parent
        radius: root.radius
        color:"#00000000"
        border.width: 1
        opacity: 0.15
        border.color : Qt.lighter(shadowColor,1.3)
    }

    Rectangle{
        width: root.width - 2
        height: root.height - 2
        anchors.centerIn: parent
        radius: root.radius
        color:"#00000000"
        border.width: 1
        opacity: 0.1
        border.color : Qt.lighter(shadowColor,1.4)
    }

    Rectangle{
        width: root.width
        height: root.height
        anchors.centerIn: parent
        radius: root.radius
        color:"#00000000"
        border.width: 1
        opacity:0.05
        border.color : Qt.lighter(shadowColor,1.5)
    }


}
