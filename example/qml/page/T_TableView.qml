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
                              width:100
                          },
                          {
                              title: '年龄',
                              dataIndex: 'age',
                              width:100
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
                        showSuccess(JSON.stringify(dataObject))
                    }
                }
                FluFilledButton{
                    text:"删除"
                    horizontalPadding: 6
                    onClicked:{
                        showError(JSON.stringify(dataObject))
                    }
                }
            }
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
        const dataSource = []
        for(var i=0;i<count;i++){
            dataSource.push({
                                name: "孙悟空%1".arg(((page-1)*count+i)),
                                age: 500,
                                address: "钟灵毓秀的花果山,如神仙仙境的水帘洞",
                                nickname: "齐天大圣",
                                action:com_action
                            })
        }
        table_view.dataSource = dataSource
    }
}
