import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0

Item {

    ColumnLayout{
        spacing: 5


        FluText{
            text:"Controls"
            fontStyle: FluText.TitleLarge
        }



        FluButton{

            Layout.topMargin: 20
        }

        FluFilledButton{
            onClicked:{
                FluApp.navigate("/Setting")
                console.debug("FluFilledButton:"+Window.window.x)
            }
        }

        FluFilledButton{
            disabled: true
            onClicked:{
                console.debug("FluFilledButton-disabled")
            }
        }

        FluIconButton{
            Component.onCompleted: {

            }
            icon:FluentIcons.FA_android
        }

        FluToggleSwitch{

        }

    }


}
