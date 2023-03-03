import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Rectangle{

    color: FluApp.isDark ? "#323232" : "#FFFFFF"
    height: 50
    width: {
        if(parent==null)
            return 200
        return parent.width
    }

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
        fontStyle: FluText.Title
        font.pixelSize: 14
        font.bold: true
    }

    RowLayout{
        anchors.right: parent.right;
        height: parent.height
        spacing: 5

        TFpsMonitor{
            Layout.alignment: Qt.AlignVCenter
            Layout.rightMargin: 12
            Layout.topMargin: 5
            visible: showFps
        }

        RowLayout{
            Layout.alignment: Qt.AlignVCenter
            spacing: 5
            visible: showDark
            FluText{
                text:"夜间模式"
                fontStyle: FluText.Body
            }
            FluToggleSwitch{
                checked: FluApp.isDark
                onClickFunc:function(){
                    FluApp.isDark = !FluApp.isDark
                }
            }
        }

        FluIconButton{
            icon : FluentIcons.FA_window_minimize
            Layout.alignment: Qt.AlignVCenter
            iconSize: 15
            text:"最小化"
            onClicked: {
                Window.window.showMinimized()
            }
        }
        FluIconButton{
            icon :  {
                if(Window.window == null)
                    return false
                return Window.Maximized === Window.window.visibility  ? FluentIcons.FA_window_restore : FluentIcons.FA_window_maximize
            }
            Layout.alignment: Qt.AlignVCenter
            visible: resizable
            text:{
                if(Window.window == null)
                    return ""
                Window.Maximized === Window.window.visibility?"向下还原":"最大化"
            }
            iconSize: 15
            onClicked: {
                toggleMaximized()
            }
        }
        FluIconButton{
            icon : FluentIcons.FA_close
            Layout.alignment: Qt.AlignVCenter
            text:"关闭"
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
