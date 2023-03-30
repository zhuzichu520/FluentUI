import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI

FluScrollablePage{

    title:"CheckBox"
    leftPadding:10
    rightPadding:10
    bottomPadding:20

    FluCheckBox{
        Layout.topMargin: 20
    }

    FluCheckBox{
        Layout.topMargin: 20
        text:"Text"
    }

}
