import QtQuick 2.15


Text {

    id:text

    enum FontStyle {
        Display,
        TitleLarge,
        Title,
        Subtitle,
        BodyLarge,
        BodyStrong,
        Body,
        Caption
    }

    property int fontStyle: FluText.Display
    property color textColor: "#333333"

    property int pixelSize : 16

    color: textColor

    Component.onCompleted: {
        setFontStyle(fontStyle)
    }

    onStyleChanged: {
        setFontStyle(fontStyle)
    }

    function setFontStyle(fontStyle) {
        switch (fontStyle) {
            case FluText.Display:
                font.bold = true
                font.pixelSize = text.pixelSize * 4
                break
            case FluText.TitleLarge:
                font.bold = true
                font.pixelSize = text.pixelSize * 2
                break
            case FluText.Title:
                font.bold = true
                font.pixelSize = text.pixelSize * 1.5
                break
            case FluText.Subtitle:
                font.bold = true
                font.pixelSize = text.pixelSize * 0.9
                break
            case FluText.BodyLarge:
                font.bold = false
                font.pixelSize = text.pixelSize * 1.1
                break
            case FluText.BodyStrong:
                font.bold = true
                font.pixelSize = text.pixelSize * 1.0
                break
            case FluText.Body:
                font.bold = false
                font.pixelSize = text.pixelSize
                break
            case FluText.Caption:
                font.bold = false
                font.pixelSize = text.pixelSize * 0.8
                break
            default:
                break
        }
    }

}
