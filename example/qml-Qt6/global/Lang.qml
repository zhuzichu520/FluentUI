pragma Singleton

import QtQuick

QtObject {

    property string home
    property string basic_input
    property string form
    property string surface
    property string popus
    property string navigation
    property string theming
    property string media
    property string dark_mode
    property string sys_dark_mode
    property string search
    property string about
    property string settings
    property string locale
    property string navigation_view_display_mode
    property string other

    function zh(){
        home="首页"
        basic_input="基本输入"
        form="表单"
        surface="表面"
        popus="弹窗"
        navigation="导航"
        theming="主题"
        media="媒体"
        dark_mode="夜间模式"
        sys_dark_mode="跟随系统"
        search="查找"
        about="关于"
        settings="设置"
        locale="语言环境"
        navigation_view_display_mode="导航视图显示模式"
        other="其他"
    }

    function en(){
        home="Home"
        basic_input="Basic Input"
        form="Form"
        surface="Surfaces"
        popus="Popus"
        navigation="Navigation"
        theming="Theming"
        media="Media"
        dark_mode="Dark Mode"
        sys_dark_mode="Sync with system"
        search="Search"
        about="About"
        settings="Settings"
        locale="Locale"
        navigation_view_display_mode="NavigationView Display Mode"
        other="Other"
    }

    property string __locale
    property var __localeList: ["Zh","En"]

    on__LocaleChanged: {
        if(__locale === "Zh"){
            zh()
        }else{
            en()
        }
    }

    Component.onCompleted: {
        __locale = "En"
    }

}
