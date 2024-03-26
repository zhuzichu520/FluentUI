import QtQuick
import FluentUI

Item {

    id:control
    property var _from : Window.window
    property var _to
    property var path
    signal result(var data)

    function launch(argument = {}){
        FluRouter.navigate(control.path,argument,control)
    }

    function setResult(data = {}){
        control.result(data)
    }

}
