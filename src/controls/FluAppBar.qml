import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Rectangle{

    property string title: ""
    property color textColor: FluTheme.dark ? "#FFFFFF" : "#000000"
    property bool showDark: false
    property bool showFps: false
    property var window: Window.window
    property color borerlessColor : FluTheme.dark ? FluTheme.primaryColor.lighter : FluTheme.primaryColor.dark
    property bool resizable: {
        if(window == null){
            return false
        }
        return !(window.minimumHeight === window.maximumHeight && window.maximumWidth === window.minimumWidth)
    }

    id:root
    color: Qt.rgba(0,0,0,0)
    visible: FluTheme.frameless
    height: visible ? 30 : 0
    width: {
        if(parent==null)
            return 200
        return parent.width
    }
    z: 65535

    TapHandler {
        onTapped: if (tapCount === 2) toggleMaximized()
        gesturePolicy: TapHandler.DragThreshold
    }

    DragHandler {
        target: null
        grabPermissions: TapHandler.CanTakeOverFromAnything
        onActiveChanged: if (active) { window.startSystemMove(); }
    }

    FluText {
        text: title
        anchors{
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 10
        }
        color:root.textColor
        fontStyle: FluText.Title
        font.pixelSize: 14
        font.bold: true
    }

    RowLayout{
        anchors.right: parent.right
        height: root.height
        spacing: 0

        TFpsMonitor{
            Layout.alignment: Qt.AlignVCenter
            Layout.rightMargin: 20
            Layout.topMargin: 5
            color:root.textColor
            visible: showFps
        }

        RowLayout{
            Layout.alignment: Qt.AlignVCenter
            Layout.rightMargin: 5
            visible: showDark
            spacing: 5
            FluText{
                text:"夜间模式"
                color:root.textColor
                fontStyle: FluText.Caption
            }
            FluToggleSwitch{
                selected: FluTheme.dark
                clickFunc:function(){
                    FluTheme.dark = !FluTheme.dark
                }
            }
        }

        FluIconButton{
            width: 40
            height: 30
            iconSource : FluentIcons.ChromeMinimize
            Layout.alignment: Qt.AlignVCenter
            iconSize: 11
            text:"最小化"
            radius: 0
            textColor: root.textColor
            color:{
                if(FluTheme.dark){
                    if(hovered){
                        return Qt.rgba(1,1,1,0.06)
                    }
                    return Qt.rgba(0,0,0,0)
                }else{
                    if(hovered){
                        return Qt.rgba(0,0,0,0.06)
                    }
                    return Qt.rgba(0,0,0,0)
                }
            }
            onClicked: {
                window.showMinimized()
            }
        }
        FluIconButton{
            width: 40
            height: 30
            property bool isRestore:{
                if(window == null)
                    return false
                return Window.Maximized === window.visibility
            }
            iconSource : isRestore  ? FluentIcons.ChromeRestore : FluentIcons.ChromeMaximize
            color:{
                if(FluTheme.dark){
                    if(hovered){
                        return Qt.rgba(1,1,1,0.06)
                    }
                    return Qt.rgba(0,0,0,0)
                }else{
                    if(hovered){
                        return Qt.rgba(0,0,0,0.06)
                    }
                    return Qt.rgba(0,0,0,0)
                }
            }
            Layout.alignment: Qt.AlignVCenter
            visible: resizable
            radius: 0
            textColor: root.textColor
            text:isRestore?"向下还原":"最大化"
            iconSize: 11
            onClicked: {
                toggleMaximized()
            }
        }
        FluIconButton{
            iconSource : FluentIcons.ChromeClose
            Layout.alignment: Qt.AlignVCenter
            text:"关闭"
            width: 40
            height: 30
            radius: 0
            iconSize: 10
            textColor: hovered ? Qt.rgba(1,1,1,1) : root.textColor
            color:hovered ? Qt.rgba(251/255,115/255,115/255,1) : "#00000000"
            onClicked: {
                Window.window.close()
            }
        }
    }

    function toggleMaximized() {
        if(!resizable)
            return
        if (window.visibility === Window.Maximized) {
            window.showNormal();
        } else {
            window.showMaximized();
        }
    }

}
