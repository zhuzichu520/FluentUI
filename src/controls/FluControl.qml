import QtQuick 2.15
import QtQuick.Controls  2.15
import QtQuick.Controls.impl 2.15
import QtQuick.Templates 2.15 as T
import FluentUI 1.0

T.Button {
    id: control
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
}
