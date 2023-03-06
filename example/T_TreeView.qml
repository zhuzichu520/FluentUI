import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import FluentUI 1.0

Item {
    FluText{
        id:title
        text:"TreeView"
        fontStyle: FluText.TitleLarge
    }
    FluTreeView{
        id:tree_view
        width:100
        anchors{
            top:title.bottom
            left:parent.left
            bottom:parent.bottom
        }
        Component.onCompleted: {

        }

    }
}
