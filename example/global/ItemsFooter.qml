pragma Singleton

import QtQuick 2.15
import FluentUI 1.0

FluObject{
    id:footer_items
    FluPaneItemSeparator{}
    FluPaneItem{
        title:"意见反馈"
        onTap:{
            Qt.openUrlExternally("https://github.com/zhuzichu520/FluentUI/issues/new")
        }
    }
    FluPaneItem{
        title:"关于"
        onTap:{
            FluApp.navigate("/about")
        }
    }
}
