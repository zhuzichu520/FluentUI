import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 1.3 as Dialogs
import Qt.labs.platform 1.1
import UI 1.0
import FluentUI 1.0

FluWindow {

    id:window
    width: 800
    height: 400
    minimumWidth:800
    maximumWidth:800
    minimumHeight:400
    maximumHeight:400
    title:"安装向导"

    property string installPath: "C:\\Program Files"
    property string installName: "FluentUI"

    FluAppBar{
        id:appbar
        title: "安装向导"
    }


    Item{
        id:data
        InstallHelper{
            id:helper
        }
        Dialogs.FileDialog {
            id: fileDialog
            selectFolder: true
            folder: "file:///"+installPath
            onAccepted: {
                installPath = String(fileDialog.fileUrls[0]).replace("file:///","").replace(RegExp("/",'g'),"\\")
            }
        }
    }


    ColumnLayout{

        width: parent.width

        anchors{
            top: appbar.bottom
            bottom: parent.bottom
            topMargin: 20
        }

        RowLayout{

            width: parent.width

            FluText{
                text:"安装路径:"
                Layout.leftMargin: 30
            }

            FluTextBox{
                id:textbox_path
                Layout.preferredHeight: 40
                Layout.fillWidth: true
                text:installPath+ "\\" +installName
                readOnly:true
            }

            FluButton{
                text:"更改路径"
                Layout.rightMargin: 30
                onClicked: {
                    fileDialog.open()
                }
            }
        }

        FluCheckBox{
            id:checkbox_startmenu
            Layout.topMargin: 20
            Layout.leftMargin: 30
            checked: true
            text:"创建启动菜单快捷方式"
        }
        FluCheckBox{
            id:checkbox_home
            Layout.leftMargin: 30
            Layout.topMargin: 5
            checked: true
            text:"创建桌面图标"
        }

        Item{
            width: 1
            Layout.fillHeight: true
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
                FluFilledButton{
                    text:"同意并安装"
                    onClicked: {
                        helper.install(textbox_path.text,checkbox_home.checked,checkbox_startmenu.checked)
                    }
                }
                FluButton{
                    text:"不安装直接运行"
                    onClicked: {
                        FluApp.navigate("/")
                        window.close()
                    }
                }
            }
        }
    }

    Rectangle{

        anchors.fill: parent
        visible: helper.installing
        color: "#80000000"

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
        }

        FluProgressBar{
            id:progress
            anchors.centerIn: parent
        }

        FluText{
            text:"正在安装..."
            color:"#FFFFFF"
            font.pixelSize: 20
            anchors{
                horizontalCenter: progress.horizontalCenter
                bottom: progress.top
                bottomMargin: 10
            }
        }

    }

}
