import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

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
    property bool showClose: true
    property bool showMinimize: true
    property bool showMaximize: true
    property bool titleVisible: true
    property url icon
    property int iconSize: 20
    property bool isMac: FluTools.isMacos()
    property color borerlessColor : FluTheme.dark ? FluTheme.primaryColor.lighter : FluTheme.primaryColor.dark
    property var maxClickListener : function(){
        if (d.win.visibility === Window.Maximized)
            d.win.visibility = Window.Windowed
        else
            d.win.visibility = Window.Maximized
    }
    property var minClickListener: function(){
        d.win.visibility = Window.Minimized
    }
    property var closeClickListener : function(){
        d.win.close()
    }
    property var darkClickListener: function(){
        if(FluTheme.dark){
            FluTheme.darkMode = FluThemeType.Light
        }else{
            FluTheme.darkMode = FluThemeType.Dark
        }
    }
    id:control
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
    Row{
        anchors{
            verticalCenter: parent.verticalCenter
            left: isMac ? undefined : parent.left
            leftMargin: isMac ? undefined : 10
            horizontalCenter: isMac ? parent.horizontalCenter : undefined
        }
        spacing: 10
        Image{
            width: control.iconSize
            height: control.iconSize
            visible: status === Image.Ready ? true : false
            source: control.icon
            anchors.verticalCenter: parent.verticalCenter
        }
        FluText {
            text: title
            visible: control.titleVisible
            color:control.textColor
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    RowLayout{
        anchors.right: parent.right
        height: control.height
        spacing: 0
        FluToggleSwitch{
            id:btn_dark
            Layout.alignment: Qt.AlignVCenter
            Layout.rightMargin: 5
            visible: showDark
            text:darkText
            textColor:control.textColor
            checked: FluTheme.dark
            textRight: false
            clickListener:()=> darkClickListener(btn_dark)
        }
        FluIconButton{
            id:btn_minimize
            Layout.preferredWidth: 40
            Layout.preferredHeight: 30
            iconSource : FluentIcons.ChromeMinimize
            Layout.alignment: Qt.AlignVCenter
            iconSize: 11
            text:minimizeText
            radius: 0
            visible: !isMac && showMinimize
            iconColor: control.textColor
            color: hovered ? minimizeHoverColor : minimizeNormalColor
            onClicked: minClickListener()
        }
        FluIconButton{
            id:btn_maximize
            Layout.preferredWidth: 40
            Layout.preferredHeight: 30
            iconSource : d.isRestore  ? FluentIcons.ChromeRestore : FluentIcons.ChromeMaximize
            color: hovered ? maximizeHoverColor : maximizeNormalColor
            Layout.alignment: Qt.AlignVCenter
            visible: d.resizable && !isMac && showMaximize
            radius: 0
            iconColor: control.textColor
            text:d.isRestore?restoreText:maximizeText
            iconSize: 11
            onClicked: maxClickListener()
        }
        FluIconButton{
            id:btn_close
            iconSource : FluentIcons.ChromeClose
            Layout.alignment: Qt.AlignVCenter
            text:closeText
            Layout.preferredWidth: 40
            Layout.preferredHeight: 30
            visible: !isMac && showClose
            radius: 0
            iconSize: 10
            iconColor: hovered ? Qt.rgba(1,1,1,1) : control.textColor
            color:hovered ? closeHoverColor : closeNormalColor
            onClicked: closeClickListener()
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

    function darkButton(){
        return btn_dark
    }

}
