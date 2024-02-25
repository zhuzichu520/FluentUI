import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import FluentUI

FluRectangle {
    id:control
    color: "#00000000"
    layer.enabled: !FluTools.isSoftware()
    layer.textureSize: Qt.size(control.width*Math.ceil(Screen.devicePixelRatio),control.height*Math.ceil(Screen.devicePixelRatio))
    layer.effect: OpacityMask{
        maskSource: ShaderEffectSource{
            sourceItem: FluRectangle{
                radius: control.radius
                width: control.width
                height: control.height
            }
        }
    }
}
