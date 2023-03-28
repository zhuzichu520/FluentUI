import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import FluentUI 1.0

FluScrollablePage{

    title:"Slider"
    leftPadding:10
    rightPadding:10
    bottomPadding:20

    FluSlider{
        Layout.topMargin: 20
        value: 50
        Layout.leftMargin: 10
    }
    FluSlider{
        orientation:FluSlider.Vertical
        Layout.topMargin: 20
        Layout.leftMargin: 10
        Layout.bottomMargin: 20
        value: 50
    }
}
