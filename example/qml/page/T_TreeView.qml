import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "qrc:///example/qml/component"
import "../component"

FluScrollablePage {

    title:"TreeView"

    function treeData(){
        const dig = (path = '0', level = 4) => {
            const list = [];
            for (let i = 0; i < 9; i += 1) {
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
        height: 80
        Column{
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10
            FluText{
                text:"高性能树控件，新的TreeView用TableView实现！！"
            }
            FluText{
                text:"共计：%1条数据，当前显示的%2条数据".arg(tree_view.count()).arg(tree_view.visibleCount())
            }
        }
    }
    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 10
        paddings: 10
        height: 420
        Item{
            anchors.fill: tree_view
            FluShadow{}
        }
        FluTreeView{
            id:tree_view
            width:slider_width.value
            anchors{
                top:parent.top
                left:parent.left
                bottom:parent.bottom
            }
            draggable:switch_draggable.checked
            showLine: switch_showline.checked
            Component.onCompleted: {
                var data = treeData()
                dataSource = data
            }
        }
        Column{
            spacing: 15
            anchors{
                top:parent.top
                topMargin: 10
                bottomMargin: 10
                rightMargin: 10
                bottom:parent.bottom
                right: parent.right
            }
            RowLayout{
                spacing: 10
                FluText{
                    text:"width:"
                    Layout.alignment: Qt.AlignVCenter
                }
                FluSlider{
                    id:slider_width
                    value: 280
                    from: 160
                    to:400
                }
            }
            FluToggleSwitch{
                id:switch_showline
                text:"showLine"
                checked: true
            }
            FluToggleSwitch{
                id:switch_draggable
                text:"draggable"
                checked: true
            }
            FluButton{
                text:"all expand"
                onClicked: {
                    tree_view.allExpand()
                }
            }
            FluButton{
                text:"all collapse"
                onClicked: {
                    tree_view.allCollapse()
                }
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
