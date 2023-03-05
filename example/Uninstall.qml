import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 1.3 as Dialogs
import Qt.labs.platform 1.1
import FluentUI 1.0

FluWindow {

    id:window
    width: 800
    height: 400
    minimumWidth:800
    maximumWidth:800
    minimumHeight:400
    maximumHeight:400
    title:"卸载向导"

    FluAppBar{
        id:appbar
        title: "卸载向导"
    }

    ColumnLayout{

        width: parent.width

        anchors{
            top: appbar.bottom
            bottom: parent.bottom
            topMargin: 20
        }



        Item{
            Layout.preferredWidth : parent.width
            Layout.fillHeight: true
            FluText{
                text:"青山不改，绿水长流，有缘再见"
                anchors.centerIn: parent
                fontStyle:FluText.TitleLarge
            }
        }

        Rectangle{

            Layout.fillWidth: true
            border.width: 1
            border.color: FluApp.isDark ? Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(238/255,238/255,238/255,1)

            height: 60
            color: FluApp.isDark ? "#323232" : "#FFFFFF"
            RowLayout{
                anchors{
                    right: parent.right
                    rightMargin: 30
                    verticalCenter: parent.verticalCenter
                }
                spacing: 14
                FluButton{
                    text:"取消"
                    onClicked: {
                        window.close()
                    }
                }
                FluButton{
                    text:"确定要卸载"
                    onClicked: {
                        installHelper.uninstall()
                    }
                }
            }
        }
    }
}
