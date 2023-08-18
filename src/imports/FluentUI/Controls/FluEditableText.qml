import QtQuick
import FluentUI
Item {
    id:root
    property bool editable: false
    property string text: ""
    property int elide
    property color color
    property color editBgColor: FluTheme.dark ? Qt.rgba(62/255,62/255,62/255,1) : Qt.rgba(255/255,255/255,255/255,1)
    property color editTextColor: FluTheme.dark ?  Qt.rgba(255/255,255/255,255/255,1) : Qt.rgba(27/255,27/255,27/255,1)

    property alias editBgRect : editBackgroundComponent
    property alias normalText :normalTextComponent
    property alias editableText :editableTextComponent


    signal fluTextEdited(var newText)
    signal fluLostFocus(bool isActiveFocus)


    height:24

    function setEditable(value){
        editable = value;
    }

    Keys.onPressed:function(event) {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
             if(editableTextComponent.text !== "" && editableTextComponent.text !== root.text){
                 fluTextEdited(editableTextComponent.text)
             }

            fluLostFocus(false)
        }
    }


    //property alias anchors:normalText.anchors
    FluText{
        id:normalTextComponent
        text: root.text
        elide:root.elide
        color:root.color
        visible: !editable
        anchors.fill: parent
        lineHeight: height
        verticalAlignment: Text.AlignVCenter
    }

    Rectangle{
        id:editBackgroundComponent
        width: Math.max(editableText.implicitWidth,20)
        height:parent.height
        radius: 5


        color:editable? editBgColor:"transparent"
        visible: editable
        TextInput{
            id:editableTextComponent
            anchors.fill: parent

            text:root.text
            color:editTextColor
            visible: editable
            renderType: FluTheme.nativeText ? Text.NativeRendering : Text.QtRendering
            font: FluTextStyle.Body
            verticalAlignment: Text.AlignVCenter
            //focus: editable

            onActiveFocusChanged: {
                if(editableTextComponent.text !== "" && editableTextComponent.text !== root.text){
                    fluTextEdited(text)
                }
                fluLostFocus(activeFocus);
            }
        }
    }
    onEditableChanged: {
        if(editable){
            editableTextComponent.forceActiveFocus()
            editableTextComponent.selectAll()
        }
    }






}
