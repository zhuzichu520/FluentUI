import QtQuick 2.15
import QtQuick.Window 2.15

MouseArea {

    property int border: 4
    property bool fixedSize: {
        if(Window.window == null)
            return true
        if(Window.window.visibility === Window.Maximized || Window.window.visibility === Window.FullScreen){
            return true
        }
        return (Window.window.minimumWidth === Window.window.maximumWidth && Window.window.minimumHeight === Window.window.maximumHeight)
    }

    anchors.fill: parent
    acceptedButtons: Qt.LeftButton
    hoverEnabled: true
    preventStealing: true
    propagateComposedEvents: true
    z: -65535

    onReleased: {
        Window.window.width = Window.window.width+1
        Window.window.width = Window.window.width-1
    }

    onPressed :
        (mouse)=> {
            if (fixedSize) {
                return;
            }

            var rc = Qt.rect(0, 0, 0, 0);
            let e = 0;

            //top-left
            rc = Qt.rect(0, 0, border, border);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                e = Qt.TopEdge | Qt.LeftEdge;
                window.startSystemResize(e);
                return;
            }

            //top
            rc = Qt.rect(border, 0, window.width-border*2, border);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                e = Qt.TopEdge;
                window.startSystemResize(e);
                return;
            }

            //top-right
            rc = Qt.rect(window.width-border, 0, border, border);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                e = Qt.TopEdge | Qt.RightEdge;
                window.startSystemResize(e);
                return;
            }

            //right
            rc = Qt.rect(window.width-border, border, border, window.height-border*2);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                e = Qt.RightEdge;
                window.startSystemResize(e);
                return;
            }

            //bottom-right
            rc = Qt.rect(window.width-border, window.height-border, border, border);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                e = Qt.BottomEdge | Qt.RightEdge;
                window.startSystemResize(e);
                return;
            }

            //bottom
            rc = Qt.rect(border, window.height-border, window.width-border*2, border);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                e = Qt.BottomEdge;
                window.startSystemResize(e);
                return;
            }

            //bottom_left
            rc = Qt.rect(0, window.height-border,border, border);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                e = Qt.BottomEdge | Qt.LeftEdge;
                window.startSystemResize(e);
                return;
            }

            //left
            rc = Qt.rect(0, border,border, window.height-border*2);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                e = Qt.LeftEdge;
                window.startSystemResize(e);
                return;
            }
        }

    onPositionChanged:
        (mouse)=> {
            if (fixedSize) {
                cursorShape = Qt.ArrowCursor;
                return;
            }

            var rc = Qt.rect(0, 0, 0, 0);

            //top-left
            rc = Qt.rect(0, 0, border, border);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                cursorShape = Qt.SizeFDiagCursor;
                return;
            }

            //top
            rc = Qt.rect(border, 0, window.width-border*2, border);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                cursorShape = Qt.SizeVerCursor;
                return;
            }

            //top-right
            rc = Qt.rect(window.width-border, 0, border, border);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                cursorShape = Qt.SizeBDiagCursor;
                return;
            }

            //right
            rc = Qt.rect(window.width-border, border, border, window.height-border*2);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                cursorShape = Qt.SizeHorCursor;
                return;
            }

            //bottom-right
            rc = Qt.rect(window.width-border, window.height-border, border, border);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                cursorShape = Qt.SizeFDiagCursor;
                return;
            }

            //bottom
            rc = Qt.rect(border, window.height-border, window.width-border*2, border);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                cursorShape = Qt.SizeVerCursor;
                return;
            }

            //bottom_left
            rc = Qt.rect(0, window.height-border,border, border);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                cursorShape = Qt.SizeBDiagCursor;
                return;
            }

            //left
            rc = Qt.rect(0, border,border, window.height-border*2);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                cursorShape = Qt.SizeHorCursor;
                return;
            }

            //default
            cursorShape = Qt.ArrowCursor;
        }

    onExited: {
        cursorShape = Qt.ArrowCursor;
    }

    function ptInRect(rc, x, y)
    {
        if ((rc.x <= x && x <= (rc.x + rc.width)) &&
                (rc.y <= y && y <= (rc.y + rc.height))) {
            return true;
        }

        return false;
    }

}
