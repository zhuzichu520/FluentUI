import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import FluentUI

Rectangle{
    readonly property string displayText : d._displayText
    property bool disabled: false
    property int from: 0
    property int to: 99
    property var validator: IntValidator {
        bottom: Math.min(control.from, control.to)
        top: Math.max(control.from, control.to)
    }
    id:control
    implicitWidth: 200
    implicitHeight: 34
    radius: 4
    color: FluTheme.dark ? Qt.rgba(62/255,62/255,62/255,1) : Qt.rgba(1,1,1,1)
    border.width: 1
    border.color: FluTheme.dark ? Qt.rgba(76/255,76/255,76/255,1) : Qt.rgba(240/255,240/255,240/255,1)
    QtObject{
        id:d
        property string _displayText: "0"
    }
    Component{
        id:com_edit
        FluTextBox{
            rightPadding: 80
            iconRightMargin: 55
            disabled: control.disabled
            validator: control.validator
            text: d._displayText
            Component.onCompleted: {
                forceActiveFocus()
            }
            onCommit: {
                var number = Number(text)
                if(number>=control.from && number<=control.to){
                    d._displayText = String(number)
                }
                edit_loader.sourceComponent = null
            }
            onActiveFocusChanged: {
                if(!activeFocus){
                    edit_loader.sourceComponent = null
                }
            }
        }
    }
    FluTextBox{
        id:text_number
        anchors.fill: parent
        readOnly: true
        rightPadding: 80
        disabled: control.disabled
        text: control.displayText
        MouseArea{
            anchors.fill: parent
            onClicked: {
                edit_loader.sourceComponent = com_edit
            }
        }
    }
    Loader{
        id:edit_loader
        anchors.fill: parent
    }
    FluIconButton{
        id:btn_up
        width: 20
        height: 20
        iconSize: 16
        disabled: {
            if(control.disabled===true){
                return true
            }
            return Number(control.displayText) === control.to
        }
        iconSource: FluentIcons.ChevronUp
        anchors{
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: 30
        }
        onClicked: {
            d._displayText = String(Math.min(Number(d._displayText)+1,control.to))
        }
        MouseArea{
            anchors.fill: parent
            onReleased: {
                timer.stop()
            }
            TapHandler{
                onTapped: {
                    btn_up.clicked()
                }
                onCanceled: {
                    timer.stop()
                }
                onLongPressed: {
                    timer.isUp = true
                    timer.start()
                }
            }
        }
    }
    FluIconButton{
        id:btn_down
        iconSource: FluentIcons.ChevronDown
        width: 20
        height: 20
        disabled: {
            if(control.disabled === true){
                return true
            }
            return Number(control.displayText) === control.from
        }
        iconSize: 16
        anchors{
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: 5
        }
        onClicked: {
            d._displayText = String(Math.max(Number(d._displayText)-1,control.from))
        }
        MouseArea{
            anchors.fill: parent
            onReleased: {
                timer.stop()
            }
            TapHandler{
                onTapped: {
                    btn_down.clicked()
                }
                onCanceled: {
                    timer.stop()
                }
                onLongPressed: {
                    timer.isUp = false
                    timer.start()
                }
            }
        }
    }
    Timer{
        id:timer
        property bool isUp : true
        interval: 50
        repeat: true
        onTriggered: {
            if(isUp){
                btn_up.clicked()
            }else{
                btn_down.clicked()
            }
        }
    }
}
