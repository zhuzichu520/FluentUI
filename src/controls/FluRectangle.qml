import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

Item{
    id:root
    property var radius:[0,0,0,0]
    property color color : "#FFFFFF"
    property color borderColor:"red"
    property int borderWidth: 1
    default property alias contentItem: container.children

    Rectangle{
        id:container
        width: root.width
        height: root.height
        opacity: 0
        color:root.color
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        visible: false
        onPaint: {
            var ctx = getContext("2d");
            var x = 0;
            var y = 0;
            var w = root.width;
            var h = root.height;
            ctx.setTransform(1, 0, 0, 1, 0, 0);
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            ctx.save();
            ctx.beginPath();
            ctx.moveTo(x + radius[0], y);
            ctx.lineTo(x + w - radius[1], y);
            ctx.arcTo(x + w, y, x + w, y + radius[1], radius[1]);
            ctx.lineTo(x + w, y + h - radius[2]);
            ctx.arcTo(x + w, y + h, x + w - radius[2], y + h, radius[2]);
            ctx.lineTo(x + radius[3], y + h);
            ctx.arcTo(x, y + h, x, y + h - radius[3], radius[3]);
            ctx.lineTo(x, y + radius[0]);
            ctx.arcTo(x, y, x + radius[0], y, radius[0]);
            ctx.closePath();
            ctx.fillStyle = root.color;
            ctx.fill();
            ctx.restore();
        }
    }

    OpacityMask {
        anchors.fill: container
        source: container
        maskSource: canvas
    }

}
