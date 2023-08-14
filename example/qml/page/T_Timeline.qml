import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import "qrc:///example/qml/component"

FluScrollablePage{

    title:"Timeline"

    Component{
        id:com_dot
        Rectangle{
            width: 16
            height: 16
            radius: 8
            border.width: 4
            border.color: FluTheme.dark ? FluColors.Teal.lighter : FluColors.Teal.dark
        }
    }

    Component{
        id:com_lable
        FluText{
            wrapMode: Text.WrapAnywhere
            font.bold: true
            horizontalAlignment: isRight ? Qt.AlignRight : Qt.AlignLeft
            text: modelData.lable
            color: FluTheme.dark ? FluColors.Teal.lighter : FluColors.Teal.dark
            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    showSuccess(modelData.lable)
                }
            }
        }
    }

    Component{
        id:com_text
        FluText{
            wrapMode: Text.WrapAnywhere
            horizontalAlignment: isRight ? Qt.AlignRight : Qt.AlignLeft
            text: modelData.text
            font.bold: true
            linkColor: FluTheme.dark ? FluColors.Teal.lighter : FluColors.Teal.dark
            onLinkActivated:
                (link)=> {
                    Qt.openUrlExternally(link)
                }
            onLinkHovered:
                (link)=> {
                    if(link === ""){
                        FluTools.restoreOverrideCursor()
                    }else{
                        FluTools.setOverrideCursor(Qt.PointingHandCursor)
                    }
                }
        }
    }

    ListModel{
        id:list_model
        ListElement{
            lable:"2013-09-01"
            text:"考上家里蹲大学"
        }
        ListElement{
            lable:"2017-07-01"
            text:"大学毕业，在寝室打了4年LOL，没想到毕业还要找工作，瞬间蒙蔽~害"
        }
        ListElement{
            lable:"2017-09-01"
            text:"开始找工作，毕业即失业！回农村老家躺平，继承三亩良田！！"
        }
        ListElement{
            lable:"2018-02-01"
            text:"玩了一年没钱，惨，出去找工作上班"
        }
        ListElement{
            lable:"2018-03-01"
            text:"找到一份Android外包开发岗位，开发了一个Android应用，满满成就感！前端、服务端、Flutter也都懂一丢丢，什么都会什么都不精通，钱途无望"
        }
        ListElement{
            lable:"2020-06-01"
            text:"由于某个项目紧急，临时加入Qt项目组（就因为大学学了点C++），本来是想进去打个酱油，到后面竟然成开发主力，坑啊"
        }
        ListElement{
            lable:"2022-08-01"
            text:"额，被老板卖到甲方公司，走时老板还问我想不想去，我说：'哪里工资高就去哪里？'，老板：'无语'"
        }
        ListElement{
            lable:"2023-02-28"
            text:"开发FluentUI组件库"
        }
        ListElement{
            lable:"2023-03-28"
            text:'将FluentUI源码开源到<a href="https://github.com/zhuzichu520/FluentUI">github</a>，并发布视频到<a href="https://www.bilibili.com/video/BV1mg4y1M71w">B站</a>'
            lableDelegate:()=>com_lable
            textDelegate:()=>com_text
            dot:()=>com_dot
        }
    }

    RowLayout{
        spacing: 20
        Layout.topMargin: 20
        FluTextBox{
            id:text_box
            text:"Technical testing 2015-09-01"
        }
        FluFilledButton{
            text:"Append"
            onClicked: {
                list_model.append({text:text_box.text})
            }
        }
        FluFilledButton{
            text:"clear"
            onClicked: {
                list_model.clear()
            }
        }
    }

    RowLayout{
        Layout.topMargin: 10
        FluText{
            text:"mode:"
        }
        FluDropDownButton{
            id:btn_mode
            Layout.preferredWidth: 100
            text:"Alternate"
            FluMenuItem{
                text:"Left"
                onClicked: {
                    btn_mode.text = text
                    time_line.mode = FluTimelineType.Left
                }
            }
            FluMenuItem{
                text:"Right"
                onClicked: {
                    btn_mode.text = text
                    time_line.mode = FluTimelineType.Right
                }
            }
            FluMenuItem{
                text:"Alternate"
                onClicked: {
                    btn_mode.text = text
                    time_line.mode = FluTimelineType.Alternate
                }
            }
        }
    }

    FluTimeline{
        id:time_line
        Layout.fillWidth: true
        Layout.topMargin: 20
        Layout.bottomMargin: 20
        mode: FluTimelineType.Alternate
        model:list_model
    }

}
