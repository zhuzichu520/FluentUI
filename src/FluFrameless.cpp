#include "FluFrameless.h"

#include <QGuiApplication>

FluFrameless::FluFrameless(QObject *parent)
    : QObject{parent}
{
}

void FluFrameless::classBegin(){
}

void FluFrameless::updateCursor(int edges){
    switch (edges) {
    case 0:
        _window->setCursor(Qt::ArrowCursor);
        break;
    case Qt::LeftEdge:
    case Qt::RightEdge:
        _window->setCursor(Qt::SizeHorCursor);
        break;
    case Qt::TopEdge:
    case Qt::BottomEdge:
        _window->setCursor(Qt::SizeVerCursor);
        break;
    case Qt::LeftEdge | Qt::TopEdge:
    case Qt::RightEdge | Qt::BottomEdge:
        _window->setCursor(Qt::SizeFDiagCursor);
        break;
    case Qt::RightEdge | Qt::TopEdge:
    case Qt::LeftEdge | Qt::BottomEdge:
        _window->setCursor(Qt::SizeBDiagCursor);
        break;
    }
}

bool FluFrameless::eventFilter(QObject *obj, QEvent *ev){
    if (!_window.isNull() && _window->flags()& Qt::FramelessWindowHint) {
        static int edges = 0;
        const int margin = 8;
        switch (ev->type()) {
        case QEvent::MouseButtonPress:
            if(edges!=0){
                updateCursor(edges);
                _window->startSystemResize(Qt::Edges(edges));
            }
            break;
        case QEvent::MouseButtonRelease:
            edges = Qt::Edges();
            updateCursor(edges);
            break;
        case QEvent::MouseMove: {
            if(_window->visibility() == QWindow::Maximized || _window->visibility() == QWindow::FullScreen){
                break;
            }
            if(_window->width() == _window->maximumWidth() && _window->width() == _window->minimumWidth() && _window->height() == _window->maximumHeight() && _window->height() == _window->minimumHeight()){
                break;
            }
            edges = Qt::Edges();
            QMouseEvent *event = static_cast<QMouseEvent*>(ev);
            QPoint p =
#if QT_VERSION < QT_VERSION_CHECK(6,0,0)
                event->pos();
#else
                event->position().toPoint();
#endif
            if ( p.x() < margin ) {
                edges |= Qt::LeftEdge;
            }
            if ( p.x() > (_window->width() - margin) ) {
                edges |= Qt::RightEdge;
            }
            if ( p.y() < margin ) {
                edges |= Qt::TopEdge;
            }
            if ( p.y() > (_window->height() - margin) ) {
                edges |= Qt::BottomEdge;
            }
            updateCursor(edges);
            break;
        }
        default:
            break;
        }
    }
    return QObject::eventFilter(obj, ev);
}

void FluFrameless::componentComplete(){
    auto o = parent();
    while (nullptr != o) {
        _window = (QQuickWindow*)o;
        o = o->parent();
    }

    if(!_window.isNull()){
        _window->setFlag(Qt::FramelessWindowHint,true);
        _window->update();
        QGuiApplication::processEvents();
        _window->installEventFilter(this);
    }
}

FluFrameless::~FluFrameless(){
    if (!_window.isNull()) {
        _window->setFlag(Qt::FramelessWindowHint,false);
        _window->update();
        QGuiApplication::processEvents();
        _window->removeEventFilter(this);
    }
}
