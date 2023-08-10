import QtQuick
import QtQuick.Controls
import FluentUI

Item{
    property alias model: repeater.model
    id:control

    width: layout_column.width
    height: layout_column.height

    Rectangle{
        color: Qt.rgba(240/255,240/255,240/255,1)
        height: parent.height
        width: 2
        anchors{
            left: parent.left
            leftMargin: 7
        }
    }

    Component{
        id:com_dot
        Rectangle{
            width: 16
            height: 16
            radius: 8
            border.width: 4
            border.color: FluTheme.primaryColor.dark
        }
    }

    Column{
        id:layout_column
        spacing: 30
        Repeater{
            id:repeater
            Item{
                width: item_text.width
                height: item_text.height

                Loader{
                    sourceComponent: {
                        if(model.dot)
                            return model.dot()
                        return com_dot
                    }
                }

                FluText{
                    id:item_text
                    anchors{
                        left: parent.left
                        leftMargin: 30
                    }
                    text: model.text
                }
            }

        }
    }


}
