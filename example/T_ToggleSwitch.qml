import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI

FluScrollablePage{

    title:"ToggleSwitch"
    leftPadding:10
    rightPadding:10
    bottomPadding:20

    FluToggleSwitch{
        Layout.topMargin: 20
    }
    FluToggleSwitch{
        Layout.topMargin: 20
        text:"Text"
    }
}
