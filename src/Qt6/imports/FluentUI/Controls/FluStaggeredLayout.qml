import QtQuick

Item {
    property int itemWidth : 200
    property alias model: rep.model
    property alias delegate: rep.delegate
    property int rowSpacing: 8
    property int colSpacing: 8
    id: control
    QtObject{
        id:d
        property int cellWidth : itemWidth+rowSpacing
        property int colCount: {
            var cols = parseInt(control.width/cellWidth)
            return cols>0?cols:1
        }
        property var colsHeightArr: []
        property int maxHeight: 0
        property var itemsInRep: []
        onMaxHeightChanged: {
            control.implicitHeight = maxHeight
        }
        onColCountChanged: {
            refresh()
        }
        function refresh(){
            d.colsHeightArr = []
            var count = itemsInRep.length
            for(var i=0; i<count; ++i){
                addToFall(i, itemsInRep[i])
            }
        }
        function addToFall(index, item){
            var top = 0,left = 0
            if(index<colCount){
                colsHeightArr.push(item.height)
                left = index * cellWidth
            }else{
                var minHeight = Math.min.apply(null, colsHeightArr)
                var minIndex = colsHeightArr.indexOf(minHeight)
                top = minHeight + control.colSpacing
                left = minIndex * cellWidth
                colsHeightArr[minIndex] = top + item.height
            }
            item.x = left
            item.y = top
            item.width = control.itemWidth
            maxHeight = Math.max.apply(null, colsHeightArr)
        }
    }
    Repeater {
        id: rep
        onCountChanged: {
            d.refresh()
        }
        onItemAdded:
            (index,item)=>  {
                d.addToFall(index, item)
                d.itemsInRep.push(item)
            }
    }
    function clear(){
        d.maxHeight = 0
        d.colsHeightArr = []
        d.itemsInRep = []
        model.clear()
    }
}
