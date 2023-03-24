import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

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
