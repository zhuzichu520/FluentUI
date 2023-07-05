import QtQuick 2.12
import QtQuick.Controls 2.12
import FluentUI 1.0

Image {
    property string errorButtonText: "重新加载"
    property var clickErrorListener : function(){
        image.source = ""
        image.source = control.source
    }
    property Component errorItem : com_error
    property Component loadingItem: com_loading
    id: control
    Loader{
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
            color: FluTheme.dark ? Qt.rgba(1,1,1,0.03) : Qt.rgba(0,0,0,0.03)
            FluProgressRing{
                anchors.centerIn: parent
                visible: control.status === Image.Loading
            }
        }
    }
    Component{
        id:com_error
        Rectangle{
            color: FluTheme.dark ? Qt.rgba(1,1,1,0.03) : Qt.rgba(0,0,0,0.03)
            FluFilledButton{
                text: control.errorButtonText
                anchors.centerIn: parent
                visible: control.status === Image.Error
                onClicked: clickErrorListener()
            }
        }
    }
}
