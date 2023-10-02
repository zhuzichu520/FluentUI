import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0
import "qrc:///example/qml/component"
import "../component"

FluContentPage{

    id:root
    title:"TableView"
    signal checkBoxChanged

    property var dataSource : []
    property int sortType: 0

    Component.onCompleted: {
        loadData(1,1000)
    }

    onSortTypeChanged: {
        table_view.closeEditor()
        if(sortType === 0){
            table_view.sort()
        }else if(sortType === 1){
            table_view.sort((a, b) => a.age - b.age);
        }else if(sortType === 2){
            table_view.sort((a, b) => b.age - a.age);
        }
    }

    Component{
        id:com_checbox
        Item{
            FluCheckBox{
                anchors.centerIn: parent
                checked: true === options.checked
                enableAnimation: false
                clickListener: function(){
                    var obj = tableModel.getRow(row)
                    obj.checkbox = table_view.customItem(com_checbox,{checked:!options.checked})
                    tableModel.setRow(row,obj)
                    checkBoxChanged()
                }
            }
        }
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
                        checkBoxChanged()
                    }
                }
                FluFilledButton{
                    text:"编辑"
                    onClicked: {
                        var obj = tableModel.getRow(row)
                        obj.name = "12345"
                        tableModel.setRow(row,obj)
                        showSuccess(JSON.stringify(tableModel.getRow(row)))
                    }
                }
            }
        }
    }


    Component{
        id:com_column_checbox
        Item{
            RowLayout{
                anchors.centerIn: parent
                FluText{
                    text:"全选"
                    Layout.alignment: Qt.AlignVCenter
                }
                FluCheckBox{
                    checked: true === options.checked
                    enableAnimation: false
                    Layout.alignment: Qt.AlignVCenter
                    clickListener: function(){
                        var checked = !options.checked
                        itemModel.display = table_view.customItem(com_column_checbox,{"checked":checked})
                        for(var i =0;i< tableModel.rowCount ;i++){
                            var rowData = tableModel.getRow(i)
                            rowData.checkbox = table_view.customItem(com_checbox,{"checked":checked})
                            tableModel.setRow(i,rowData)
                        }
                    }
                }
                Connections{
                    target: root
                    function onCheckBoxChanged(){
                        for(var i =0;i< tableModel.rowCount ;i++){
                            if(false === tableModel.getRow(i).checkbox.options.checked){
                                itemModel.display = table_view.customItem(com_column_checbox,{"checked":false})
                                return
                            }
                        }
                        itemModel.display = table_view.customItem(com_column_checbox,{"checked":true})
                    }
                }
            }
        }
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

    Component{
        id:com_avatar
        Item{
            FluClip{
                anchors.centerIn: parent
                width: 40
                height: 40
                radius: [20,20,20,20]
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

    Component{
        id:com_column_sort_age
        Item{
            FluText{
                text:"年龄"
                anchors.centerIn: parent
            }
            ColumnLayout{
                spacing: 0
                anchors{
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: 4
                }
                FluIconButton{
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 15
                    iconSize: 12
                    verticalPadding:0
                    horizontalPadding:0
                    iconSource: FluentIcons.ChevronUp
                    iconColor: {
                        if(1 === root.sortType){
                            return FluTheme.primaryColor.dark
                        }
                        return FluTheme.dark ?  Qt.rgba(1,1,1,1) : Qt.rgba(0,0,0,1)
                    }
                    onClicked: {
                        if(root.sortType === 1){
                            root.sortType = 0
                            return
                        }
                        root.sortType = 1
                    }
                }
                FluIconButton{
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 15
                    iconSize: 12
                    verticalPadding:0
                    horizontalPadding:0
                    iconSource: FluentIcons.ChevronDown
                    iconColor: {
                        if(2 === root.sortType){
                            return FluTheme.primaryColor.dark
                        }
                        return FluTheme.dark ?  Qt.rgba(1,1,1,1) : Qt.rgba(0,0,0,1)
                    }
                    onClicked: {
                        if(root.sortType === 2){
                            root.sortType = 0
                            return
                        }
                        root.sortType = 2
                    }
                }
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
                title: table_view.customItem(com_column_checbox,{checked:true}),
                dataIndex: 'checkbox',
                width:80,
                minimumWidth:80,
                maximumWidth:80,
            },
            {
                title: '头像',
                dataIndex: 'avatar',
                width:100,
                minimumWidth:100,
                maximumWidth:100
            },
            {
                title: '姓名',
                dataIndex: 'name',
                readOnly:true,
            },
            {
                title: table_view.customItem(com_column_sort_age,{sort:0}),
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

        var avatars = ["qrc:/example/res/svg/avatar_1.svg", "qrc:/example/res/svg/avatar_2.svg", "qrc:/example/res/svg/avatar_3.svg", "qrc:/example/res/svg/avatar_4.svg","qrc:/example/res/svg/avatar_5.svg","qrc:/example/res/svg/avatar_6.svg","qrc:/example/res/svg/avatar_7.svg","qrc:/example/res/svg/avatar_8.svg","qrc:/example/res/svg/avatar_9.svg","qrc:/example/res/svg/avatar_10.svg","qrc:/example/res/svg/avatar_11.svg","qrc:/example/res/svg/avatar_12.svg"];
        function getAvatar(){
            var randomIndex = Math.floor(Math.random() * avatars.length);
            return avatars[randomIndex];
        }

        const dataSource = []
        for(var i=0;i<count;i++){
            dataSource.push({
                                checkbox: table_view.customItem(com_checbox,{checked:true}),
                                avatar:table_view.customItem(com_avatar,{avatar:getAvatar()}),
                                name: getRandomName(),
                                age:getRandomAge(),
                                address: getRandomAddresses(),
                                nickname: getRandomNickname(),
                                longstring:"你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好",
                                action: table_view.customItem(com_action),
                                minimumHeight:50
                            })
        }
        root.dataSource = dataSource
        table_view.dataSource = root.dataSource
    }

}
