import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI

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
        vertical:true
        Layout.topMargin: 20
        Layout.leftMargin: 10
        Layout.bottomMargin: 20
        value: 50
    }
}
