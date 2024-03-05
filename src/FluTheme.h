#ifndef FLUTHEME_H
#define FLUTHEME_H

#include <QObject>
#include <QtQml/qqml.h>
#include <QJsonArray>
#include <QJsonObject>
#include <QColor>
#include "FluColorSet.h"
#include "stdafx.h"
#include "singleton.h"

/**
 * @brief The FluTheme class
 */
class FluTheme : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool dark READ dark NOTIFY darkChanged)
    Q_PROPERTY_AUTO(FluColorSet*,themeColor);
    Q_PROPERTY_AUTO(QColor,primaryColor);
    Q_PROPERTY_AUTO(QColor,backgroundColor);
    Q_PROPERTY_AUTO(QColor,dividerColor);
    Q_PROPERTY_AUTO(QColor,windowBackgroundColor);
    Q_PROPERTY_AUTO(QColor,windowActiveBackgroundColor);
    Q_PROPERTY_AUTO(QColor,fontPrimaryColor);
    Q_PROPERTY_AUTO(QColor,fontSecondaryColor);
    Q_PROPERTY_AUTO(QColor,fontTertiaryColor);
    Q_PROPERTY_AUTO(QColor,itemNormalColor);
    Q_PROPERTY_AUTO(QColor,itemHoverColor);
    Q_PROPERTY_AUTO(QColor,itemPressColor);
    Q_PROPERTY_AUTO(QColor,itemCheckColor);
    Q_PROPERTY_AUTO(int,darkMode);
    Q_PROPERTY_AUTO(bool,nativeText);
    Q_PROPERTY_AUTO(bool,enableAnimation);
    QML_NAMED_ELEMENT(FluTheme)
    QML_SINGLETON
private:
    explicit FluTheme(QObject *parent = nullptr);
    bool eventFilter(QObject *obj, QEvent *event);
    bool systemDark();
    void refreshColors();
public:
    SINGLETON(FluTheme)
    Q_INVOKABLE QJsonArray awesomeList(const QString& keyword = "");
    Q_SIGNAL void darkChanged();
    static FluTheme *create(QQmlEngine *qmlEngine, QJSEngine *jsEngine){return getInstance();}
    bool dark();
private:
    bool _systemDark;
};

#endif // FLUTHEME_H
