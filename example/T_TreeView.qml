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

    ListModel {
        id: tree_model
        ListElement {
            text: "Root"
            expanded:true
            items: [
                ListElement {
                    text: "Node 1"
                    expanded:false
                    items: [
                        ListElement {
                            text: "Node 1.1"
                            expanded:true
                            items:[
                                ListElement{
                                    text:"Node 1.1.1"
                                    expanded:true
                                    items:[
                                        ListElement{
                                            text:"Node 1.1.1.1"
                                            expanded:false
                                            items:[]
                                        },
                                        ListElement{
                                            text:"Node 1.1.1.2"
                                            expanded:false
                                            items:[]
                                        },
                                        ListElement{
                                            text:"Node 1.1.1.3"
                                            expanded:false
                                            items:[]
                                        },
                                        ListElement{
                                            text:"Node 1.1.1.4"
                                            expanded:false
                                            items:[]
                                        },
                                        ListElement{
                                            text:"Node 1.1.1.5"
                                            expanded:false
                                            items:[]
                                        },
                                        ListElement{
                                            text:"Node 1.1.1.6"
                                            expanded:false
                                            items:[]
                                        }
                                    ]
                                }
                            ]
                        },
                        ListElement {
                            text: "Node 1.2"
                            expanded:false
                            items:[]
                        }
                    ]
                },
                ListElement {
                    text: "Node 2"
                    expanded:false
                    items:[]
                },
                ListElement {
                    text: "Node 3"
                    expanded:true
                    items: [
                        ListElement {
                            text: "Node 3.1"
                            expanded:false
                            items:[]
                        },
                        ListElement {
                            text: "Node 3.2"
                            expanded:false
                            items:[]
                        },
                        ListElement {
                            text: "Node 3.3"
                            expanded:false
                            items:[]
                        },
                        ListElement {
                            text: "Node 3.4"
                            expanded:false
                            items:[]
                        },
                        ListElement {
                            text: "Node 3.5"
                            expanded:false
                            items:[]
                        },
                        ListElement {
                            text: "Node 3.6"
                            expanded:false
                            items:[]
                        },
                        ListElement {
                            text: "Node 3.7"
                            expanded:false
                            items:[]
                        },
                        ListElement {
                            text: "Node 3.8"
                            expanded:false
                            items:[]
                        },
                        ListElement {
                            text: "Node 3.9"
                            expanded:false
                            items:[]
                        },
                        ListElement {
                            text: "Node 3.10"
                            expanded:true
                            items:[
                                ListElement{
                                    text:"Node 3.10.1"
                                    expanded:false
                                    items:[]
                                },
                                ListElement{
                                    text:"Node 3.10.2"
                                    expanded:false
                                    items:[]
                                },
                                ListElement{
                                    text:"Node 3.10.3"
                                    expanded:false
                                    items:[]
                                },
                                ListElement{
                                    text:"Node 3.10.4"
                                    expanded:false
                                    items:[]
                                },
                                ListElement{
                                    text:"Node 3.10.5"
                                    expanded:false
                                    items:[]
                                },
                                ListElement{
                                    text:"Node 3.10.6"
                                    expanded:false
                                    items:[]
                                },
                                ListElement{
                                    text:"Node 3.10.7"
                                    expanded:false
                                    items:[]
                                },
                                ListElement{
                                    text:"Node 3.10.8"
                                    expanded:false
                                    items:[]
                                },
                                ListElement{
                                    text:"Node 3.10.9"
                                    expanded:false
                                    items:[]
                                }
                            ]
                        },
                        ListElement {
                            text: "Node 3.11"
                            expanded:false
                            items:[]
                        }
                    ]
                }
            ]
        }
    }



    FluTreeView{
        id:tree_view
        width:240
        anchors{
            top:title.bottom
            left:parent.left
            bottom:parent.bottom
        }
        model:tree_model
    }


    ColumnLayout{
        anchors{
            left: tree_view.right
            right: parent.right
            top: parent.top
        }
        FluButton{
            text:"test"
            onClicked: {
            }
        }
    }

}
