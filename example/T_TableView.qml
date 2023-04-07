import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import "./component"

FluScrollablePage{

    title:"TableView"
    leftPadding:10
    rightPadding:10
    bottomPadding:20
    spacing: 0

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
                              width:100
                          },
                      ];
        table_view.columns = columns
        loadData(1,10)
    }


    FluTableView{
        id:table_view
        Layout.fillWidth: true
        Layout.topMargin: 20
        width:parent.width
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
            Row{
                anchors.centerIn: parent
                spacing: 10
                FluFilledButton{
                    text:"编辑"
                    topPadding:3
                    bottomPadding:3
                    leftPadding:3
                    rightPadding:3
                    onClicked:{
                        console.debug(dataModel.index)
                        showSuccess(JSON.stringify(dataObject))
                    }
                }
                FluFilledButton{
                    text:"删除"
                    topPadding:3
                    bottomPadding:3
                    leftPadding:3
                    rightPadding:3
                    onClicked:{
                        showError(JSON.stringify(dataObject))
                    }
                }
            }
        }
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
