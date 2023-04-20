#ifndef FLUTHEME_H
#define FLUTHEME_H

#include <QObject>
#include "FluColorSet.h"
#include "stdafx.h"

class FluTheme : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool dark READ dark NOTIFY darkChanged)
    Q_PROPERTY_AUTO(FluColorSet*,primaryColor)
    Q_PROPERTY_AUTO(bool,frameless);
    Q_PROPERTY_AUTO(int,darkMode);
    Q_PROPERTY_AUTO(bool,nativeText);
    Q_PROPERTY_AUTO(int,textSize);
public:
    explicit FluTheme(QObject *parent = nullptr);
    static FluTheme *getInstance();
    bool dark();
    Q_SIGNAL void darkChanged();
private:
    static FluTheme* m_instance;
    bool _dark;
    bool eventFilter(QObject *obj, QEvent *event);
    bool systemDark();
};

#endif // FLUTHEME_H
