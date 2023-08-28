#ifndef FPSITEM_H
#define FPSITEM_H

#include <QQuickItem>
#include "src/stdafx.h"

class FpsItem : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY_AUTO(int,fps)
public:
    FpsItem();

private:
    int _frameCount = 0;

};

#endif // FPSITEM_H
