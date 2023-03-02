import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15
import FluentUI 1.0

Item {

    ColumnLayout{
        spacing: 5

        FluText{
            text:"TextBox"
            fontStyle: FluText.TitleLarge
        }
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
    }
}
