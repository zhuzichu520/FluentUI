import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import "qrc:///global/"
import "./component"

FluScrollablePage{

    title:"Settings"
    leftPadding:10
    rightPadding:10
    bottomPadding:20
    spacing: 0

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 168
        paddings: 10

        ColumnLayout{
            spacing: 10
            anchors{
                top: parent.top
                left: parent.left
            }

            FluText{
                text:lang.navigation_view_display_mode
                fontStyle: FluText.BodyStrong
                Layout.bottomMargin: 4
            }

            Repeater{
                id:repeater
                model: [{title:"Open",mode:FluNavigationView.Open},{title:"Compact",mode:FluNavigationView.Compact},{title:"Minimal",mode:FluNavigationView.Minimal},{title:"Auto",mode:FluNavigationView.Auto}]
                delegate:  FluRadioButton{
                    selected : MainEvent.displayMode===modelData.mode
                    text:modelData.title
                    onClicked:{
                        MainEvent.displayMode = modelData.mode
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
                fontStyle: FluText.BodyStrong
                Layout.bottomMargin: 4
            }

            Flow{
                spacing: 5
                Repeater{
                    model: ["Zh","En"]
                    delegate:  FluRadioButton{
                        selected : appInfo.lang.objectName === modelData
                        text:modelData
                        onClicked:{
                            console.debug(modelData)
                            appInfo.changeLang(modelData)
                        }
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
                text:lang.dark_mode
                fontStyle: FluText.BodyStrong
                Layout.bottomMargin: 4
            }

            Flow{
                spacing: 5
                FluToggleSwitch{
                    text:lang.sys_dark_mode
                    selected:FluTheme.dark
                    onClicked:{
                        FluTheme.follow_system = true
                        FluTheme.dark = FluTheme.follow_system
                    }
                }
            }
        }

    }

}
