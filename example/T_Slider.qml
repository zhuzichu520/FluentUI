import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

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
