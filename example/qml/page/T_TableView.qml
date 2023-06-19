import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import "qrc:///example/qml/component"

FluScrollablePage{

    title:"TableView"

    Component.onCompleted: {
        const columns = [
                          {
                              title: '姓名',
                              dataIndex: 'name',
                              width:100,

                          },
                          {
                              title: '年龄',
                              dataIndex: 'item_age',
                              width:100,
                              minimumWidth:100
                          },
                          {
                              title: '住址',
                              dataIndex: 'address',
                              width:200
                          },
                          {
                              title: '别名',
                              dataIndex: 'nickname',
                              width:100
                          },
                          {
                              title: '操作',
                              dataIndex: 'action',
                              width:120
                          },
                      ];
        table_view.columns = columns
        loadData(1,10)
    }

    Component{
        id:com_age
        Item{
            id:item_age
            property var ageArr: [100,300,500,1000]
            height: 60
            FluComboBox{
                width: 80
                anchors{
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 10
                }
                model: ListModel {
                    ListElement { text: 100 }
                    ListElement { text: 300 }
                    ListElement { text: 500 }
                    ListElement { text: 1000 }
                }
                Component.onCompleted: {
                    currentIndex=ageArr.findIndex((element) => element === dataModel.age)
                }
            }
        }
    }

    Component{
        id:com_action
        Item{
            height: 60
            Row{
                anchors.centerIn: parent
                spacing: 10
                FluFilledButton{
                    text:"编辑"
                    horizontalPadding: 6
                    onClicked:{
                        showError(JSON.stringify(dataObject))
                    }
                }
                FluFilledButton{
                    text:"删除"
                    horizontalPadding: 6
                    onClicked:{
                        tableView.remove(dataModel.index)
                    }
                }
            }
        }
    }

    FluText{
        Layout.topMargin: 20
        text:"此TableView适用于小数据量，带分页的表格，大数据量请使用TableView2。"
    }

    FluTableView{
        id:table_view
        Layout.fillWidth: true
        Layout.topMargin: 20
        pageCurrent:1
        pageCount:10
        itemCount: 1000
        onRequestPage:
            (page,count)=> {
                loadData(page,count)
            }
    }

    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: 10
        code:'FluTableView{
    id:table_view
    Layout.fillWidth: true
    Layout.topMargin: 20
    pageCurrent:1
    pageCount:10
    itemCount: 1000
    onRequestPage:
            (page,count)=> {
                loadData(page,count)
            }
    Component.onCompleted: {
        const columns = [
                          {
                              title: "姓名",
                              dataIndex: "name",
                              width:100
                          },
                          {
                              title: "年龄",
                              dataIndex: "age",
                              width:100
                          },
                          {
                              title: "住址",
                              dataIndex: "address",
                              width:200
                          },
                          {
                              title: "别名",
                              dataIndex: "nickname",
                              width:100
                          }
                      ];
        table_view.columns = columns
        const dataSource = [
                {
                    name: "孙悟空”,
                    age: 500,
                    address:"钟灵毓秀的花果山,如神仙仙境的水帘洞",
                    nickname:"齐天大圣"
                }
        ];
        table_view.dataSource = columns
    }
}'
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
                                item_age: com_age,
                                age:getRandomAge(),
                                address: getRandomAddresses(),
                                nickname: getRandomNickname(),
                                action:com_action
                            })
        }
        table_view.dataSource = dataSource
    }
}
