#include "FluTextStyle.h"

FluTextStyle::FluTextStyle(QObject *parent) : QObject{parent} {
    _family = QFont().defaultFamily();
#ifdef Q_OS_WIN
    _family = "微软雅黑";
#endif

    QFont caption;
    caption.setFamily(_family);
    caption.setPixelSize(12);
    Caption(caption);

    QFont body;
    body.setFamily(_family);
    body.setPixelSize(13);
    Body(body);

    QFont bodyStrong;
    bodyStrong.setFamily(_family);
    bodyStrong.setPixelSize(13);
    bodyStrong.setWeight(QFont::DemiBold);
    BodyStrong(bodyStrong);

    QFont subtitle;
    subtitle.setFamily(_family);
    subtitle.setPixelSize(20);
    subtitle.setWeight(QFont::DemiBold);
    Subtitle(subtitle);

    QFont title;
    title.setFamily(_family);
    title.setPixelSize(28);
    title.setWeight(QFont::DemiBold);
    Title(title);

    QFont titleLarge;
    titleLarge.setFamily(_family);
    titleLarge.setPixelSize(40);
    titleLarge.setWeight(QFont::DemiBold);
    TitleLarge(titleLarge);

    QFont display;
    display.setFamily(_family);
    display.setPixelSize(68);
    display.setWeight(QFont::DemiBold);
    Display(display);
}
