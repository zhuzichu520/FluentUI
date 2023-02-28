import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15
import FluentUI 1.0

Item {

    ColumnLayout{
        spacing: 5

        FluText{
            text:"Rectangle"
            fontStyle: FluText.TitleLarge
        }

        FluRectangle{
            width: 50
            height: 50
            color:"#ffeb3b"
            radius:[15,0,0,0]
        }

        FluRectangle{
            width: 50
            height: 50
            color:"#f7630c"
            radius:[0,15,0,0]
        }

        FluRectangle{
            width: 50
            height: 50
            color:"#e71123"
            radius:[0,0,15,0]
        }

        FluRectangle{
            width: 50
            height: 50
            color:"#b4009e"
            radius:[0,0,0,15]
        }

        FluRectangle{
            width: 50
            height: 50
            color:"#744da9"
            radius:[15,15,15,15]
        }

        FluRectangle{
            width: 50
            height: 50
            color:"#0078d4"
            radius:[0,0,0,0]
        }
    }
}
