import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Window {
    default property alias content: container.data
    property bool closeDestory: true
    property int launchMode: FluWindowType.Standard
    property var argument:({})
    property var background : com_background
    property Component loadingItem: com_loading
    property color backgroundColor: {
        if(active){
            return FluTheme.dark ? Qt.rgba(26/255,34/255,40/255,1) : Qt.rgba(243/255,243/255,243/255,1)
        }
        return FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(237/255,237/255,237/255,1)
    }
    property var _pageRegister
    property string _route
    property var closeFunc: function(event){
        if(closeDestory){
            deleteWindow()
        }else{
            visible = false
            event.accepted = false
        }
    }
    signal initArgument(var argument)
    id:window
    color:"transparent"
    Component.onCompleted: {
        helper.initWindow(window)
        initArgument(argument)
    }
    Connections{
        target: window
        function onClosing(event){closeFunc(event)}
    }
    Component{
        id:com_background
        Rectangle{
            color: window.backgroundColor
        }
    }
    Loader{
        anchors.fill: parent
        sourceComponent: background
    }
    Item{
        id:container
        anchors.fill: parent
        clip: true
    }
    Loader{
        property string loadingText: "加载中..."
        property bool cancel: false
        id:loader_loading
        anchors.fill: container
    }
    FluInfoBar{
        id:infoBar
        root: window
    }
    Component{
        id:com_loading
        Popup{
            id:popup_loading
            modal:true
            focus: true
            width: window.width
            height: window.height
            anchors.centerIn: Overlay.overlay
            closePolicy: {
                if(cancel){
                    return Popup.CloseOnEscape | Popup.CloseOnPressOutside
                }
                return Popup.NoAutoClose
            }
            Overlay.modal: Item {}
            onVisibleChanged: {
                if(!visible){
                    loader_loading.sourceComponent = undefined
                }
            }
            padding: 0
            opacity: 0
            visible:true
            Behavior on opacity {
                SequentialAnimation {
                    PauseAnimation {
                        duration: 88
                    }
                    NumberAnimation{
                        duration:  167
                    }
                }
            }
            Component.onCompleted: {
                opacity = 1
            }
            background: Rectangle{
                color:"#44000000"
            }
            contentItem: Item{
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        popup_loading.visible = false
                    }
                }
                ColumnLayout{
                    spacing: 8
                    anchors.centerIn: parent
                    FluProgressRing{
                        Layout.alignment: Qt.AlignHCenter
                    }
                    FluText{
                        text:loadingText
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
        }
    }
    WindowHelper{
        id:helper
    }
    function showLoading(text = "加载中...",cancel = true){
        loader_loading.loadingText = text
        loader_loading.cancel = cancel
        loader_loading.sourceComponent = com_loading
    }
    function hideLoading(){
        loader_loading.sourceComponent = undefined
    }
    function showSuccess(text,duration,moremsg){
        infoBar.showSuccess(text,duration,moremsg)
    }
    function showInfo(text,duration,moremsg){
        infoBar.showInfo(text,duration,moremsg)
    }
    function showWarning(text,duration,moremsg){
        infoBar.showWarning(text,duration,moremsg)
    }
    function showError(text,duration,moremsg){
        infoBar.showError(text,duration,moremsg)
    }
    function registerForWindowResult(path){
        return helper.createRegister(window,path)
    }
    function deleteWindow(){
        FluApp.deleteWindow(window)
    }
    function onResult(data){
        if(_pageRegister){
            _pageRegister.onResult(data)
        }
    }
}
