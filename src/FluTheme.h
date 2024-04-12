#ifndef FLUTHEME_H
#define FLUTHEME_H

#include <QObject>
#include <QtQml/qqml.h>
#include <QJsonArray>
#include <QJsonObject>
#include <QColor>
#include <QTimer>
#include <QFileSystemWatcher>
#include "FluAccentColor.h"
#include "stdafx.h"
#include "singleton.h"

/**
 * @brief The FluTheme class
 */
class FluTheme : public QObject {
Q_OBJECT
Q_PROPERTY(bool dark READ dark NOTIFY darkChanged)
Q_PROPERTY_AUTO_P(FluAccentColor*, accentColor);
Q_PROPERTY_AUTO(QColor, primaryColor);
Q_PROPERTY_AUTO(QColor, backgroundColor);
Q_PROPERTY_AUTO(QColor, dividerColor);
Q_PROPERTY_AUTO(QColor, windowBackgroundColor);
Q_PROPERTY_AUTO(QColor, windowActiveBackgroundColor);
Q_PROPERTY_AUTO(QColor, fontPrimaryColor);
Q_PROPERTY_AUTO(QColor, fontSecondaryColor);
Q_PROPERTY_AUTO(QColor, fontTertiaryColor);
Q_PROPERTY_AUTO(QColor, itemNormalColor);
Q_PROPERTY_AUTO(QColor, frameColor);
Q_PROPERTY_AUTO(QColor, frameActiveColor);
Q_PROPERTY_AUTO(QColor, itemHoverColor);
Q_PROPERTY_AUTO(QColor, itemPressColor);
Q_PROPERTY_AUTO(QColor, itemCheckColor);
Q_PROPERTY_AUTO(QString, desktopImagePath);
Q_PROPERTY_AUTO(int, darkMode);
Q_PROPERTY_AUTO(bool, nativeText);
Q_PROPERTY_AUTO(bool, animationEnabled);
Q_PROPERTY_AUTO(bool, blurBehindWindowEnabled);
    QML_NAMED_ELEMENT(FluTheme)
    QML_SINGLETON

private:
    explicit FluTheme(QObject *parent = nullptr);

    bool eventFilter(QObject *obj, QEvent *event) override;

    void refreshColors();

    void updateBackgroundMainColor();

protected:

    void timerEvent(QTimerEvent *event) override;

    void updateDesktopImage();

public:
SINGLETON(FluTheme)

    [[maybe_unused]] Q_INVOKABLE static QJsonArray awesomeList(const QString &keyword = "");

    Q_SIGNAL void darkChanged();

    static FluTheme *create(QQmlEngine *, QJSEngine *) { return getInstance(); }

    bool dark() const;

private:
    bool _systemDark;
    QFileSystemWatcher _watcher;
};

#endif // FLUTHEME_H
