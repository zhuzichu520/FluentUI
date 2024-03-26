pragma Singleton

import QtQuick
import FluentUI

QtObject {
    property var routes : ({})
    property var windows: []
    function addWindow(window){
        if(!window.transientParent){
            windows.push(window)
        }
    }
    function removeWindow(window) {
        if(!window.transientParent){
            var index = windows.indexOf(window)
            if (index !== -1) {
                windows.splice(index, 1)
                FluTools.deleteLater(window)
            }
        }
    }
    function exit(retCode){
        for(var i =0 ;i< windows.length; i++){
            var item = windows[i]
            FluTools.deleteLater(item)
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
