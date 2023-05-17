import QtQuick
import QtQuick.Layouts
import FluentUI
import org.wangwenx190.FramelessHelper

FluWindow {

    id:window

    property bool fixSize
    property alias titleVisible: title_bar.titleVisible
    property bool appBarVisible: true
    default property alias content: container.data

    FluAppBar {
        id: title_bar
        title: window.title
        visible: window.appBarVisible
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
    }

    Item{
        id:container
        anchors{
            top: title_bar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        clip: true
    }

    FramelessHelper{
        id:framless_helper
        onReady: {
            setTitleBarItem(title_bar)
            framless_helper.moveWindowToDesktopCenter()
            setHitTestVisible(title_bar.minimizeButton())
            setHitTestVisible(title_bar.maximizeButton())
            setHitTestVisible(title_bar.closeButton())
            framless_helper.setWindowFixedSize(fixSize)
            title_bar.maximizeButton.visible = !fixSize
            window.visible = true
        }
    }

    function setHitTestVisible(com){
        framless_helper.setHitTestVisible(com)
    }

    function setTitleBarItem(com){
        framless_helper.setTitleBarItem(com)
    }

}
