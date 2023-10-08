import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import example 1.0
import "qrc:///example/qml/component"
import "../component"

FluWindow {

    id:window
    width: 800
    height: 600
    minimumWidth: 520
    minimumHeight: 200
    launchMode: FluWindowType.SingleInstance
    onInitArgument:
        (arg)=>{
            window.title = arg.title
            loader.setSource( arg.url,{animDisabled:true})
        }
    Loader{
        id: loader
        anchors.fill: parent
    }
}
