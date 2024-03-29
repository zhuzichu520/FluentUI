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
    property int pageMode: FluNavigationViewType.Stack
    property FluMenu navItemRightMenu
    property FluMenu navItemExpanderRightMenu
    property int navCompactWidth: 50
    property int navTopMargin: 0
    property int cellHeight: 38
    property int cellWidth: 300
    property bool hideNavAppBar: false
    property alias buttonMenu: btn_menu
    property alias buttonBack: btn_back
    property alias imageLogo: image_logo
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
        property color itemDisableColor: FluTheme.dark ? Qt.rgba(131/255,131/255,131/255,1) : Qt.rgba(160/255,160/255,160/255,1)
        onIsCompactAndNotPanelChanged: {
            collapseAll()
        }
        function handleItems(){
            var _idx = 0
            var data = []
            var comEmpty = Qt.createComponent("FluPaneItemEmpty.qml");
            if(items){
                for(var i=0;i<items.children.length;i++){
                    var item = items.children[i]
                    if(item.visible !== true){
                        continue
                    }
                    item._idx = _idx
                    data.push(item)
                    _idx++
                    if(item instanceof FluPaneItemExpander){
                        for(var j=0;j<item.children.length;j++){
                            var itemChild = item.children[j]
                            if(itemChild.visible !== true){
                                continue
                            }
                            itemChild._parent = item
                            itemChild._idx = _idx
                            data.push(itemChild)
                            _idx++
                        }
                    }
                }
                if(footerItems){
                    for(var k=0;k<footerItems.children.length;k++){
                        var itemFooter = footerItems.children[k]
                        if(itemFooter.visible !== true){
                            continue
                        }
                        var objEmpty = comEmpty.createObject(items,{_idx:_idx});
                        itemFooter._idx = _idx;
                        data.push(objEmpty)
                        _idx++
                    }
                }
            }
            return data
        }
        function handleFooterItems(){
            var data = []
            if(footerItems){
                for(var i=0;i<footerItems.children.length;i++){
                    var item = footerItems.children[i]
                    if(item.visible !== true){
                        continue
                    }
                    data.push(item)
                }
            }
            return data;
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
            size: {
                if(!model){
                    return 1
                }
                if(model._parent){
                    return model._parent.isExpand ? model.size : 0
                }
                return model.size
            }
        }
    }
    Component{
        id:com_panel_item_header
        Item{
            height: {
                if(model._parent){
                    return model._parent.isExpand ? control.cellHeight : 0
                }
                return  control.cellHeight
            }
            Behavior on height {
                enabled: FluTheme.animationEnabled && d.animDisabled
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
            height: control.cellHeight
            width: layout_list.width
            FluControl{
                id:item_control
                enabled: !model.disabled
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
                FluTooltip {
                    text: model.title
                    visible: item_control.hovered && model.title && d.isCompactAndNotPanel
                    delay: 800
                }
                MouseArea{
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton
                    onClicked:
                        (mouse) =>{
                            if (mouse.button === Qt.RightButton) {
                                if(model.menuDelegate){
                                    loader_item_menu.sourceComponent = model.menuDelegate
                                    connection_item_menu.target = loader_item_menu.item
                                    loader_item_menu.modelData = model
                                    loader_item_menu.item.popup();
                                }
                            }
                        }
                    z:-100
                }
                onClicked: {
                    if(d.isCompactAndNotPanel && model.children.length > 0){
                        let h = 38*Math.min(Math.max(model.children.length,1),8)
                        let y = mapToItem(control,0,0).y
                        if(h+y>control.height){
                            y = control.height - h
                        }
                        control_popup.showPopup(Qt.point(control.navCompactWidth,y),h,model.children)
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
                        color: FluTheme.primaryColor
                        visible: {
                            if(!model){
                                return false
                            }
                            if(!model.children){
                                return false
                            }
                            for(var i=0;i<model.children.length;i++){
                                var item = model.children[i]
                                if(item.visible !== true){
                                    continue
                                }
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
                            rightMargin: visible ? 12 : 0
                        }
                        visible: {
                            if(d.isCompactAndNotPanel){
                                return false
                            }
                            return true
                        }
                        Behavior on rotation {
                            enabled: FluTheme.animationEnabled && d.animDisabled
                            NumberAnimation{
                                duration: 167
                                easing.type: Easing.OutCubic
                            }
                        }
                        color: {
                            if(!item_control.enabled){
                                return d.itemDisableColor
                            }
                            return FluTheme.dark ? "#FFFFFF" : "#000000"
                        }
                    }
                    color: {
                        if(!item_control.enabled){
                            return FluTheme.itemNormalColor
                        }
                        if(nav_list.currentIndex === _idx&&type===0){
                            return FluTheme.itemCheckColor
                        }
                        if(item_control.hovered){
                            return FluTheme.itemHoverColor
                        }
                        return FluTheme.itemNormalColor
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
                            color: {
                                if(!item_control.enabled){
                                    return d.itemDisableColor
                                }
                                return FluTheme.dark ? "#FFFFFF" : "#000000"
                            }
                        }
                    }
                    Item{
                        id:item_icon
                        width: visible ? 30 : 8
                        height: 30
                        visible: {
                            if(model){
                                return model.iconVisible
                            }
                            return true
                        }
                        anchors{
                            left:parent.left
                            verticalCenter: parent.verticalCenter
                            leftMargin: d.isCompactAndNotPanel ? (parent.width - 30)/2 : 3
                        }
                        FluLoader{
                            anchors.centerIn: parent
                            sourceComponent: {
                                if(model&&model.iconDelegate){
                                    return model.iconDelegate
                                }
                                return com_icon
                            }
                        }
                    }
                    FluText{
                        id:item_title
                        text:{
                            if(model){
                                if(!item_icon.visible && d.isCompactAndNotPanel){
                                    return model.title[0]
                                }
                                return model.title
                            }
                            return ""
                        }
                        visible: {
                            if(d.isCompactAndNotPanel){
                                if(item_icon.visible){
                                    return false
                                }
                                return true
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
                            if(!item_control.enabled){
                                return d.itemDisableColor
                            }
                            if(item_control.pressed){
                                return FluTheme.dark ? FluColors.Grey80 : FluColors.Grey120
                            }
                            return FluTheme.dark ? FluColors.White : FluColors.Grey220
                        }
                    }
                    FluLoader{
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
                            if(status === FluLoader.Ready){
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
                enabled: FluTheme.animationEnabled && d.animDisabled
                NumberAnimation{
                    duration: 167
                    easing.type: Easing.OutCubic
                }
            }
            height: {
                if(model&&model._parent){
                    return model._parent.isExpand ? control.cellHeight : 0
                }
                return control.cellHeight
            }
            visible: control.cellHeight === Number(height)
            opacity: visible
            Behavior on opacity {
                NumberAnimation { duration: 83 }
            }
            width: layout_list.width
            FluControl{
                property var modelData: model
                id:item_control
                enabled: !model.disabled
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
                FluTooltip {
                    text: model.title
                    visible: item_control.hovered && model.title && d.isCompactAndNotPanel
                    delay: 800
                }
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
                    onClicked:
                        (mouse)=>{
                            if (mouse.button === Qt.RightButton) {
                                if(model.menuDelegate){
                                    loader_item_menu.sourceComponent = model.menuDelegate
                                    connection_item_menu.target = loader_item_menu.item
                                    loader_item_menu.modelData = model
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
                        if(!item_control.enabled){
                            return FluTheme.itemNormalColor
                        }
                        if(type===0){
                            if(nav_list.currentIndex === _idx){
                                return FluTheme.itemCheckColor
                            }
                        }else{
                            if(nav_list.currentIndex === (nav_list.count-layout_footer.count+_idx)){
                                return FluTheme.itemCheckColor
                            }
                        }
                        if(item_control.hovered){
                            return FluTheme.itemHoverColor
                        }
                        return FluTheme.itemNormalColor
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
                            color: {
                                if(!item_control.enabled){
                                    return d.itemDisableColor
                                }
                                return FluTheme.dark ? "#FFFFFF" : "#000000"
                            }
                            iconSize: 15
                        }
                    }
                    Item{
                        id:item_icon
                        height: 30
                        width: visible ? 30 : 8
                        visible: {
                            if(model){
                                return model.iconVisible
                            }
                            return true
                        }
                        anchors{
                            left:parent.left
                            verticalCenter: parent.verticalCenter
                            leftMargin: d.isCompactAndNotPanel ? (parent.width - 30)/2 : 3
                        }
                        FluLoader{
                            anchors.centerIn: parent
                            sourceComponent: {
                                if(model&&model.iconDelegate){
                                    return model.iconDelegate
                                }
                                return com_icon
                            }
                        }
                    }
                    FluText{
                        id:item_title
                        text:{
                            if(model){
                                if(!item_icon.visible && d.isCompactAndNotPanel){
                                    return model.title[0]
                                }
                                return model.title
                            }
                            return ""
                        }
                        visible: {
                            if(d.isCompactAndNotPanel){
                                if(item_icon.visible){
                                    return false
                                }
                                return true
                            }
                            return true
                        }
                        elide: Text.ElideRight
                        color:{
                            if(!item_control.enabled){
                                return d.itemDisableColor
                            }
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
                    FluLoader{
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
                            if(status === FluLoader.Ready){
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
                    FluLoader{
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
        height: visible ? 40 : 0
        anchors{
            top: parent.top
            topMargin: control.topPadding
        }
        visible: !control.hideNavAppBar
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
                id:btn_menu
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
                    enabled: FluTheme.animationEnabled && d.animDisabled
                    NumberAnimation{
                        duration: 83
                    }
                }
                Behavior on Layout.preferredWidth {
                    enabled: FluTheme.animationEnabled && d.animDisabled
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
                    if(btn_menu.visible){
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
            FluLoader{
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
    FluLoader{
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
                    return control.navCompactWidth
                }
                return control.cellWidth
            }
        }
        Behavior on anchors.leftMargin {
            enabled: FluTheme.animationEnabled && d.animDisabled
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
                return control.navCompactWidth
            }
            return control.cellWidth
        }
        anchors{
            top: parent.top
            topMargin: control.navTopMargin
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
            enabled: FluTheme.animationEnabled && d.animDisabled
            NumberAnimation{
                duration: 167
                easing.type: Easing.OutCubic
            }
        }
        Behavior on x {
            enabled: FluTheme.animationEnabled && d.animDisabled
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
            FluLoader{
                id:loader_auto_suggest_box
                sourceComponent: autoSuggestBox
                anchors{
                    left: parent.left
                    right: parent.right
                    leftMargin: 6
                    rightMargin: 6
                    verticalCenter: parent.verticalCenter
                }
                visible: {
                    if(d.isCompactAndNotPanel){
                        return false
                    }
                    return true
                }
            }
            FluIconButton{
                visible:d.isCompactAndNotPanel
                anchors{
                    fill: parent
                    leftMargin: 6
                    rightMargin: 6
                    topMargin: 2
                    bottomMargin: 2
                }
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
                displaced: Transition {
                    NumberAnimation {
                        properties: "x,y"
                        easing.type: Easing.OutQuad
                    }
                }
                anchors.fill: parent
                interactive: false
                model:d.handleItems()
                boundsBehavior: ListView.StopAtBounds
                highlightMoveDuration: FluTheme.animationEnabled && d.animDisabled ? 167 : 0
                highlight: Item{
                    clip: true
                    Rectangle{
                        height: 18
                        radius: 1.5
                        color: FluTheme.primaryColor
                        width: 3
                        anchors{
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                            leftMargin: 6
                        }
                    }
                }
                currentIndex: -1
                delegate: FluLoader{
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
            model: d.handleFooterItems()
            highlightMoveDuration: 150
            highlight: Item{
                clip: true
                Rectangle{
                    height: 18
                    radius: 1.5
                    color: FluTheme.primaryColor
                    width: 3
                    anchors{
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: 6
                    }
                }
            }
            delegate: FluLoader{
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
                boundsBehavior: ListView.StopAtBounds
                ScrollBar.vertical: FluScrollBar {}
                delegate:Button{
                    id:item_button
                    width: 180
                    height: 38
                    focusPolicy:Qt.TabFocus
                    background: Rectangle{
                        color:  {
                            if(item_button.hovered){
                                return FluTheme.itemHoverColor
                            }
                            return FluTheme.itemNormalColor
                        }
                        FluFocusRectangle{
                            visible: item_button.activeFocus
                            radius:4
                        }

                        FluLoader{
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
            radius: [4,4,4,4]
            FluShadow{
                radius: 4
            }
            color: FluTheme.dark ? Qt.rgba(51/255,48/255,48/255,1) : Qt.rgba(248/255,250/255,253/255,1)
        }
        function showPopup(pos,height,model){
            background.implicitHeight = height
            control_popup.x = pos.x
            control_popup.y = pos.y
            control_popup.childModel = model
            control_popup.open()
        }
    }
    FluLoader{
        property var modelData
        id:loader_item_menu
    }
    Connections{
        id:connection_item_menu
        function onVisibleChanged(visible){
            if(target.visible === false){
                loader_item_menu.sourceComponent = undefined
            }
        }
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
        var item = nav_list.model[index]
        if(item.url){
            nav_list.currentIndex = index
            if(item instanceof FluPaneItem){
                item.tap()
            }
        }else{
            item.onTapListener()
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
                if(item._parent && !d.isCompactAndNotPanel){
                    item._parent.isExpand = true
                }
                return
            }
        }
    }
}
