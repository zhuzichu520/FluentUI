import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0
import FluentUI 1.0

FluRectangle {
    id:control
    color: "#00000000"
    layer.enabled: !FluTools.isSoftware()
    layer.effect: OpacityMask{
        maskSource: FluRectangle{
            radius: control.radius
            width: control.width
            height: control.height
        }
    }
}
