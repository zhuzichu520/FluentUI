import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Rectangle{

    id:root

    property color borerlessColor : FluTheme.isDark ? FluTheme.primaryColor.lighter : FluTheme.primaryColor.dark
    color: {
        if(Window.window == null)
            return borerlessColor
        return Window.window.active ? borerlessColor : Qt.lighter(borerlessColor,1.1)
    }
    visible: FluTheme.isFrameless
    height: visible ? 34 : 0

    width: {
        if(parent==null)
            return 200
        return parent.width
    }
    z: 65535
    clip: true
    property string title: "标题"
    property color textColor: FluTheme.isDark ? "#000000" : "#FFFFFF"
    property bool showDark: false
    property bool showFps: false

    property var window: Window.window

    property bool resizable: {
        if(window == null){
            return false
        }
        return !(window.minimumHeight === window.maximumHeight && window.maximumWidth === window.minimumWidth)
    }

    TapHandler {
        onTapped: if (tapCount === 2) toggleMaximized()
        gesturePolicy: TapHandler.DragThreshold
    }

    DragHandler {
        target: null
        grabPermissions: TapHandler.CanTakeOverFromAnything
        onActiveChanged: if (active) { window.startSystemMove(); }
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
        height: 30
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
            Layout.rightMargin: 14
            visible: showDark
            spacing: 5
            FluText{
                text:"夜间模式"
                color:root.textColor
                fontStyle: FluText.Body
            }
            FluToggleSwitch{
                selected: FluTheme.isDark
                clickFunc:function(){
                    FluTheme.isDark = !FluTheme.isDark
                }
            }
        }

        FluIconButton{
            iconSource : FluentIcons.ChromeMinimizeContrast
            Layout.alignment: Qt.AlignVCenter
            iconSize: 15
            text:"最小化"
            textColor: root.textColor
            color:hovered ? "#20000000" : "#00000000"
            onClicked: {
                window.showMinimized()
            }
        }
        FluIconButton{
            property bool isRestore:{
                if(window == null)
                    return false
                return Window.Maximized === window.visibility
            }
            iconSource : isRestore  ? FluentIcons.ChromeRestoreContrast : FluentIcons.ChromeMaximizeContrast
            color:hovered ? "#20000000" : "#00000000"
            Layout.alignment: Qt.AlignVCenter
            visible: resizable
            textColor: root.textColor
            text:isRestore?"向下还原":"最大化"
            iconSize: 15
            onClicked: {
                toggleMaximized()
            }
        }
        FluIconButton{
            iconSource : FluentIcons.ChromeCloseContrast
            Layout.alignment: Qt.AlignVCenter
            text:"关闭"
            iconSize: 13
            textColor: root.textColor
            color:hovered ? "#20000000" : "#00000000"
            onClicked: {
                Window.window.close()
            }
        }
    }

    FluDivider{
        width: parent.width;
        height: 1;
        anchors.bottom: parent.bottom;
    }

}
