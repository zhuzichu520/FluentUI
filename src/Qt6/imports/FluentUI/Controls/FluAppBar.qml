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
    property string stayTopText : "置顶"
    property string stayTopCancelText : "取消置顶"
    property color textColor: FluTheme.dark ? "#FFFFFF" : "#000000"
    property color minimizeNormalColor: FluTheme.itemNormalColor
    property color minimizeHoverColor: FluTheme.itemHoverColor
    property color minimizePressColor: FluTheme.itemPressColor
    property color maximizeNormalColor: FluTheme.itemNormalColor
    property color maximizeHoverColor: FluTheme.itemHoverColor
    property color maximizePressColor: FluTheme.itemPressColor
    property color closeNormalColor: Qt.rgba(0,0,0,0)
    property color closeHoverColor:  Qt.rgba(251/255,115/255,115/255,1)
    property color closePressColor: Qt.rgba(251/255,115/255,115/255,0.8)
    property bool showDark: false
    property bool showClose: true
    property bool showMinimize: true
    property bool showMaximize: true
    property bool showStayTop: true
    property bool titleVisible: true
    property url icon
    property int iconSize: 20
    property bool isMac: FluTools.isMacos()
    property color borerlessColor : FluTheme.primaryColor
    property bool systemMoveEnable: true
    property var maxClickListener : function(){
        if(FluTools.isMacos()){
            if (d.win.visibility === Window.FullScreen)
                d.win.showNormal()
            else
                d.win.showFullScreen()
        }else{
            if (d.win.visibility === Window.Maximized)
                d.win.showNormal()
            else
                d.win.showMaximized()
            d.hoverMaxBtn = false
        }
    }
    property var minClickListener: function(){
        d.win.showMinimized()
    }
    property var closeClickListener : function(){
        d.win.close()
    }
    property var stayTopClickListener: function(){
        if(d.win instanceof FluWindow){
            d.win.stayTop = !d.win.stayTop
        }
    }
    property var darkClickListener: function(){
        if(FluTheme.dark){
            FluTheme.darkMode = FluThemeType.Light
        }else{
            FluTheme.darkMode = FluThemeType.Dark
        }
    }
    property var systemMenuListener: function(){
        if(d.win instanceof FluWindow){
            d.win.showSystemMenu()
        }
    }
    property alias buttonStayTop: btn_stay_top
    property alias buttonMinimize: btn_minimize
    property alias buttonMaximize: btn_maximize
    property alias buttonClose: btn_close
    property alias buttonDark: btn_dark
    id:control
    color: Qt.rgba(0,0,0,0)
    height: visible ? 30 : 0
    opacity: visible
    z: 65535
    Item{
        id:d
        property var hitTestList: []
        property bool hoverMaxBtn: false
        property var win: Window.window
        property bool stayTop: {
            if(d.win instanceof FluWindow){
                return d.win.stayTop
            }
            return false
        }
        property bool isRestore: win && Window.Maximized === win.visibility
        property bool resizable: win && !(win.height === win.maximumHeight && win.height === win.minimumHeight && win.width === win.maximumWidth && win.width === win.minimumWidth)
        function containsPointToItem(point,item){
            var pos = item.mapToGlobal(0,0)
            var rect = Qt.rect(pos.x,pos.y,item.width,item.height)
            if(point.x>rect.x && point.x<(rect.x+rect.width) && point.y>rect.y && point.y<(rect.y+rect.height)){
                return true
            }
            return false
        }
    }
    MouseArea{
        id:mouse_app_bar
        anchors.fill: parent
        onPositionChanged:
            (mouse)=>{
                if(systemMoveEnable){
                    d.win.startSystemMove()
                }
            }
        onDoubleClicked:
            (mouse)=>{
                if(systemMoveEnable && d.resizable && Qt.LeftButton){
                    btn_maximize.clicked()
                }
            }
        acceptedButtons: Qt.LeftButton|Qt.RightButton
        onClicked:
            (mouse)=>{
                if (systemMoveEnable && mouse.button === Qt.RightButton){
                    control.systemMenuListener()
                }
            }
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

    Component{
        id:com_mac_buttons
        RowLayout{
            FluImageButton{
                Layout.preferredHeight: 12
                Layout.preferredWidth: 12
                normalImage: "../Image/btn_close_normal.png"
                hoveredImage: "../Image/btn_close_hovered.png"
                pushedImage: "../Image/btn_close_pushed.png"
                visible: showClose
                onClicked: closeClickListener()
            }
            FluImageButton{
                Layout.preferredHeight: 12
                Layout.preferredWidth: 12
                normalImage: "../Image/btn_min_normal.png"
                hoveredImage: "../Image/btn_min_hovered.png"
                pushedImage: "../Image/btn_min_pushed.png"
                onClicked: minClickListener()
                visible: showMinimize
            }
            FluImageButton{
                Layout.preferredHeight: 12
                Layout.preferredWidth: 12
                normalImage: "../Image/btn_max_normal.png"
                hoveredImage: "../Image/btn_max_hovered.png"
                pushedImage: "../Image/btn_max_pushed.png"
                onClicked: maxClickListener()
                visible: d.resizable && showMaximize
            }
        }
    }

    FluLoader{
        anchors{
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 10
        }
        sourceComponent: isMac ? com_mac_buttons : undefined
    }

    RowLayout{
        id:layout_row
        anchors.right: parent.right
        height: control.height
        spacing: 0
        Component.onCompleted: {
            setHitTestVisible(layout_row)
        }
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
            id:btn_stay_top
            Layout.preferredWidth: 40
            Layout.preferredHeight: 30
            iconSource : FluentIcons.Pinned
            Layout.alignment: Qt.AlignVCenter
            iconSize: 13
            visible: {
                if(!(d.win instanceof FluWindow)){
                    return false
                }
                return showStayTop
            }
            text:d.stayTop ? control.stayTopCancelText : control.stayTopText
            radius: 0
            iconColor: d.stayTop ? FluTheme.primaryColor : control.textColor
            onClicked: stayTopClickListener()
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
            color: {
                if(pressed){
                    return minimizePressColor
                }
                return hovered ? minimizeHoverColor : minimizeNormalColor
            }
            onClicked: minClickListener()
        }
        FluIconButton{
            id:btn_maximize
            Layout.preferredWidth: 40
            Layout.preferredHeight: 30
            iconSource : d.isRestore  ? FluentIcons.ChromeRestore : FluentIcons.ChromeMaximize
            color: {
                if(down){
                    return maximizePressColor
                }
                if(FluTools.isWindows11OrGreater()){
                    return d.hoverMaxBtn ? maximizeHoverColor : maximizeNormalColor
                }
                return hovered ? maximizeHoverColor : maximizeNormalColor
            }
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
            color:{
                if(pressed){
                    return closePressColor
                }
                return hovered ? closeHoverColor : closeNormalColor
            }
            onClicked: closeClickListener()
        }
    }
    function _maximizeButtonHover(){
        var hover = false
        if(btn_maximize.visible && FluTools.isWindows11OrGreater() && d.resizable){
            if(d.containsPointToItem(FluTools.cursorPos(),btn_maximize)){
                hover = true
            }else{
                if(btn_maximize.down){
                    btn_maximize.down = false
                }
            }
        }
        d.hoverMaxBtn = hover
        return hover;
    }
    function _appBarHover(){
        var cursorPos = FluTools.cursorPos()
        for(var i =0 ;i< d.hitTestList.length; i++){
            var item = d.hitTestList[i]
            if(item.visible){
                if(d.containsPointToItem(cursorPos,item)){
                    return false
                }
            }
        }
        if(d.containsPointToItem(cursorPos,control)){
            return true
        }
        return false
    }
    function setHitTestVisible(id){
        d.hitTestList.push(id)
    }
}
