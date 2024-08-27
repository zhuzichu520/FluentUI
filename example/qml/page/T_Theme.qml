import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    property var colorData: [FluColors.Yellow,FluColors.Orange,FluColors.Red,FluColors.Magenta,FluColors.Purple,FluColors.Blue,FluColors.Teal,FluColors.Green]
    id: root
    title: qsTr("Theme")

    FluFrame{
        Layout.fillWidth: true
        Layout.fillHeight: true
        padding: 10

        ColumnLayout{
            spacing:0
            anchors{
                left: parent.left
            }
            FluText{
                text: qsTr("Theme colors")
                Layout.topMargin: 10
            }
            RowLayout{
                Layout.topMargin: 5
                Repeater{
                    model: root.colorData
                    delegate:  Rectangle{
                        width: 42
                        height: 42
                        radius: 4
                        color: mouse_item.containsMouse ? Qt.lighter(modelData.normal,1.1) : modelData.normal
                        border.color: modelData.darker
                        FluIcon {
                            anchors.centerIn: parent
                            iconSource: FluentIcons.AcceptMedium
                            iconSize: 15
                            visible: modelData === FluTheme.accentColor
                            color: FluTheme.dark ? Qt.rgba(0,0,0,1) : Qt.rgba(1,1,1,1)
                        }
                        MouseArea{
                            id:mouse_item
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                FluTheme.accentColor = modelData
                            }
                        }
                    }
                }
            }
            Row{
                Layout.topMargin: 10
                spacing: 10
                FluText{
                    text: qsTr("Customize the Theme Color")
                    anchors.verticalCenter: parent.verticalCenter
                }
                FluColorPicker{
                    id:color_picker
                    current: FluTheme.accentColor.normal
                    onAccepted: {
                       FluTheme.accentColor = FluColors.createAccentColor(current)
                    }
                    FluIcon {
                        anchors.centerIn: parent
                        iconSource: FluentIcons.AcceptMedium
                        iconSize: 15
                        visible: {
                            for(var i =0 ;i< root.colorData.length; i++){
                                if(root.colorData[i] === FluTheme.accentColor){
                                    return false
                                }
                            }
                            return true
                        }
                        color: FluTheme.dark ? Qt.rgba(0,0,0,1) : Qt.rgba(1,1,1,1)
                    }
                }
            }
            FluText{
                text: qsTr("Dark Mode")
                Layout.topMargin: 20
            }
            FluToggleSwitch{
                Layout.topMargin: 5
                checked: FluTheme.dark
                onClicked: {
                    if(FluTheme.dark){
                        FluTheme.darkMode = FluThemeType.Light
                    }else{
                        FluTheme.darkMode = FluThemeType.Dark
                    }
                }
            }
            FluText{
                text: qsTr("Native Text")
                Layout.topMargin: 20
            }
            FluToggleSwitch{
                Layout.topMargin: 5
                checked: FluTheme.nativeText
                onClicked: {
                    FluTheme.nativeText = !FluTheme.nativeText
                }
            }
            FluText{
                text: qsTr("Open Animation")
                Layout.topMargin: 20
            }
            FluToggleSwitch{
                Layout.topMargin: 5
                checked: FluTheme.animationEnabled
                onClicked: {
                    FluTheme.animationEnabled = !FluTheme.animationEnabled
                }
            }
            FluText{
                text: qsTr("Rounded Window")
                Layout.topMargin: 20
            }
            FluToggleSwitch{
                Layout.topMargin: 5
                checked: window.roundCornerEnable
                onClicked: {
                    window.roundCornerEnable = !window.roundCornerEnable
                }
            }
            FluText{
                text: qsTr("Open Blur Window")
                Layout.topMargin: 20
            }
            FluToggleSwitch{
                id: toggle_blur
                Layout.topMargin: 5
                checked: FluTheme.blurBehindWindowEnabled
                onClicked: {
                    FluTheme.blurBehindWindowEnabled = !FluTheme.blurBehindWindowEnabled
                }
            }
            FluText{
                visible: FluTheme.blurBehindWindowEnabled || window.effect === "dwm-blur"
                text: qsTr("window tintOpacity")
                Layout.topMargin: 20
            }
            FluSlider{
                visible: FluTheme.blurBehindWindowEnabled || window.effect === "dwm-blur"
                Layout.topMargin: 5
                to:1
                stepSize:0.1
                onValueChanged: {
                    window.tintOpacity = value
                }
                Component.onCompleted: {
                    value = window.tintOpacity
                }
            }
            FluText{
                visible: FluTheme.blurBehindWindowEnabled
                text: qsTr("window blurRadius")
                Layout.topMargin: 20
            }
            FluSlider{
                visible: FluTheme.blurBehindWindowEnabled
                Layout.topMargin: 5
                to:100
                stepSize:1
                onValueChanged: {
                    window.blurRadius = value
                }
                Component.onCompleted: {
                    value = window.blurRadius
                }
            }
            FluText{
                text: qsTr("window effect")
                Layout.topMargin: 20
            }
            Row{
                spacing: 10
                Repeater{
                    model: window.availableEffects
                    delegate: FluRadioButton{
                        checked: window.effect === modelData
                        text: qsTr(`${modelData}`)
                        clickListener:function(){
                            window.effect = modelData
                            if(window.effective){
                                FluTheme.blurBehindWindowEnabled = false
                                toggle_blur.checked = Qt.binding( function() {return FluTheme.blurBehindWindowEnabled})
                            }
                        }
                    }

                }
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -6
        code:'FluTheme.accentColor = FluColors.Orange

FluTheme.dark = true

FluTheme.nativeText = true'
    }


}
