import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0
import QtGraphicalEffects 1.15
import "qrc:///example/qml/component"

FluScrollablePage{

    title:"QRCode"

    FluQRCode{
        id:qrcode
        Layout.topMargin: 20
        size:slider_size.value
        text:text_box.text
        color:color_picker.colorValue
        bgColor: bgcolor_picker.colorValue
        margins:slider_margins.value
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
        Layout.topMargin: 10
        FluText{
            text:"bgColor:"
            Layout.alignment: Qt.AlignVCenter
        }
        FluColorPicker{
            id:bgcolor_picker
            Component.onCompleted: {
                setColor(Qt.rgba(1,1,1,1))
            }
        }
    }

    RowLayout{
        spacing: 10
        FluText{
            text:"margins:"
            Layout.alignment: Qt.AlignVCenter
        }
        FluSlider{
            id:slider_margins
            from:0
            to:80
            value: 0
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
            from:120
            to:260
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
