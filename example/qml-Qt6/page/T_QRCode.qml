import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import "../component"

FluScrollablePage{

    title:"QRCode"

    FluQRCode{
        id:qrcode
        Layout.topMargin: 20
        size:slider_size.value
        text:text_box.text
        color:color_picker.current
        bgColor: bgcolor_picker.current
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
            Layout.preferredWidth: 240
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
            current: Qt.rgba(0,0,0,1)
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
            current: Qt.rgba(1,1,1,1)
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
