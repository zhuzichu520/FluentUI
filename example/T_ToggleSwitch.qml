import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import FluentUI 1.0

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
