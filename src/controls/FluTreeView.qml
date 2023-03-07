import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import QtGraphicalEffects 1.15

Rectangle {
    id:root
    color: FluTheme.isDark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(253/255,253/255,253/255,1)

    property alias model: list_root.model

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



    Component{
        id:comp_delegate

        ColumnLayout{
            id:layout_column
            spacing: 0
            property var itemModel: model
            property int level: mapToItem(list_root,0,0).x/0.001
            width: list_root.width
            Item{
                Layout.preferredHeight: childrenRect.height
                Layout.preferredWidth: childrenRect.width

                Rectangle{
                    height: parent.height
                    width: list_root.width
                    anchors.margins: 2
                    radius: 4
                    color:{
                        if(FluTheme.isDark){
                            return (item_layout_mouse.containsMouse || item_layout_expanded.hovered)?Qt.rgba(62/255,62/255,62/255,1):Qt.rgba(50/255,50/255,50/255,1)
                        }else{
                            return (item_layout_mouse.containsMouse || item_layout_expanded.hovered)?Qt.rgba(244/255,244/255,244/255,1):Qt.rgba(253/255,253/255,253/255,1)
                        }
                    }

                    MouseArea{
                        id:item_layout_mouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            console.debug("---------")
                        }
                    }
                }

                RowLayout{
                    spacing: 0
                    Item{
                        width: 15*level
                        Layout.alignment: Qt.AlignVCenter
                    }
                    FluIconButton{
                        id:item_layout_expanded
                        color:"#00000000"
                        icon:model.expanded?FluentIcons.FA_angle_down:FluentIcons.FA_angle_right
                        onClicked: {
                            model.expanded = !model.expanded
                        }
                    }
                    FluText{
                        text:model.text
                        Layout.alignment: Qt.AlignVCenter
                    }
                }
            }
            Item{
                Layout.preferredWidth: layout_column.width
                Layout.preferredHeight:childrenRect.height
                visible: model.expanded
                ListView{
                    x:0.001
                    width: parent.width
                    height: childrenRect.height
                    model:itemModel.items
                    delegate:comp_delegate
                    boundsBehavior: ListView.StopAtBounds
                }
            }

        }
    }

    ListView{
        id:list_root
        anchors.fill: parent
        delegate:comp_delegate
        clip: true
    }


}
