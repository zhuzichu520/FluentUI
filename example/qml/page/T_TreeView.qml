import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluContentPage {

    title: qsTr("TreeView")

    function treeData(){
        const names = ["孙悟空", "猪八戒", "沙和尚", "唐僧","白骨夫人","金角大王","熊山君","黄风怪","银角大王"]
        function getRandomName(){
            var randomIndex = Math.floor(Math.random() * names.length)
            return names[randomIndex]
        }
        const addresses = ["傲来国界花果山水帘洞","傲来国界坎源山脏水洞","大唐国界黑风山黑风洞","大唐国界黄风岭黄风洞","大唐国界骷髅山白骨洞","宝象国界碗子山波月洞","宝象国界平顶山莲花洞","宝象国界压龙山压龙洞","乌鸡国界号山枯松涧火云洞","乌鸡国界衡阳峪黑水河河神府"]
        function getRandomAddresses(){
            var randomIndex = Math.floor(Math.random() * addresses.length)
            return addresses[randomIndex]
        }
        const avatars = ["qrc:/example/res/svg/avatar_1.svg", "qrc:/example/res/svg/avatar_2.svg", "qrc:/example/res/svg/avatar_3.svg", "qrc:/example/res/svg/avatar_4.svg","qrc:/example/res/svg/avatar_5.svg","qrc:/example/res/svg/avatar_6.svg","qrc:/example/res/svg/avatar_7.svg","qrc:/example/res/svg/avatar_8.svg","qrc:/example/res/svg/avatar_9.svg","qrc:/example/res/svg/avatar_10.svg","qrc:/example/res/svg/avatar_11.svg","qrc:/example/res/svg/avatar_12.svg"]
        function getRandomAvatar(){
            var randomIndex = Math.floor(Math.random() * avatars.length);
            return avatars[randomIndex];
        }
        const dig = (path = '0', level = 5) => {
            const list = [];
            for (let i = 0; i < 4; i += 1) {
                const key = `${path}-${i}`;
                const treeNode = {
                    title: key,
                    _key: key,
                    name: getRandomName(),
                    avatar:tree_view.customItem(com_avatar,{avatar:getRandomAvatar()}),
                    address: getRandomAddresses()
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

    Component{
        id:com_avatar
        Item{
            FluClip{
                anchors.centerIn: parent
                width: height
                height: parent.height/3*2
                radius: [height/2,height/2,height/2,height/2]
                Image{
                    anchors.fill: parent
                    source: {
                        if(options && options.avatar){
                            return options.avatar
                        }
                        return ""
                    }
                    sourceSize: Qt.size(80,80)
                }
            }
        }
    }
    FluFrame{
        id:layout_controls
        anchors{
            left: parent.left
            right: parent.right
            top: parent.top
            topMargin: 10
        }
        height: 80
        clip: true
        Row{
            spacing: 12
            anchors{
                left: parent.left
                leftMargin: 10
                verticalCenter: parent.verticalCenter
            }
            Column{
                anchors.verticalCenter: parent.verticalCenter
                RowLayout{
                    spacing: 10
                    FluText{
                        text: qsTr("cellHeight:")
                        Layout.alignment: Qt.AlignVCenter
                    }
                    FluSlider{
                        id: slider_cell_height
                        value: 38
                        from: 38
                        to:100
                    }
                }
                RowLayout{
                    spacing: 10
                    FluText{
                        text: qsTr("depthPadding:")
                        Layout.alignment: Qt.AlignVCenter
                    }
                    FluSlider{
                        id: slider_depth_padding
                        value: 15
                        from: 15
                        to:100
                    }
                }
            }
            Column{
                spacing: 8
                anchors.verticalCenter: parent.verticalCenter
                FluToggleSwitch{
                    id: switch_showline
                    text: qsTr("showLine")
                    checked: false
                }
                FluToggleSwitch{
                    id: switch_checkable
                    text: qsTr("checkable")
                    checked: false
                }
            }
            Column{
                spacing: 8
                anchors.verticalCenter: parent.verticalCenter
                FluButton{
                    text: qsTr("all expand")
                    onClicked: {
                        tree_view.allExpand()
                    }
                }
                FluButton{
                    text: qsTr("all collapse")
                    onClicked: {
                        tree_view.allCollapse()
                    }
                }
            }
            FluButton{
                text: qsTr("print selection model")
                onClicked: {
                    var printData = []
                    var data = tree_view.selectionModel();
                    console.debug(data.length)
                    for(var i = 0; i <= data.length-1 ; i++){
                        const newObj = Object.assign({}, data[i].data);
                        delete newObj["__parent"];
                        delete newObj["children"];
                        printData.push(newObj)
                    }
                    console.debug(JSON.stringify(printData))
                }
            }
        }
    }

    FluTreeView{
        id:tree_view
        anchors{
            left: parent.left
            top: layout_controls.bottom
            topMargin: 10
            bottom: parent.bottom
            right: parent.right
        }
        cellHeight: slider_cell_height.value
        showLine: switch_showline.checked
        checkable:switch_checkable.checked
        depthPadding: slider_depth_padding.value
        onCurrentChanged: {
            showInfo(current.data.title)
        }
        columnSource:[
            {
                title: qsTr("Title"),
                dataIndex: 'title',
                width: 300
            },{
                title: qsTr("Name"),
                dataIndex: 'name',
                width: 100
            },{
                title: qsTr("Avatar"),
                dataIndex: 'avatar',
                width: 100
            },{
                title: qsTr("Address"),
                dataIndex: 'address',
                width: 200
            },
        ]
        Component.onCompleted: {
            var data = treeData()
            dataSource = data
        }
    }
}
