import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15
import FluentUI 1.0

Item {
    FluText{
        id:title
        text:"TextBox"
        fontStyle: FluText.TitleLarge
    }
    ScrollView{
        clip: true
        width: parent.width
        contentWidth: parent.width
        anchors{
            top: title.bottom
            bottom: parent.bottom
        }
        ColumnLayout{
            spacing: 5
            FluTextBox{
                Layout.topMargin: 20
                placeholderText: "单行输入框"
                Layout.preferredWidth: 300
            }
            FluMultiLineTextBox{
                Layout.topMargin: 20
                Layout.preferredWidth: 300
                placeholderText: "多行输入框"
            }
            FluAutoSuggestBox{
                Layout.topMargin: 20
                values:generateRandomNames(100)
                placeholderText: "AutoSuggestBox"
                Layout.preferredWidth: 300
            }
        }
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
        names.push(name);
      }
      return names;
    }


}
