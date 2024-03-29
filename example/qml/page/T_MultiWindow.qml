import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    property string password: ""

    title: qsTr("MultiWindow")

    FluWindowResultLauncher{
        id:loginResultLauncher
        path: "/login"
        onResult:
            (data)=>{
                password = data.password
            }

    }

    FluArea{
        Layout.fillWidth: true
        Layout.preferredHeight: 86
        padding: 10
        Column{
            spacing: 15
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            FluText{
                text: qsTr("<font color='red'>Standard</font> mode window，a new window is created every time")
            }
            FluButton{
                text: qsTr("Create Window")
                onClicked: {
                    FluRouter.navigate("/standardWindow")
                }
            }
        }
    }

    FluArea{
        Layout.fillWidth: true
        Layout.preferredHeight: 86
        padding: 10
        Layout.topMargin: 10
        Column{
            spacing: 15
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            FluText{
                text: qsTr("<font color='red'>SingleTask</font> mode window，If a window exists, this activates the window")
                textFormat: Text.RichText
            }
            FluButton{
                text: qsTr("Create Window")
                onClicked: {
                    FluRouter.navigate("/singleTaskWindow")
                }
            }
        }
    }

    FluArea{
        Layout.fillWidth: true
        Layout.preferredHeight: 86
        padding: 10
        Layout.topMargin: 10
        Column{
            spacing: 15
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            FluText{
                text: qsTr("<font color='red'>SingleInstance</font> mode window，If the window exists, destroy the window and create a new window")
            }
            FluButton{
                text: qsTr("Create Window")
                onClicked: {
                    FluRouter.navigate("/singleInstanceWindow")
                }
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -6
        code:'FluWindow{
  //launchMode: FluWindowType.Standard
  //launchMode: FluWindowType.SingleTask
     launchMode: FluWindowType.SingleInstance
}
'
    }


    FluArea{
        Layout.fillWidth: true
        Layout.preferredHeight: 100
        padding: 10
        Layout.topMargin: 20
        Column{
            spacing: 15
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            FluText{
                text: qsTr("Create the window without carrying any parameters")
            }
            FluButton{
                text: qsTr("Create Window")
                onClicked: {
                    FluRouter.navigate("/about")
                }
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -6
        code:'FluButton{
    text: qsTr("Create Window")
    onClicked: {
        FluRouter.navigate("/about")
    }
}
'
    }

    FluArea{
        Layout.fillWidth: true
        Layout.preferredHeight: 130
        padding: 10
        Layout.topMargin: 20

        Column{
            spacing: 15
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            FluText{
                text: qsTr("Create a window with the parameter username: zhuzichu")
            }
            FluButton{
                text: qsTr("Create Window")
                onClicked: {
                    loginResultLauncher.launch({username:"zhuzichu"})
                }
            }
            FluText{
                text:qsTr("Login Window Returned Password - >")+password
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -6
        code:'FluWindowResultLauncher{
    id:loginResultLauncher
    path: "/login"
    onResult:
        (data)=>{
            password = data.password
     }
}

FluButton{
    text: qsTr("Create Window")
    onClicked: {
        loginResultLauncher.launch({username:"zhuzichu"})
    }
}
'
    }

}
