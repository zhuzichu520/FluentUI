import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Item {
    property url logo
    property string title: ""
    property FluObject items
    property FluObject footerItems
    property int displayMode: FluNavigationViewType.Auto
    property Component autoSuggestBox
    property Component actionItem
    property int topPadding: 0
    property int navWidth: 300
    property int pageMode: FluNavigationViewType.Stack
    property FluMenu navItemRightMenu
    property FluMenu navItemExpanderRightMenu
    signal logoClicked
    id:control
    Item{
        id:d
        property bool animDisabled:false
        property var stackItems: []
        property int displayMode: control.displayMode
        property bool enableNavigationPanel: false
        property bool isCompact: d.displayMode === FluNavigationViewType.Compact
        property bool isMinimal: d.displayMode === FluNavigationViewType.Minimal
        property bool isCompactAndPanel: d.displayMode === FluNavigationViewType.Compact && d.enableNavigationPanel
        property bool isCompactAndNotPanel:d.displayMode === FluNavigationViewType.Compact && !d.enableNavigationPanel
        property bool isMinimalAndPanel: d.displayMode === FluNavigationViewType.Minimal && d.enableNavigationPanel
        onIsCompactAndNotPanelChanged: {
            collapseAll()
        }
        function handleItems(){
            var _idx = 0
            var data = []
            if(items){
                for(var i=0;i<items.children.length;i++){
                    var item = items.children[i]
                    item._idx = _idx
                    data.push(item)
                    _idx++
                    if(item instanceof FluPaneItemExpander){
                        for(var j=0;j<item.children.length;j++){
                            var itemChild = item.children[j]
                            itemChild.parent = item
                            itemChild._idx = _idx
                            data.push(itemChild)
                            _idx++
                        }
                    }
                }
                if(footerItems){
                    var comEmpty = Qt.createComponent("FluPaneItemEmpty.qml");
                    for(var k=0;k<footerItems.children.length;k++){
                        var itemFooter = footerItems.children[k]
                        if (comEmpty.status === Component.Ready) {
                            var objEmpty = comEmpty.createObject(items,{_idx:_idx});
                            itemFooter._idx = _idx;
                            data.push(objEmpty)
                            _idx++
                        }
                    }
                }
            }
            return data
        }
    }
    Component.onCompleted: {
        d.displayMode = Qt.binding(function(){
            if(control.displayMode !==FluNavigationViewType.Auto){
                return control.displayMode
            }
            if(control.width<=700){
                return FluNavigationViewType.Minimal
            }else if(control.width<=900){
                return FluNavigationViewType.Compact
            }else{
                return FluNavigationViewType.Open
            }
        })
        timer_anim_delay.restart()
    }
    Timer{
        id:timer_anim_delay
        interval: 200
        onTriggered: {
            d.animDisabled = true
        }
    }
    Connections{
        target: d
        function onDisplayModeChanged(){
            if(d.displayMode === FluNavigationViewType.Compact){
                collapseAll()
            }
            d.enableNavigationPanel = false
            if(loader_auto_suggest_box.item){
                loader_auto_suggest_box.item.focus = false
            }
        }
    }
    Component{
        id:com_panel_item_empty
        Item{
            visible: false
        }
    }
    Component{
        id:com_panel_item_separatorr
        FluDivider{
            width: layout_list.width
            spacing: {
                if(model){
                    return model.spacing
                }
                return 1
            }
            separatorHeight: {
                if(!model){
                    return 1
                }
                if(model.parent){
                    return model.parent.isExpand ? model.size : 0
                }
                return model.size
            }
        }
    }
    Component{
        id:com_panel_item_header
        Item{
            height: {
                if(model.parent){
                    return model.parent.isExpand ? 30 : 0
                }
                return 30
            }
            Behavior on height {
                enabled: FluTheme.enableAnimation && d.animDisabled
                NumberAnimation{
                    duration: 83
                }
            }
            width: layout_list.width
            FluText{
                text:model.title
                font: FluTextStyle.BodyStrong
                anchors{
                    bottom: parent.bottom
                    left:parent.left
                    leftMargin: 10
                }
            }
        }
    }
    Component{
        id:com_panel_item_expander
        Item{
            height: 38
            width: layout_list.width
            FluControl{
                id:item_control
                anchors{
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                    topMargin: 2
                    bottomMargin: 2
                    leftMargin: 6
                    rightMargin: 6
                }
                MouseArea{
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton
                    onClicked:
                        (mouse) =>{
                            if (mouse.button === Qt.RightButton) {
                                if(model.menuDelegate){
                                    loader_item_menu.sourceComponent = model.menuDelegate
                                    loader_item_menu.item.popup()
                                }
                            }
                        }
                    z:-100
                }
                onClicked: {
                    if(d.isCompactAndNotPanel){
                        control_popup.showPopup(Qt.point(50,mapToItem(control,0,0).y),model.children)
                        return
                    }
                    model.isExpand = !model.isExpand
                }
                Rectangle{
                    color:Qt.rgba(255/255,77/255,79/255,1)
                    width: 10
                    height: 10
                    radius: 5
                    border.width: 1
                    border.color: Qt.rgba(1,1,1,1)
                    anchors{
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        rightMargin: 3
                        verticalCenterOffset: -8
                    }
                    visible: {
                        if(!model){
                            return false
                        }
                        if(!model.isExpand){
                            for(var i=0;i<model.children.length;i++){
                                var item = model.children[i]
                                if(item.infoBadge && item.count !==0){
                                    return true
                                }
                            }
                        }
                        return false
                    }
                }
                Rectangle{
                    radius: 4
                    anchors.fill: parent
                    Rectangle{
                        width: 3
                        height: 18
                        radius: 1.5
                        color: FluTheme.primaryColor.dark
                        visible: {
                            if(!model){
                                return false
                            }
                            if(!model.children){
                                return false
                            }
                            for(var i=0;i<model.children.length;i++){
                                var item = model.children[i]
                                if(item._idx === nav_list.currentIndex && !model.isExpand){
                                    return true
                                }
                            }
                            return false
                        }
                        anchors{
                            verticalCenter: parent.verticalCenter
                        }
                    }
                    FluIcon{
                        id:item_icon_expand
                        rotation: model&&model.isExpand?0:180
                        iconSource:FluentIcons.ChevronUp
                        iconSize: 15
                        anchors{
                            verticalCenter: parent.verticalCenter
                            right: parent.right
                            rightMargin: 12
                        }
                        visible: {
                            if(d.isCompactAndNotPanel){
                                return false
                            }
                            return true
                        }
                        Behavior on rotation {
                            enabled: FluTheme.enableAnimation && d.animDisabled
                            NumberAnimation{
                                duration: 167
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                    color: {
                        if(FluTheme.dark){
                            if((nav_list.currentIndex === _idx)&&type===0){
                                return Qt.rgba(1,1,1,0.06)
                            }
                            if(item_control.hovered){
                                return Qt.rgba(1,1,1,0.03)
                            }
                            return Qt.rgba(0,0,0,0)
                        }else{
                            if(nav_list.currentIndex === _idx&&type===0){
                                return Qt.rgba(0,0,0,0.06)
                            }
                            if(item_control.hovered){
                                return Qt.rgba(0,0,0,0.03)
                            }
                            return Qt.rgba(0,0,0,0)
                        }
                    }
                    Component{
                        id:com_icon
                        FluIcon{
                            iconSource: {
                                if(model&&model.icon){
                                    return model.icon
                                }
                                return 0
                            }
                            iconSize: 15
                        }
                    }
                    Item{
                        id:item_icon
                        width: 30
                        height: 30
                        anchors{
                            verticalCenter: parent.verticalCenter
                            left:parent.left
                            leftMargin: 3
                        }
                        Loader{
                            anchors.centerIn: parent
                            sourceComponent: {
                                if(model&&model.cusIcon){
                                    return model.cusIcon
                                }
                                return com_icon
                            }
                        }
                    }
                    FluText{
                        id:item_title
                        text:{
                            if(model){
                                return model.title
                            }
                            return ""
                        }
                        visible: {
                            if(d.isCompactAndNotPanel){
                                return false
                            }
                            return true
                        }
                        elide: Text.ElideRight
                        anchors{
                            verticalCenter: parent.verticalCenter
                            left:item_icon.right
                            right: item_icon_expand.left
                        }
                        color:{
                            if(item_control.pressed){
                                return FluTheme.dark ? FluColors.Grey80 : FluColors.Grey120
                            }
                            return FluTheme.dark ? FluColors.White : FluColors.Grey220
                        }
                    }
                    Loader{
                        id:item_edit_loader
                        anchors{
                            top: parent.top
                            bottom: parent.bottom
                            left: item_title.left
                            right: item_title.right
                            rightMargin: 8
                        }
                        sourceComponent: {
                            if(d.isCompact){
                                return undefined
                            }
                            return model&&model.showEdit ? model.editDelegate : undefined
                        }
                        onStatusChanged: {
                            if(status === Loader.Ready){
                                item.forceActiveFocus()
                                item_connection_edit_focus.target = item
                            }
                        }
                        Connections{
                            id:item_connection_edit_focus
                            ignoreUnknownSignals:true
                            function onActiveFocusChanged(focus){
                                if(focus === false){
                                    model.showEdit = false
                                }
                            }
                            function onCommit(text){
                                model.title = text
                                model.showEdit = false
                            }
                        }
                    }
                }
            }
        }
    }
    Component{
        id:com_panel_item
        Item{
            Behavior on height {
                enabled: FluTheme.enableAnimation && d.animDisabled
                NumberAnimation{
                    duration: 83
                }
            }
            height: {
                if(model&&model.parent){
                    return model.parent.isExpand ? 38 : 0
                }
                return 38
            }
            visible: {
                if(model&&model.parent){
                    return model.parent.isExpand ? true : false
                }
                return true
            }
            width: layout_list.width
            FluControl{
                property var modelData: model
                id:item_control
                anchors{
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                    topMargin: 2
                    bottomMargin: 2
                    leftMargin: 6
                    rightMargin: 6
                }
                Drag.active: item_mouse.drag.active
                Drag.hotSpot.x: item_control.width / 2
                Drag.hotSpot.y: item_control.height / 2
                Drag.dragType: Drag.Automatic
                onClicked:{
                    if(type === 0){
                        if(model.onTapListener){
                            model.onTapListener()
                        }else{
                            nav_list.currentIndex = _idx
                            layout_footer.currentIndex = -1
                            model.tap()
                            if(d.isMinimal || d.isCompact){
                                d.enableNavigationPanel = false
                            }
                        }
                    }else{
                        if(model.onTapListener){
                            model.onTapListener()
                        }else{
                            nav_list.currentIndex = nav_list.count-layout_footer.count+_idx
                            layout_footer.currentIndex = _idx
                            model.tap()
                            if(d.isMinimal || d.isCompact){
                                d.enableNavigationPanel = false
                            }
                        }
                    }
                }
                MouseArea{
                    id:item_mouse
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton | Qt.LeftButton
                    drag.target: item_control
                    onPositionChanged: {
                        parent.grabToImage(function(result) {
                            parent.Drag.imageSource = result.url;
                        })
                    }
                    drag.onActiveChanged:
                        if (active) {
                            parent.grabToImage(function(result) {
                                parent.Drag.imageSource = result.url;
                            })
                        }
                    onClicked:
                        (mouse)=>{
                            if (mouse.button === Qt.RightButton) {
                                if(model.menuDelegate){
                                    loader_item_menu.sourceComponent = model.menuDelegate
                                    loader_item_menu.item.popup();
                                }
                            }else{
                                item_control.clicked()
                            }
                        }
                }
                Rectangle{
                    radius: 4
                    anchors.fill: parent
                    color: {
                        if(FluTheme.dark){
                            if(type===0){
                                if(nav_list.currentIndex === _idx){
                                    return Qt.rgba(1,1,1,0.06)
                                }
                            }else{
                                if(nav_list.currentIndex === (nav_list.count-layout_footer.count+_idx)){
                                    return Qt.rgba(1,1,1,0.06)
                                }
                            }
                            if(item_control.hovered){
                                return Qt.rgba(1,1,1,0.03)
                            }
                            return Qt.rgba(0,0,0,0)
                        }else{
                            if(type===0){
                                if(nav_list.currentIndex === _idx){
                                    return Qt.rgba(0,0,0,0.06)
                                }
                            }else{
                                if(nav_list.currentIndex === (nav_list.count-layout_footer.count+_idx)){
                                    return Qt.rgba(0,0,0,0.06)
                                }
                            }
                            if(item_control.hovered){
                                return Qt.rgba(0,0,0,0.03)
                            }
                            return Qt.rgba(0,0,0,0)
                        }
                    }
                    Component{
                        id:com_icon
                        FluIcon{
                            iconSource: {
                                if(model&&model.icon){
                                    return model.icon
                                }
                                return 0
                            }
                            iconSize: 15
                        }
                    }
                    Item{
                        id:item_icon
                        width: 30
                        height: 30
                        anchors{
                            verticalCenter: parent.verticalCenter
                            left:parent.left
                            leftMargin: 3
                        }
                        Loader{
                            anchors.centerIn: parent
                            sourceComponent: {
                                if(model&&model.cusIcon){
                                    return model.cusIcon
                                }
                                return com_icon
                            }
                        }
                    }
                    FluText{
                        id:item_title
                        text:{
                            if(model){
                                return model.title
                            }
                            return ""
                        }
                        visible: {
                            if(d.isCompactAndNotPanel){
                                return false
                            }
                            return true
                        }
                        elide: Text.ElideRight
                        color:{
                            if(item_mouse.pressed){
                                return FluTheme.dark ? FluColors.Grey80 : FluColors.Grey120
                            }
                            return FluTheme.dark ? FluColors.White : FluColors.Grey220
                        }
                        anchors{
                            verticalCenter: parent.verticalCenter
                            left:item_icon.right
                            right: item_dot_loader.left
                        }
                    }
                    Loader{
                        id:item_edit_loader
                        anchors{
                            top: parent.top
                            bottom: parent.bottom
                            left: item_title.left
                            right: item_title.right
                            rightMargin: 8
                        }
                        sourceComponent: {
                            if(d.isCompact){
                                return undefined
                            }
                            if(!model){
                                return undefined
                            }
                            return model.showEdit ? model.editDelegate : undefined
                        }
                        onStatusChanged: {
                            if(status === Loader.Ready){
                                item.forceActiveFocus()
                                item_connection_edit_focus.target = item
                            }
                        }
                        Connections{
                            id:item_connection_edit_focus
                            ignoreUnknownSignals:true
                            function onActiveFocusChanged(focus){
                                if(focus === false){
                                    model.showEdit = false
                                }
                            }
                            function onCommit(text){
                                model.title = text
                                model.showEdit = false
                            }
                        }
                    }
                    Loader{
                        id:item_dot_loader
                        property bool isDot: (item_dot_loader.item&&item_dot_loader.item.isDot)
                        anchors{
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                            rightMargin: isDot ? 3 : 10
                            verticalCenterOffset: isDot ? -8 : 0
                        }
                        sourceComponent: {
                            if(model&&model.infoBadge){
                                return model.infoBadge
                            }
                            return undefined
                        }
                        Connections{
                            target: d
                            function onIsCompactAndNotPanelChanged(){
                                if(item_dot_loader.item){
                                    item_dot_loader.item.isDot = d.isCompactAndNotPanel
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    Item {
        id:nav_app_bar
        width: parent.width
        height: 40
        anchors{
            top: parent.top
            topMargin: control.topPadding
        }
        z:999
        RowLayout{
            height:parent.height
            spacing: 0
            FluIconButton{
                id:btn_back
                iconSource: FluentIcons.ChromeBack
                Layout.leftMargin: 5
                Layout.alignment: Qt.AlignVCenter
                disabled:  {
                    return d.stackItems.length <= 1
                }
                iconSize: 13
                onClicked: {
                    d.stackItems = d.stackItems.slice(0, -1)
                    var item = d.stackItems[d.stackItems.length-1]
                    if(item._idx<(nav_list.count - layout_footer.count)){
                        layout_footer.currentIndex = -1
                    }else{
                        layout_footer.currentIndex = item._idx-(nav_list.count-layout_footer.count)
                    }
                    nav_list.currentIndex = item._idx
                    if(pageMode === FluNavigationViewType.Stack){
                        var nav_stack = loader_content.item.navStack()
                        var nav_stack2 = loader_content.item.navStack2()
                        nav_stack.pop()
                        if(nav_stack.currentItem.launchMode === FluPageType.SingleInstance){
                            var url = nav_stack.currentItem.url
                            var pageIndex = -1
                            for(var i=0;i<nav_stack2.children.length;i++){
                                var obj =  nav_stack2.children[i]
                                if(obj.url === url){
                                    pageIndex = i
                                    break
                                }
                            }
                            if(pageIndex !== -1){
                                nav_stack2.currentIndex = pageIndex
                            }
                        }
                    }else if(pageMode === FluNavigationViewType.NoStack){
                        loader_content.setSource(item._ext.url,item._ext.argument)
                    }
                }
            }
            FluIconButton{
                id:btn_nav
                iconSource: FluentIcons.GlobalNavButton
                iconSize: 15
                Layout.preferredWidth: d.isMinimal ? 30 : 0
                Layout.preferredHeight: 30
                Layout.alignment: Qt.AlignVCenter
                clip: true
                onClicked: {
                    d.enableNavigationPanel = !d.enableNavigationPanel
                }
                visible: opacity
                opacity: d.isMinimal
                Behavior on opacity{
                    enabled: FluTheme.enableAnimation && d.animDisabled
                    NumberAnimation{
                        duration: 83
                    }
                }
                Behavior on Layout.preferredWidth {
                    enabled: FluTheme.enableAnimation && d.animDisabled
                    NumberAnimation{
                        duration: 167
                        easing.type: Easing.OutCubic
                    }
                }
            }
            Image{
                id:image_logo
                Layout.preferredHeight: 20
                Layout.preferredWidth: 20
                source: control.logo
                Layout.leftMargin: {
                    if(btn_nav.visible){
                        return 12
                    }
                    return 5
                }
                sourceSize: Qt.size(40,40)
                Layout.alignment: Qt.AlignVCenter
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        logoClicked()
                    }
                }
            }
            FluText{
                Layout.alignment: Qt.AlignVCenter
                text:control.title
                Layout.leftMargin: 12
                font: FluTextStyle.Body
            }
        }
        Item{
            anchors.right: parent.right
            height: parent.height
            width: {
                if(loader_action.item){
                    return loader_action.item.width
                }
                return 0
            }
            Loader{
                id:loader_action
                anchors.centerIn: parent
                sourceComponent: actionItem
            }
        }
    }

    Component{
        id:com_stack_content
        Item{
            StackView{
                id:nav_stack
                anchors.fill: parent
                clip: true
                visible: !nav_stack2.visible
                popEnter : Transition{}
                popExit : Transition {}
                pushEnter: Transition {}
                pushExit : Transition{}
                replaceEnter : Transition{}
                replaceExit : Transition{}
            }
            StackLayout{
                id:nav_stack2
                anchors.fill: nav_stack
                clip: true
                visible: {
                    if(!nav_stack.currentItem){
                        return false
                    }
                    return FluPageType.SingleInstance === nav_stack.currentItem.launchMode
                }
            }
            function navStack(){
                return nav_stack
            }
            function navStack2(){
                return nav_stack2
            }
        }
    }
    DropArea{
        anchors.fill: loader_content
        onDropped:
            (drag)=>{
                if(drag.source.modelData){
                    drag.source.modelData.dropped(drag)
                }
            }
    }
    Loader{
        id:loader_content
        anchors{
            left: parent.left
            top: nav_app_bar.bottom
            right: parent.right
            bottom: parent.bottom
            leftMargin: {
                if(d.isMinimal){
                    return 0
                }
                if(d.isCompact){
                    return 50
                }
                return control.navWidth
            }
        }
        Behavior on anchors.leftMargin {
            enabled: FluTheme.enableAnimation && d.animDisabled
            NumberAnimation{
                duration: 167
                easing.type: Easing.OutCubic
            }
        }
        sourceComponent: com_stack_content
    }
    MouseArea{
        anchors.fill: parent
        visible: d.isMinimalAndPanel||d.isCompactAndPanel
        hoverEnabled: true
        onWheel: {
        }
        onClicked: {
            d.enableNavigationPanel = false
        }
    }
    Rectangle{
        id:layout_list
        width: {
            if(d.isCompactAndNotPanel){
                return 50
            }
            return control.navWidth
        }
        anchors{
            top: parent.top
            bottom: parent.bottom
        }
        border.color: FluTheme.dark ? Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(226/255,230/255,234/255,1)
        border.width:  d.isMinimal || d.isCompactAndPanel ? 1 : 0
        color: {
            if(d.isMinimal || d.enableNavigationPanel){
                return FluTheme.dark ? Qt.rgba(61/255,61/255,61/255,1) : Qt.rgba(243/255,243/255,243/255,1)
            }
            return "transparent"
        }
        FluShadow{
            visible: d.isMinimal || d.isCompactAndPanel
            radius: 0
        }
        x: visible ? 0 : -width
        Behavior on width {
            enabled: FluTheme.enableAnimation && d.animDisabled
            NumberAnimation{
                duration: 167
                easing.type: Easing.OutCubic
            }
        }
        Behavior on x {
            enabled: FluTheme.enableAnimation && d.animDisabled
            NumberAnimation{
                duration: 167
                easing.type: Easing.OutCubic
            }
        }
        visible: {
            if(d.displayMode !== FluNavigationViewType.Minimal)
                return true
            return d.isMinimalAndPanel  ? true : false
        }
        Item{
            id:layout_header
            width: layout_list.width
            clip: true
            y:nav_app_bar.height+control.topPadding
            height: autoSuggestBox ? 38 : 0
            Loader{
                id:loader_auto_suggest_box
                anchors.centerIn: parent
                sourceComponent: autoSuggestBox
                visible: {
                    if(d.isCompactAndNotPanel){
                        return false
                    }
                    return true
                }
            }
            FluIconButton{
                visible:d.isCompactAndNotPanel
                hoverColor: FluTheme.dark ? Qt.rgba(1,1,1,0.03) : Qt.rgba(0,0,0,0.03)
                pressedColor: FluTheme.dark ? Qt.rgba(1,1,1,0.03) : Qt.rgba(0,0,0,0.03)
                normalColor: FluTheme.dark ? Qt.rgba(0,0,0,0) : Qt.rgba(0,0,0,0)
                width:38
                height:34
                x:6
                y:2
                iconSize: 15
                iconSource: {
                    if(loader_auto_suggest_box.item){
                        return loader_auto_suggest_box.item.autoSuggestBoxReplacement
                    }
                    return 0
                }
                onClicked: {
                    d.enableNavigationPanel = !d.enableNavigationPanel
                }
            }
        }
        Flickable{
            id:layout_flickable
            anchors{
                top: layout_header.bottom
                topMargin: 6
                left: parent.left
                right: parent.right
                bottom: layout_footer.top
            }
            boundsBehavior: ListView.StopAtBounds
            clip: true
            contentHeight: nav_list.contentHeight
            ScrollBar.vertical: FluScrollBar {}
            ListView{
                id:nav_list
                clip: true
                displaced: Transition {
                    NumberAnimation {
                        properties: "x,y"
                        easing.type: Easing.OutQuad
                    }
                }
                anchors.fill: parent
                model:d.handleItems()
                boundsBehavior: ListView.StopAtBounds
                highlightMoveDuration: FluTheme.enableAnimation && d.animDisabled ? 167 : 0
                highlight: Item{
                    clip: true
                    Rectangle{
                        height: 18
                        radius: 1.5
                        color: FluTheme.primaryColor.dark
                        width: 3
                        anchors{
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                            leftMargin: 6
                        }
                    }
                }
                currentIndex: -1
                delegate: Loader{
                    property var model: modelData
                    property var _idx: index
                    property int type: 0
                    sourceComponent: {
                        if(model === null || !model)
                            return undefined
                        if(modelData instanceof FluPaneItem){
                            return com_panel_item
                        }
                        if(modelData instanceof FluPaneItemHeader){
                            return com_panel_item_header
                        }
                        if(modelData instanceof FluPaneItemSeparator){
                            return com_panel_item_separatorr
                        }
                        if(modelData instanceof FluPaneItemExpander){
                            return com_panel_item_expander
                        }
                        if(modelData instanceof FluPaneItemEmpty){
                            return com_panel_item_empty
                        }
                        return undefined
                    }
                }
            }
        }

        ListView{
            id:layout_footer
            clip: true
            width: layout_list.width
            height: childrenRect.height
            anchors.bottom: parent.bottom
            interactive: false
            boundsBehavior: ListView.StopAtBounds
            currentIndex: -1
            model: {
                if(footerItems){
                    return footerItems.children
                }
            }
            highlightMoveDuration: 150
            highlight: Item{
                clip: true
                Rectangle{
                    height: 18
                    radius: 1.5
                    color: FluTheme.primaryColor.dark
                    width: 3
                    anchors{
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: 6
                    }
                }
            }
            delegate: Loader{
                property var model: modelData
                property var _idx: index
                property int type: 1
                sourceComponent: {
                    if(modelData instanceof FluPaneItem){
                        return com_panel_item
                    }
                    if(modelData instanceof FluPaneItemHeader){
                        return com_panel_item_header
                    }
                    if(modelData instanceof FluPaneItemSeparator){
                        return com_panel_item_separatorr
                    }
                }
            }
        }
    }
    Popup{
        property var childModel
        id:control_popup
        enter: Transition {
            NumberAnimation {
                property: "opacity"
                from:0
                to:1
                duration: 83
            }
        }
        Connections{
            target: d
            function onIsCompactChanged(){
                if(!d.isCompact){
                    control_popup.close()
                }
            }
        }
        padding: 0
        focus: true
        contentItem: Item{
            ListView{
                id:list_view
                anchors.fill: parent
                clip: true
                currentIndex: -1
                model: control_popup.childModel
                ScrollBar.vertical: FluScrollBar {}
                delegate:Button{
                    id:item_button
                    width: 180
                    height: 38
                    focusPolicy:Qt.TabFocus
                    background: Rectangle{
                        color:  {
                            if(FluTheme.dark){
                                if(item_button.hovered){
                                    return Qt.rgba(1,1,1,0.06)
                                }
                                return Qt.rgba(0,0,0,0)
                            }else{
                                if(item_button.hovered){
                                    return Qt.rgba(0,0,0,0.03)
                                }
                                return Qt.rgba(0,0,0,0)
                            }
                        }
                        FluFocusRectangle{
                            visible: item_button.activeFocus
                            radius:4
                        }

                        Loader{
                            id:item_dot_loader
                            anchors{
                                right: parent.right
                                verticalCenter: parent.verticalCenter
                                rightMargin: 10
                            }
                            sourceComponent: {
                                if(model.infoBadge){
                                    return model.infoBadge
                                }
                                return undefined
                            }
                        }

                    }
                    contentItem: FluText{
                        text:modelData.title
                        elide: Text.ElideRight
                        rightPadding: item_dot_loader.width
                        verticalAlignment: Qt.AlignVCenter
                        anchors{
                            verticalCenter: parent.verticalCenter
                        }
                    }
                    onClicked: {
                        if(modelData.onTapListener){
                            modelData.onTapListener()
                        }else{
                            modelData.tap()
                            nav_list.currentIndex = _idx
                            layout_footer.currentIndex = -1
                            if(d.isMinimal || d.isCompact){
                                d.enableNavigationPanel = false
                            }
                        }
                        control_popup.close()
                    }
                }
            }
        }
        background: FluRectangle{
            implicitWidth: 180
            implicitHeight: 38*Math.min(Math.max(list_view.count,1),8)
            radius: [4,4,4,4]
            FluShadow{
                radius: 4
            }
            color: FluTheme.dark ? Qt.rgba(51/255,48/255,48/255,1) : Qt.rgba(248/255,250/255,253/255,1)
        }
        function showPopup(pos,model){
            control_popup.x = pos.x
            control_popup.y = pos.y
            control_popup.childModel = model
            control_popup.open()
        }
    }
    Loader{
        id:loader_item_menu
    }
    Component{
        id:com_placeholder
        Item{
            property int launchMode: FluPageType.SingleInstance
            property string url
        }
    }
    function collapseAll(){
        for(var i=0;i<nav_list.model.length;i++){
            var item = nav_list.model[i]
            if(item instanceof FluPaneItemExpander){
                item.isExpand = false
            }
        }
    }
    function setCurrentIndex(index){
        nav_list.currentIndex = index
        var item = nav_list.model[index]
        if(item instanceof FluPaneItem){
            item.tap()
        }
    }
    function getItems(){
        return nav_list.model
    }
    function getCurrentIndex(){
        return nav_list.currentIndex
    }
    function getCurrentUrl(){
        if(pageMode === FluNavigationViewType.Stack){
            var nav_stack = loader_content.item.navStack()
            if(nav_stack.currentItem){
                return nav_stack.currentItem.url
            }
        }else if(pageMode === FluNavigationViewType.NoStack){
            return loader_content.source.toString()
        }
        return undefined
    }
    function push(url,argument={}){
        function stackPush(){
            var nav_stack = loader_content.item.navStack()
            var nav_stack2 = loader_content.item.navStack2()
            var page = nav_stack.find(function(item) {
                return item.url === url;
            })
            if(page){
                switch(page.launchMode)
                {
                case FluPageType.SingleTask:
                    while(nav_stack.currentItem !== page)
                    {
                        nav_stack.pop()
                        d.stackItems = d.stackItems.slice(0, -1)
                    }
                    return
                case FluPageType.SingleTop:
                    if (nav_stack.currentItem.url === url){
                        return
                    }
                    break
                case FluPageType.Standard:
                default:
                }
            }
            var pageIndex = -1
            for(var i=0;i<nav_stack2.children.length;i++){
                var item =  nav_stack2.children[i]
                if(item.url === url){
                    pageIndex = i
                    break
                }
            }
            var options = Object.assign(argument,{url:url})
            if(pageIndex!==-1){
                nav_stack2.currentIndex = pageIndex
                nav_stack.push(com_placeholder,options)
            }else{
                var comp = Qt.createComponent(url)
                if (comp.status === Component.Ready) {
                    var obj  = comp.createObject(nav_stack,options)
                    if(obj.launchMode === FluPageType.SingleInstance){
                        nav_stack.push(com_placeholder,options)
                        nav_stack2.children.push(obj)
                        nav_stack2.currentIndex = nav_stack2.count - 1
                    }else{
                        nav_stack.push(obj)
                    }
                }else{
                    console.error(comp.errorString())
                }
            }
            d.stackItems = d.stackItems.concat(nav_list.model[nav_list.currentIndex])
        }
        function noStackPush(){
            if(loader_content.source.toString() === url){
                return
            }
            loader_content.setSource(url,argument)
            var obj = nav_list.model[nav_list.currentIndex]
            obj._ext = {url:url,argument:argument}
            d.stackItems = d.stackItems.concat(obj)
        }
        if(pageMode === FluNavigationViewType.Stack){
            stackPush()
        }else if(pageMode === FluNavigationViewType.NoStack){
            noStackPush()
        }
    }
    function startPageByItem(data){
        var items = getItems()
        for(var i=0;i<items.length;i++){
            var item =  items[i]
            if(item.key === data.key){
                if(getCurrentIndex() === i){
                    return
                }
                setCurrentIndex(i)
                if(item.parent && !d.isCompactAndNotPanel){
                    item.parent.isExpand = true
                }
                return
            }
        }
    }
    function backButton(){
        return btn_back
    }
    function navButton(){
        return btn_nav
    }
    function logoButton(){
        return image_logo
    }
}
