import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQuick.Window
import FluentUI

Button{
    id:control
    width: 36
    height: 36
    implicitWidth: width
    implicitHeight: height
    property color current : Qt.rgba(1,1,1,1)
    signal accepted()
    property int colorHandleRadius: 8
    property string cancelText: qsTr("Cancel")
    property string okText: qsTr("OK")
    property string titleText: qsTr("Color Picker")
    property string editText: qsTr("Edit Color")
    property string redText: qsTr("Red")
    property string greenText: qsTr("Green")
    property string blueText: qsTr("Blue")
    property string opacityText: qsTr("Opacity")
    background: Rectangle{
        id:layout_color
        radius: 5
        color:"#00000000"
        border.color: {
            if(hovered)
                return FluTheme.primaryColor
            return FluTheme.dark ? Qt.rgba(100/255,100/255,100/255,1) : Qt.rgba(200/255,200/255,200/255,1)
        }
        border.width: 1
        Rectangle{
            anchors.fill: parent
            anchors.margins: 4
            radius: 5
            color: control.current
        }
    }
    contentItem: Item{}
    onClicked: {
        color_dialog.open()
    }
    FluPopup{
        id:color_dialog
        implicitWidth: 326
        implicitHeight: 560
        closePolicy: Popup.CloseOnEscape
        Rectangle{
            id:layout_actions
            width: parent.width
            height: 60
            radius: 5
            z:999
            anchors.bottom: parent.bottom
            color: FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(243/255,243/255,243/255,1)
            RowLayout{
                anchors
                {
                    centerIn: parent
                    margins: spacing
                    fill: parent
                }
                spacing: 10
                Item{
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    FluButton{
                        text: control.cancelText
                        width: parent.width
                        anchors.centerIn: parent
                        onClicked: {
                            color_dialog.close()
                        }
                    }
                }
                Item{
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    FluFilledButton{
                        text: control.okText
                        width: parent.width
                        anchors.centerIn: parent
                        onClicked: {
                            current = layout_color_hue.colorValue
                            control.accepted()
                            color_dialog.close()
                        }
                    }
                }
            }
        }
        contentItem: Flickable{
            implicitWidth: parent.width
            implicitHeight: Math.min(layout_content.height,560,color_dialog.height)
            boundsBehavior:Flickable.StopAtBounds
            contentHeight: layout_content.height + 70
            contentWidth: width
            clip: true
            ScrollBar.vertical: FluScrollBar {}
            Item{
                id: layout_content
                width: parent.width
                height: childrenRect.height
                FluText{
                    id: text_titile
                    font: FluTextStyle.Subtitle
                    text: control.titleText
                    anchors{
                        left: parent.left
                        top: parent.top
                        leftMargin: 20
                        topMargin: 20
                    }
                }
                Item{
                    id: layout_sb
                    width: 200
                    height: 200
                    anchors{
                        left: parent.left
                        top: text_titile.bottom
                        leftMargin: 12
                    }
                    FluClip{
                        id: layout_color_hue
                        property color colorValue
                        property real xPercent: pickerCursor.x/width
                        property real yPercent: pickerCursor.y/height
                        property real blackPercent: blackCursor.x/(layout_black.width-12)
                        property real opacityPercent: opacityCursor.x/(layout_opacity.width-12)
                        property color opacityColor:{
                            var c = blackColor
                            c = Qt.rgba(c.r,c.g,c.b,opacityPercent)
                            return c
                        }
                        onOpacityColorChanged: {
                            layout_color_hue.colorValue = opacityColor
                            updateColorText(opacityColor)
                        }
                        function updateColorText(color){
                            text_box_r.text = String(Math.floor(color.r*255))
                            text_box_g.text = String(Math.floor(color.g*255))
                            text_box_b.text = String(Math.floor(color.b*255))
                            text_box_a.text = String(Math.floor(color.a*100))
                            var colorString = color.toString().slice(1)
                            if(color.a===1){
                                colorString = "FF"+colorString
                            }
                            text_box_color.text = colorString.toUpperCase()
                        }
                        property color blackColor: {
                            var c = whiteColor
                            c = Qt.rgba(c.r*blackPercent,c.g*blackPercent,c.b*blackPercent,1)
                            return c
                        }
                        property color hueColor: {
                            var v = 1.0-xPercent
                            var c
                            if(0.0 <= v && v < 0.16) {
                                c = Qt.rgba(1.0, 0.0, v/0.16, 1.0)
                            } else if(0.16 <= v && v < 0.33) {
                                c = Qt.rgba(1.0 - (v-0.16)/0.17, 0.0, 1.0, 1.0)
                            } else if(0.33 <= v && v < 0.5) {
                                c = Qt.rgba(0.0, ((v-0.33)/0.17), 1.0, 1.0)
                            } else if(0.5 <= v && v < 0.76) {
                                c = Qt.rgba(0.0, 1.0, 1.0 - (v-0.5)/0.26, 1.0)
                            } else if(0.76 <= v && v < 0.85) {
                                c = Qt.rgba((v-0.76)/0.09, 1.0, 0.0, 1.0)
                            } else if(0.85 <= v && v <= 1.0) {
                                c = Qt.rgba(1.0, 1.0 - (v-0.85)/0.15, 0.0, 1.0)
                            } else {
                                c = Qt.rgba(1.0,0.0,0.0,1.0)
                            }
                            return c
                        }
                        property color whiteColor: {
                            var c = hueColor
                            c = Qt.rgba((1-c.r)*yPercent+c.r,(1-c.g)*yPercent+c.g,(1-c.b)*yPercent+c.b,1.0)
                            return c
                        }
                        function updateColor(){
                            var r = Number(text_box_r.text)/255
                            var g = Number(text_box_g.text)/255
                            var b = Number(text_box_b.text)/255
                            var opacityPercent = Number(text_box_a.text)/100
                            var blackPercent = Math.max(r,g,b)
                            r = r/blackPercent
                            g = g/blackPercent
                            b = b/blackPercent
                            var yPercent = Math.min(r,g,b)
                            if(r === g && r === b){
                                r = 1
                                b = 1
                                g = 1
                            }else{
                                r = (yPercent-r)/(yPercent-1)
                                g = (yPercent-g)/(yPercent-1)
                                b = (yPercent-b)/(yPercent-1)
                            }
                            var xPercent
                            if (r === 1.0 && g === 0.0 && b <= 1.0) {
                                if(b===0.0){
                                    xPercent = 0
                                }else{
                                    xPercent = 1.0 - b * 0.16
                                }
                            } else if (r <= 1.0 && g === 0.0 && b === 1.0) {
                                xPercent = 1.0 - (1.0 - r) * 0.17 - 0.16
                            } else if (r === 0.0 && g <= 1.0 && b === 1.0) {
                                xPercent = 1.0 - (g * 0.17 + 0.33)
                            } else if (r === 0.0 && g === 1.0 && b <= 1.0) {
                                xPercent = 1.0 - (1.0 - b) * 0.26 - 0.5
                            } else if (r <= 1.0 && g === 1.0 && b === 0.0) {
                                xPercent = 1.0 - (r * 0.09 + 0.76)
                            } else if (r === 1.0 && g <= 1.0 && b === 0.0) {
                                xPercent = 1.0 - (1.0 - g) * 0.15 - 0.85
                            } else {
                                xPercent = 0
                            }
                            pickerCursor.x = xPercent * width
                            pickerCursor.y = yPercent * height
                            blackCursor.x = blackPercent * (layout_black.width-12)
                            opacityCursor.x = opacityPercent * (layout_opacity.width-12)
                        }
                        radius: [4,4,4,4]
                        x: colorHandleRadius
                        y: colorHandleRadius
                        width: parent.width - 2 * colorHandleRadius
                        height: parent.height - 2 *  colorHandleRadius
                        Rectangle {
                            anchors.fill: parent
                            gradient: Gradient {
                                orientation: Gradient.Horizontal
                                GradientStop { position: 0.0;  color: "#FF0000" }
                                GradientStop { position: 0.16; color: "#FFFF00" }
                                GradientStop { position: 0.33; color: "#00FF00" }
                                GradientStop { position: 0.5;  color: "#00FFFF" }
                                GradientStop { position: 0.76; color: "#0000FF" }
                                GradientStop { position: 0.85; color: "#FF00FF" }
                                GradientStop { position: 1.0;  color: "#FF0000" }
                            }
                        }
                        Rectangle {
                            anchors.fill: parent
                            gradient: Gradient {
                                GradientStop { position: 1.0; color: "#FFFFFFFF" }
                                GradientStop { position: 0.0; color: "#00000000" }
                            }
                        }
                        Rectangle{
                            radius: 4
                            anchors.fill: parent
                            border.width: 1
                            border.color: FluTheme.dividerColor
                            color:"#00000000"
                        }
                    }
                    Item {
                        id: pickerCursor
                        Rectangle {
                            width: colorHandleRadius*2; height: colorHandleRadius*2
                            radius: colorHandleRadius
                            border.color: "black"; border.width: 2
                            color: "transparent"
                            Rectangle {
                                anchors.fill: parent; anchors.margins: 2;
                                border.color: "white"; border.width: 2
                                radius: width/2
                                color: "transparent"
                            }
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        x: colorHandleRadius
                        y: colorHandleRadius
                        preventStealing: true
                        function handleMouse(mouse) {
                            if (mouse.buttons & Qt.LeftButton) {
                                pickerCursor.x = Math.max(0,Math.min(mouse.x - colorHandleRadius,width-2*colorHandleRadius));
                                pickerCursor.y = Math.max(0,Math.min(mouse.y - colorHandleRadius,height-2*colorHandleRadius));
                            }
                        }
                        onPositionChanged:(mouse)=> handleMouse(mouse)
                        onPressed:(mouse)=> handleMouse(mouse)
                    }
                }
                FluClip{
                    width: 40
                    height: 200
                    anchors{
                        top: layout_sb.top
                        bottom: layout_sb.bottom
                        left: layout_sb.right
                        topMargin: colorHandleRadius
                        bottomMargin: colorHandleRadius
                        leftMargin: 4
                    }
                    radius: [4,4,4,4]
                    Grid {
                        padding: 0
                        id:target_grid_color
                        anchors.fill: parent
                        rows: height/5+1
                        columns: width/5+1
                        Repeater {
                            model: (target_grid_color.columns-1)*(target_grid_color.rows-1)
                            Rectangle {
                                width: 6
                                height: 6
                                color: (model.index%2 == 0) ? "gray" : "white"
                            }
                        }
                    }
                    Rectangle{
                        anchors.fill: parent
                        color:layout_color_hue.colorValue
                        radius: 4
                        border.width: 1
                        border.color: FluTheme.dividerColor
                    }
                }

                Column{
                    id:layout_slider_bar
                    spacing: 8
                    anchors{
                        left: parent.left
                        leftMargin: 18
                        right: parent.right
                        rightMargin: 18
                        top: layout_sb.bottom
                        topMargin: 10
                    }
                    Rectangle{
                        id:layout_black
                        radius: 6
                        height: 12
                        width:parent.width
                        gradient: Gradient {
                            orientation:Gradient.Horizontal
                            GradientStop { position: 0.0; color: "#FF000000" }
                            GradientStop { position: 1.0; color: layout_color_hue.hueColor }
                        }
                        Item {
                            id:blackCursor
                            x:layout_black.width-12
                            Rectangle {
                                width: 12
                                height: 12
                                radius: 6
                                border.color: "black"
                                border.width: 2
                                color: "transparent"
                                Rectangle {
                                    anchors.fill: parent
                                    anchors.margins: 2
                                    border.color: "white"
                                    border.width: 2
                                    radius: width/2
                                    color: "transparent"
                                }
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            preventStealing: true
                            function handleMouse(mouse) {
                                if (mouse.buttons & Qt.LeftButton) {
                                    blackCursor.x = Math.max(0,Math.min(mouse.x - 6,width-2*6));
                                    blackCursor.y = 0
                                }
                            }
                            onPositionChanged:(mouse)=> handleMouse(mouse)
                            onPressed:(mouse)=> handleMouse(mouse)
                        }

                    }
                    FluClip{
                        id:layout_opacity
                        height: 12
                        width:parent.width
                        radius: [6,6,6,6]
                        Grid {
                            id:grid_opacity
                            anchors.fill: parent
                            rows: height/4
                            columns: width/4+1
                            clip: true
                            Repeater {
                                model: grid_opacity.columns*grid_opacity.rows
                                Rectangle {
                                    width: 4
                                    height: 4
                                    color: (model.index%2 == 0) ? "gray" : "white"
                                }
                            }
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                console.debug(grid_opacity.columns,grid_opacity.rows)
                            }
                        }
                        Rectangle{
                            anchors.fill: parent
                            gradient: Gradient {
                                orientation:Gradient.Horizontal
                                GradientStop { position: 0.0; color: "#00000000" }
                                GradientStop { position: 1.0; color: layout_color_hue.blackColor }
                            }
                        }
                        Item {
                            id:opacityCursor
                            x:layout_opacity.width-12
                            Rectangle {
                                width: 12
                                height: 12
                                radius: 6
                                border.color: "black"
                                border.width: 2
                                color: "transparent"
                                Rectangle {
                                    anchors.fill: parent
                                    anchors.margins: 2
                                    border.color: "white"
                                    border.width: 2
                                    radius: width/2
                                    color: "transparent"
                                }
                            }
                        }
                        MouseArea {
                            id:mouse_opacity
                            anchors.fill: parent
                            preventStealing: true
                            function handleMouse(mouse) {
                                if (mouse.buttons & Qt.LeftButton) {
                                    opacityCursor.x = Math.max(0,Math.min(mouse.x - 6,width-2*6));
                                    opacityCursor.y = 0
                                }
                            }
                            onPositionChanged:(mouse)=> handleMouse(mouse)
                            onPressed:(mouse)=> handleMouse(mouse)
                        }
                    }
                }

                Column{
                    anchors{
                        left: parent.left
                        leftMargin: 20
                        top: layout_slider_bar.bottom
                        topMargin: 10
                        right: parent.right
                        rightMargin: 20
                    }
                    spacing: 5
                    Item{
                        width: parent.width
                        height: text_box_color.height
                        FluText{
                            text: control.editText
                            anchors{
                                verticalCenter: parent.verticalCenter
                                left:parent.left
                            }
                        }
                        FluTextBox{
                            id:text_box_color
                            width: 136
                            validator: RegularExpressionValidator {
                                regularExpression: /^[0-9A-F]{8}$/
                            }
                            anchors{
                                right: parent.right
                            }
                            leftPadding: 20
                            FluText{
                                text:"#"
                                anchors{
                                    verticalCenter: parent.verticalCenter
                                    left: parent.left
                                    leftMargin: 5
                                }
                            }
                            onTextEdited: {
                                if(text!==""){
                                    var colorString = text_box_color.text.padStart(8,"0")
                                    var c = Qt.rgba(
                                                parseInt(colorString.substring(2, 4), 16) / 255,
                                                parseInt(colorString.substring(4, 6), 16) / 255,
                                                parseInt(colorString.substring(6, 8), 16) / 255,
                                                parseInt(colorString.substring(0, 2), 16) / 255)
                                    layout_color_hue.colorValue = c
                                }
                            }
                        }
                    }
                    Row{
                        spacing: 10
                        FluTextBox{
                            id:text_box_r
                            width: 120
                            validator: RegularExpressionValidator {
                                regularExpression: /^(25[0-5]|2[0-4]\d|1\d{2}|[1-9]?\d)$/
                            }
                            onTextEdited: {
                                if(text!==""){
                                    layout_color_hue.updateColor()
                                }
                            }
                        }
                        FluText{
                            text: control.redText
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                    Row{
                        spacing: 10
                        FluTextBox{
                            id:text_box_g
                            width: 120
                            validator: RegularExpressionValidator {
                                regularExpression: /^(25[0-5]|2[0-4]\d|1\d{2}|[1-9]?\d)$/
                            }
                            onTextEdited: {
                                if(text!==""){
                                    layout_color_hue.updateColor()
                                }
                            }
                        }
                        FluText{
                            text: control.greenText
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                    Row{
                        spacing: 10
                        FluTextBox{
                            id:text_box_b
                            width: 120
                            validator: RegularExpressionValidator {
                                regularExpression: /^(25[0-5]|2[0-4]\d|1\d{2}|[1-9]?\d)$/
                            }
                            onTextEdited: {
                                if(text!==""){
                                    layout_color_hue.updateColor()
                                }
                            }
                        }
                        FluText{
                            text: control.blueText
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                    Row{
                        spacing: 10
                        FluTextBox{
                            id:text_box_a
                            width: 120
                            validator: RegularExpressionValidator {
                                regularExpression: /^(100|[1-9]?\d)$/
                            }
                            FluText{
                                id:text_opacity
                                text:"%"
                                anchors.verticalCenter: parent.verticalCenter
                                x:Math.min(text_box_a.implicitWidth,text_box_a.width)-38
                            }
                            onTextEdited: {
                                if(text!==""){
                                    opacityCursor.x = Number(text)/100 * (layout_opacity.width-12)
                                }
                            }
                        }
                        FluText{
                            text: control.opacityText
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }
        }
    }
}
