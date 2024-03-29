import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title: qsTr("ComboBox")

    FluArea{
        Layout.fillWidth: true
        Layout.preferredHeight: 80
        padding: 5
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

    FluArea {
        Layout.fillWidth: true
        Layout.preferredHeight: 80
        padding: 5
        Layout.topMargin: 20
        Column{
            spacing: 5
            anchors.verticalCenter: parent.verticalCenter
            FluText{
                text: "disabled=true"
                x:10
            }
            FluComboBox {
                disabled: true
                model: ListModel {
                    id: model_2
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
        padding: 10
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
                    id: model_3
                    ListElement { text: "Banana" }
                    ListElement { text: "Apple" }
                    ListElement { text: "Coconut" }
                }
                onAccepted: {
                    if (find(editText) === -1)
                        model_3.append({text: editText})
                }
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -6
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
