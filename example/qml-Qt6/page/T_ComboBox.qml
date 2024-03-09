import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import "../component"

FluScrollablePage{

    title: qsTr("ComboBox")

    FluArea{
        Layout.fillWidth: true
        height: 80
        paddings: 5
        Layout.topMargin: 20
        Column{
            spacing: 5
            anchors.verticalCenter: parent.verticalCenter
            FluText{
                text: "editable=false"
                x:10
            }
            FluComboBox {
                model: ListModel {
                    id: model_1
                    ListElement { text: "Banana" }
                    ListElement { text: "Apple" }
                    ListElement { text: "Coconut" }
                }
            }
        }
    }

    FluArea{
        Layout.fillWidth: true
        height: 80
        paddings: 10
        Layout.topMargin: 20
        Column{
            spacing: 5
            anchors.verticalCenter: parent.verticalCenter
            FluText{
                text: "editable=true"
                x:5
            }
            FluComboBox {
                editable: true
                model: ListModel {
                    id: model_2
                    ListElement { text: "Banana" }
                    ListElement { text: "Apple" }
                    ListElement { text: "Coconut" }
                }
                onAccepted: {
                    if (find(editText) === -1)
                        model_2.append({text: editText})
                }
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluComboBox{
    editable: true
    model: ListModel {
        id: model
        ListElement { text: "Banana" }
        ListElement { text: "Apple" }
        ListElement { text: "Coconut" }
    }
    onAccepted: {
        if (find(editText) === -1)
            model.append({text: editText})
    }
}'
    }

}
