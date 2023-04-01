import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI

FluScrollablePage{

    title:"TextBox"
    leftPadding:10
    rightPadding:10
    bottomPadding:20

    FluTextBox{
        Layout.topMargin: 20
        placeholderText: "单行输入框"
        Layout.preferredWidth: 300
        disabled:toggle_switch.selected
    }
    FluMultilineTextBox{
        Layout.topMargin: 20
        Layout.preferredWidth: 300
        placeholderText: "多行输入框"
        disabled:toggle_switch.selected
    }
    FluAutoSuggestBox{
        Layout.topMargin: 20
        items:generateRandomNames(100)
        placeholderText: "AutoSuggestBox"
        Layout.preferredWidth: 300
        disabled:toggle_switch.selected
    }

    FluToggleSwitch{
        id:toggle_switch
        text:"Disabled"
        Layout.topMargin: 20
    }

    function generateRandomNames(numNames) {
        const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        const names = [];
        function generateRandomName() {
            const nameLength = Math.floor(Math.random() * 5) + 4;
            let name = '';
            for (let i = 0; i < nameLength; i++) {
                const letterIndex = Math.floor(Math.random() * 26);
                name += alphabet.charAt(letterIndex);
            }
            return name;
        }
        for (let i = 0; i < numNames; i++) {
            const name = generateRandomName();
            names.push({title:name});
        }
        return names;
    }


}
