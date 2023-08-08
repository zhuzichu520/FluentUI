import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import Qt5Compat.GraphicalEffects
import "qrc:///example/qml/component"

FluScrollablePage{

    title:"QRCode"

    FluQRCode{
        id:qrcode
        Layout.topMargin: 20
        size:slider_size.value
        text:text_box.text
        color:color_picker.colorValue
        Layout.preferredWidth: size
        Layout.preferredHeight: size
    }

    RowLayout{
        spacing: 10
        Layout.topMargin: 20
        FluText{
            text:"text:"
            Layout.alignment: Qt.AlignVCenter
        }
        FluTextBox{
            id:text_box
            text:"会磨刀的小猪"
        }
    }

    RowLayout{
        spacing: 10
        Layout.topMargin: 10
        FluText{
            text:"color:"
            Layout.alignment: Qt.AlignVCenter
        }
        FluColorPicker{
            id:color_picker
            Component.onCompleted: {
                setColor(Qt.rgba(0,0,0,1))
            }
        }
    }

    RowLayout{
        spacing: 10
        FluText{
            text:"size:"
            Layout.alignment: Qt.AlignVCenter
        }
        FluSlider{
            id:slider_size
            from:60
            to:200
            value: 120
        }
    }

    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: 20
        code:'FluQRCode{
    color:"red"
    text:"会磨刀的小猪"
    size:100
}'
    }

}
