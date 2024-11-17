import QtQuick
import QtQuick.Controls
import FluentUI

FluObject {
    property var root
    property int layoutY: 75
    id:control
    FluObject{
        id:mcontrol
        property string const_success: "success"
        property string const_info: "info"
        property string const_warning: "warning"
        property string const_error: "error"
        property int maxWidth: 300
        property var screenLayout: null
        function create(type,text,duration,moremsg){
            if(screenLayout){
                var last = screenLayout.getLastloader()
                if(last.type === type && last.text === text && moremsg === last.moremsg){
                    last.duration = duration
                    if (duration > 0) last.restart()
                    return last
                }
            }
            initScreenLayout()
            return contentComponent.createObject(screenLayout,{type:type,text:text,duration:duration,moremsg:moremsg,})
        }
        function createCustom(itemcomponent,duration){
            initScreenLayout()
            if(itemcomponent){
                return contentComponent.createObject(screenLayout,{itemcomponent:itemcomponent,duration:duration})
            }
        }
        function initScreenLayout(){
            if(screenLayout == null){
                screenLayout = screenlayoutComponent.createObject(root)
                screenLayout.y = control.layoutY
                screenLayout.z = 100000
            }
        }
        Component{
            id:screenlayoutComponent
            Column{
                parent: Overlay.overlay
                z:999
                spacing: 20
                width: root.width
                move: Transition {
                    NumberAnimation {
                        properties: "y"
                        easing.type: Easing.OutCubic
                        duration: FluTheme.animationEnabled ? 333 : 0
                    }
                }
                onChildrenChanged: if(children.length === 0)  destroy()
                function getLastloader(){
                    if(children.length > 0){
                        return children[children.length - 1]
                    }
                    return null
                }
            }
        }
        Component{
            id:contentComponent
            Item{
                id:content
                property int duration: 1500
                property var itemcomponent
                property string type
                property string text
                property string moremsg
                width:  parent.width
                height: loader.height
                function close(){
                    content.destroy()
                }
                function restart(){
                    delayTimer.restart()
                }
                Timer {
                    id:delayTimer
                    interval: duration
                    running: duration > 0
                    repeat: duration > 0
                    onTriggered: content.close()
                }
                FluLoader{
                    id:loader
                    x:(parent.width - width) / 2
                    property var _super: content
                    scale: item ? 1 : 0
                    asynchronous: true
                    Behavior on scale {
                        enabled: FluTheme.animationEnabled
                        NumberAnimation {
                            easing.type: Easing.OutCubic
                            duration: 167
                        }
                    }
                    sourceComponent:itemcomponent ? itemcomponent : mcontrol.fluent_sytle
                }
            }
        }
        property Component fluent_sytle:  Rectangle{
            width:  rowlayout.width + (btn_close.visible ? 30 : 48)
            height: rowlayout.height + 20
            color: {
                if(FluTheme.dark){
                    switch(_super.type){
                    case mcontrol.const_success: return Qt.rgba(57/255,61/255,27/255,1)
                    case mcontrol.const_warning: return Qt.rgba(67/255,53/255,25/255,1)
                    case mcontrol.const_info: return Qt.rgba(39/255,39/255,39/255,1)
                    case mcontrol.const_error: return Qt.rgba(68/255,39/255,38/255,1)
                    }
                    return Qt.rgba(1,1,1,1)
                }else{
                    switch(_super.type){
                    case mcontrol.const_success: return Qt.rgba(223/255,246/255,221/255,1)
                    case mcontrol.const_warning: return Qt.rgba(255/255,244/255,206/255,1)
                    case mcontrol.const_info: return Qt.rgba(244/255,244/255,244/255,1)
                    case mcontrol.const_error: return Qt.rgba(253/255,231/255,233/255,1)
                    }
                    return Qt.rgba(1,1,1,1)
                }
            }
            FluShadow{
                radius: 4
            }
            radius: 4
            border.width: 1
            border.color: {
                if(FluTheme.dark){
                    switch(_super.type){
                    case mcontrol.const_success: return Qt.rgba(56/255,61/255,27/255,1)
                    case mcontrol.const_warning: return Qt.rgba(66/255,53/255,25/255,1)
                    case mcontrol.const_info:    return Qt.rgba(38/255,39/255,39/255,1)
                    case mcontrol.const_error:   return Qt.rgba(67/255,39/255,38/255,1)
                    }
                    return Qt.rgba(1,1,1,1)
                }else{
                    switch(_super.type){
                    case mcontrol.const_success: return Qt.rgba(210/255,232/255,208/255,1)
                    case mcontrol.const_warning: return Qt.rgba(240/255,230/255,194/255,1)
                    case mcontrol.const_info:    return Qt.rgba(230/255,230/255,230/255,1)
                    case mcontrol.const_error:   return Qt.rgba(238/255,217/255,219/255,1)
                    }
                    return Qt.rgba(1,1,1,1)
                }
            }
            Row{
                id:rowlayout
                x:20
                y:(parent.height - height) / 2
                spacing: 10
                FluIcon{
                    iconSource:{
                        switch(_super.type){
                        case mcontrol.const_success: return FluentIcons.CompletedSolid
                        case mcontrol.const_warning: return FluentIcons.InfoSolid
                        case mcontrol.const_info:    return FluentIcons.InfoSolid
                        case mcontrol.const_error:   return FluentIcons.StatusErrorFull
                        }FluentIcons.StatusErrorFull
                        return FluentIcons.FA_info_circle
                    }
                    iconSize:20
                    iconColor: {
                        if(FluTheme.dark){
                            switch(_super.type){
                            case mcontrol.const_success: return Qt.rgba(108/255,203/255,95/255,1)
                            case mcontrol.const_warning: return Qt.rgba(252/255,225/255,0/255,1)
                            case mcontrol.const_info:    return FluTheme.primaryColor
                            case mcontrol.const_error:   return Qt.rgba(255/255,153/255,164/255,1)
                            }
                            return Qt.rgba(1,1,1,1)
                        }else{
                            switch(_super.type){
                            case mcontrol.const_success: return Qt.rgba(15/255,123/255,15/255,1)
                            case mcontrol.const_warning: return Qt.rgba(157/255,93/255,0/255,1)
                            case mcontrol.const_info:    return Qt.rgba(0/255,102/255,180/255,1)
                            case mcontrol.const_error:   return Qt.rgba(196/255,43/255,28/255,1)
                            }
                            return Qt.rgba(1,1,1,1)
                        }
                    }
                }

                Column{
                    spacing: 5
                    FluText{
                        text:_super.text
                        wrapMode: Text.WordWrap
                        width: Math.min(implicitWidth,mcontrol.maxWidth)
                    }
                    FluText{
                        text: _super.moremsg
                        visible: _super.moremsg
                        wrapMode : Text.WordWrap
                        textColor: FluColors.Grey120
                        width: Math.min(implicitWidth,mcontrol.maxWidth)
                    }
                }

                FluIconButton{
                    id:btn_close
                    iconSource: FluentIcons.ChromeClose
                    iconSize: 10
                    verticalPadding: 0
                    horizontalPadding: 0
                    width: 30
                    height: 20
                    visible: _super.duration<=0
                    anchors.verticalCenter: parent.verticalCenter
                    iconColor: FluTheme.dark ? Qt.rgba(222/255,222/255,222/255,1) : Qt.rgba(97/255,97/255,97/255,1)
                    onClicked: _super.close()
                }
            }
        }
    }
    function showSuccess(text,duration=1000,moremsg){
        return mcontrol.create(mcontrol.const_success,text,duration,moremsg ? moremsg : "")
    }
    function showInfo(text,duration=1000,moremsg){
        return mcontrol.create(mcontrol.const_info,text,duration,moremsg ? moremsg : "")
    }
    function showWarning(text,duration=1000,moremsg){
        return mcontrol.create(mcontrol.const_warning,text,duration,moremsg ? moremsg : "")
    }
    function showError(text,duration=1000,moremsg){
        return mcontrol.create(mcontrol.const_error,text,duration,moremsg ? moremsg : "")
    }
    function showCustom(itemcomponent,duration=1000){
        return mcontrol.createCustom(itemcomponent,duration)
    }
    function clearAllInfo(){
        if(mcontrol.screenLayout != null) {
            mcontrol.screenLayout.destroy()
            mcontrol.screenLayout = null
        }

        return true
    }
}
