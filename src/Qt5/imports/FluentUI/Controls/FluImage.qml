import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

Image {
    property string errorButtonText: qsTr("Reload")
    property var clickErrorListener : function(){
        image.source = ""
        image.source = control.source
    }
    property Component errorItem : com_error
    property Component loadingItem: com_loading
    id: control
    opacity: enabled ? 1 : 0.5
    FluLoader{
        anchors.fill: parent
        sourceComponent: {
            if(control.status === Image.Loading){
                return com_loading
            }else if(control.status == Image.Error){
                return com_error
            }else{
                return undefined
            }
        }
    }
    Component{
        id:com_loading
        Rectangle{
            color: FluTheme.itemHoverColor
            FluProgressRing{
                anchors.centerIn: parent
                visible: control.status === Image.Loading
            }
        }
    }
    Component{
        id:com_error
        Rectangle{
            color: FluTheme.itemHoverColor
            FluFilledButton{
                text: control.errorButtonText
                anchors.centerIn: parent
                visible: control.status === Image.Error
                onClicked: clickErrorListener()
            }
        }
    }
}
