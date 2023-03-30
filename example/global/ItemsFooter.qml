pragma Singleton

import QtQuick
import FluentUI

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
