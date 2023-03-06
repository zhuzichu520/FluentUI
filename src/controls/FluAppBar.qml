import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Rectangle{

    color: FluTheme.primaryColor.dark
    height: 50
    width: {
        if(parent==null)
            return 200
        return parent.width
    }
    z: 65535
    property string title: "标题"

    property bool showDark: false
    property bool showFps: false

    property bool resizable: {
        if(Window.window == null){
            return false
        }
        return !(Window.window.minimumHeight === Window.window.maximumHeight && Window.window.maximumWidth === Window.window.minimumWidth)
    }

    MouseArea{
        anchors.fill: parent
        anchors.topMargin: 5
        acceptedButtons: Qt.LeftButton
        hoverEnabled: true
        onPressed: Window.window.startSystemMove()
        onDoubleClicked: {
            if(resizable)
                toggleMaximized();
        }
    }

    function toggleMaximized() {
        if (Window.window.visibility === Window.Maximized) {
            Window.window.showNormal();
        } else {
            Window.window.showMaximized();
        }
    }

    FluText {
        text: title
        anchors{
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 14
        }
        color:"#FFFFFFFF"
        fontStyle: FluText.Title
        font.pixelSize: 14
        font.bold: true
    }

    RowLayout{
        anchors.right: parent.right;
        anchors.rightMargin: 10
        height: parent.height
        spacing: 15

        TFpsMonitor{
            Layout.alignment: Qt.AlignVCenter
            Layout.rightMargin: 12
            Layout.topMargin: 5
            color:"#FFFFFFFF"
            visible: showFps
        }

        RowLayout{
            Layout.alignment: Qt.AlignVCenter
            spacing: 5
            visible: showDark
            FluText{
                text:"夜间模式"
                color:"#FFFFFFFF"
                fontStyle: FluText.Body
            }
            FluToggleSwitch{
                checked: FluApp.isDark
                onClickFunc:function(){
                    FluApp.isDark = !FluApp.isDark
                }
            }
        }

        FluIcon{
            icon : FluentIcons.FA_window_minimize
            Layout.alignment: Qt.AlignVCenter
            iconSize: 15
            color:"#FFFFFF"
            MouseArea{
                id:mouse_miniminzed
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    Window.window.showMinimized()
                }
            }
            FluTooltip{
                visible: mouse_miniminzed.containsMouse
                text:"最小化"
                delay: 1000
            }
        }
        FluIcon{

            property bool isRestore: {
                if(Window.window == null)
                    return false
                return Window.Maximized === Window.window.visibility
            }
            color:"#FFFFFF"
            icon :  {
                if(Window.window == null)
                    return FluentIcons.FA_window_restore
                return Window.Maximized === Window.window.visibility  ? FluentIcons.FA_window_restore : FluentIcons.FA_window_maximize
            }
            Layout.alignment: Qt.AlignVCenter
            visible: resizable
            iconSize: 15
            MouseArea{
                id:mouse_maximized
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    toggleMaximized()
                }
            }
            FluTooltip{
                visible: mouse_maximized.containsMouse
                text:{
                    return parent.isRestore?"向下还原":"最大化"
                }
                delay: 1000
            }
        }
        FluIcon{
            icon : FluentIcons.FA_close
            Layout.alignment: Qt.AlignVCenter
            color:"#FFFFFF"
            MouseArea{
                id:mouse_close
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    Window.window.close()
                }
            }
            FluTooltip{
                visible: mouse_close.containsMouse
                text:"关闭"
                delay: 1000
            }
        }
    }

    FluDivider{
        width: parent.width;
        height: 1;
        anchors.bottom: parent.bottom;
    }

}
