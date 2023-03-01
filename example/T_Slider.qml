import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15
import FluentUI 1.0

Item {

    ColumnLayout{
        spacing: 5


        FluText{
            text:"Slider"
            fontStyle: FluText.TitleLarge
        }

        FluSlider{
            Layout.topMargin: 20
            value: 50
        }


    }


}
