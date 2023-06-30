import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import "qrc:///example/qml/component"

FluContentPage{

    title:"TableView"

    Component.onCompleted: {
        loadData(1,1000)
    }

    Component{
        id:com_action
        Item{
            RowLayout{
                anchors.centerIn: parent
                FluButton{
                    text:"删除"
                    onClicked: {
                        table_view.closeEditor()
                        tableModel.removeRow(row)
                    }
                }
                FluFilledButton{
                    text:"编辑"
                    onClicked: {
                        showSuccess(JSON.stringify(tableModel.getRow(row)))
                    }
                }
            }
        }
    }

    function loadData(page,count){
        var numbers = [100, 300, 500, 1000];
        function getRandomAge() {
            var randomIndex = Math.floor(Math.random() * numbers.length);
            return numbers[randomIndex];
        }
        var names = ["孙悟空", "猪八戒", "沙和尚", "唐僧","白骨夫人","金角大王","熊山君","黄风怪","银角大王"];
        function getRandomName(){
            var randomIndex = Math.floor(Math.random() * names.length);
            return names[randomIndex];
        }
        var nicknames = ["复海大圣","混天大圣","移山大圣","通风大圣","驱神大圣","齐天大圣","平天大圣"]
        function getRandomNickname(){
            var randomIndex = Math.floor(Math.random() * nicknames.length);
            return nicknames[randomIndex];
        }
        var addresses = ["傲来国界花果山水帘洞","傲来国界坎源山脏水洞","大唐国界黑风山黑风洞","大唐国界黄风岭黄风洞","大唐国界骷髅山白骨洞","宝象国界碗子山波月洞","宝象国界平顶山莲花洞","宝象国界压龙山压龙洞","乌鸡国界号山枯松涧火云洞","乌鸡国界衡阳峪黑水河河神府"]
        function getRandomAddresses(){
            var randomIndex = Math.floor(Math.random() * addresses.length);
            return addresses[randomIndex];
        }
        const dataSource = []
        for(var i=0;i<count;i++){
            dataSource.push({
                                name: getRandomName(),
                                age:getRandomAge(),
                                address: getRandomAddresses(),
                                nickname: getRandomNickname(),
                                longstring:"你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好",
                                height:46,
                                minimumHeight:46,
                                maximumHeight:300,
                                action:com_action
                            })
        }
        table_view.dataSource = dataSource
    }

    Component{
        id:com_combobox
        FluComboBox {
            anchors.fill: parent
            focus: true
            currentIndex: display
            editable: true
            model: ListModel {
                ListElement { text: 100 }
                ListElement { text: 300 }
                ListElement { text: 500 }
                ListElement { text: 1000 }
            }
            Component.onCompleted: {
                currentIndex=[100,300,500,1000].findIndex((element) => element === Number(display))
                selectAll()
            }
            onCommit: {
                display = editText
                tableView.closeEditor()
            }
        }
    }

    FluTableView{
        id:table_view
        anchors{
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: gagination.top
        }
        anchors.topMargin: 20
        columnSource:[
            {
                title: '姓名',
                dataIndex: 'name',
                width:100,
                minimumWidth:80,
                maximumWidth:200,
                readOnly:true
            },
            {
                title: '年龄',
                dataIndex: 'age',
                editDelegate:com_combobox,
                width:100,
                minimumWidth:100,
                maximumWidth:100
            },
            {
                title: '住址',
                dataIndex: 'address',
                width:200,
                minimumWidth:100,
                maximumWidth:250
            },
            {
                title: '别名',
                dataIndex: 'nickname',
                width:100,
                minimumWidth:80,
                maximumWidth:200
            },
            {
                title: '长字符串',
                dataIndex: 'longstring',
                width:200,
                minimumWidth:100,
                maximumWidth:300
            },
            {
                title: '操作',
                dataIndex: 'action',
                width:160,
                minimumWidth:160,
                maximumWidth:160
            }
        ]
    }

    FluPagination{
        id:gagination
        anchors{
            bottom: parent.bottom
            left: parent.left
        }
        pageCurrent: 1
        itemCount: 100000
        pageButtonCount: 7
        __itemPerPage: 1000
        onRequestPage:
            (page,count)=> {
                table_view.closeEditor()
                loadData(page,count)
                table_view.resetPosition()
            }
    }



}
