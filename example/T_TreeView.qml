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

    function randomName() {
        var names = ["张三", "李四", "王五", "赵六", "钱七", "孙八", "周九", "吴十"]
        return names[Math.floor(Math.random() * names.length)]
    }

    function randomCompany() {
        var companies = ["阿里巴巴", "腾讯", "百度", "京东", "华为", "小米", "字节跳动", "美团", "滴滴"]
        return companies[Math.floor(Math.random() * companies.length)]
    }

    function randomDepartment() {
        var departments = ["技术部", "销售部", "市场部", "人事部", "财务部", "客服部", "产品部", "设计部", "运营部"]
        return departments[Math.floor(Math.random() * departments.length)]
    }

    function createEmployee() {
        var name = randomName()
        return tree_view.createItem(name, false)
    }

    function createSubtree(numEmployees) {
        var employees = []
        for (var i = 0; i < numEmployees; i++) {
            employees.push(createEmployee())
        }
        return tree_view.createItem(randomDepartment(), true, employees)
    }

    function createOrg(numLevels, numSubtrees, numEmployees) {
        if (numLevels === 0) {
            return []
        }
        var subtrees = []
        for (var i = 0; i < numSubtrees; i++) {
            subtrees.push(createSubtree(numEmployees))
        }
        return [tree_view.createItem(randomCompany(), true, subtrees)].concat(createOrg(numLevels - 1, numSubtrees, numEmployees))
    }


    FluTreeView{
        id:tree_view
        width:240
        anchors{
            top:title.bottom
            left:parent.left
            bottom:parent.bottom
        }
        onItemClicked:
            (model)=>{
                showSuccess(model.text)
            }

        Component.onCompleted: {
            var org = createOrg(3, 3, 3)
            updateData(org)

        }

    }


    ColumnLayout{
        anchors{
            left: tree_view.right
            right: parent.right
            top: parent.top
        }

        FluText{
            text:{
                if(tree_view.selectionMode === FluTreeView.None){
                    return "selectionMode->FluTreeView.None"
                }
                if(tree_view.selectionMode === FluTreeView.Single){
                    return "selectionMode->FluTreeView.Single"
                }
                if(tree_view.selectionMode === FluTreeView.Multiple){
                    return "selectionMode->FluTreeView.Multiple"
                }
            }
        }

        FluButton{
            text:"None"
            onClicked: {
                tree_view.selectionMode = FluTreeView.None
            }
        }

        FluButton{
            text:"Single"
            onClicked: {
                tree_view.selectionMode = FluTreeView.Single
            }
        }

        FluButton{
            text:"Multiple"
            onClicked: {
                tree_view.selectionMode = FluTreeView.Multiple
            }
        }

        FluFilledButton{
            text:"获取选中的数据"
            onClicked: {
                if(tree_view.selectionMode === FluTreeView.None){
                    showError("当前非选择模式,没有选中的数据")
                }
                if(tree_view.selectionMode === FluTreeView.Single){
                    showSuccess(tree_view.signleData().text)
                }
                if(tree_view.selectionMode === FluTreeView.Multiple){
                    if(tree_view.multipData().length===0){
                        showError("没有选中数据")
                        return
                    }
                    var info = []
                    tree_view.multipData().map((value)=>info.push(value.text))
                    showSuccess(info.join(","))
                }
            }
        }

    }
}
