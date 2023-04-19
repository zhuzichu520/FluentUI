#ifndef FLUTHEME_H
#define FLUTHEME_H

#include <QObject>
#include "FluColorSet.h"
#include "stdafx.h"

class FluTheme : public QObject
{
    Q_OBJECT
    Q_PROPERTY_AUTO(FluColorSet*,primaryColor)
    Q_PROPERTY_AUTO(bool,frameless);
    Q_PROPERTY_AUTO(bool,dark);
    Q_PROPERTY_AUTO(bool,follow_system);
    Q_PROPERTY_AUTO(bool,nativeText);
    Q_PROPERTY_AUTO(int,textSize);
public:
    explicit FluTheme(QObject *parent = nullptr);
    static FluTheme *getInstance();
private:
    static FluTheme* m_instance;
    bool eventFilter(QObject *obj, QEvent *event);
    bool isDark();
};

#endif // FLUTHEME_H
