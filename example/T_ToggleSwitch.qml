import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI

FluScrollablePage{

    title:"ToggleSwitch"

    FluToggleSwitch{
        Layout.topMargin: 20
    }
    FluToggleSwitch{
        Layout.topMargin: 20
        text:"Disabled"
    }
}
