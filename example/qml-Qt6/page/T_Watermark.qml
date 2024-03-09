import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import "../component"

FluContentPage{

    title: qsTr("Watermark")

    FluArea{
        anchors.fill: parent
        anchors.topMargin: 20

        ColumnLayout{
            anchors{
                left: parent.left
                leftMargin: 14
            }

            RowLayout{
                spacing: 10
                Layout.topMargin: 14
                FluText{
                    text: "text:"
                    Layout.alignment: Qt.AlignVCenter
                }
                FluTextBox{
                    id: text_box
                    text: "会磨刀的小猪"
                    Layout.preferredWidth: 240
                }
            }

            RowLayout{
                spacing: 10
                FluText{
                    text: "textSize:"
                    Layout.alignment: Qt.AlignVCenter
                }
                FluSlider{
                    id: slider_text_size
                    value: 20
                    from: 13
                    to:50
                }
            }
            RowLayout{
                spacing: 10
                FluText{
                    text: "gapX:"
                    Layout.alignment: Qt.AlignVCenter
                }
                FluSlider{
                    id:slider_gap_x
                    value: 100
                }
            }
            RowLayout{
                spacing: 10
                FluText{
                    text: "gapY:"
                    Layout.alignment: Qt.AlignVCenter
                }
                FluSlider{
                    id: slider_gap_y
                    value: 100
                }
            }
            RowLayout{
                spacing: 10
                FluText{
                    text: "offsetX:"
                    Layout.alignment: Qt.AlignVCenter
                }
                FluSlider{
                    id:slider_offset_x
                    value: 50
                }
            }
            RowLayout{
                spacing: 10
                FluText{
                    text: "offsetY:"
                    Layout.alignment: Qt.AlignVCenter
                }
                FluSlider{
                    id: slider_offset_y
                    value: 50
                }
            }
            RowLayout{
                spacing: 10
                FluText{
                    text: "rotate:"
                    Layout.alignment: Qt.AlignVCenter
                }
                FluSlider{
                    id: slider_rotate
                    value: 22
                    from: 0
                    to:360
                }
            }
            RowLayout{
                spacing: 10
                FluText{
                    text: "textColor:"
                    Layout.alignment: Qt.AlignVCenter
                }
                FluColorPicker{
                    id: color_picker
                    current: Qt.rgba(0,0,0,0.1)
                }
            }
        }

        FluWatermark{
            id: water_mark
            anchors.fill: parent
            text:text_box.text
            textColor: color_picker.current
            textSize: slider_text_size.value
            rotate: slider_rotate.value
            gap:Qt.point(slider_gap_x.value,slider_gap_y.value)
            offset: Qt.point(slider_offset_x.value,slider_offset_y.value)
        }
    }

}
