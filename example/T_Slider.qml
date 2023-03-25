import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI

FluScrollablePage{

    title:"Slider"

    FluSlider{
        Layout.topMargin: 20
        Layout.leftMargin: 15
        value: 50
    }
    FluSlider{
        orientation:FluSlider.Vertical
        Layout.topMargin: 20
        Layout.leftMargin: 15
        value: 50
    }
}
