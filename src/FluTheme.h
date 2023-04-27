#ifndef FLUTHEME_H
#define FLUTHEME_H

#include <QObject>
#include <QtQml/qqml.h>
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
    QML_NAMED_ELEMENT(FluTheme)
    QML_SINGLETON
public:
    explicit FluTheme(QObject *parent = nullptr);
    bool dark();
    Q_SIGNAL void darkChanged();
private:
    bool _dark;
    bool eventFilter(QObject *obj, QEvent *event);
    bool systemDark();
};

#endif // FLUTHEME_H
