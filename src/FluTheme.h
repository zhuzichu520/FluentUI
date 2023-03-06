#ifndef FLUTHEME_H
#define FLUTHEME_H

#include <QObject>
#include "FluColorSet.h"
#include "stdafx.h"

class FluTheme : public QObject
{
    Q_OBJECT
    Q_PROPERTY_AUTO(FluColorSet*,primaryColor)
    Q_PROPERTY_AUTO(bool,isDark);
public:
    explicit FluTheme(QObject *parent = nullptr);
    static FluTheme *getInstance();
private:
    static FluTheme* m_instance;

};

#endif // FLUTHEME_H
