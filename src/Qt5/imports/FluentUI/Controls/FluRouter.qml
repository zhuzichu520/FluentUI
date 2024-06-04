pragma Singleton

import QtQuick 2.15

QtObject {
    property var routes : ({})
    property var windows: []
    function addWindow(window){
        if(!window.transientParent){
            windows.push(window)
        }
    }
    function removeWindow(win) {
        if(!win.transientParent){
            var index = windows.indexOf(win)
            if (index !== -1) {
                windows.splice(index, 1)
                win.deleteLater()
            }
        }
    }
    function exit(retCode){
        for(var i =0 ;i< windows.length; i++){
            var win = windows[i]
            win.deleteLater()
        }
        windows = []
        Qt.exit(retCode)
    }
    function navigate(route,argument={},windowRegister = undefined){
        if(!routes.hasOwnProperty(route)){
            console.error("Not Found Route",route)
            return
        }
        var windowComponent = Qt.createComponent(routes[route])
        if (windowComponent.status !== Component.Ready) {
            console.error(windowComponent.errorString())
            return
        }
        var properties = {}
        properties._route = route
        if(windowRegister){
            properties._windowRegister = windowRegister
        }
        properties.argument = argument
        var win = undefined
        for(var i =0 ;i< windows.length; i++){
            var item = windows[i]
            if(route === item._route){
                win = item
                break
            }
        }
        if(win){
            var launchMode = win.launchMode
            if(launchMode === 1){
                win.argument = argument
                win.show()
                win.raise()
                win.requestActivate()
                return
            }else if(launchMode === 2){
                win.close()
            }
        }
        win  = windowComponent.createObject(null,properties)
        if(windowRegister){
            windowRegister._to = win
        }
    }
}
