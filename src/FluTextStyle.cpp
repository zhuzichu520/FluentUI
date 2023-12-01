#include "FluTextStyle.h"

FluTextStyle::FluTextStyle(QObject *parent):QObject{parent}{
    QFont caption;
    caption.setPixelSize(12);
    Caption(caption);

    QFont body;
    body.setPixelSize(13);
    Body(body);

    QFont bodyStrong;
    bodyStrong.setPixelSize(13);
    bodyStrong.setWeight(QFont::DemiBold);
    BodyStrong(bodyStrong);

    QFont subtitle;
    subtitle.setPixelSize(20);
    subtitle.setWeight(QFont::DemiBold);
    Subtitle(subtitle);

    QFont title;
    title.setPixelSize(28);
    title.setWeight(QFont::DemiBold);
    Title(title);

    QFont titleLarge;
    titleLarge.setPixelSize(40);
    titleLarge.setWeight(QFont::DemiBold);
    TitleLarge(titleLarge);

    QFont display;
    display.setPixelSize(68);
    display.setWeight(QFont::DemiBold);
    Display(display);
}
