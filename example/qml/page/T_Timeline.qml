import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import "qrc:///example/qml/component"

FluScrollablePage{

    title:"Timeline"

    Component{
        id:com_dot
        Rectangle{
            width: 16
            height: 16
            radius: 8
            border.width: 4
            border.color: FluColors.Green.dark
        }
    }


    ListModel{
        id:list_model

        ListElement{
            text:"Create a services site 2015-09-01"
        }
        ListElement{
            text:"Solve initial network problems 2015-09-01 \nSolve initial network problems 2015-09-01 \nSolve initial network problems 2015-09-01"
            dot:()=>com_dot
        }
        ListElement{
            text:"Technical testing 2015-09-01"
        }
        ListElement{
            text:"Network problems being solved 2015-09-01"
        }
    }

    RowLayout{
        spacing: 20
        Layout.topMargin: 20
        FluTextBox{
            id:text_box
            text:"Technical testing 2015-09-01"
        }
        FluFilledButton{
            text:"Append"
            onClicked: {
                list_model.append({text:text_box.text})
            }
        }
        FluFilledButton{
            text:"clear"
            onClicked: {
                list_model.clear()
            }
        }
    }

    FluArea{
        Layout.fillWidth: true
        height: time_line.height + 20
        paddings: 10
        Layout.topMargin: 10

        FluTimeline{
            id:time_line
            anchors.verticalCenter: parent.verticalCenter
            model:list_model
        }

    }

}
