import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import "../component"

FluScrollablePage{

    property string password: ""
    property var loginPageRegister: registerForWindowResult("/login")

    title: qsTr("MultiWindow")

    Connections{
        target: loginPageRegister
        function onResult(data)
        {
            password = data.password
        }
    }

    FluArea{
        Layout.fillWidth: true
        height: 86
        paddings: 10
        Layout.topMargin: 20
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
                    FluApp.navigate("/standardWindow")
                }
            }
        }
    }

    FluArea{
        Layout.fillWidth: true
        height: 86
        paddings: 10
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
                    FluApp.navigate("/singleTaskWindow")
                }
            }
        }
    }

    FluArea{
        Layout.fillWidth: true
        height: 86
        paddings: 10
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
                    FluApp.navigate("/singleInstanceWindow")
                }
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluWindow{
  //launchMode: FluWindowType.Standard
  //launchMode: FluWindowType.SingleTask
     launchMode: FluWindowType.SingleInstance
}
'
    }


    FluArea{
        Layout.fillWidth: true
        height: 100
        paddings: 10
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
                    FluApp.navigate("/about")
                }
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluButton{
    text: qsTr("Create Window")
    onClicked: {
        FluApp.navigate("/about")
    }
}
'
    }

    FluArea{
        Layout.fillWidth: true
        height: 130
        paddings: 10
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
                    loginPageRegister.launch({username:"zhuzichu"})
                }
            }
            FluText{
                text:qsTr("Login Window Returned Password - >")+password
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'property var loginPageRegister: registerForWindowResult("/login")

Connections{
    target: loginPageRegister
    function onResult(data)
    {
        password = data.password
    }
}

FluButton{
    text: qsTr("Create Window")
    onClicked: {
        loginPageRegister.launch({username:"zhuzichu"})
    }
}
'
    }

}
