import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts
import FluentUI

Rectangle{
    property string title: ""
    property string darkText : "夜间模式"
    property string minimizeText : "最小化"
    property string restoreText : "向下还原"
    property string maximizeText : "最大化"
    property string closeText : "关闭"
    property color textColor: FluTheme.dark ? "#FFFFFF" : "#000000"
    property color minimizeNormalColor: Qt.rgba(0,0,0,0)
    property color minimizeHoverColor: FluTheme.dark ? Qt.rgba(1,1,1,0.1) : Qt.rgba(0,0,0,0.06)
    property color maximizeNormalColor: Qt.rgba(0,0,0,0)
    property color maximizeHoverColor: FluTheme.dark ? Qt.rgba(1,1,1,0.1) : Qt.rgba(0,0,0,0.06)
    property color closeNormalColor: Qt.rgba(0,0,0,0)
    property color closeHoverColor:  Qt.rgba(251/255,115/255,115/255,1)
    property bool showDark: false
    property bool titleVisible: true
    property bool isMac: Qt.platform.os === "osx"
    property color borerlessColor : FluTheme.dark ? FluTheme.primaryColor.lighter : FluTheme.primaryColor.dark
    id:root
    color: Qt.rgba(0,0,0,0)
    height: visible ? 30 : 0
    opacity: visible
    z: 65535
    Item{
        id:d
        property var win: Window.window
        property bool isRestore: win && Window.Maximized === win.visibility
        property bool resizable: win && !(win.minimumHeight === win.maximumHeight && win.maximumWidth === win.minimumWidth)
    }
    TapHandler {
        onTapped: if (tapCount === 2) btn_maximize.clicked()
        gesturePolicy: TapHandler.DragThreshold
    }
    DragHandler {
        target: null
        grabPermissions: TapHandler.CanTakeOverFromAnything
        onActiveChanged: if (active) { d.win.startSystemMove(); }
    }
    FluText {
        text: title
        anchors{
            verticalCenter: parent.verticalCenter
            left: isMac ? undefined : parent.left
            leftMargin: isMac ? undefined : 10
            horizontalCenter: isMac ? parent.horizontalCenter : undefined
        }
        visible: root.titleVisible
        color:root.textColor
    }
    RowLayout{
        anchors.right: parent.right
        height: root.height
        spacing: 0
        RowLayout{
            Layout.alignment: Qt.AlignVCenter
            Layout.rightMargin: 5
            visible: showDark
            spacing: 5
            FluText{
                text:darkText
                color:root.textColor
            }
            FluToggleSwitch{
                selected: FluTheme.dark
                clickFunc:function(){
                    if(FluTheme.dark){
                        FluTheme.darkMode = FluDarkMode.Light
                    }else{
                        FluTheme.darkMode = FluDarkMode.Dark
                    }
                }
            }
        }
        FluIconButton{
            id:btn_minimize
            width: 40
            height: 30
            iconSource : FluentIcons.ChromeMinimize
            Layout.alignment: Qt.AlignVCenter
            iconSize: 11
            text:minimizeText
            radius: 0
            visible: !isMac
            iconColor: root.textColor
            color: hovered ? minimizeHoverColor : minimizeNormalColor
            onClicked: {
                d.win.visibility = Window.Minimized
            }
        }
        FluIconButton{
            id:btn_maximize
            width: 40
            height: 30
            iconSource : d.isRestore  ? FluentIcons.ChromeRestore : FluentIcons.ChromeMaximize
            color: hovered ? maximizeHoverColor : maximizeNormalColor
            Layout.alignment: Qt.AlignVCenter
            visible: d.resizable && !isMac
            radius: 0
            iconColor: root.textColor
            text:d.isRestore?restoreText:maximizeText
            iconSize: 11
            onClicked: {
                if (d.win.visibility === Window.Maximized)
                    d.win.visibility = Window.Windowed
                else
                    d.win.visibility = Window.Maximized
            }
        }
        FluIconButton{
            id:btn_close
            iconSource : FluentIcons.ChromeClose
            Layout.alignment: Qt.AlignVCenter
            text:closeText
            width: 40
            height: 30
            visible: !isMac
            radius: 0
            iconSize: 10
            iconColor: hovered ? Qt.rgba(1,1,1,1) : root.textColor
            color:hovered ? closeHoverColor : closeNormalColor
            onClicked: {
                d.win.close()
            }
        }
    }

    function minimizeButton(){
        return btn_minimize
    }

    function maximizeButton(){
        return btn_maximize
    }

    function closeButton(){
        return btn_close
    }

}
