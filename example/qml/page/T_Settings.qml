import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"
import "../global"

FluScrollablePage{

    title: qsTr("Settings")

    FluEvent{
        name: "checkUpdateFinish"
        onTriggered: {
            btn_checkupdate.loading = false
        }
    }

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 60
        paddings: 10
        Row{
            spacing: 20
            anchors.verticalCenter: parent.verticalCenter
            FluText{
                text: "%1 v%2".arg(qsTr("Current Version")).arg(AppInfo.version)
                font: FluTextStyle.Body
                anchors.verticalCenter: parent.verticalCenter
            }
            FluLoadingButton{
                id: btn_checkupdate
                text: qsTr("Check for Updates")
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    loading = true
                    FluEventBus.post("checkUpdate")
                }
            }
        }
    }

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 50
        paddings: 10
        FluCheckBox{
            text: qsTr("Use System AppBar")
            checked: FluApp.useSystemAppBar
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                FluApp.useSystemAppBar = !FluApp.useSystemAppBar
                dialog_restart.open()
            }
        }
    }

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 50
        paddings: 10
        FluCheckBox{
            text:qsTr("Fits AppBar Windows")
            checked: window.fitsAppBarWindows
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                window.fitsAppBarWindows = !window.fitsAppBarWindows
            }
        }
    }

    FluContentDialog{
        id: dialog_restart
        title: qsTr("Friendly Reminder")
        message: qsTr("This action requires a restart of the program to take effect, is it restarted?")
        buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
        negativeText: qsTr("Cancel")
        positiveText: qsTr("OK")
        onPositiveClicked: {
            FluRouter.exit(931)
        }
    }

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 128
        paddings: 10

        ColumnLayout{
            spacing: 5
            anchors{
                top: parent.top
                left: parent.left
            }
            FluText{
                text: qsTr("Dark Mode")
                font: FluTextStyle.BodyStrong
                Layout.bottomMargin: 4
            }
            Repeater{
                model: [{title:qsTr("System"),mode:FluThemeType.System},{title:qsTr("Light"),mode:FluThemeType.Light},{title:qsTr("Dark"),mode:FluThemeType.Dark}]
                delegate: FluRadioButton{
                    checked : FluTheme.darkMode === modelData.mode
                    text:modelData.title
                    clickListener:function(){
                        FluTheme.darkMode = modelData.mode
                    }
                }
            }
        }
    }

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 160
        paddings: 10

        ColumnLayout{
            spacing: 5
            anchors{
                top: parent.top
                left: parent.left
            }
            FluText{
                text:qsTr("Navigation View Display Mode")
                font: FluTextStyle.BodyStrong
                Layout.bottomMargin: 4
            }
            Repeater{
                model: [{title:qsTr("Open"),mode:FluNavigationViewType.Open},{title:qsTr("Compact"),mode:FluNavigationViewType.Compact},{title:qsTr("Minimal"),mode:FluNavigationViewType.Minimal},{title:qsTr("Auto"),mode:FluNavigationViewType.Auto}]
                delegate: FluRadioButton{
                    text: modelData.title
                    checked: GlobalModel.displayMode === modelData.mode
                    clickListener:function(){
                        GlobalModel.displayMode = modelData.mode
                    }
                }
            }
        }
    }

    ListModel{
        id:model_language
        ListElement{
            name:"en"
        }
        ListElement{
            name:"zh"
        }
    }

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 80
        paddings: 10

        ColumnLayout{
            spacing: 10
            anchors{
                top: parent.top
                left: parent.left
            }
            FluText{
                text:qsTr("Language")
                font: FluTextStyle.BodyStrong
                Layout.bottomMargin: 4
            }
            Flow{
                spacing: 5
                Repeater{
                    model: TranslateHelper.languages
                    delegate: FluRadioButton{
                        checked: TranslateHelper.current === modelData
                        text:modelData
                        clickListener:function(){
                            TranslateHelper.current = modelData
                            dialog_restart.open()
                        }
                    }
                }
            }
        }
    }
}
