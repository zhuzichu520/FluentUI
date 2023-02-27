#include "WindowHelper.h"

WindowHelper::WindowHelper(QObject *parent)
    : QObject{parent}
{

}

void WindowHelper::classBegin()
{
}

void WindowHelper::componentComplete()
{

    auto rootItem = qobject_cast<QQuickItem*>(parent());
    if (auto window = rootItem->window())
    {
        this->window = window;
        this->window->setTitle("FluentUI");
        qDebug()<<"--------->--------->";
    }
}

void WindowHelper::setTitle(const QString& text){
    window->setTitle(text);
}
