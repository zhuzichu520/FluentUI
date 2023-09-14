import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import "qrc:///example/qml/component"

FluScrollablePage {

    title:"TreeView"

    function treeData(){
        const dig = (path = '0', level = 4) => {
            const list = [];
            for (let i = 0; i < 6; i += 1) {
                const key = `${path}-${i}`;
                const treeNode = {
                    title: key,
                    key,
                };
                if (level > 0) {
                    treeNode.children = dig(key, level - 1);
                }
                list.push(treeNode);
            }
            return list;
        };
        return dig();
    }

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 10
        paddings: 10
        height: 60
        FluText{
            text:"共计：%1条数据".arg(tree_view.count())
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 10
        paddings: 10
        height: 400
        FluTreeView{
            id:tree_view
            width:240
            anchors{
                top:parent.top
                left:parent.left
                bottom:parent.bottom
            }
            Component.onCompleted: {
                var data = treeData()
                dataSource = data
            }
        }
    }

    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluTreeView{
    id:tree_view
    width:240
    height:600
    Component.onCompleted: {
        var data = treeData()
        dataSource = data
    }
}
'
    }
}
