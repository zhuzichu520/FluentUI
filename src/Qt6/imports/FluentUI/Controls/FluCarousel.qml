import QtQuick
import QtQuick.Controls
import FluentUI

Item {
    property bool autoPlay: true
    property int orientation: Qt.Horizontal
    property int loopTime: 2000
    property var model
    property Component delegate
    property bool showIndicator: true
    property int indicatorGravity : Qt.AlignBottom | Qt.AlignHCenter
    property int indicatorMarginLeft: 0
    property int indicatorMarginRight: 0
    property int indicatorMarginTop: 0
    property int indicatorMarginBottom: 20
    property int indicatorSpacing: 10
    property alias indicatorAnchors: indicator_loader.anchors
    property Component indicatorDelegate : com_indicator
    id:control
    implicitWidth: 400
    implicitHeight: 300
    onIndicatorGravityChanged: {
        indicator_loader.updateAnchors()
    }
    ListModel{
        id:content_model
    }
    QtObject{
        id:d
        property bool isManualMoving: false
        property bool isAnimEnable: control.autoPlay && list_view.count>3
        onIsAnimEnableChanged: {
            if(isAnimEnable){
                timer_run.restart()
            }else{
                timer_run.stop()
            }
        }
        function setData(data){
            if(!data || !Array.isArray(data)){
                return
            }
            content_model.clear()
            list_view.resetPos()
            if(data.length === 0){
                return
            }
            content_model.append(data[data.length-1])
            content_model.append(data)
            content_model.append(data[0])
            list_view.highlightMoveDuration = 0
            list_view.currentIndex = 1
            list_view.highlightMoveDuration = 250
            if(d.isAnimEnable){
                timer_run.restart()
            }
        }
    }
    ListView{
        id:list_view
        anchors.fill: parent
        snapMode: ListView.SnapOneItem
        clip: true
        boundsBehavior: ListView.StopAtBounds
        model:content_model
        maximumFlickVelocity: 4 * (control.orientation === Qt.Vertical ? height : width)
        preferredHighlightBegin: 0
        preferredHighlightEnd: 0
        highlightMoveDuration: 0
        Component.onCompleted: {
            d.setData(control.model)
        }
        interactive: list_view.count>3
        Connections{
            target: control
            function onModelChanged(){
                d.setData(control.model)
            }
        }
        orientation : control.orientation
        delegate: Item{
            id:item_control
            width: ListView.view.width
            height: ListView.view.height
            property int displayIndex: {
                if(index === 0)
                    return content_model.count-3
                if(index === content_model.count-1)
                    return 0
                return index-1
            }
            FluLoader{
                property int displayIndex : item_control.displayIndex
                property var model: list_view.model.get(index)
                anchors.fill: parent
                sourceComponent: {
                    if(model){
                        return control.delegate
                    }
                    return undefined
                }
            }
        }
        onMovementEnded:{
            d.isManualMoving = false
            list_view.highlightMoveDuration = 0
            if(control.orientation === Qt.Vertical){
                currentIndex = (list_view.contentY - list_view.originY) / list_view.height
                if(currentIndex === 0){
                    currentIndex = list_view.count - 2
                }else if(currentIndex === list_view.count - 1) {
                    currentIndex = 1
                }
            } else {
                currentIndex = (list_view.contentX - list_view.originX) / list_view.width
                if(currentIndex === 0){
                    currentIndex = list_view.count - 2
                }else if(currentIndex === list_view.count - 1){
                    currentIndex = 1
                }
            }
            if(d.isAnimEnable){
                timer_run.restart()
            }
        }
        onMovementStarted: {
            d.isManualMoving = true
            timer_run.stop()
        }
        onContentXChanged: {
            if(d.isManualMoving && control.orientation === Qt.Horizontal){
                const range = getPosRange(list_view.width, currentIndex)
                if(contentX >= range.max){
                    contentX = range.max
                }
                if(contentX <= range.min){
                    contentX = range.min
                }
            }
        }
        onContentYChanged: {
            if(d.isManualMoving && control.orientation === Qt.Vertical){
                const range = getPosRange(list_view.height, currentIndex)
                if(contentY >= range.max){
                    contentY = range.max
                }
                if(contentY <= range.min){
                    contentY = range.min
                }
            }
        }
        onOrientationChanged: {
            positionViewAtIndex(currentIndex, ListView.Center)
        }
        function resetPos() {
            contentX = 0
            contentY = 0
        }
        function getPosRange(size, index) {
            return {
                "min": Math.max(0, size * (index - 1)),
                "max": Math.min(size * (index + 1), list_view.count * size)
            }
        }
    }
    Component{
        id:com_indicator
        Rectangle{
            width:  8
            height: 8
            radius: 4
            FluShadow{
                radius: 4
            }
            scale: checked ? 1.2 : 1
            color: checked ?  FluTheme.primaryColor : Qt.rgba(1,1,1,0.7)
            border.width: mouse_item.containsMouse ? 1 : 0
            border.color: FluTheme.primaryColor
            MouseArea{
                id:mouse_item
                hoverEnabled: true
                anchors.fill: parent
                onClicked: {
                    changedIndex(realIndex)
                }
            }
        }
    }

    Loader{
        id: indicator_loader
        active: showIndicator
        sourceComponent: control.orientation === Qt.Vertical ? column_indicator : row_indicator
        function updateAnchors() {
            anchors.horizontalCenter = undefined
            anchors.verticalCenter = undefined
            anchors.top = undefined
            anchors.bottom = undefined
            anchors.left = undefined
            anchors.right = undefined
            if (indicatorGravity & Qt.AlignHCenter) {
                anchors.horizontalCenter = parent.horizontalCenter
            }
            if (indicatorGravity & Qt.AlignVCenter) {
                anchors.verticalCenter = parent.verticalCenter
            }
            if (indicatorGravity & Qt.AlignTop) {
                anchors.top = parent.top
            }
            if (indicatorGravity & Qt.AlignBottom) {
                anchors.bottom = parent.bottom
            }
            if (indicatorGravity & Qt.AlignLeft) {
                anchors.left = parent.left
            }
            if (indicatorGravity & Qt.AlignRight) {
                anchors.right = parent.right
            }
            anchors.topMargin = Qt.binding(() => control.indicatorMarginTop)
            anchors.bottomMargin = Qt.binding(() => control.indicatorMarginBottom)
            anchors.leftMargin = Qt.binding(() => control.indicatorMarginLeft)
            anchors.rightMargin = Qt.binding(() => control.indicatorMarginRight)
        }
        Component.onCompleted: {
            updateAnchors()
        }
    }

    Component{
        id: row_indicator
        Row{
            id:layout_indicator
            spacing: control.indicatorSpacing
            Repeater{
                id:repeater_indicator
                model: list_view.count
                FluLoader{
                    property int displayIndex: {
                        if(index === 0)
                            return list_view.count-3
                        if(index === list_view.count-1)
                            return 0
                        return index-1
                    }
                    property int realIndex: index
                    property bool checked: list_view.currentIndex === index
                    sourceComponent: {
                        if(index===0 || index===list_view.count-1)
                            return undefined
                        return control.indicatorDelegate
                    }
                }
            }
        }
    }

    Component{
        id: column_indicator
        Column{
            id:layout_indicator
            spacing: control.indicatorSpacing
            Repeater{
                id:repeater_indicator
                model: list_view.count
                FluLoader{
                    property int displayIndex: {
                        if(index === 0)
                            return list_view.count-3
                        if(index === list_view.count-1)
                            return 0
                        return index-1
                    }
                    property int realIndex: index
                    property bool checked: list_view.currentIndex === index
                    sourceComponent: {
                        if(index===0 || index===list_view.count-1)
                            return undefined
                        return control.indicatorDelegate
                    }
                }
            }
        }
    }

    Timer{
        id:timer_anim
        interval: 250
        onTriggered: {
            list_view.highlightMoveDuration = 0
            if(list_view.currentIndex === list_view.count-1){
                list_view.currentIndex = 1
            }
        }
    }
    Timer{
        id:timer_run
        interval: control.loopTime
        repeat: d.isAnimEnable
        onTriggered: {
            list_view.highlightMoveDuration = 250
            list_view.currentIndex = list_view.currentIndex+1
            timer_anim.start()
        }
    }
    function changedIndex(index){
        d.isManualMoving = true
        timer_run.stop()
        list_view.currentIndex = index
        d.isManualMoving = false
        if(d.isAnimEnable){
            timer_run.restart()
        }
    }
}
