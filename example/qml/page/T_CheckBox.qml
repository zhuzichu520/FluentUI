import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title: qsTr("CheckBox")

    QtObject {
        id: controller
        readonly property bool checked: allChecked()
        readonly property bool indeterminate: !allChecked() && anyChecked()
        property var items: []
        function addItem(id, item) {
            const ref = items
            ref.push({
                         "id": id,
                         "item": item
                     })
            items = ref
        }
        function setItemChecked(id, checked) {
            const ref = items
            const index = ref.findIndex(obj => obj.id === id)
            if (index !== -1) {
                ref[index].item.checked = checked
            }
            items = ref
        }
        function setAllChecked(checked) {
            const ref = items
            ref.forEach(obj => obj.item.checked = checked)
            items = ref
        }
        function allChecked() {
            return items.every(obj => obj.item.checked)
        }
        function anyChecked() {
            return items.some(obj => obj.item.checked)
        }
    }

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 72
        padding: 10

        FluText{
            text: qsTr("A 2-state CheckBox")
        }

        Row{
            spacing: 30
            anchors{
                top: parent.top
                topMargin: 30
            }
            FluCheckBox{
                disabled: check_box_switch_two.checked
            }
            FluCheckBox{
                disabled: check_box_switch_two.checked
                text: qsTr("Right")
            }
            FluCheckBox{
                disabled: check_box_switch_two.checked
                text: qsTr("Left")
                textRight: false
            }
        }
        FluToggleSwitch{
            id:check_box_switch_two
            anchors{
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            text: qsTr("Disabled")
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -6
        code:'FluCheckBox{
    text:"Text"
}'
    }

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 72
        padding: 10
        Layout.topMargin: 20

        FluText{
            text: qsTr("A 3-state CheckBox")
        }

        Row{
            spacing: 30
            anchors{
                top: parent.top
                topMargin: 30
            }
            FluCheckBox{
                property int count: 1
                text: qsTr("Three State")
                disabled: check_box_switch_three.checked
                clickListener: function(){
                    var flag = count%3
                    if(flag === 0){
                        checked = false
                        indeterminate = false
                    }
                    if(flag === 1){
                        checked = true
                        indeterminate = false
                    }
                    if(flag === 2){
                        checked = true
                        indeterminate = true
                    }
                    count++
                }
            }
        }
        FluToggleSwitch{
            id:  check_box_switch_three
            anchors{
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            text: qsTr("Disabled")
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -6
        code:'FluCheckBox{
    text:"Text"
    indeterminate:true
}'
    }

    FluFrame{
        Layout.fillWidth: true
        padding: 10
        Layout.topMargin: 20

        ColumnLayout {
            FluText{
                text: qsTr("Using a 3-state CheckBox")
            }
            FluCheckBox {
                text: qsTr("Select all")
                checked: controller.checked
                indeterminate: controller.indeterminate
                clickListener: function () {
                    controller.setAllChecked(!checked)
                }
            }
            Repeater {
                model: 3
                FluCheckBox {
                    Layout.leftMargin: 24
                    text: qsTr("Option %1").arg(index)
                    clickListener: function () {
                        controller.setItemChecked(this.toString(), !checked)
                    }
                }
                onItemAdded: (index, item) => {
                    controller.addItem(item.toString(), item)
                    if (index === count - 1) {
                        controller.setItemChecked(item.toString(), true)
                    }
                }
            }
        }
    }
}
