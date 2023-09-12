import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import "qrc:///example/qml/global"
import "qrc:///example/qml/component"
import "qrc:///example/qml/viewmodel"

FluScrollablePage{

    title:"Settings"

    SettingsViewModel{
        id:viewmodel_settings
    }

    FluEvent{
        id:event_checkupdate_finish
        name: "checkUpdateFinish"
        onTriggered: {
            btn_checkupdate.loading = false
        }
    }

    Component.onCompleted: {
        FluEventBus.registerEvent(event_checkupdate_finish)
    }

    Component.onDestruction: {
        FluEventBus.unRegisterEvent(event_checkupdate_finish)
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
                text:"当前版本 v%1".arg(appInfo.version)
                font: FluTextStyle.Body
                anchors.verticalCenter: parent.verticalCenter
            }
            FluLoadingButton{
                id:btn_checkupdate
                text:"检查更新"
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
        height: 128
        paddings: 10

        ColumnLayout{
            spacing: 5
            anchors{
                top: parent.top
                left: parent.left
            }
            FluText{
                text:lang.dark_mode
                font: FluTextStyle.BodyStrong
                Layout.bottomMargin: 4
            }
            Repeater{
                model: [{title:"System",mode:FluThemeType.System},{title:"Light",mode:FluThemeType.Light},{title:"Dark",mode:FluThemeType.Dark}]
                delegate:  FluRadioButton{
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
                text:lang.navigation_view_display_mode
                font: FluTextStyle.BodyStrong
                Layout.bottomMargin: 4
            }
            Repeater{
                model: [{title:"Open",mode:FluNavigationViewType.Open},{title:"Compact",mode:FluNavigationViewType.Compact},{title:"Minimal",mode:FluNavigationViewType.Minimal},{title:"Auto",mode:FluNavigationViewType.Auto}]
                delegate: FluRadioButton{
                    checked : viewmodel_settings.displayMode===modelData.mode
                    text:modelData.title
                    clickListener:function(){
                        viewmodel_settings.displayMode = modelData.mode
                    }
                }
            }
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
                text:lang.locale
                font: FluTextStyle.BodyStrong
                Layout.bottomMargin: 4
            }

            Flow{
                spacing: 5
                Repeater{
                    model: ["Zh","En"]
                    delegate: FluRadioButton{
                        checked: appInfo.lang.objectName === modelData
                        text:modelData
                        clickListener:function(){
                            appInfo.changeLang(modelData)
                        }
                    }
                }
            }
        }
    }

}
