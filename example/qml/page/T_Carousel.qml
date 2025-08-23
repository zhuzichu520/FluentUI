import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title: qsTr("Carousel")

    ListModel{
        id:data_model
        ListElement{
            url:"qrc:/example/res/image/banner_1.jpg"
        }
        ListElement{
            url:"qrc:/example/res/image/banner_2.jpg"
        }
        ListElement{
            url:"qrc:/example/res/image/banner_3.jpg"
        }
    }

    FluFrame{
        Layout.fillWidth: true
        padding: 10
        ColumnLayout {
            anchors {
                left: parent.left
                right: parent.right
            }
            FluText {
                text: qsTr("Carousel map, support infinite carousel, infinite swipe, and components implemented with ListView")
            }
            RowLayout {
                FluText {
                    text: qsTr("Play orientation:")
                }
                FluComboBox {
                    id: orientation_box
                    textRole: "key"
                    valueRole: "value"
                    model: ListModel {
                        ListElement {
                            key: qsTr("Horizontal")
                            value: Qt.Horizontal
                        }
                        ListElement {
                            key: qsTr("Vertical")
                            value: Qt.Vertical
                        }
                    }
                }
                FluText {
                    text: qsTr("Indicator position:")
                }
                FluComboBox {
                    id: position_box
                    textRole: "key"
                    valueRole: "value"
                    model: orientation_box.currentValue === Qt.Horizontal ? [{
                                                                                 "key": qsTr("top"),
                                                                                 "value": Qt.AlignHCenter | Qt.AlignTop
                                                                             }, {
                                                                                 "key": qsTr("bottom"),
                                                                                 "value": Qt.AlignHCenter | Qt.AlignBottom
                                                                             }] : [{
                                                                                       "key": qsTr("right"),
                                                                                       "value": Qt.AlignVCenter | Qt.AlignRight
                                                                                   }, {
                                                                                       "key": qsTr("left"),
                                                                                       "value": Qt.AlignVCenter | Qt.AlignLeft
                                                                                   }]
                }
            }
            FluToggleSwitch{
                id: auto_play_switch
                text: qsTr("Auto play")
                checked: true
                textRight: false
            }
            Item{
                Layout.preferredWidth: 400
                Layout.preferredHeight: 300
                FluShadow{
                    radius: 8
                }
                FluCarousel{
                    anchors.fill: parent
                    orientation: orientation_box.currentValue
                    autoPlay: auto_play_switch.checked
                    loopTime:1500
                    indicatorGravity: position_box.currentValue
                    indicatorMarginTop: 15
                    indicatorMarginBottom: 15
                    indicatorMarginLeft: 15
                    indicatorMarginRight: 15
                    delegate: Component{
                        Item{
                            anchors.fill: parent
                            Image {
                                anchors.fill: parent
                                source: model.url
                                asynchronous: true
                                fillMode:Image.PreserveAspectCrop
                            }
                            Rectangle{
                                height: 40
                                width: parent.width
                                anchors.bottom: parent.bottom
                                color: "#33000000"
                                FluText{
                                    anchors.fill: parent
                                    verticalAlignment: Qt.AlignVCenter
                                    horizontalAlignment: Qt.AlignHCenter
                                    text:model.title
                                    color: FluColors.Grey10
                                }
                            }
                        }
                    }
                    Layout.topMargin: 20
                    Layout.leftMargin: 5
                    Component.onCompleted: {
                        var arr = []
                        arr.push({url:"qrc:/example/res/image/banner_1.jpg",title:"共同应对全球性问题"})
                        arr.push({url:"qrc:/example/res/image/banner_2.jpg",title:"三小只全程没互动"})
                        arr.push({url:"qrc:/example/res/image/banner_3.jpg",title:"有效投资扩大 激发增长动能"})
                        model = arr
                    }
                }
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -6
        code:'FluCarousel{
    id:carousel
    width: 400
    height: 300
    orientation: Qt.Vertical
    indicatorGravity: Qt.AlignTop | Qt.AlignHCenter
    autoPlay: true
    delegate: Component{
        Image {
            anchors.fill: parent
            source: model.url
            asynchronous: true
            fillMode:Image.PreserveAspectCrop
        }
    }
    Component.onCompleted: {
        carousel.model = [{url:"qrc:/example/res/image/banner_1.jpg"},{url:"qrc:/example/res/image/banner_2.jpg"},{url:"qrc:/example/res/image/banner_3.jpg"}]
    }
}'
    }
}
