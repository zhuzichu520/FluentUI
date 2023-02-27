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
            onClicked: {

            }
        }

        FluFilledButton{
            onClicked:{
                FluApp.navigate("/Setting")
            }
        }

        FluFilledButton{
            disabled: true
            onClicked:{
            }
        }

        FluIconButton{
            Component.onCompleted: {

            }
            icon:FluentIcons.FA_close
        }

        FluToggleSwitch{

        }

    }


}
