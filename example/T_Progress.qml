import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI

FluScrollablePage{
    title:"Progress"

    FluProgressBar{
        Layout.topMargin: 20
    }
    FluProgressRing{
        Layout.topMargin: 10
    }
    FluProgressBar{
        id:progress_bar
        Layout.topMargin: 20
        indeterminate: false
    }
    FluProgressRing{
        id:progress_ring
        Layout.topMargin: 10
        indeterminate: false
    }
    FluSlider{
        Layout.topMargin: 30
        value:50
        onValueChanged:{
            progress_bar.progress = value/100
            progress_ring.progress = value/100
        }
        Layout.bottomMargin: 30
    }
}
