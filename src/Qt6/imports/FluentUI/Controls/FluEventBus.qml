pragma Singleton

import QtQuick

QtObject {
    property var events: []
    function register(event){
        events.push(event)
    }
    function unregister(event){
        var index = events.indexOf(event)
        if (index !== -1) {
            events.splice(index, 1)
        }
    }
    function post(name,data = {}){
        for(var i =0 ;i< events.length; i++){
            var item = events[i]
            if(item.name === name){
                item.triggered(data)
            }
        }
    }
}
