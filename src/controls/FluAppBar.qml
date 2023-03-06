import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Rectangle{

    id:root
    color: FluTheme.isDark ? FluTheme.primaryColor.lighter : FluTheme.primaryColor.dark
    height: 50
    width: {
        if(parent==null)
            return 200
        return parent.width
    }
    z: 65535
    property string title: "标题"
    property color textColor: FluTheme.isDark ? "#000000" : "#FFFFFF"
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
        color:root.textColor
        fontStyle: FluText.Title
        font.pixelSize: 14
        font.bold: true
    }

    RowLayout{
        anchors.right: parent.right;
        anchors.rightMargin: 10
        height: parent.height
        spacing: 5

        TFpsMonitor{
            Layout.alignment: Qt.AlignVCenter
            Layout.rightMargin: 12
            Layout.topMargin: 5
            color:root.textColor
            visible: showFps
        }

        RowLayout{
            Layout.alignment: Qt.AlignVCenter
            spacing: 5
            visible: showDark
            FluText{
                text:"夜间模式"
                color:root.textColor
                fontStyle: FluText.Body
            }
            FluToggleSwitch{
                checked: FluTheme.isDark
                onClickFunc:function(){
                    FluTheme.isDark = !FluTheme.isDark
                }
            }
        }

        FluIconButton{
            icon : FluentIcons.FA_window_minimize
            Layout.alignment: Qt.AlignVCenter
            iconSize: 15
            text:"最小化"
            textColor: root.textColor
            color:hovered ? "#20000000" : "#00000000"
            onClicked: {
                Window.window.showMinimized()
            }
        }
        FluIconButton{
            property bool isRestore:{
                if(Window.window == null)
                    return false
                return Window.Maximized === Window.window.visibility
            }
            icon : isRestore  ? FluentIcons.FA_window_restore : FluentIcons.FA_window_maximize
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
            icon : FluentIcons.FA_close
            Layout.alignment: Qt.AlignVCenter
            text:"关闭"
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
