#include "FluTheme.h"

#include <QGuiApplication>
#include <QPalette>
#include "Def.h"
#include "FluentIconDef.h"
#include "FluColors.h"

bool systemDark() {
    QPalette palette = QGuiApplication::palette();
    QColor color = palette.color(QPalette::Window).rgb();
    return color.red() * 0.2126 + color.green() * 0.7152 + color.blue() * 0.0722 <= 255.0f / 2;
}

FluTheme::FluTheme(QObject *parent) : QObject{parent} {
    _accentColor = FluColors::getInstance()->Blue();
    _darkMode = FluThemeType::DarkMode::Light;
    _nativeText = false;
    _animationEnabled = true;
    _systemDark = systemDark();
    QGuiApplication::instance()->installEventFilter(this);
    connect(this, &FluTheme::darkModeChanged, this, [=] {
        Q_EMIT darkChanged();
    });
    connect(this, &FluTheme::darkChanged, this, [=] { refreshColors(); });
    connect(this, &FluTheme::accentColorChanged, this, [=] { refreshColors(); });
    refreshColors();
}

void FluTheme::refreshColors() {
    auto isDark = dark();
    primaryColor(isDark ? _accentColor->lighter() : _accentColor->dark());
    backgroundColor(isDark ? QColor(0, 0, 0, 255) : QColor(255, 255, 255, 255));
    dividerColor(isDark ? QColor(80, 80, 80, 255) : QColor(210, 210, 210, 255));
    windowBackgroundColor(isDark ? QColor(32, 32, 32, 255) : QColor(237, 237, 237, 255));
    windowActiveBackgroundColor(isDark ? QColor(26, 26, 26, 255) : QColor(243, 243, 243, 255));
    fontPrimaryColor(isDark ? QColor(248, 248, 248, 255) : QColor(7, 7, 7, 255));
    fontSecondaryColor(isDark ? QColor(222, 222, 222, 255) : QColor(102, 102, 102, 255));
    fontTertiaryColor(isDark ? QColor(200, 200, 200, 255) : QColor(153, 153, 153, 255));
    itemNormalColor(isDark ? QColor(255, 255, 255, 0) : QColor(0, 0, 0, 0));
    itemHoverColor(isDark ? QColor(255, 255, 255, qRound(255 * 0.06)) : QColor(0, 0, 0, qRound(255 * 0.03)));
    itemPressColor(isDark ? QColor(255, 255, 255, qRound(255 * 0.09)) : QColor(0, 0, 0, qRound(255 * 0.06)));
    itemCheckColor(isDark ? QColor(255, 255, 255, qRound(255 * 0.12)) : QColor(0, 0, 0, qRound(255 * 0.09)));
}

bool FluTheme::eventFilter(QObject *, QEvent *event) {
    if (event->type() == QEvent::ApplicationPaletteChange || event->type() == QEvent::ThemeChange) {
        _systemDark = systemDark();
        Q_EMIT darkChanged();
        event->accept();
        return true;
    }
    return false;
}

[[maybe_unused]] QJsonArray FluTheme::awesomeList(const QString &keyword) {
    QJsonArray arr;
    QMetaEnum enumType = Fluent_Icons::staticMetaObject.enumerator(Fluent_Icons::staticMetaObject.indexOfEnumerator("Fluent_IconType"));
    for (int i = 0; i <= enumType.keyCount() - 1; ++i) {
        QString name = enumType.key(i);
        int icon = enumType.value(i);
        if (keyword.isEmpty() || name.contains(keyword)) {
            QJsonObject obj;
            obj.insert("name", name);
            obj.insert("icon", icon);
            arr.append(obj);
        }
    }
    return arr;
}

bool FluTheme::dark() const {
    if (_darkMode == FluThemeType::DarkMode::Dark) {
        return true;
    } else if (_darkMode == FluThemeType::DarkMode::System) {
        return _systemDark;
    } else {
        return false;
    }
}
